"""
SMS Service Module
Handles SMS sending via Payamak BaseServiceNumber and MeliPayamak APIs.
"""
import logging
import json
import requests
from django.conf import settings

logger = logging.getLogger(__name__)


def _normalize_phone_number(phone_number):
    """
    Normalize phone number to standard format (09123456789).
    
    Args:
        phone_number (str): Phone number in various formats
        
    Returns:
        str: Normalized phone number (09123456789)
    """
    if not phone_number:
        return None
    
    # Remove all spaces, dashes, and parentheses
    normalized = phone_number.strip().replace(' ', '').replace('-', '').replace('(', '').replace(')', '')
    
    # Remove +98 prefix if present
    if normalized.startswith('+98'):
        normalized = '0' + normalized[3:]
    # Remove 98 prefix if present (without +)
    elif normalized.startswith('98') and len(normalized) == 12:
        normalized = '0' + normalized[2:]
    # Ensure starts with 0
    elif not normalized.startswith('0'):
        normalized = '0' + normalized
    
    return normalized


def _normalize_phone_for_melipayamak(phone_number):
    """
    Normalize phone number for MeliPayamak API (09123456789 format).
    
    Args:
        phone_number (str): Phone number in various formats
        
    Returns:
        str: Normalized phone number (09123456789)
    """
    return _normalize_phone_number(phone_number)


