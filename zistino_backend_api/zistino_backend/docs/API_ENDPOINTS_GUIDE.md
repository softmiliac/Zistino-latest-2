# Complete API Endpoints Guide for New Developers

## 📖 Introduction

Welcome! This guide will teach you how to interact with the Zistino Backend API step by step. Even if you're not a programmer, this guide will help you understand how to use all the API endpoints.

**Important**: All API requests should be sent to: `http://127.0.0.1:8000/api/v1/` (or your server URL)

You can use tools like:
- **Swagger UI**: Open `http://127.0.0.1:8000/api/schema/swagger-ui/` in your browser
- **Postman**: A desktop application for testing APIs
- **cURL**: Command line tool
- **Any HTTP client**: Your Flutter app, JavaScript, etc.

---

## 🔐 STEP 1: Get Your Authentication Token

**Why do you need this?** Before you can access most API endpoints, you need to prove who you are. This is called "authentication". You get a special code called a "token" that you'll use for all other requests.

### Endpoint: `POST /api/v1/tokens/tokenbyemail`

**What this does**: This endpoint lets you log in using your email and password. After successful login, you'll receive a token that you must use for all other API calls.

**How to use it**:

1. **Method**: POST
2. **URL**: `http://127.0.0.1:8000/api/v1/tokens/tokenbyemail`
3. **Headers**: 
   - `Content-Type: application/json`
   - `tenant: root` (this is required!)

4. **Request Body** (JSON):
```json
{
  "email": "akmalnawabi007@gmail.com",
  "password": "admin"
}
```

**What to expect**:

If successful, you'll get a response like this:
```json
{
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "abc123def456...",
    "refreshTokenExpiryTime": "2025-11-15T10:30:00Z"
  },
  "messages": [],
  "succeeded": true
}
```

**What you need to do**: 
- Copy the `token` value from the response. This is your authentication token.
- You'll use this token in the next step to authorize yourself.
- Save this token somewhere safe - you'll need it for all future requests!

**Important Notes**:
- The token expires after some time (usually 7 days). If your token stops working, just get a new one using this same endpoint.
- If you get an error, check:
  - Is your email correct? (`akmalnawabi007@gmail.com`)
  - Is your password correct? (`admin`)
  - Did you include the `tenant: root` header?
  - Is the server running?

---

## 🔑 STEP 2: Authorize Yourself (Use Your Token)

**Why do you need this?** Now that you have a token, you need to tell the API "Hey, it's me!" every time you make a request. This is called "authorization".

**How to authorize**:

Every time you make a request to a protected endpoint (most endpoints), you need to add this header:

```
Authorization: Bearer YOUR_TOKEN_HERE
```

**Example**:
If your token is `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`, your header should be:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**In Swagger UI**:
1. Look for the "Authorize" button (usually at the top right)
2. Click it
3. In the "Value" field, enter: `Bearer YOUR_TOKEN_HERE` (include the word "Bearer" and a space before your token)
4. Click "Authorize"
5. Now all your requests will automatically include this token

**In Postman**:
1. Go to the "Authorization" tab
2. Select "Bearer Token" from the Type dropdown
3. Paste your token in the "Token" field
4. Save

**In cURL**:
Add this to your command:
```bash
-H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**What you need to do**:
- Make sure you understand how to add the Authorization header
- Test it by trying to access a protected endpoint (like getting your profile in the next step)
- If you get a 401 Unauthorized error, it means your token is missing or incorrect

---

## 👤 STEP 3: Get Your User Profile

**Why do you need this?** Your profile contains all your personal information - name, email, phone number, etc. This is usually the first thing you check after logging in.

### Endpoint: `GET /api/v1/personal/profile`

**What this does**: Gets all the information about the currently logged-in user (that's you, since you're using your token).

**How to use it**:

1. **Method**: GET
2. **URL**: `http://127.0.0.1:8000/api/v1/personal/profile`
3. **Headers**: 
   - `Authorization: Bearer YOUR_TOKEN_HERE` (the token you got in Step 1)

