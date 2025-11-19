"""
Compatibility views for Notifications endpoints.
All endpoints will appear under "Notifications" folder in Swagger UI.

Based on Flutter Swagger format.
"""
from rest_framework import status, serializers
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from drf_spectacular.utils import extend_schema, OpenApiExample, OpenApiResponse
from zistino_apps.users.permissions import IsManager
import requests
import json
import logging

from zistino_apps.compatibility.utils import create_success_response, create_error_response
from .serializers import NotificationSendRequestSerializer

logger = logging.getLogger(__name__)


@extend_schema(
    tags=['Notifications'],
    operation_id='notifications_send',
    summary='Send notification (SMS)',
    description='Send SMS notification to a user/driver matching old Swagger format.',
    request=NotificationSendRequestSerializer,
    examples=[
        OpenApiExample(
            'Send notification to user',
            value={
                'phoneNumber': '09123456789',
                'message': 'Your order has been confirmed',
                'userId': 'user-uuid-here'
            }
        ),
        OpenApiExample(
            'Send notification without userId',
            value={
                'phoneNumber': '+989123456789',
                'message': 'Your delivery is scheduled for tomorrow'
            }
        ),
        OpenApiExample(
            'Send notification to all users',
            value={
                'phoneNumber': '',
                'message': 'Important announcement for all users',
                'sendToAll': True
            }
        ),
        OpenApiExample(
            'Send notification to all users (empty phoneNumber)',
            value={
                'phoneNumber': '',
                'message': 'System maintenance scheduled'
            }
        )
    ],
    responses={
        200: OpenApiResponse(
            response=serializers.Serializer,
            description='Notification sent successfully',
            examples=[
                OpenApiExample(
                    'Success response',
                    value={
                        'data': {
                            'phoneNumber': '09123456789',
                            'message': 'Your order has been confirmed',
                            'sent': True
                        },
                        'messages': ['SMS sent successfully'],
                        'succeeded': True
                    }
                )
            ]
        ),
        400: {'description': 'Validation error'},
        500: {'description': 'SMS sending failed'}
    }
)
class NotificationSendView(APIView):
    """POST /api/v1/notifications/send - Send notification (SMS)"""
    permission_classes = [IsAuthenticated, IsManager]

    def post(self, request):
        """Send SMS notification matching old Swagger format."""
        try:
            # Validate input
            serializer = NotificationSendRequestSerializer(data=request.data)
            if not serializer.is_valid():
                errors = {}
                for field, error_list in serializer.errors.items():
                    errors[field] = [str(error) for error in error_list]
                return create_error_response(
                    error_message='Validation failed',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors=errors
                )
            
            validated_data = serializer.validated_data
            phone_number = validated_data.get('phoneNumber', '').strip()
            message = validated_data['message']
            send_to_all = validated_data.get('sendToAll', False)
            
            # Determine if sending to all users
            if send_to_all or (not phone_number):
                # Send to all active users
                from django.contrib.auth import get_user_model
                User = get_user_model()
                
                # Get all active users with phone numbers
                active_users = User.objects.filter(
                    is_active=True,
                    phone_number__isnull=False
                ).exclude(phone_number='')
                
                total_users = active_users.count()
                if total_users == 0:
                    return create_error_response(
                        error_message='No active users found with phone numbers',
                        status_code=status.HTTP_400_BAD_REQUEST,
                        errors={'users': ['No active users found']}
                    )
                
                # Send SMS to all users using MeliPayamak (for free-form messages)
                from zistino_apps.payments.sms_service import _send_sms_melipayamak
                successful = 0
                failed = 0
                failed_numbers = []
                
                for user in active_users:
                    try:
                        success, error_message = _send_sms_melipayamak(user.phone_number, message)
                        if success:
                            successful += 1
                        else:
                            failed += 1
                            failed_numbers.append(user.phone_number)
                    except Exception as e:
                        failed += 1
                        failed_numbers.append(user.phone_number)
                
                return create_success_response(
                    data={
                        'sentToAll': True,
                        'totalUsers': total_users,
                        'successful': successful,
                        'failed': failed,
                        'message': message,
                        'failedNumbers': failed_numbers[:10] if failed_numbers else []  # Limit to first 10 failed numbers
                    },
                    messages=[f'SMS sent to {successful} out of {total_users} users'],
                    status_code=status.HTTP_200_OK
                )
            else:
                # Send to single phone number
                if not phone_number:
                    return create_error_response(
                        error_message='Phone number is required when not sending to all users',
                        status_code=status.HTTP_400_BAD_REQUEST,
                        errors={'phoneNumber': ['Phone number is required']}
                    )
                
                # Send SMS using MeliPayamak (for free-form messages, not pattern-based)
                # Use MeliPayamak directly instead of send_sms which tries Payamak BaseServiceNumber first
                try:
                    import logging
                    logger = logging.getLogger(__name__)
                    from django.conf import settings
                    
                    # Check if MeliPayamak is configured
                    melipayamak_username = getattr(settings, 'MELIPAYAMAK_USERNAME', None)
                    melipayamak_api_key = getattr(settings, 'MELIPAYAMAK_API_KEY', None)
                    
                    if not melipayamak_username or not melipayamak_api_key:
                        # Fallback to regular send_sms if MeliPayamak not configured
                        logger.warning(f"MeliPayamak not configured, using fallback send_sms for {phone_number}")
                        logger.warning("NOTE: Payamak BaseServiceNumber is for pattern-based OTPs, not free-form messages!")
                        logger.warning("For notifications, please configure MELIPAYAMAK_USERNAME and MELIPAYAMAK_API_KEY")
                        from zistino_apps.payments.sms_service import send_sms
                        success, error_message = send_sms(phone_number, message)
                        if not success:
                            logger.error(f"send_sms failed for {phone_number}: {error_message}")
                        else:
                            logger.info(f"send_sms reported success for {phone_number}, but verify SMS was actually delivered")
                    else:
                        from zistino_apps.payments.sms_service import _send_sms_melipayamak, send_sms_with_pattern
                        from django.conf import settings
                        
                        # Log the phone number being sent to (for debugging)
                        logger.info(f"=== Notification SMS Request ===")
                        logger.info(f"Phone number: {phone_number}")
                        logger.info(f"Message: {message}")
                        logger.info(f"Message length: {len(message)} characters")
                        
                        # Priority 1: Try Pattern 395131 (Universal Pattern - works for all messages)
                        pattern_id = getattr(settings, 'MELIPAYAMAK_PATTERN_ID', None)
                        logger.info(f"Pattern ID from settings: {pattern_id}")
                        if pattern_id:
                            try:
                                pattern_id_int = int(pattern_id)
                                logger.info(f"Using Universal Pattern {pattern_id_int} for {phone_number}")
                                logger.info(f"Pattern 395131 works for all phone numbers and all message types")
                                
                                from zistino_apps.payments.sms_service import send_universal_pattern_sms
                                logger.info(f"Calling send_universal_pattern_sms for {phone_number}...")
                                success, error_message = send_universal_pattern_sms(phone_number, message)
                                
                                logger.info(f"Result: success={success}, error={error_message}")
                                
                                if success:
                                    logger.info(f"✅ SMS sent successfully via Universal Pattern {pattern_id_int} to {phone_number}")
                                    return create_success_response(
                                        data={
                                            'phoneNumber': phone_number,
                                            'message': message,
                                            'sent': True,
                                            'method': 'pattern',
                                            'patternId': pattern_id_int
                                        },
                                        messages=['SMS sent successfully via Universal Pattern'],
                                        status_code=status.HTTP_200_OK
                                    )
                                else:
                                    logger.warning(f"Universal Pattern failed: {error_message}. Trying BaseServiceNumber.")
                            except (ValueError, TypeError) as e:
                                logger.warning(f"Invalid Pattern ID: {pattern_id}. Error: {e}. Trying BaseServiceNumber.")
                        
                        # Priority 2: Try Payamak BaseServiceNumber (Pattern 270325 - for OTP only, may not work for free-form)
                        from zistino_apps.payments.sms_service import send_payamak_base_service_sms
                        payamak_body_id = getattr(settings, 'PAYAMAK_BODY_ID', None)
                        if payamak_body_id:
                            logger.info(f"Using Payamak BaseServiceNumber with BodyId: {payamak_body_id} for {phone_number}")
                            logger.warning(f"⚠️ BaseServiceNumber Pattern 270325 is for OTP only, may not work for free-form messages!")
                            # Use message as text (BaseServiceNumber accepts any text with pattern)
                            success, error_message, response_data = send_payamak_base_service_sms(phone_number, message)
                            if success:
                                logger.info(f"✅ SMS sent successfully via Payamak BaseServiceNumber to {phone_number}")
                                logger.warning(f"⚠️ NOTE: BaseServiceNumber returned success, but free-form messages may not be delivered!")
                                return create_success_response(
                                    data={
                                        'phoneNumber': phone_number,
                                        'message': message,
                                        'sent': True,
                                        'method': 'base_service',
                                        'warning': 'BaseServiceNumber Pattern 270325 is for OTP only. For notifications, use Pattern 395131.'
                                    },
                                    messages=['SMS sent successfully via BaseServiceNumber (OTP Pattern - may not work for free-form)'],
                                    status_code=status.HTTP_200_OK
                                )
                            else:
                                logger.warning(f"Payamak BaseServiceNumber failed: {error_message}. Trying free-form SMS.")
                        
                        # Fallback to free-form SMS (may fail if sender number is not valid)
                        # Note: This may only work for specific numbers due to sender number restrictions
                        logger.warning(f"⚠️ Free-form SMS may only work for specific numbers. BaseServiceNumber should be used instead.")
                        success, error_message = _send_sms_melipayamak(phone_number, message)
                        
                        if success:
                            logger.info(f"✅ SMS sent successfully to {phone_number}")
                            logger.info(f"Response: {error_message if error_message else 'No error message'}")
                            return create_success_response(
                                data={
                                    'phoneNumber': phone_number,
                                    'message': message,
                                    'sent': True
                                },
                                messages=['SMS sent successfully'],
                                status_code=status.HTTP_200_OK
                            )
                        else:
                            logger.error(f"❌ SMS failed for {phone_number}")
                            logger.error(f"Error: {error_message}")
                            return create_error_response(
                                error_message=f'Failed to send SMS: {error_message}',
                                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                                errors={'sms': [error_message or 'Unknown error']}
                            )
                except Exception as sms_error:
                    import logging
                    logger = logging.getLogger(__name__)
                    logger.error(f"Exception sending SMS to {phone_number}: {str(sms_error)}")
                    import traceback
                    logger.error(f"Traceback: {traceback.format_exc()}")
                    return create_error_response(
                        error_message=f'Error sending SMS: {str(sms_error)}',
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        errors={'sms': [str(sms_error)]}
                    )
        
        except Exception as e:
            error_detail = str(e)
            error_type = type(e).__name__
            
            return create_error_response(
                error_message=f'An error occurred while processing the request: {error_detail}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [f'{error_type}: {error_detail}']}
            )



