# Zistino Backend API Documentation

## 📚 Documentation Overview

Welcome to the Zistino Backend API documentation. This documentation is designed for developers who will integrate with our API using the **compatibility endpoints** (old Swagger format).

**Important**: All endpoints documented here use the compatibility layer format that matches the old Swagger specification. This is the format used by:
- React Admin Panel
- Flutter Customer App
- Flutter Driver App
- Flutter Manager App

---

## 🎯 Main Documentation

### **[API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md)** ⭐ **START HERE**

**This is the main guide for new developers.** It provides step-by-step instructions on how to use all API endpoints, starting with authentication and covering all major features.

**What it covers:**
- Step 1: Get Authentication Token (`/api/v1/tokens/tokenbyemail`)
- Step 2: Authorize Yourself
- Step 3: Get User Profile (`/api/v1/personal/profile`)
- Step 4: Browse Products (`/api/v1/products/search`)
- Step 5: Get Categories (`/api/v1/categories/`)
- Step 6: Add to Basket (`/api/v1/baskets/`)
- Step 7: Create Order (`/api/v1/orders/`)
- Step 8: Manage Addresses (`/api/v1/addresses/`)
- Step 9: Check Wallet (`/api/v1/transactionwallet/mytransactionwallettotal`)
- Step 10: Check Points (`/api/v1/points/my-balance`)
- And more...

**Use this guide if:**
- You're a new developer starting with the API
- You need to understand the complete flow
- You want step-by-step instructions
- You're integrating Flutter apps or React panel

---

## 📖 Feature-Specific Guides

### **[3-products-categories-guide](./3-products-categories-guide/README.md)**
Detailed guide for products and categories management.

**Endpoints covered:**
- `/api/v1/products/` - List, create, update, delete products
- `/api/v1/products/search` - Search products
- `/api/v1/categories/` - Manage categories

### **[4-basket-guide](./4-basket-guide/README.md)**
Guide for shopping cart (basket) functionality.

**Endpoints covered:**
- `/api/v1/baskets/` - Manage shopping cart

### **[5-orders-guide](./5-orders-guide/README.md)**
Guide for order management.

**Endpoints covered:**
- `/api/v1/orders/` - Create and manage orders
- `/api/v1/orders/search` - Search orders

### **[6-deliveries-customer-guide](./6-deliveries-customer-guide/README.md)**
Guide for customer delivery requests.

### **[7-deliveries-driver-guide](./7-deliveries-driver-guide/README.md)**
Guide for driver delivery management.

### **[8-payments-wallet-guide](./8-payments-wallet-guide/README.md)**
Guide for wallet and payment functionality.

**Endpoints covered:**
- `/api/v1/transactionwallet/` - Wallet operations

### **[9-points-lottery-guide](./9-points-lottery-guide/README.md)**
Guide for points and lottery system.

**Endpoints covered:**
- `/api/v1/points/` - Points balance and history
- `/api/v1/lotteries/` - Lottery management

### **[10-manager-guide](./10-manager-guide/README.md)**
Guide for manager/admin specific endpoints.

---

## 🔑 Authentication Endpoints

**All authentication uses compatibility endpoints:**

- **Login with Email/Password**: `POST /api/v1/tokens/tokenbyemail`
- **Login with Phone Code**: `POST /api/v1/tokens/token-by-code`
- **Send Verification Code**: `GET /api/v1/tokens/send-code?phoneNumber=...`
- **Register**: `POST /api/v1/identity/register-with-code`
- **Forgot Password**: `POST /api/v1/identity/forgot-password-by-code`
- **Reset Password**: `POST /api/v1/identity/reset-password-by-code`

**See [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md) Step 1 for detailed instructions.**

---

## ⚠️ Important Notes

### Endpoint Format

**✅ CORRECT (Use These):**
- `/api/v1/tokens/tokenbyemail` - Login
- `/api/v1/personal/profile` - User profile
- `/api/v1/products/search` - Search products
- `/api/v1/orders/` - Orders
- `/api/v1/addresses/` - Addresses
- `/api/v1/categories/` - Categories

**❌ WRONG (Don't Use These):**
- `/api/v1/auth/login/` - Old format, not used
- `/api/v1/users/profile/` - Old format, not used
- `/api/v1/products/products/` - Old format, not used

### Response Format

All endpoints return data in this format:
```json
{
  "data": { ... },
  "messages": [],
  "succeeded": true
}
```

### Authorization

All protected endpoints require this header:
```
Authorization: Bearer YOUR_TOKEN_HERE
```

Get your token using: `POST /api/v1/tokens/tokenbyemail`

---

## 🚀 Quick Start

1. **Read [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md)** - Complete step-by-step guide
2. **Get your token** - Use `POST /api/v1/tokens/tokenbyemail` with email and password
3. **Authorize** - Add `Authorization: Bearer YOUR_TOKEN` header to all requests
4. **Start using endpoints** - Follow the guide for each feature

---

## 📝 Additional Resources

- **Swagger UI**: `http://127.0.0.1:8000/api/schema/swagger-ui/` - Interactive API documentation
- **API Schema**: `http://127.0.0.1:8000/api/schema/` - OpenAPI schema file

---

## ❓ Need Help?

- Refer to [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md) for step-by-step instructions
- Check Swagger UI for interactive testing
- Contact the backend team for support

---

**Last Updated**: 2025-11-08

