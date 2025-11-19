# Documentation Changelog

## 2025-11-08 - Documentation Cleanup

### Removed Guides (Used Wrong Endpoints)

The following guides were **removed** because they documented endpoints that don't match the compatibility layer (old Swagger format) used by React panel and Flutter apps:

1. **`1-authentication-guide/README.md`** ❌
   - **Problem**: Used `/api/v1/auth/send-code/`, `/api/v1/auth/register/`, `/api/v1/auth/login/`
   - **Correct endpoints**: `/api/v1/tokens/tokenbyemail`, `/api/v1/tokens/token-by-code`, `/api/v1/identity/register-with-code`
   - **Replacement**: See [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md) Step 1

2. **`2-user-profile-guide/README.md`** ❌
   - **Problem**: Used `/api/v1/users/profile/`, `/api/v1/users/customer/addresses/`
   - **Correct endpoints**: `/api/v1/personal/profile`, `/api/v1/addresses/`
   - **Replacement**: See [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md) Step 3 and Step 8

3. **`NEW_DEVELOPER_GUIDE.md`** ❌
   - **Problem**: Used wrong endpoints throughout (`/api/v1/auth/`, `/api/v1/users/`, etc.)
   - **Replacement**: See [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md) - Complete guide with correct endpoints

4. **`SIMPLE_EXPLANATION.md`** ❌
   - **Problem**: Explained compatibility layer but could be confusing
   - **Replacement**: See [README.md](./README.md) for overview

### Updated Guides (Fixed to Use Correct Endpoints)

The following guides were **updated** to use the correct compatibility endpoints:

1. **`API_ENDPOINTS_GUIDE.md`** ✅
   - Main guide for new developers
   - Uses all correct compatibility endpoints
   - Step-by-step instructions

2. **`3-products-categories-guide/README.md`** ✅ **UPDATED**
   - **Fixed**: Changed `/api/v1/products/categories/` → `/api/v1/categories/`
   - **Fixed**: Changed `/api/v1/products/products/` → `/api/v1/products/`
   - **Fixed**: Changed `/api/v1/products/products/{id}/` → `/api/v1/products/{id}`
   - **Fixed**: Changed `/api/v1/products/products/{id}/codes/` → `/api/v1/products/{id}/codes`
   - **Fixed**: Updated search to use `POST /api/v1/products/search`
   - **Fixed**: Changed `Authorization: Token` → `Authorization: Bearer`

3. **`4-basket-guide/README.md`** ✅ **UPDATED**
   - **Fixed**: Changed `/api/v1/baskets/items/` → `/api/v1/baskets/client`
   - **Fixed**: Changed `Authorization: Token` → `Authorization: Bearer`

4. **`5-orders-guide/README.md`** ✅ **UPDATED**
   - **Fixed**: Changed `/api/v1/orders/customer/orders/` → `/api/v1/orders/`
   - **Fixed**: Changed `/api/v1/orders/customer/orders/client/search/` → `/api/v1/orders/client/search`
   - **Fixed**: Changed `/api/v1/orders/customer/orders/{id}/` → `/api/v1/orders/client/{id}`
   - **Fixed**: Changed `Authorization: Token` → `Authorization: Bearer`

5. **`6-deliveries-customer-guide/README.md`** ✅
   - Uses `/api/v1/deliveries/` (correct)

6. **`7-deliveries-driver-guide/README.md`** ✅
   - Uses `/api/v1/deliveries/` (correct)

7. **`8-payments-wallet-guide/README.md`** ✅
   - Uses `/api/v1/transactionwallet/` (correct)

8. **`9-points-lottery-guide/README.md`** ✅
   - Uses `/api/v1/points/` and `/api/v1/lotteries/` (correct)

9. **`10-manager-guide/README.md`** ✅
   - Manager-specific endpoints (correct)

### New Files

1. **`README.md`** ✅
   - Main documentation index
   - Points to correct guides
   - Explains endpoint format

2. **`CHANGELOG.md`** ✅ (this file)
   - Documents all changes made

---

## Why These Changes?

**Problem**: Multiple guides documented different endpoint formats, causing confusion:
- Some guides used `/api/v1/auth/` (new format, not used)
- Some guides used `/api/v1/users/` (new format, not used)
- React panel and Flutter apps use compatibility endpoints (`/api/v1/tokens/`, `/api/v1/personal/`, etc.)

**Solution**: 
- Removed guides with wrong endpoints
- Kept only guides that use compatibility endpoints (old Swagger format)
- Created clear main guide ([API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md)) that uses correct endpoints throughout

**Result**: 
- Clear, consistent documentation
- All guides use the same endpoint format (compatibility endpoints)
- No confusion about which endpoints to use
- All endpoints match the old Swagger format used by React panel and Flutter apps
- New developers have one clear path: [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md)
- All authorization headers use `Bearer` format (not `Token`)

---

## For New Developers

**Start here**: [API_ENDPOINTS_GUIDE.md](./API_ENDPOINTS_GUIDE.md)

This guide covers everything step-by-step using the correct compatibility endpoints that match:
- React Admin Panel
- Flutter Customer App
- Flutter Driver App
- Flutter Manager App