def _send_sms_melipayamak(phone_number, message):
    """
    Send SMS via MeliPayamak REST API (free-form messages).
    
    Args:
        phone_number (str): Phone number to send SMS to
        message (str): SMS message content
        
    Returns:
        tuple: (success: bool, error_message: str or None)
    """
    try:
        username = settings.MELIPAYAMAK_USERNAME
        api_key = settings.MELIPAYAMAK_API_KEY  # API Key is used as password
        api_url = settings.MELIPAYAMAK_API_URL
        sender = settings.MELIPAYAMAK_SENDER
        
        # Use dedicated number 30008666009664 (confirmed working)
        if not sender or sender in ['21700077', '300086669664', '']:
            sender = '30008666009664'
        
        if not username or not api_key:
            error_msg = "MeliPayamak credentials not configured. Please set MELIPAYAMAK_USERNAME and MELIPAYAMAK_API_KEY in settings."
            logger.error(error_msg)
            return False, error_msg
        
        if not sender:
            error_msg = "MeliPayamak sender number not configured. Please set MELIPAYAMAK_SENDER in settings."
            logger.error(error_msg)
            return False, error_msg
        
        # Normalize phone number
        normalized_phone = _normalize_phone_number(phone_number)
        
        # MeliPayamak REST API endpoint
        send_endpoint = api_url if api_url else "https://rest.payamak-panel.com/api/SendSMS/SendSMS"
        
        # Prepare payload
        payload = {
            'username': username,
            'password': api_key,
            'to': normalized_phone,
            'from': sender,
            'text': message
        }
        
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json, text/plain, */*'
        }
        
        logger.info(f"=== MeliPayamak SMS Request ===")
        logger.info(f"Sending SMS via MeliPayamak REST API to {normalized_phone}")
        logger.info(f"Using endpoint: {send_endpoint}")
        logger.info(f"Sender (from): {sender}")
        logger.info(f"Message length: {len(message)} characters")
        
        # Send POST request
        response = requests.post(
            send_endpoint,
            data=payload,
            headers=headers,
            timeout=30
        )
        
        logger.info(f"MeliPayamak API Response Status: {response.status_code}")
        logger.info(f"MeliPayamak API Response Text (Full): {response.text}")
        
        raw_response_text = response.text
        
        if response.status_code == 200:
            response_text = response.text.strip()
            
            # Try to parse as JSON first
            try:
                response_data = response.json()
                logger.info(f"MeliPayamak API Response JSON: {json.dumps(response_data, indent=2, ensure_ascii=False)}")
                
                if isinstance(response_data, dict):
                    ret_status = response_data.get('RetStatus')
                    str_ret_status = response_data.get('StrRetStatus', '')
                    value = response_data.get('Value', '')
                    
                    logger.info(f"MeliPayamak Response - RetStatus: {ret_status}, StrRetStatus: {str_ret_status}, Value: {value}")
                    
                    if isinstance(ret_status, (int, float)):
                        # Check StrRetStatus first - if it contains error keywords, it's an error
                        if str_ret_status and any(keyword in str_ret_status.lower() for keyword in ['error', 'invalid', 'fail', 'خطا', 'نامعتبر']):
                            error_msg = f"MeliPayamak API error (RetStatus: {ret_status}, StrRetStatus: {str_ret_status})"
                            logger.error(f"❌ {error_msg}")
                            return False, error_msg
                        
                        # Only RetStatus = 1 means success (according to MeliPayamak documentation)
                        if ret_status == 1:
                            logger.info(f"✅ SMS request accepted by MeliPayamak to {normalized_phone}. RetStatus: {ret_status}")
                            return True, None
                        elif ret_status == 9:
                            error_msg = f"InvalidNumber (RetStatus: 9) - Phone number format is incorrect: {normalized_phone}"
                            logger.error(f"❌ {error_msg}")
                            return False, error_msg
                        elif ret_status < 0:
                            error_codes = {
                                -1: "Invalid username or password",
                                -2: "Insufficient credit",
                                -3: "Invalid sender number",
                                -4: "Invalid recipient number",
                                -5: "Message is empty",
                                -6: "Message too long",
                                -7: "Invalid API key",
                                -8: "IP not allowed",
                                -9: "Account disabled",
                                -10: "Daily limit exceeded"
                            }
                            error_msg = error_codes.get(ret_status, f"Unknown error code: {ret_status}")
                            logger.error(f"❌ MeliPayamak API error (RetStatus: {ret_status}): {error_msg}")
                            return False, f"API Error {ret_status}: {error_msg}"
                        else:
                            # RetStatus > 1 and != 9 means error (e.g., 35 = InvalidData)
                            error_msg = f"MeliPayamak API error (RetStatus: {ret_status}, StrRetStatus: {str_ret_status})"
                            logger.error(f"❌ {error_msg}")
                            return False, error_msg
                    elif str_ret_status:
                        if str_ret_status.lower() in ['ok', 'success', 'موفق']:
                            logger.info(f"✅ SMS sent successfully via MeliPayamak to {normalized_phone}")
                            return True, None
                        else:
                            error_msg = f"MeliPayamak API error: {str_ret_status}"
                            logger.error(f"❌ {error_msg}")
                            return False, error_msg
                    else:
                        error_msg = f"Unexpected response format: {response_data}"
                        logger.error(f"❌ {error_msg}")
                        return False, f"API Error: {error_msg}"
                else:
                    logger.info(f"SMS sent successfully via MeliPayamak to {normalized_phone}")
                    return True, None
                    
            except (ValueError, json.JSONDecodeError):
                # Not JSON, treat as plain text
                logger.info(f"Response is not JSON, treating as plain text: '{response_text}'")
                
                try:
                    response_value = int(response_text)
                    if response_value > 0:
                        logger.info(f"✅ SMS sent successfully via MeliPayamak to {normalized_phone}. Message ID: {response_value}")
                        return True, None
                    elif response_value < 0:
                        error_codes = {
                            -1: "Invalid username or password",
                            -2: "Insufficient credit",
                            -3: "Invalid sender number",
                            -4: "Invalid recipient number",
                            -5: "Message is empty",
                            -6: "Message too long",
                            -7: "Invalid API key",
                            -8: "IP not allowed",
                            -9: "Account disabled",
                            -10: "Daily limit exceeded"
                        }
                        error_msg = error_codes.get(response_value, f"Unknown error code: {response_value}")
                        logger.error(f"❌ MeliPayamak API returned error code: {response_value} - {error_msg}")
                        return False, f"API Error {response_value}: {error_msg}"
                    else:
                        logger.warning(f"⚠️ MeliPayamak API returned 0 (unknown status) for {normalized_phone}")
                        return False, "API returned 0 (unknown status - check MeliPayamak dashboard)"
                except ValueError:
                    response_lower = response_text.lower()
                    if any(keyword in response_lower for keyword in ['error', 'fail', 'invalid', 'خطا', 'نامعتبر']):
                        logger.error(f"❌ MeliPayamak API returned error: {response_text}")
                        return False, f"API Error: {response_text}"
                    elif 'ok' in response_lower or response_lower == 'success' or 'موفق' in response_text:
                        logger.info(f"✅ SMS sent successfully via MeliPayamak to {normalized_phone}")
                        return True, None
                    else:
                        logger.warning(f"⚠️ Unknown response format from MeliPayamak: {response_text}")
                        return True, None
        else:
            error_msg = f"HTTP {response.status_code}: {response.text[:200]}"
            logger.error(f"MeliPayamak API request failed: {error_msg}")
            return False, error_msg
            
    except requests.exceptions.RequestException as e:
        error_msg = f"Network error: {str(e)}"
        logger.error(f"Network error while sending SMS via MeliPayamak: {error_msg}")
        return False, error_msg
    except Exception as e:
        error_msg = f"Unexpected error: {str(e)}"
        logger.error(f"Failed to send SMS via MeliPayamak: {error_msg}")
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, error_msg


def send_payamak_base_service_sms(phone_number, text_code):
    """
    Send SMS via Payamak Panel BaseServiceNumber API (for OTP/service messages).
    
    Args:
        phone_number (str): Phone number to send SMS to
        text_code (str): OTP or service code to send
        
    Returns:
        tuple: (success: bool, error_message: str or None, response_data: dict or None)
    """
    try:
        username = settings.PAYAMAK_USERNAME
        password = settings.PAYAMAK_PASSWORD
        body_id = settings.PAYAMAK_BODY_ID
        api_url = settings.PAYAMAK_BASE_URL
        
        if not username or not password or not body_id:
            error_msg = "Payamak BaseService credentials not configured. Please set PAYAMAK_USERNAME, PAYAMAK_PASSWORD, and PAYAMAK_BODY_ID in settings."
            logger.error(error_msg)
            return False, error_msg, None
        
        # Normalize phone: remove leading 0, add 98 prefix
        normalized_phone = phone_number.strip()
        if normalized_phone.startswith('0'):
            normalized_phone = '98' + normalized_phone[1:]
        elif normalized_phone.startswith('+98'):
            normalized_phone = '98' + normalized_phone[3:]
        elif not normalized_phone.startswith('98'):
            normalized_phone = '98' + normalized_phone
        
        send_endpoint = api_url if api_url else "https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber"
        
        payload = {
            'username': username,
            'password': password,
            'text': text_code,
            'to': normalized_phone,
            'bodyId': body_id
        }
        
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
        }
        
        logger.info(f"Sending SMS via Payamak BaseServiceNumber to {normalized_phone}")
        logger.info(f"Using endpoint: {send_endpoint}")
        logger.info(f"BodyId: {body_id}, Text: {text_code}")
        
        response = requests.post(
            send_endpoint,
            data=payload,
            headers=headers,
            timeout=30,
            verify=False
        )
        
        logger.info(f"Payamak BaseServiceNumber Response Status: {response.status_code}")
        logger.info(f"Payamak BaseServiceNumber Response Text: {response.text[:500]}")
        
        try:
            response_data = response.json()
        except (ValueError, json.JSONDecodeError):
            response_data = {'raw': response.text}
        
        if response.status_code == 200:
            response_text = response.text.strip()
            
            try:
                response_value = int(response_text)
                if response_value < 0:
                    error_msg = f"Payamak BaseServiceNumber returned error code: {response_value}"
                    logger.error(f"Error sending to {normalized_phone}: {error_msg}")
                    return False, error_msg, response_data
                elif response_value > 0:
                    logger.info(f"SMS sent successfully via Payamak BaseServiceNumber to {normalized_phone}. Message ID: {response_value}")
                    return True, None, response_data
            except ValueError:
                if isinstance(response_data, dict):
                    error_field = response_data.get('error') or response_data.get('Error') or response_data.get('message')
                    if error_field:
                        error_msg = f"Payamak BaseServiceNumber error: {error_field}"
                        logger.error(f"Error sending to {normalized_phone}: {error_msg}")
                        return False, error_msg, response_data
                    
                    ret_status = response_data.get('RetStatus')
                    str_ret_status = response_data.get('StrRetStatus', '')
                    value = response_data.get('Value', '')
                    
                    if ret_status == 1 and str_ret_status.lower() == 'ok':
                        logger.info(f"✅ Payamak BaseServiceNumber accepted SMS for {normalized_phone}. RetStatus: {ret_status}")
                        return True, None, response_data
                    elif ret_status and ret_status < 0:
                        error_msg = f"Payamak BaseServiceNumber error: RetStatus={ret_status}, StrRetStatus={str_ret_status}"
                        logger.error(f"Error sending to {normalized_phone}: {error_msg}")
                        return False, error_msg, response_data
                    else:
                        logger.warning(f"Payamak BaseServiceNumber returned unknown status for {normalized_phone}: RetStatus={ret_status}")
                        return True, None, response_data
                else:
                    logger.warning(f"Payamak BaseServiceNumber returned non-numeric response for {normalized_phone}: {response_text}")
                    return True, None, response_data
            
            logger.info(f"SMS sent successfully via Payamak BaseServiceNumber to {normalized_phone}")
            return True, None, response_data
        else:
            error_msg = f"Payamak BaseServiceNumber API returned status {response.status_code}: {response.text[:200]}"
            logger.error(error_msg)
            return False, error_msg, response_data
            
    except requests.exceptions.RequestException as e:
        error_msg = f"Network error while sending SMS via Payamak BaseServiceNumber: {str(e)}"
        logger.error(error_msg)
        return False, error_msg, None
    except Exception as e:
        error_msg = f"Unexpected error in send_payamak_base_service_sms: {str(e)}"
        logger.error(error_msg)
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, error_msg, None


def send_sms(phone_number, message):
    """
    Send SMS to phone number using Payamak BaseServiceNumber (priority) or MeliPayamak (fallback).
    
    Priority order:
    0. Payamak BaseServiceNumber (single approved pattern – temporary global usage)
    1. MeliPayamak (if MELIPAYAMAK_USERNAME and MELIPAYAMAK_API_KEY are configured)
    2. Development mode (log to console only)
    
    Args:
        phone_number (str): Phone number to send SMS to
        message (str): Message content
        
    Returns:
        tuple: (success: bool, error_message: str or None)
    """
    try:
        is_free_form = len(message) > 10 or any(c.isalpha() for c in message)
        
        payamak_username = settings.PAYAMAK_USERNAME
        payamak_password = settings.PAYAMAK_PASSWORD
        payamak_body_id = settings.PAYAMAK_BODY_ID

        if payamak_username and payamak_password and payamak_body_id:
            if is_free_form:
                logger.warning(f"⚠️ WARNING: Attempting to send free-form message via Payamak BaseServiceNumber to {phone_number}")
                logger.warning("⚠️ BaseServiceNumber is for pattern-based OTPs only. Message may not be delivered!")
                logger.warning("⚠️ For notifications, configure MELIPAYAMAK_USERNAME and MELIPAYAMAK_API_KEY")
            
            logger.info("Using Payamak BaseServiceNumber SMS (single pattern mode)")
            success, error_message, response_data = send_payamak_base_service_sms(phone_number, message)
            if success:
                if is_free_form:
                    logger.warning(f"⚠️ BaseServiceNumber returned success, but free-form messages may not be delivered to {phone_number}")
                return True, None
            else:
                logger.warning(f"Payamak BaseServiceNumber failed: {error_message}. Falling back to MeliPayamak.")

        melipayamak_username = settings.MELIPAYAMAK_USERNAME
        melipayamak_api_key = settings.MELIPAYAMAK_API_KEY
        
        if melipayamak_username and melipayamak_api_key:
            logger.info("Using MeliPayamak SMS service (fallback provider)")
            return _send_sms_melipayamak(phone_number, message)
        
        # No SMS credentials configured - log to console (development mode)
        logger.warning("No SMS credentials configured. SMS will be logged only.")
        logger.info(f"[SMS] To: {phone_number}")
        logger.info(f"[SMS] Message: {message}")
        logger.info(f"[SMS NOTIFICATION - DEVELOPMENT MODE] To: {phone_number}, Message: {message}")
        return True, None
        
    except Exception as e:
        error_msg = f"Unexpected error in send_sms: {str(e)}"
        logger.error(f"Failed to send SMS to {phone_number}: {error_msg}")
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, error_msg


def send_deposit_request_confirmation(phone_number, amount):
    """
    Send SMS confirmation when customer creates deposit request.
    
    Args:
        phone_number (str): Customer phone number
        amount (Decimal): Deposit amount
        
    Returns:
        bool: True if SMS was sent successfully
    """
    message = f"Your deposit request of {amount:,.0f} Rials has been registered. Please deposit the money and wait for verification."
    success, _ = send_sms(phone_number, message)
    return success


def send_deposit_confirmation(phone_number, amount, balance):
    """
    Send SMS confirmation when deposit is approved and money is added to wallet.
    
    Args:
        phone_number (str): Customer phone number
        amount (Decimal): Deposited amount
        balance (Decimal): New wallet balance
        
    Returns:
        bool: True if SMS was sent successfully
    """
    message = f"{amount:,.0f} Rials have been deposited into your account. Your current balance is {balance:,.0f} Rials."
    success, _ = send_sms(phone_number, message)
    return success


def send_deposit_rejection(phone_number, amount, reason=None):
    """
    Send SMS notification when deposit request is rejected.
    
    Args:
        phone_number (str): Customer phone number
        amount (Decimal): Requested deposit amount
        reason (str, optional): Reason for rejection
        
    Returns:
        bool: True if SMS was sent successfully
    """
    message = f"Your deposit request of {amount:,.0f} Rials has been rejected."
    if reason:
        message += f" Reason: {reason}"
    success, _ = send_sms(phone_number, message)
    return success


def send_delivery_reminder(phone_number, delivery_date, delivery_id=None):
    """
    Send SMS reminder 1 hour before delivery time period.
    
    Args:
        phone_number (str): Customer phone number
        delivery_date (datetime): Scheduled delivery date/time
        delivery_id (str, optional): Delivery ID for reference
        
    Returns:
        bool: True if SMS was sent successfully
    """
    from datetime import datetime, timedelta
    from django.utils import timezone
    
    delivery_start = delivery_date
    delivery_end = delivery_date + timedelta(hours=2)
    
    start_time = delivery_start.strftime('%H:%M')
    end_time = delivery_end.strftime('%H:%M')
    delivery_date_str = delivery_start.strftime('%Y/%m/%d')
    
    message = f"یادآوری: راننده در بازه زمانی {start_time} تا {end_time} امروز ({delivery_date_str}) به آدرس شما خواهد آمد. لطفا آماده باشید."
    
    success, _ = send_sms(phone_number, message)
    return success


def send_sms_with_pattern(phone_number, pattern_id, pattern_args):
    """
    Send SMS using a registered MeliPayamak pattern (template).
    
    Args:
        phone_number (str): Phone number to send SMS to
        pattern_id (int): Pattern ID (BodyId) from MeliPayamak
        pattern_args (list): List of values to replace pattern variables
        
    Returns:
        tuple: (success: bool, error_message: str or None)
    """
    try:
        username = settings.MELIPAYAMAK_USERNAME
        api_key = settings.MELIPAYAMAK_API_KEY
        
        if not username or not api_key:
            error_msg = "MeliPayamak credentials not configured. Please set MELIPAYAMAK_USERNAME and MELIPAYAMAK_API_KEY in settings."
            logger.error(error_msg)
            return False, error_msg
        
        normalized_phone = _normalize_phone_number(phone_number)
        
        # Try Smart Webservice first (if available)
        rest_endpoint = "https://rest.payamak-panel.com/api/SendSMS/SendByBaseNumber"
        
        # If Smart Webservice is not available, use regular REST API with formatted message
        # Format message according to pattern: "سلام کد شما: {0} می باشد نرم افزار میلیونر"
        # Pattern 395131 format: "سلام کد شما: {0} می باشد نرم افزار میلیونر"
        if pattern_id == 395131 and len(pattern_args) == 1:
            # Use regular REST API with formatted message
            formatted_message = f"سلام کد شما: {pattern_args[0]} می باشد نرم افزار میلیونر"
            logger.info(f"Using regular REST API with formatted message for Pattern 395131")
            return _send_sms_melipayamak(phone_number, formatted_message)
        
        payload = {
            'username': username,
            'password': api_key,
            'to': normalized_phone,
            'bodyId': pattern_id,
            'args': pattern_args
        }
        
        headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
        
        logger.info(f"Sending SMS via MeliPayamak Smart webservice (REST API) to {normalized_phone}")
        logger.info(f"Pattern ID: {pattern_id}")
        logger.info(f"Pattern args: {pattern_args}")
        
        response = requests.post(
            rest_endpoint,
            json=payload,
            headers=headers,
            timeout=30
        )
        
        logger.info(f"MeliPayamak Smart API Response Status: {response.status_code}")
        logger.info(f"MeliPayamak Smart API Response Text: {response.text[:500]}")
        
        if response.status_code == 200:
            try:
                response_data = response.json()
                logger.info(f"MeliPayamak Smart API Response JSON: {json.dumps(response_data, indent=2, ensure_ascii=False)}")
                
                status = None
                message_id = None
                error_message = None
                
                if isinstance(response_data, dict):
                    status = (
                        response_data.get('StrRetStatus') or
                        response_data.get('status') or
                        response_data.get('Status') or
                        response_data.get('RetStatus') or
                        response_data.get('result')
                    )
                    
                    message_id = (
                        response_data.get('RetStatus') or
                        response_data.get('messageId') or
                        response_data.get('MessageId') or
                        response_data.get('id')
                    )
                    
                    error_message = (
                        response_data.get('message') or
                        response_data.get('Message') or
                        response_data.get('error') or
                        response_data.get('Error')
                    )
                
                is_success = False
                
                if isinstance(status, (int, float)) and status > 0:
                    is_success = True
                elif isinstance(message_id, (int, float)) and message_id > 0:
                    is_success = True
                elif isinstance(status, str) and status.lower() in ['ok', 'success', 'true']:
                    is_success = True
                elif isinstance(response_data, dict) and 'RetStatus' in response_data:
                    ret_status = response_data.get('RetStatus')
                    if isinstance(ret_status, (int, float)) and ret_status > 0:
                        is_success = True
                        message_id = ret_status
                
                if is_success:
                    logger.info(f"SMS sent successfully via MeliPayamak Smart pattern {pattern_id} to {normalized_phone}. Message ID: {message_id}")
                    return True, None
                else:
                    error_msg = error_message or str(response_data) or "Unknown error from API"
                    logger.error(f"MeliPayamak Smart API returned error: {error_msg}")
                    return False, error_msg
                    
            except ValueError:
                response_text = response.text.strip()
                
                try:
                    result_value = int(response_text)
                    if result_value > 0:
                        logger.info(f"SMS sent successfully via MeliPayamak Smart pattern {pattern_id} to {normalized_phone}. Message ID: {result_value}")
                        return True, None
                    else:
                        error_msg = f"API returned error code: {result_value}"
                        logger.error(f"MeliPayamak Smart API error: {error_msg}")
                        return False, error_msg
                except ValueError:
                    error_msg = f"Unexpected API response: {response_text}"
                    logger.error(f"MeliPayamak Smart API error: {error_msg}")
                    return False, error_msg
        else:
            error_msg = f"HTTP {response.status_code}: {response.text}"
            logger.error(f"MeliPayamak Smart API request failed: {error_msg}")
            return False, error_msg
            
    except requests.exceptions.RequestException as e:
        error_msg = f"Network error: {str(e)}"
        logger.error(f"Network error while sending SMS via MeliPayamak Smart pattern: {error_msg}")
        return False, error_msg
    except Exception as e:
        error_msg = f"Unexpected error: {str(e)}"
        logger.error(f"Failed to send SMS via MeliPayamak Smart pattern: {error_msg}")
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, error_msg


def add_melipayamak_pattern(title, body, black_list_id=1):
    """
    Add a pattern (template) to MeliPayamak using SharedServiceBodyAdd method.
    
    Args:
        title (str): Pattern title/name
        body (str): Pattern body with variables
        black_list_id (int): Black list ID (default: 1)
    
    Returns:
        tuple: (success: bool, pattern_id: int or None, error_message: str or None)
    """
    try:
        username = settings.MELIPAYAMAK_USERNAME
        api_key = settings.MELIPAYAMAK_API_KEY
        
        if not username or not api_key:
            error_msg = "MeliPayamak credentials not configured. Please set MELIPAYAMAK_USERNAME and MELIPAYAMAK_API_KEY in settings."
            logger.error(error_msg)
            return False, None, error_msg
        
        endpoint = "https://api.payamak-panel.com/post/SharedService.asmx/SharedServiceBodyAdd"
        
        payload = {
            'username': username,
            'password': api_key,
            'title': title,
            'body': body,
            'blackListId': black_list_id
        }
        
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'text/xml, application/xml, text/plain, */*'
        }
        
        logger.info(f"Adding MeliPayamak pattern: {title}")
        logger.info(f"Pattern body: {body}")
        
        response = requests.post(
            endpoint,
            data=payload,
            headers=headers,
            timeout=30
        )
        
        logger.info(f"MeliPayamak Pattern API Response Status: {response.status_code}")
        logger.info(f"MeliPayamak Pattern API Response Text: {response.text[:500]}")
        
        if response.status_code == 200:
            response_text = response.text.strip()
            
            try:
                import xml.etree.ElementTree as ET
                root = ET.fromstring(response_text)
                result_elem = root.find('.//{http://tempuri.org/}SharedServiceBodyAddResult')
                if result_elem is not None:
                    result_text = result_elem.text.strip()
                else:
                    result_elem = root.find('.//SharedServiceBodyAddResult')
                    result_text = result_elem.text.strip() if result_elem is not None else response_text
            except ET.ParseError:
                result_text = response_text
            
            try:
                result_value = int(result_text)
                
                if result_value > 0:
                    logger.info(f"Pattern '{title}' registered successfully with BodyId: {result_value}")
                    return True, result_value, None
                elif result_value == -2:
                    error_msg = "Invalid black list ID. blackListId must be 1."
                    logger.error(f"MeliPayamak Pattern API error: {error_msg}")
                    return False, None, error_msg
                elif result_value == 0:
                    error_msg = "Invalid username or password (API key)."
                    logger.error(f"MeliPayamak Pattern API error: {error_msg}")
                    return False, None, error_msg
                else:
                    error_msg = f"API returned error code: {result_value}"
                    logger.error(f"MeliPayamak Pattern API error: {error_msg}")
                    return False, None, error_msg
            except ValueError:
                error_msg = f"Unexpected API response: {result_text}"
                logger.error(f"MeliPayamak Pattern API error: {error_msg}")
                return False, None, error_msg
        else:
            error_msg = f"HTTP {response.status_code}: {response.text}"
            logger.error(f"MeliPayamak Pattern API request failed: {error_msg}")
            return False, None, error_msg
            
    except requests.exceptions.RequestException as e:
        error_msg = f"Network error: {str(e)}"
        logger.error(f"Network error while adding MeliPayamak pattern: {error_msg}")
        return False, None, error_msg
    except Exception as e:
        error_msg = f"Unexpected error: {str(e)}"
        logger.error(f"Failed to add MeliPayamak pattern: {error_msg}")
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, None, error_msg


