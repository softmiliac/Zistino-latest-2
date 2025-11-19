# 📱 راهنمای ایجاد Pattern واحد برای OTP و پیام‌های متنی

## 🎯 هدف

ایجاد یک Pattern در MeliPayamak که هم برای کد OTP و هم برای پیام‌های متنی (اعلان‌ها) کار کند.

---

## 📋 مراحل

### مرحله 1: ثبت Pattern در MeliPayamak

#### گزینه 1: استفاده از اسکریپت (توصیه می‌شود)

```bash
python create_universal_pattern.py
```

این اسکریپت:
- 3 Pattern پیشنهادی را نمایش می‌دهد
- Pattern را در MeliPayamak ثبت می‌کند
- Pattern ID را به شما می‌دهد

#### گزینه 2: ثبت دستی در پنل MeliPayamak

1. وارد پنل MeliPayamak شوید: https://panel.payamak-panel.com/
2. به بخش **"الگوها"** یا **"Patterns"** بروید
3. روی **"ایجاد الگوی جدید"** کلیک کنید
4. Pattern را به این صورت ثبت کنید:

**عنوان Pattern:**
```
پیام عمومی زیستینو
```

**متن Pattern:**
```
{0}
```

**توضیحات:**
- `{0}` به معنای اولین آرگومان است
- این Pattern ساده‌ترین حالت است و هر متنی را می‌پذیرد
- می‌تواند هم کد OTP باشد و هم پیام متنی

5. Pattern را ثبت کنید و منتظر تایید بمانید (معمولاً 1-2 روز کاری)

---

### مرحله 2: دریافت Pattern ID

بعد از تایید Pattern:
1. در لیست Pattern ها، ID Pattern را پیدا کنید (مثلاً `123456`)
2. این ID را یادداشت کنید

---

### مرحله 3: اضافه کردن به .env

فایل `.env` را باز کنید و این خط را اضافه کنید:

```env
MELIPAYAMAK_PATTERN_ID=123456
```

(عدد `123456` را با Pattern ID خودتان جایگزین کنید)

همچنین مطمئن شوید که این تنظیمات هم وجود دارند:

```env
MELIPAYAMAK_USERNAME=09155009664
MELIPAYAMAK_API_KEY=f2b89fd9-5633-4623-92c1-b3a896639f76
```

---

### مرحله 4: به‌روزرسانی کد

⚠️ **مهم:** ابتدا باید فایل `sms_service.py` را restore کنید (به فایل `RESTORE_SMS_SERVICE.md` مراجعه کنید).

بعد از restore، تابع `send_universal_pattern_sms` را به انتهای فایل `sms_service.py` اضافه کنید:

```python
def send_universal_pattern_sms(phone_number, message):
    """
    ارسال SMS با استفاده از Pattern واحد که هم برای OTP و هم برای پیام‌های متنی کار می‌کند.
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
        
        # Pattern فقط یک متغیر دارد: {0}
        pattern_args = [message]
        
        logger.info(f"Sending SMS via universal pattern {pattern_id_int} to {phone_number}")
        logger.info(f"Message: {message}")
        
        return send_sms_with_pattern(
            phone_number=phone_number,
            pattern_id=pattern_id_int,
            pattern_args=pattern_args
        )
        
    except Exception as e:
        error_msg = f"Unexpected error in send_universal_pattern_sms: {str(e)}"
        logger.error(error_msg)
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        return False, error_msg
```

---

### مرحله 5: استفاده در کد

#### برای OTP (لاگین):

در `authentication/views.py`:

```python
from zistino_apps.payments.sms_service import send_universal_pattern_sms

# در SendCodeView:
sms_success, sms_error = send_universal_pattern_sms(phone_number, code)
```

#### برای اعلان‌ها:

در `compatibility/notifications/views.py`:

```python
from zistino_apps.payments.sms_service import send_universal_pattern_sms

# در NotificationSendView:
sms_success, sms_error = send_universal_pattern_sms(phone_number, message)
```

---

### مرحله 6: ری‌استارت سرور

```bash
# Stop server (Ctrl+C)
# Then restart:
python manage.py runserver
```

---

### مرحله 7: تست

#### تست OTP:
```bash
curl -X POST http://127.0.0.1:8000/api/v1/auth/send-code/ \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "09017021166"}'
```

#### تست اعلان:
```bash
curl -X POST http://127.0.0.1:8000/api/v1/notifications/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Token YOUR_TOKEN" \
  -d '{
    "phoneNumber": "09017021166",
    "message": "سفارش شما ثبت شد"
  }'
```

---

## ✅ مزایای Pattern واحد

- ✅ یک Pattern برای همه موارد (OTP و اعلان‌ها)
- ✅ ساده و انعطاف‌پذیر
- ✅ ارزان‌تر از پیامک آزاد
- ✅ تحویل بهتر
- ✅ بدون نیاز به فعال‌سازی شماره فرستنده

---

## ⚠️ نکات مهم

1. **Pattern باید تایید شود:** تا Pattern تایید نشود، نمی‌توانید از آن استفاده کنید
2. **Pattern ID را ذخیره کنید:** بعد از ثبت Pattern، ID را در `.env` اضافه کنید
3. **تست کنید:** بعد از تایید Pattern، حتماً تست کنید

---

## 🔍 عیب‌یابی

**اگر Pattern کار نکرد:**
1. مطمئن شوید Pattern تایید شده است
2. Pattern ID را در `.env` بررسی کنید
3. لاگ‌های سرور را بررسی کنید

**لاگ‌های مفید:**
```
Sending SMS via universal pattern 123456 to 09017021166
Message: 123456
```

---

## 📞 پشتیبانی

اگر مشکلی داشتید:
1. لاگ‌های سرور را بررسی کنید
2. Pattern ID را در پنل MeliPayamak بررسی کنید
3. مطمئن شوید Pattern تایید شده است

