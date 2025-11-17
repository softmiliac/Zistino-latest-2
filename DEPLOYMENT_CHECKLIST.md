# Zistino Deployment Checklist

## ✅ Pre-Deployment Review Summary

### Backend Status
- ✅ **Old Swagger Format Compliance**: All Flutter endpoints match old Swagger format
- ✅ **SMS Integration**: Payamak BaseServiceNumber and MeliPayamak configured
- ✅ **Migrations**: All migrations are in place
- ✅ **Environment Variables**: Properly configured via `.env` file
- ⚠️ **Placeholder Endpoints**: Some endpoints return empty data (by design for future features)

### React Panel Status
- ✅ **All Features Implemented**: Manual payments, center confirm, telephone requests, etc.
- ✅ **API Integration**: All endpoints properly connected
- ✅ **Console Logs**: Removed from production code
- ⚠️ **API URL**: Currently hardcoded to `http://127.0.0.1:8000/api/v1` - **NEEDS UPDATE FOR PRODUCTION**

---

## 📋 Deployment Steps

### Backend Deployment

#### 1. Environment Setup
```bash
cd zistino_backend_api/zistino_backend
```

#### 2. Create Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate  # Windows
```

#### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

#### 4. Configure Environment Variables
Copy `env_example.txt` to `.env` and update:
```bash
cp env_example.txt .env
```

**Required Environment Variables:**
- `SECRET_KEY` - **MUST CHANGE** (generate secure key)
- `DEBUG=False` - **MUST SET TO FALSE** for production
- `ALLOWED_HOSTS` - Add your domain(s)
- Database credentials (`DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`)
- Redis URL (`REDIS_URL`, `CELERY_BROKER_URL`, `CELERY_RESULT_BACKEND`)
- SMS credentials:
  - `PAYAMAK_USERNAME`
  - `PAYAMAK_PASSWORD`
  - `PAYAMAK_BODY_ID`
  - `PAYAMAK_BASE_URL`
  - `MELIPAYAMAK_USERNAME` (optional fallback)
  - `MELIPAYAMAK_API_KEY` (optional fallback)
  - `MELIPAYAMAK_SENDER` (optional fallback)

#### 5. Database Setup
```bash
# Create database (PostgreSQL)
createdb zistino_db

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser
```

#### 6. Collect Static Files
```bash
python manage.py collectstatic --noinput
```

#### 7. Production Server
Use Gunicorn (included in requirements.txt):
```bash
gunicorn zistino_backend.wsgi:application --bind 0.0.0.0:8000 --workers 4
```

#### 8. CORS Configuration
Update `CORS_ALLOWED_ORIGINS` in `settings.py` to include your React panel domain:
```python
CORS_ALLOWED_ORIGINS = [
    "https://your-react-panel-domain.com",
    # Add other allowed origins
]
```

#### 9. Celery Worker (if using background tasks)
```bash
celery -A zistino_backend worker -l info
celery -A zistino_backend beat -l info  # For scheduled tasks
```

---

### React Panel Deployment

#### 1. Environment Setup
```bash
cd panel_zistino-main/panel_zistino-main
```

#### 2. Install Dependencies
```bash
npm install
# OR
yarn install
```

#### 3. **CRITICAL: Update API URL**
Edit `src/helper/constants/configs.ts`:
```typescript
export const APP_API_URL = "https://your-backend-domain.com/api/v1";
export const APP_BASE_URL = "https://your-backend-domain.com";
```

**OR** use environment variables (recommended):
1. Create `.env` file:
```bash
VITE_API_URL=https://your-backend-domain.com/api/v1
VITE_BASE_URL=https://your-backend-domain.com
```

2. Update `configs.ts`:
```typescript
export const APP_API_URL = import.meta.env.VITE_API_URL || "http://127.0.0.1:8000/api/v1";
export const APP_BASE_URL = import.meta.env.VITE_BASE_URL || "http://127.0.0.1:8000";
```

#### 4. Build for Production
```bash
npm run build
# OR
yarn build
```

#### 5. Deploy Build Folder
The `dist/` folder contains the production build. Deploy it to:
- Nginx
- Apache
- Vercel
- Netlify
- Any static file server

---

## 🔍 Pre-Deployment Verification

### Backend Checks
- [ ] All migrations applied (`python manage.py migrate`)
- [ ] `.env` file configured with production values
- [ ] `DEBUG=False` in production
- [ ] `SECRET_KEY` changed from default
- [ ] `ALLOWED_HOSTS` includes production domain
- [ ] Database credentials correct
- [ ] SMS credentials configured
- [ ] CORS origins updated for React panel domain
- [ ] Static files collected
- [ ] Superuser created

### React Panel Checks
- [ ] API URL updated to production backend
- [ ] Build completed successfully (`npm run build`)
- [ ] No console errors in browser
- [ ] All pages load correctly
- [ ] Authentication works
- [ ] API calls succeed

---

## ⚠️ Known Placeholder Endpoints

These endpoints return empty data or placeholders (by design):
- `/api/v1/audit-logs` - Returns 501 (not implemented)
- `/api/v1/adsitems/*` - Placeholder endpoints
- `/api/v1/adszones/*` - Placeholder endpoints
- `/api/v1/repairrequests/*` - Placeholder endpoints
- Some payment gateway endpoints (Stripe, PayPal) - Placeholder implementations

**These are safe to deploy** - they return proper error responses and won't break Flutter apps.

---

## 🔐 Security Checklist

- [ ] `DEBUG=False` in production
- [ ] `SECRET_KEY` is secure and unique
- [ ] Database password is strong
- [ ] `.env` file is in `.gitignore` (not committed)
- [ ] CORS properly configured (not allowing all origins in production)
- [ ] HTTPS enabled for both backend and frontend
- [ ] API authentication tokens are secure
- [ ] SMS credentials are secure

---

## 📝 Post-Deployment Testing

### Backend Tests
1. Test authentication endpoints:
   - `POST /api/v1/auth/send-code` - Should send SMS
   - `POST /api/v1/auth/login` - Should work with code
2. Test main features:
   - Products CRUD
   - Orders listing
   - Delivery management
   - Wallet transactions

### React Panel Tests
1. Login to admin panel
2. Test all main pages:
   - Dashboard
   - Products management
   - Orders
   - Collection Requests
   - Financial reports
   - Lottery management
3. Test new features:
   - Manual payment recording
   - Center confirm (waste received)
   - Telephone requests
   - Driver tracking
   - Product codes management

---

## 🐛 Troubleshooting

### Backend Issues
- **500 Errors**: Check Django logs, verify database connection
- **CORS Errors**: Update `CORS_ALLOWED_ORIGINS` in settings.py
- **SMS Not Sending**: Verify SMS credentials in `.env`
- **Migration Errors**: Run `python manage.py migrate --run-syncdb`

### React Panel Issues
- **API Connection Errors**: Verify `APP_API_URL` in `configs.ts`
- **Build Errors**: Check for TypeScript errors, run `npm run build` with verbose output
- **Blank Pages**: Check browser console for errors, verify API responses

---

## 📞 Support

For deployment issues, check:
1. Backend logs: `python manage.py runserver` (development) or Gunicorn logs (production)
2. React build output: Check `dist/` folder contents
3. Browser console: Check for JavaScript errors
4. Network tab: Verify API calls are reaching backend

---

## ✅ Final Checklist Before Handoff

- [ ] Backend deployed and accessible
- [ ] React panel deployed and accessible
- [ ] API URL in React points to production backend
- [ ] All environment variables configured
- [ ] Database migrations applied
- [ ] Superuser account created
- [ ] SMS service tested and working
- [ ] CORS properly configured
- [ ] HTTPS enabled (recommended)
- [ ] Documentation provided to hosting team

---

**Last Updated**: 2025-01-XX
**Status**: ✅ Ready for Deployment (with API URL update required)