def send_verification_code_pattern(phone_number, user_name, verification_code):
    """
    Send verification code SMS using MeliPayamak pattern 389656.
    
    This pattern expects: {0}=user_name, {1}=verification_code, {2}=date, {3}=time
    
    Args:
        phone_number (str): Phone number to send SMS to
        user_name (str): User name
        verification_code (str): Verification code
        
    Returns:
        tuple: (success: bool, error_message: str or None)
    """
    try:
        from datetime import datetime
        from django.utils import timezone
        
        now = timezone.now()
        date_str = now.strftime('%Y/%m/%d')
        time_str = now.strftime('%H:%M')
        
        # Pattern 389656 format: "کاربر گرامی {0} کد تایید شما {1} می باشد. تاریخ {2} در ساعت {3}"
        pattern_id = 389656
        pattern_args = [
            user_name,
            verification_code,
            date_str,
            time_str
        ]
        
        logger.info(f"Sending verification code via pattern {pattern_id} to {phone_number}")
        logger.info(f"User: {user_name}, Code: {verification_code}")
        
        return send_sms_with_pattern(
            phone_number=phone_number,
            pattern_id=pattern_id,
            pattern_args=pattern_args
        )
        
    except Exception as e:
        error_msg = f"Unexpected error in send_verification_code_pattern: {str(e)}"
        logger.error(error_msg)
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, error_msg