4. **Request Body**: None (GET requests don't have a body)

**What to expect**:

You'll get a response with all your user information:
```json
{
  "data": {
    "id": "906b27f1-8748-47bd-963f-45ef990d6076",
    "userName": "akmalnawabi007@gmail.com",
    "firstName": "Akmal",
    "lastName": "Nawabi",
    "email": "akmalnawabi007@gmail.com",
    "phoneNumber": "+989121234567",
    "isActive": true,
    "imageUrl": "https://...",
    // ... more fields
  },
  "messages": [],
  "succeeded": true
}
```

**What you need to do**:
- Make sure you're using the Authorization header with your token
- Check that you can see your user information
- If this works, congratulations! You've successfully authenticated and authorized yourself.

**Common Issues**:
- **401 Unauthorized**: Your token is missing or wrong. Go back to Step 1 and get a new token.
- **404 Not Found**: Check the URL - make sure it's `/api/v1/personal/profile` (not `/profile`)

---

## 🛍️ STEP 4: Browse Products

**Why do you need this?** Products are the items that users can order. You need to see what products are available in the system.

### Endpoint: `POST /api/v1/products/search`

**What this does**: Searches for products. You can search by name, filter by category, and get a list of products with pagination.

**How to use it**:

1. **Method**: POST
2. **URL**: `http://127.0.0.1:8000/api/v1/products/search`
3. **Headers**: 
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body** (JSON):
```json
{
  "pageNumber": 1,
  "pageSize": 20,
  "keyword": "",
  "categoryId": ""
}
```

**Explanation of fields**:
- `pageNumber`: Which page of results you want (start with 1)
- `pageSize`: How many products per page (10, 20, 50, etc.)
- `keyword`: Search term - leave empty `""` to get all products, or enter a product name to search
- `categoryId`: Filter by category - leave empty `""` for all categories, or enter a category UUID

**What to expect**:

You'll get a list of products:
```json
{
  "data": [
    {
      "id": "9c451b27-e822-4882-bba4-ebc20b45fca3",
      "name": "Product Name",
      "description": "Product description",
      "price": 120000,
      "imageUrl": "https://...",
      "categoryId": "...",
      // ... more fields
    }
  ],
  "currentPage": 1,
  "totalPages": 5,
  "totalCount": 100,
  "pageSize": 20,
  "hasPreviousPage": false,
  "hasNextPage": true
}
```

**What you need to do**:
- Try searching with an empty keyword to see all products
- Try searching with a keyword like "phone" to find specific products
- Notice the pagination information - you can request different pages
- Save a product ID - you'll need it for creating orders later

**Alternative Endpoint**: `GET /api/v1/products/` - Gets all products (simpler, but less flexible)

---

## 📦 STEP 5: Get Product Categories

**Why do you need this?** Categories help organize products. Users can browse products by category (like "Electronics", "Clothing", etc.).

### Endpoint: `GET /api/v1/categories/`

**What this does**: Gets a list of all product categories in the system.

**How to use it**:

1. **Method**: GET
2. **URL**: `http://127.0.0.1:8000/api/v1/categories/`
3. **Headers**: 
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body**: None

**What to expect**:

You'll get a list of categories:
```json
{
  "data": [
    {
      "id": "category-uuid-here",
      "name": "Electronics",
      "description": "Electronic products",
      "imageUrl": "https://...",
      "isActive": true
    },
    {
      "id": "another-uuid",
      "name": "Clothing",
      // ...
    }
  ]
}
```

**What you need to do**:
- Browse the categories to understand how products are organized
- Save a category ID if you want to filter products by category in Step 4
- Notice which categories are active (`isActive: true`)

---

## 🛒 STEP 6: Add Items to Basket (Shopping Cart)

**Why do you need this?** Before creating an order, users add products to their shopping cart (basket). This lets them review what they want before ordering.

### Endpoint: `POST /api/v1/baskets/`

**What this does**: Creates a new basket (shopping cart) or adds items to your existing basket.

**How to use it**:

1. **Method**: POST
2. **URL**: `http://127.0.0.1:8000/api/v1/baskets/`
3. **Headers**: 
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body** (JSON):
```json
{
  "productId": "9c451b27-e822-4882-bba4-ebc20b45fca3",
  "quantity": 2
}
```

**Explanation of fields**:
- `productId`: The UUID of the product you want to add (get this from Step 4)
- `quantity`: How many of this product you want (must be at least 1)

**What to expect**:

Success response:
```json
{
  "data": {
    "id": 123,
    "totalItems": 2,
    "cartTotal": 240000,
    "items": [
      {
        "productId": "9c451b27-e822-4882-bba4-ebc20b45fca3",
        "name": "Product Name",
        "quantity": 2,
        "price": 120000,
        "itemTotal": 240000
      }
    ]
  },
  "messages": [],
  "succeeded": true
}
```

**What you need to do**:
- Use a product ID from Step 4
- Add multiple items by calling this endpoint multiple times
- Check your basket total - this is how much the order will cost

**Related Endpoints**:
- `GET /api/v1/baskets/` - Get your current basket
- `DELETE /api/v1/baskets/{itemId}/` - Remove an item from basket
- `PUT /api/v1/baskets/{itemId}/` - Update item quantity

---

## 📝 STEP 7: Create an Order

**Why do you need this?** This is the most important step! Users create orders to purchase products. An order contains all the products they want, delivery address, phone numbers, etc.

### Endpoint: `POST /api/v1/orders/`

**What this does**: Creates a new order with products, customer information, and delivery details.

**How to use it**:

1. **Method**: POST
2. **URL**: `http://127.0.0.1:8000/api/v1/orders/`
3. **Headers**: 
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body** (JSON):
```json
{
  "totalPrice": 12340,
  "address1": "123 Main Street",
  "address2": "Apartment 4B",
  "phone1": "+989121234567",
  "phone2": "+989121234568",
  "createOrderDate": "2025-11-08T13:20:19.417Z",
  "submitPriceDate": null,
  "sendToPostDate": null,
  "postStateNumber": "",
  "paymentTrackingCode": "",
  "status": 0,
  "couponId": 0,
  "couponKey": "",
  "userId": "906b27f1-8748-47bd-963f-45ef990d6076",
  "userFullname": "Akmal Nawabi",
  "latitude": 35.6892,
  "longitude": 51.3890,
  "addressid": 0,
  "city": "Tehran",
  "country": "Iran",
  "description": "Please deliver in the morning",
  "rate": 0,
  "storeId": 0,
  "ressellerId": null,
  "orderItems": [
    {
      "productId": "9c451b27-e822-4882-bba4-ebc20b45fca3",
      "unitPrice": 120,
      "unitDiscountPrice": 0,
      "itemCount": 2,
      "status": 0,
      "description": "Product description"
    }
  ]
}
```

**Important Notes**:
- `address1`, `address2`, `phone1`, `phone2` are **optional** - you can:
  - Omit them completely
  - Pass `null`
  - Pass empty string `""`
  - Pass actual values
- `userId`: Use your user ID from Step 3 (your profile)
- `orderItems`: Array of products - each item needs `productId`, `unitPrice`, `itemCount`
- `totalPrice`: Sum of all items (unitPrice × itemCount for each item)
- `status`: 0 = pending, 1 = confirmed, 2 = in_progress, 3 = completed, 4 = cancelled

**What to expect**:

Success response:
```json
{
  "data": "order-uuid-here",
  "messages": [],
  "succeeded": true
}
```

The `data` field contains the order ID (UUID) - save this!

**What you need to do**:
- Make sure all required fields are filled
- Calculate `totalPrice` correctly (sum of all items)
- Use valid product IDs from Step 4
- Use your user ID from Step 3
- Test with optional address/phone fields (try omitting them, passing null, or passing empty strings)

**Common Issues**:
- **400 Bad Request**: Check that all required fields are present and valid
- **404 Not Found**: Product ID or User ID doesn't exist
- **401 Unauthorized**: Your token expired - get a new one from Step 1

---

## 📍 STEP 8: Manage Addresses

**Why do you need this?** Users can save multiple delivery addresses. This makes it easier to create orders without typing the address every time.

### Endpoint: `POST /api/v1/addresses/`

**What this does**: Creates a new saved address for the logged-in user.

**How to use it**:

1. **Method**: POST
2. **URL**: `http://127.0.0.1:8000/api/v1/addresses/`
3. **Headers**: 
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body** (JSON):
```json
{
  "address": "123 Main Street, Apartment 4B",
  "city": "Tehran",
  "country": "Iran",
  "phoneNumber": "+989121234567",
  "latitude": 35.6892,
  "longitude": 51.3890,
  "isDefault": true
}
```

**What to expect**:

Success response with the created address:
```json
{
  "data": {
    "id": 1,
    "address": "123 Main Street, Apartment 4B",
    "city": "Tehran",
    "country": "Iran",
    "phoneNumber": "+989121234567",
    "latitude": 35.6892,
    "longitude": 51.3890,
    "isDefault": true
  },
  "messages": [],
  "succeeded": true
}
```

**What you need to do**:
- Save the address ID - you can use it in Step 7 when creating orders (set `addressid` field)
- Create multiple addresses for testing
- Set one as default (`isDefault: true`)

**Related Endpoints**:
- `GET /api/v1/addresses/` - Get all your saved addresses
- `GET /api/v1/addresses/{id}/` - Get a specific address
- `PUT /api/v1/addresses/{id}/` - Update an address
- `DELETE /api/v1/addresses/{id}/` - Delete an address

---

## 💰 STEP 9: Check Your Wallet Balance

**Why do you need this?** Users have a wallet with money they can use to pay for orders. This endpoint shows how much money is in the wallet.

### Endpoint: `GET /api/v1/transactionwallet/mytransactionwallettotal`

**What this does**: Gets the total balance in your wallet.

**How to use it**:

1. **Method**: GET
2. **URL**: `http://127.0.0.1:8000/api/v1/transactionwallet/mytransactionwallettotal`
3. **Headers**: 
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body**: None

**What to expect**:

```json
{
  "data": {
    "total": 500000,
    "currency": "IRR"
  },
  "messages": [],
  "succeeded": true
}
```

**What you need to do**:
- Check your current balance
- Understand that this is the money available for payments

**Related Endpoint**:
- `GET /api/v1/transactionwallet/mytransactionwallethistory` - Get your wallet transaction history

---

## 🎁 STEP 10: Check Points and Lottery

**Why do you need this?** Users earn points for orders and referrals. They can use points to participate in lotteries.

### Endpoint: `GET /api/v1/points/my-balance`

**What this does**: Gets your current points balance.

**How to use it**:

1. **Method**: GET
2. **URL**: `http://127.0.0.1:8000/api/v1/points/my-balance`
3. **Headers**: 
   - `Authorization: Bearer YOUR_TOKEN_HERE`

**What to expect**:

```json
{
  "balance": 150,
  "lifetimeEarned": 200,
  "lifetimeSpent": 50
}
```

**What you need to do**:
- Check your points balance
- Understand how points work in the system

**Related Endpoints**:
- `GET /api/v1/points/my-history` - Get your points transaction history
- `GET /api/v1/lotteries/active` - Get active lotteries you can participate in
- `GET /api/v1/referrals/my-code` - Get your referral code

---

## 🚚 STEP 11: Check Deliveries (For Drivers)

**Why do you need this?** If you're a driver, you need to see delivery requests and manage them.

### Endpoint: `POST /api/v1/driverdelivery/search`

**What this does**: Searches for delivery requests (for drivers).

**How to use it**:

1. **Method**: POST
2. **URL**: `http://127.0.0.1:8000/api/v1/driverdelivery/search`
3. **Headers**: 
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body** (JSON):
```json
{
  "pageNumber": 1,
  "pageSize": 20,
  "status": "pending"
}
```

**What to expect**:

List of delivery requests:
```json
{
  "data": [
    {
      "id": "delivery-uuid",
      "orderId": "order-uuid",
      "status": "pending",
      "pickupAddress": "...",
      "deliveryAddress": "...",
      // ... more fields
    }
  ],
  "currentPage": 1,
  "totalCount": 10
}
```

**What you need to do**:
- Only drivers can access this
- Check available delivery requests
- Accept deliveries you want to handle

**Note**: You must be logged in as a driver user to access this endpoint.

---

## 📊 STEP 12: Search Orders (For Managers/Admins)

**Why do you need this?** Managers and admins need to search and manage all orders in the system.

### Endpoint: `POST /api/v1/orders/search`

**What this does**: Searches all orders with filters (status, date range, etc.).

**How to use it**:

1. **Method**: POST
2. **URL**: `http://127.0.0.1:8000/api/v1/orders/search`
3. **Headers**: 
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body** (JSON):
```json
{
  "pageNumber": 1,
  "pageSize": 20,
  "status": "",
  "keyword": ""
}
```

**What to expect**:

List of orders:
```json
{
  "data": [
    {
      "id": "order-uuid",
      "totalPrice": 12340,
      "status": "pending",
      "userFullname": "Akmal Nawabi",
      "createOrderDate": "2025-11-08T13:20:19.417Z",
      // ... more fields
    }
  ],
  "currentPage": 1,
  "totalCount": 50
}
```

**What you need to do**:
- Only managers/admins can access this
- Search orders by status, keyword, etc.
- Manage orders (update status, view details)

**Note**: You must be logged in as a manager or admin user to access this endpoint.

---

## 🔄 STEP 13: Update Your Profile

**Why do you need this?** Users can update their personal information like name, email, phone number, etc.

### Endpoint: `PUT /api/v1/personal/profile`

**What this does**: Updates your user profile information.

**How to use it**:

1. **Method**: PUT
2. **URL**: `http://127.0.0.1:8000/api/v1/personal/profile`
3. **Headers**: 
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`

4. **Request Body** (JSON):
```json
{
  "firstName": "Akmal",
  "lastName": "Nawabi",
  "email": "akmalnawabi007@gmail.com",
  "phoneNumber": "+989121234567"
}
```

**What to expect**:

Updated profile:
```json
{
  "data": {
    "id": "906b27f1-8748-47bd-963f-45ef990d6076",
    "firstName": "Akmal",
    "lastName": "Nawabi",
    // ... updated fields
  },
  "messages": [],
  "succeeded": true
}
```

**What you need to do**:
- Update any fields you want to change
- Only include fields you want to update (partial update is allowed)
- Verify the changes by getting your profile again (Step 3)

---

## 📱 STEP 14: Send Verification Code (For Phone Login)

**Why do you need this?** Some users prefer to log in with their phone number instead of email. This sends a verification code to their phone.

### Endpoint: `GET /api/v1/tokens/send-code?phoneNumber=+989121234567`

**What this does**: Sends a 6-digit verification code to the specified phone number via SMS.

**How to use it**:

1. **Method**: GET
2. **URL**: `http://127.0.0.1:8000/api/v1/tokens/send-code?phoneNumber=+989121234567`
3. **Headers**: None (public endpoint - no token needed)

4. **Request Body**: None

**What to expect**:

```json
{
  "message": "Verification code sent successfully",
  "code": "123456"
}
```

**Note**: In production, the code won't be returned in the response. Check your SMS.

**What you need to do**:
- Use the code you receive (via SMS or in response) to verify
- Then use `/api/v1/tokens/token-by-code` to log in with the code

**Related Endpoint**:
- `POST /api/v1/tokens/token-by-code` - Login using the verification code

---

## 🎯 Summary: Complete Flow for New Developers

Here's the complete flow you should follow:

1. **Get Token** → `POST /api/v1/tokens/tokenbyemail` (Step 1)
2. **Authorize** → Add `Authorization: Bearer YOUR_TOKEN` header (Step 2)
3. **Get Profile** → `GET /api/v1/personal/profile` (Step 3) - Verify authentication works
4. **Browse Products** → `POST /api/v1/products/search` (Step 4)
5. **Get Categories** → `GET /api/v1/categories/` (Step 5)
6. **Add to Basket** → `POST /api/v1/baskets/` (Step 6)
7. **Create Order** → `POST /api/v1/orders/` (Step 7) - Most important!
8. **Manage Addresses** → `POST /api/v1/addresses/` (Step 8)
9. **Check Wallet** → `GET /api/v1/transactionwallet/mytransactionwallettotal` (Step 9)
10. **Check Points** → `GET /api/v1/points/my-balance` (Step 10)

**For Drivers**:
- `POST /api/v1/driverdelivery/search` (Step 11)

**For Managers/Admins**:
- `POST /api/v1/orders/search` (Step 12)

---

## 🛠️ Common Issues and Solutions

### Issue 1: "401 Unauthorized" Error
**Problem**: Your token is missing, expired, or incorrect.

**Solution**:
1. Go back to Step 1 and get a new token
2. Make sure you're including the `Authorization: Bearer YOUR_TOKEN` header
3. Check that you included the word "Bearer" and a space before your token

### Issue 2: "404 Not Found" Error
**Problem**: The endpoint URL is wrong.

**Solution**:
1. Check the URL - it should start with `/api/v1/`
2. Make sure there are no typos
3. Check if the endpoint exists in Swagger UI

### Issue 3: "400 Bad Request" Error
**Problem**: Your request body is missing required fields or has invalid data.

**Solution**:
1. Check the request body format (must be valid JSON)
2. Make sure all required fields are present
3. Check field types (numbers should be numbers, strings should be strings)
4. Look at the error message - it will tell you what's wrong

### Issue 4: "403 Forbidden" Error
**Problem**: You don't have permission to access this endpoint.

**Solution**:
1. Some endpoints are only for managers/admins
2. Make sure you're logged in with the right user type
3. Check if your user has the required permissions

---

## 📚 Additional Resources

- **Swagger UI**: `http://127.0.0.1:8000/api/schema/swagger-ui/` - Interactive API documentation
- **API Schema**: `http://127.0.0.1:8000/api/schema/` - OpenAPI schema file

---

## ✅ Testing Checklist

Before you start developing, make sure you can:

- [ ] Get a token using email and password
- [ ] Authorize yourself with the token
- [ ] Get your user profile
- [ ] Search for products
- [ ] Get categories
- [ ] Add items to basket
- [ ] Create an order
- [ ] Create an address
- [ ] Check wallet balance
- [ ] Check points balance

If you can do all of these, you're ready to start developing! 🎉

---

## 📝 Notes for Flutter Developers

- All endpoints return data in the format: `{ "data": ..., "messages": [], "succeeded": true }`
- Always include `Authorization: Bearer YOUR_TOKEN` header for protected endpoints
- Use `Content-Type: application/json` for POST/PUT requests
- Empty strings `""` and `null` are both accepted for optional fields
- Dates should be in ISO 8601 format: `"2025-11-08T13:20:19.417Z"`

---

**End of Guide**

Good luck with your development! If you have questions, refer to the Swagger UI documentation or contact the backend team.

