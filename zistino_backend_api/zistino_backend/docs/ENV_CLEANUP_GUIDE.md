# 🧹 راهنمای پاکسازی و تنظیم `.env`

## 📋 تنظیمات مورد نیاز برای SMS

### ✅ تنظیمات ضروری (فقط این‌ها را نگه دارید):

```env
# ============================================
# SMS Settings - MeliPayamak (برای اعلان‌ها)
# ============================================
# این تنظیمات برای ارسال پیامک‌های آزاد (اعلان‌ها) استفاده می‌شود
MELIPAYAMAK_USERNAME=09155009664
MELIPAYAMAK_API_KEY=f2b89fd9-5633-4623-92c1-b3a896639f76
MELIPAYAMAK_SENDER=30008666009664
MELIPAYAMAK_PATTERN_ID=395131

# ============================================
# SMS Settings - Payamak BaseServiceNumber (برای OTP)
# ============================================
# این تنظیمات فقط برای کدهای OTP (لاگین، بازیابی رمز) استفاده می‌شود
PAYAMAK_USERNAME=09155009664
PAYAMAK_PASSWORD=f2b89fd9-5633-4623-92c1-b3a896639f76
PAYAMAK_BODY_ID=270325
```

---

## ❌ تنظیمات غیرضروری (پاک کنید):

```env
# این تنظیمات استفاده نمی‌شوند - پاک کنید:
MELIPAYAMAK_API_URL=...  # استفاده نمی‌شود (default در کد است)
PAYAMAK_BASE_URL=...     # استفاده نمی‌شود (default در کد است)
SMS_SERVICE_API_KEY=...  # Legacy - استفاده نمی‌شود
SMS_SERVICE_URL=...      # Legacy - استفاده نمی‌شود
```

---

## 🔍 توضیحات

### 1️⃣ MeliPayamak Settings (برای اعلان‌ها)

- **MELIPAYAMAK_USERNAME**: شماره تلفن شما در MeliPayamak (مثلاً `09155009664`)
- **MELIPAYAMAK_API_KEY**: کلید API شما از پنل MeliPayamak
- **MELIPAYAMAK_SENDER**: شماره فرستنده (مثلاً `30008666009664`)
- **MELIPAYAMAK_PATTERN_ID**: کد Pattern تایید شده (مثلاً `395131`)

**استفاده:** برای ارسال پیامک‌های آزاد (اعلان‌ها، قرعه‌کشی، کیف پول)

---

### 2️⃣ Payamak BaseServiceNumber Settings (برای OTP)

- **PAYAMAK_USERNAME**: شماره تلفن شما در Payamak (مثلاً `09155009664`)
- **PAYAMAK_PASSWORD**: رمز عبور یا API Key شما
- **PAYAMAK_BODY_ID**: کد Pattern برای OTP (مثلاً `270325`)

**استفاده:** فقط برای کدهای OTP (لاگین، بازیابی رمز)

---

## ⚠️ نکات مهم

1. **Username یکسان؟**
   - اگر `MELIPAYAMAK_USERNAME` و `PAYAMAK_USERNAME` یکسان هستند، مشکلی نیست
   - اما `MELIPAYAMAK_API_KEY` و `PAYAMAK_PASSWORD` ممکن است متفاوت باشند

2. **Pattern ID:**
   - `MELIPAYAMAK_PATTERN_ID=395131` برای اعلان‌ها (تایید شده ✅)
   - `PAYAMAK_BODY_ID=270325` برای OTP (تایید شده ✅)

3. **Sender Number:**
   - `MELIPAYAMAK_SENDER=30008666009664` (شماره اختصاصی شما)

---

## 📝 مثال کامل `.env` (پاک شده)

```env
# Django Settings
SECRET_KEY=your-secret-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Settings
DB_NAME=zistino_db
DB_USER=postgres
DB_PASSWORD=your-password
DB_HOST=localhost
DB_PORT=5432

# Redis Settings
REDIS_URL=redis://127.0.0.1:6379/1
CELERY_BROKER_URL=redis://localhost:6379
CELERY_RESULT_BACKEND=redis://localhost:6379

# ============================================
# SMS Settings - MeliPayamak (برای اعلان‌ها)
# ============================================
MELIPAYAMAK_USERNAME=09155009664
MELIPAYAMAK_API_KEY=f2b89fd9-5633-4623-92c1-b3a896639f76
MELIPAYAMAK_SENDER=30008666009664
MELIPAYAMAK_PATTERN_ID=395131

# ============================================
# SMS Settings - Payamak BaseServiceNumber (برای OTP)
# ============================================
PAYAMAK_USERNAME=09155009664
PAYAMAK_PASSWORD=f2b89fd9-5633-4623-92c1-b3a896639f76
PAYAMAK_BODY_ID=270325
```

---

## ✅ چک‌لیست

- [ ] `MELIPAYAMAK_USERNAME` تنظیم شده است
- [ ] `MELIPAYAMAK_API_KEY` تنظیم شده است
- [ ] `MELIPAYAMAK_SENDER` تنظیم شده است
- [ ] `MELIPAYAMAK_PATTERN_ID=395131` تنظیم شده است
- [ ] `PAYAMAK_USERNAME` تنظیم شده است
- [ ] `PAYAMAK_PASSWORD` تنظیم شده است
- [ ] `PAYAMAK_BODY_ID=270325` تنظیم شده است
- [ ] تنظیمات غیرضروری پاک شده‌اند
- [ ] سرور Django راه‌اندازی مجدد شده است

---

## 🚀 بعد از تنظیمات

1. فایل `.env` را ذخیره کنید
2. سرور Django را راه‌اندازی مجدد کنید:
   ```bash
   # Ctrl+C برای توقف
   python manage.py runserver
   ```
3. از پنل React تست کنید
4. لاگ‌های Django را بررسی کنید

---

## 🔍 عیب‌یابی

### مشکل: "MELIPAYAMAK_USERNAME not configured"

**راه‌حل:** مطمئن شوید که `MELIPAYAMAK_USERNAME` در `.env` تنظیم شده است

---

### مشکل: "Pattern 395131 failed"

**راه‌حل:** 
1. مطمئن شوید که `MELIPAYAMAK_PATTERN_ID=395131` در `.env` تنظیم شده است
2. سرور را راه‌اندازی مجدد کنید
3. لاگ‌ها را بررسی کنید

---

### مشکل: "Username different"

**راه‌حل:** 
- اگر `MELIPAYAMAK_USERNAME` و `PAYAMAK_USERNAME` متفاوت هستند، مشکلی نیست
- فقط مطمئن شوید که هر کدام مربوط به حساب درست است

---

## ✅ خلاصه

**تنظیمات ضروری:**
- ✅ `MELIPAYAMAK_USERNAME` - برای اعلان‌ها
- ✅ `MELIPAYAMAK_API_KEY` - برای اعلان‌ها
- ✅ `MELIPAYAMAK_SENDER` - برای اعلان‌ها
- ✅ `MELIPAYAMAK_PATTERN_ID=395131` - برای اعلان‌ها
- ✅ `PAYAMAK_USERNAME` - برای OTP
- ✅ `PAYAMAK_PASSWORD` - برای OTP
- ✅ `PAYAMAK_BODY_ID=270325` - برای OTP

**پاک کنید:**
- ❌ `MELIPAYAMAK_API_URL` (غیرضروری)
- ❌ `PAYAMAK_BASE_URL` (غیرضروری)
- ❌ `SMS_SERVICE_API_KEY` (Legacy)
- ❌ `SMS_SERVICE_URL` (Legacy)

**موفق باشید! 🎉**

