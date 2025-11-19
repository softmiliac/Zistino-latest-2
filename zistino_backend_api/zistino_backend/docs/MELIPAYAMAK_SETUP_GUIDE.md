# How to Configure MeliPayamak for Notifications

## 📋 Overview

MeliPayamak is needed to send **free-form text messages** (like notifications). The current Payamak BaseServiceNumber is only for pattern-based OTP codes, which is why some phone numbers don't receive notifications.

## 🔑 Step 1: Get Your MeliPayamak Credentials

### Option A: If You Already Have a MeliPayamak Account

1. **Login to MeliPayamak Dashboard**: https://panel.payamak-panel.com/
2. **Go to Settings/Developer Menu**: Look for "تنظیمات" or "Developer" or "Web Service"
3. **Find Your API Key**: 
   - Look for "API Key" or "کلید API" or "Web Service Key"
   - It's usually a long string like: `f2b89fd9-5633-4623-92c1-b3a896639f76`
4. **Find Your Username**: 
   - This is usually your phone number (the one you registered with)
   - Example: `09155009664`
5. **Find Your Sender Number**: 
   - This is the number that appears as the sender when SMS is received
   - It's usually a short number like `21700077` or `50004001`
   - Check "شماره فرستنده" or "Sender Number" in dashboard

### Option B: If You Don't Have a MeliPayamak Account

1. **Register at**: https://panel.payamak-panel.com/
2. **Complete registration** with your phone number
3. **Add credit** to your account (you need credit to send SMS)
4. **Get API Key** from Developer/Web Service section
5. **Get Sender Number** - you may need to request one or use a default

## 📝 Step 2: Add Credentials to .env File

Open your `.env` file (located at `zistino_backend_api/zistino_backend/.env`) and add these lines:

```env
# MeliPayamak Settings (for free-form notifications)
MELIPAYAMAK_USERNAME=09155009664
MELIPAYAMAK_API_KEY=your-api-key-here
MELIPAYAMAK_SENDER=21700077
MELIPAYAMAK_API_URL=https://rest.payamak-panel.com/api/SendSMS/SendSMS
```

### Replace with Your Actual Values:

- **MELIPAYAMAK_USERNAME**: Your MeliPayamak account phone number (e.g., `09155009664`)
- **MELIPAYAMAK_API_KEY**: Your API key from MeliPayamak dashboard (e.g., `f2b89fd9-5633-4623-92c1-b3a896639f76`)
- **MELIPAYAMAK_SENDER**: Your sender number (e.g., `21700077`)
- **MELIPAYAMAK_API_URL**: Keep this as is (default URL)

## 🔍 Step 3: Verify Your Current .env File

Your current `.env` file should look like this (with your actual values):

```env
# Django Settings
SECRET_KEY=django-backend-security-key-for-secret
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Settings
DB_NAME=zistino_db
DB_USER=postgres
DB_PASSWORD=123
DB_HOST=localhost
DB_PORT=5432

# Redis Settings
REDIS_URL=redis://127.0.0.1:6379/1
CELERY_BROKER_URL=redis://localhost:6379
CELERY_RESULT_BACKEND=redis://localhost:6379

# Payamak BaseServiceNumber (for OTP codes)
PAYAMAK_USERNAME=09155009664
PAYAMAK_PASSWORD=f2b89fd9-5633-4623-92c1-b3a896639f76
PAYAMAK_BODY_ID=270325
PAYAMAK_BASE_URL=https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber

# MeliPayamak Settings (for free-form notifications) - ADD THESE:
MELIPAYAMAK_USERNAME=09155009664
MELIPAYAMAK_API_KEY=your-api-key-here
MELIPAYAMAK_SENDER=21700077
MELIPAYAMAK_API_URL=https://rest.payamak-panel.com/api/SendSMS/SendSMS
```

## ⚠️ Important Notes:

1. **Username vs API Key**:
   - `MELIPAYAMAK_USERNAME` = Your phone number (like `09155009664`)
   - `MELIPAYAMAK_API_KEY` = Your API key (long string from dashboard)
   - These are **different** from `PAYAMAK_USERNAME` and `PAYAMAK_PASSWORD`

2. **Same Account?**: 
   - If your MeliPayamak account uses the same phone number as Payamak, you can use the same username
   - But the API Key might be different - check your MeliPayamak dashboard

3. **Sender Number**:
   - This is the number that appears when users receive SMS
   - It's usually a short number (4-8 digits) like `21700077`
   - If you don't have one, check your MeliPayamak dashboard or contact support

## 🚀 Step 4: Restart Django Server

After adding the credentials:

1. **Stop your Django server** (Ctrl+C)
2. **Start it again**: `python manage.py runserver`
3. **Check logs** - you should see "Using MeliPayamak SMS service" instead of "MeliPayamak not configured"

## ✅ Step 5: Test

1. **Go to React Admin Panel** → Notifications
2. **Enter phone number**: `09017021166`
3. **Enter message**: "Test notification"
4. **Click Send**
5. **Check logs** - should show "Sending SMS via MeliPayamak REST API"
6. **Check phone** - SMS should arrive!

## 🐛 Troubleshooting

### Problem: "MeliPayamak credentials not configured"
**Solution**: Make sure you added all 4 lines to `.env` file and restarted Django server

### Problem: "Invalid username or password"
**Solution**: 
- Check that `MELIPAYAMAK_USERNAME` is your phone number (not display name)
- Check that `MELIPAYAMAK_API_KEY` is correct (copy from dashboard exactly)
- Make sure there are no extra spaces in `.env` file

### Problem: "Failed to send SMS"
**Solution**:
- Check your MeliPayamak account has credit/balance
- Check sender number is correct
- Check phone number format (should be `09123456789` or `+989123456789`)

### Problem: SMS still not arriving
**Solution**:
- Check MeliPayamak dashboard for delivery reports
- Check if phone number is blocked/blacklisted
- Try with a different phone number to test
- Check Django logs for detailed error messages

## 📞 Need Help?

If you can't find your MeliPayamak credentials:
1. Login to https://panel.payamak-panel.com/
2. Look for "Web Service" or "API" or "Developer" section
3. Contact MeliPayamak support if needed

---

**After configuration, notifications will work for ALL phone numbers!** 🎉

