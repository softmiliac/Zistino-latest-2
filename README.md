# Zistino Project

> Repo: [softmiliac/Zistino-latest-2](https://github.com/softmiliac/Zistino-latest-2)

## Overview

Zistino is a multi-module platform for recycling management, client orders, driver assignments, wallet and points integration, and backend operations. It uses Flutter (Dart) for customer, driver, and admin apps, along with Django/Python for backend APIs, and React/TypeScript for web panels.

Modules include:
- **zistino-main**: Customer-facing Flutter app
- **zistino_driver-main**: Driver app (Flutter)
- **zistino_manager-master**: Manager/Admin app (Flutter)
- **panel_zistino-main**, **zistino_customer_web**: Web panels (React/TS)
- **zistino_backend**: Django backend and API

## Main Features

- Mobile/web interfaces for customer ordering and tracking
- Driver zone-based job assignment & management
- Admin management for users, products, zones, and orders
- Points and wallet system, including lottery campaigns
- SMS registration and notifications
- Modern Flutter tooling (`GetX`, `Hive`, multi-language UI)
- API compatibility layer for seamless old/new frontend-backend integration

## Detailed Usage – How It Works

### 📱 Customer

1. **Registration/Authentication**: Enter phone, receive SMS code, get authentication token via `/identity/register-with-code`.
2. **Profile**: Edit profile, manage addresses with location, upload images.
3. **Browse & Order**: Browse recyclable categories, add products to basket, create orders with addresses.
4. **Track Orders**: Orders assigned zone and matched driver; statuses update in app and via SMS.
5. **Wallet & Points**: Earn points for orders/referrals, monitor wallet balance, request deposits, participate in lottery draws.
6. **Lottery & Referral**: Lottery and referral system managed via backend; view draws and winners in-app, share referral codes.

### 🚚 Driver

1. **Login/Profile**: Similar registration & zone-based assignment.
2. **Jobs**: View assigned orders by zone, fulfill pickups/deliveries, mark status as completed.
3. **Points & Wallet**: Earnings and points tracked for each delivery; visible in app.

### 🖥️ Admin/Manager

- Use panel to manage zones, assign drivers, view orders, manage products, control wallet transactions, and oversee lottery campaigns.

### ⚙️ Backend Integration

Backend is a Django REST API with compatibility routes for different frontend endpoint conventions.
- Authentication via token
- Profile management (user, driver, address)
- Wallet and points via `/wallet/`, `/points/`
- Orders/products/zones via `/orders/`, `/products/`, `/zones/`
- Notifications via SMS gateway
- Lottery campaign admin via `/lotteries/` plus weighted random draws, etc.

Deployment steps:
1. Database setup (`createdb`, migrations)
2. Static file collection
3. Production server with Gunicorn
4. CORS configuration for web panels

## Example System Workflows

**Customer order:**
- Place order → Backend assigns zone/driver → Driver receives job → Completion triggers points, wallet, status updates, and notifications.

**Driver lottery draw:**
- Drivers earn points for deliveries/referrals → Admin defines lottery in panel → Eligible drivers filtered by points → Backend performs weighted random draw → Winner notified, shown in app.

Detailed API flow, endpoints, lottery logic, and developer onboarding are documented in:
- [`docs/NEW_DEVELOPER_GUIDE.md`](zistino_backend_api/zistino_backend/docs/NEW_DEVELOPER_GUIDE.md)
- [`docs/SIMPLE_EXPLANATION.md`](zistino_backend_api/zistino_backend/docs/SIMPLE_EXPLANATION.md)
- [`docs/9-points-lottery-guide/LOTTERY_FLOW.md`](zistino_backend_api/zistino_backend/docs/9-points-lottery-guide/LOTTERY_FLOW.md)

## Install & Run

1. **Clone repo**:  
   `git clone https://github.com/softmiliac/Zistino-latest-2`
2. **Setup backend**:
   - Install dependencies, create DB, run migrations
   - Start server: `gunicorn zistino_backend.wsgi:application --bind 0.0.0.0:8000 --workers 4`
3. **Install frontend apps**:  
   - Enter submodule, run `flutter pub get`, then `flutter run -d chrome` (etc.)
   - For web panels, follow their README instructions

## Contributing

- Fork, branch, and submit PRs for fixes and features.
- See each package's README for guidelines.
- Open issues for bugs or requests.

## License

Root repo does not specify a license; refer to individual package license files for details.

## Further Docs

- [Flutter documentation](https://docs.flutter.dev/)
- [Django documentation](https://docs.djangoproject.com/en/5.0/)
- Project internal docs (see `zistino_backend_api/zistino_backend/docs/`).

---

> This README is bot-generated from project docs, backend API references, and code annotation.