def send_universal_pattern_sms(phone_number, message):
    """
    ارسال SMS با استفاده از Pattern 395131 که برای همه پیام‌ها کار می‌کند.
    
    این تابع از REST API معمولی MeliPayamak استفاده می‌کند (نه Smart Webservice).
    Pattern 395131: "سلام کد شما: {0} می باشد نرم افزار میلیونر"
    
    Args:
        phone_number (str): شماره تلفن گیرنده
        message (str): پیام (می‌تواند کد OTP یا پیام متنی باشد)
    
    Returns:
        tuple: (success: bool, error_message: str or None)
    """
    try:
        pattern_id = settings.MELIPAYAMAK_PATTERN_ID
        
        if not pattern_id:
            error_msg = "MELIPAYAMAK_PATTERN_ID not configured in settings."
            logger.error(error_msg)
            return False, error_msg
        
        try:
            pattern_id_int = int(pattern_id)
        except (ValueError, TypeError):
            error_msg = f"Invalid MELIPAYAMAK_PATTERN_ID: {pattern_id}. Must be a number."
            logger.error(error_msg)
            return False, error_msg
        
        # Pattern 395131 format: "سلام کد شما: {0} می باشد نرم افزار میلیونر"
        # Use REST API directly (not Smart Webservice) - works for all numbers
        # IMPORTANT: This function only works with Pattern 395131!
        if pattern_id_int != 395131:
            error_msg = f"Pattern ID {pattern_id_int} is not supported. This function only works with Pattern 395131. Please set MELIPAYAMAK_PATTERN_ID=395131 in .env"
            logger.error(error_msg)
            return False, error_msg
        
        formatted_message = f"سلام کد شما: {message} می باشد نرم افزار میلیونر"
        
        logger.info(f"Sending SMS via REST API with Pattern {pattern_id_int} format to {phone_number}")
        logger.info(f"Original message: {message}")
        logger.info(f"Formatted message: {formatted_message}")
        
        # Use regular REST API (works for all numbers)
        return _send_sms_melipayamak(phone_number, formatted_message)
        
    except Exception as e:
        error_msg = f"Unexpected error in send_universal_pattern_sms: {str(e)}"
        logger.error(error_msg)
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, error_msg
