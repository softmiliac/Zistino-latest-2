# Points & Lottery System - How It Works

## 📋 Overview

This document explains how the Points and Lottery system works, who is responsible for what, and how data flows through the system.

---

## 🎯 System Architecture

### **Backend (Django API)**
- **Manages**: All data storage, business logic, and automatic point awarding
- **Responsible for**: 
  - Storing user points balances
  - Automatically awarding points when orders are completed
  - Managing lottery campaigns
  - Processing lottery ticket purchases
  - Drawing lottery winners

### **Frontend (React Panel)**
- **Manages**: Admin/Manager interface for creating and managing lotteries
- **Responsible for**: 
  - Creating lottery campaigns
  - Viewing lottery participants
  - Drawing winners
  - Managing lottery status

### **Mobile Apps (Flutter)**
- **Manages**: Customer-facing features
- **Responsible for**: 
  - Displaying user's points balance
  - Showing active lotteries
  - Allowing customers to buy lottery tickets
  - Showing lottery winners
  - Displaying referral codes and referral history

---

## 💰 Points System - How It Works

### **1. Automatic Point Earning**

Points are **automatically awarded** by the backend when certain events occur. **No manual data entry is required** from admins or clients.

#### **A. Points from Orders (Automatic)**
- **When**: When a customer completes an order (order status becomes "completed")
- **How**: Backend automatically detects order completion via Django signals
- **Amount**: Configurable (default: 1 point per order)
- **Configuration**: Set via `Configuration` model with name `'order_points'`
- **Who does it**: Backend automatically - **no action needed from Flutter devs or admins**

**Example Flow:**
```
1. Customer places order in Flutter app
2. Order status changes to "completed" in backend
3. Backend signal automatically triggers: award_order_points(user, order_id)
4. Points are added to user's balance
5. Transaction record is created
6. Flutter app can fetch updated balance via GET /api/v1/points/my-balance
```

#### **B. Points from Referrals (Automatic)**
- **When**: When a referred user completes their first order
- **How**: Backend automatically detects when referred user's first order is completed
- **Amount**: Configurable (default: 2 points for referrer)
- **Configuration**: Set via `Configuration` model with name `'referral_points'`
- **Who does it**: Backend automatically - **no action needed from Flutter devs or admins**

**Example Flow:**
```
1. User A shares referral code "ABC12345" with User B
2. User B registers using referral code "ABC12345"
3. Referral record is created (status: "pending")
4. User B completes first order
5. Backend signal automatically triggers: award_referral_points(referrer, referred, referral_id)
6. Points are added to User A's balance
7. Referral status changes to "completed"
8. Flutter app can fetch updated balance and referral history
```

#### **C. Manual Point Awards (Admin Only)**
- **When**: Admin wants to give bonus points (promotions, compensations, etc.)
- **How**: Admin uses React panel → `POST /api/v1/points/manual-award`
- **Who does it**: Admin/Manager via React panel
- **Use cases**: 
  - Special promotions
  - Customer service compensation
  - Welcome bonuses
  - Marketing campaigns

### **2. Point Spending**

#### **A. Lottery Tickets (Automatic)**
- **When**: Customer buys lottery tickets
- **How**: Customer uses Flutter app → `POST /api/v1/lotteries/{id}/buy-tickets`
- **Points deducted**: Automatically by backend
- **Transaction created**: Automatically by backend
- **Who does it**: Customer via Flutter app - **backend handles everything automatically**

**Example Flow:**
```
1. Customer views active lotteries in Flutter app
2. Customer selects lottery and number of tickets
3. Flutter app calls: POST /api/v1/lotteries/{lottery_id}/buy-tickets
   Body: { "ticket_count": 5 }
4. Backend checks:
   - Lottery is active
   - User has enough points
   - Lottery dates are valid
5. Backend automatically:
   - Deducts points from user balance
   - Creates lottery ticket records
   - Creates point transaction record
6. Returns success response with remaining balance
7. Flutter app updates UI with new balance
```

---

## 🎲 Lottery System - How It Works

### **1. Lottery Creation (Admin/Manager)**

**Who creates lotteries**: Admin or Manager via **React Panel** (not Flutter app)

**Steps:**
1. Admin logs into React panel
2. Navigates to "Lottery Management" in sidebar
3. Clicks "Add" button
4. Fills in lottery details:
   - Title (e.g., "Monthly Prize Draw")
   - Description
   - Prize Name (e.g., "Electric Scooter")
   - Ticket Price (in points, e.g., 100)
   - Start Date
   - End Date
   - Status (draft → active)
5. Saves lottery
6. Backend stores lottery in database

**Important**: 
- **Clients cannot create lotteries** - only admins/managers can
- **Flutter devs don't need to implement lottery creation** - it's admin-only
- **Lotteries must be created via React panel or Swagger** (for testing)

### **2. Lottery Visibility (Automatic)**

**Who sees lotteries**: Customers via Flutter app

**How it works:**
- Backend automatically filters active lotteries based on:
  - Status = "active"
  - Current date is between start_date and end_date
- Flutter app calls: `GET /api/v1/lotteries/active`
- Backend returns only active, valid lotteries
- **No manual filtering needed** - backend handles it automatically

### **3. Ticket Purchase (Customer via Flutter)**

**Who buys tickets**: Customers via Flutter app

**Steps:**
1. Customer views active lotteries in Flutter app
2. Customer selects a lottery
3. Customer enters number of tickets
4. Flutter app calls: `POST /api/v1/lotteries/{id}/buy-tickets`
5. Backend automatically:
   - Validates lottery is active
   - Checks user has enough points
   - Deducts points
   - Creates ticket records
   - Creates transaction record
6. Customer sees updated balance and ticket confirmation

**Important**: 
- **Flutter devs must implement the buy-tickets UI and API call**
- **Backend handles all validation and point deduction automatically**
- **No manual intervention needed**

### **4. Lottery Winner Drawing (Admin/Manager)**

**Who draws winners**: Admin or Manager via **React Panel**

**Steps:**
1. Admin logs into React panel
2. Navigates to "Lottery Management"
3. Finds the lottery that has ended
4. Clicks "Draw Winner" button (star icon)
5. Backend automatically:
   - Selects random ticket from all purchased tickets
   - Marks ticket as winner
   - Updates lottery with winner information
   - Changes lottery status to "drawn"
6. Winner is announced

**Important**: 
- **Clients cannot draw winners** - only admins/managers can
- **Flutter devs don't need to implement winner drawing** - it's admin-only
- **Winner drawing must be done via React panel**

### **5. Viewing Winners (Customer via Flutter)**

**Who sees winners**: Customers via Flutter app

**How it works:**
- Flutter app calls: `GET /api/v1/lotteries/winners`
- Backend returns all lotteries with status "drawn" that have winners
- **Flutter devs must implement the winners display UI**

---

## 📊 Data Flow Summary

### **Points Flow:**
```
Order Completion (Flutter) 
  → Backend Signal (Automatic)
  → Points Added (Automatic)
  → Transaction Record Created (Automatic)
  → Flutter App Fetches Balance (Flutter Dev)
```

### **Referral Flow:**
```
User Shares Code (Flutter)
  → New User Registers with Code (Flutter)
  → Referral Record Created (Backend Automatic)
  → Referred User Completes First Order (Flutter)
  → Backend Signal (Automatic)
  → Points Awarded to Referrer (Automatic)
  → Flutter App Shows Referral History (Flutter Dev)
```

### **Lottery Flow:**
```
Admin Creates Lottery (React Panel)
  → Lottery Stored in Database (Backend)
  → Active Lotteries Visible to Customers (Backend Automatic Filter)
  → Customer Buys Tickets (Flutter App)
  → Points Deducted (Backend Automatic)
  → Tickets Created (Backend Automatic)
  → Admin Draws Winner (React Panel)
  → Winner Selected (Backend Automatic)
  → Winners Visible to Customers (Flutter App)
```

---

## 🔑 Key Responsibilities

### **Backend (Django API) - Automatic:**
✅ Automatically awards points when orders are completed  
✅ Automatically awards referral points when referred user completes first order  
✅ Automatically deducts points when lottery tickets are purchased  
✅ Automatically creates transaction records  
✅ Automatically filters active lotteries  
✅ Stores all lottery and points data  
✅ Validates all operations  

### **React Panel (Admin/Manager) - Manual:**
✅ Create lottery campaigns  
✅ View lottery participants  
✅ Draw lottery winners  
✅ Manually award points (if needed)  
✅ View all points transactions  
✅ Manage lottery status  

### **Flutter Apps (Customer) - Implementation Required:**
✅ Display user's points balance  
✅ Show points transaction history  
✅ Display referral code  
✅ Show referral history  
✅ Display active lotteries  
✅ Allow customers to buy lottery tickets  
✅ Show customer's purchased tickets  
✅ Display lottery winners  
✅ Handle all customer-facing UI/UX  

---

## ❓ Common Questions

### **Q: Do clients need to add data in backend or Swagger?**
**A: NO!** Clients (end users) never interact with backend or Swagger. They only use the Flutter mobile app. All data is created automatically or by admins.

### **Q: Do Flutter devs need to create lotteries?**
**A: NO!** Flutter devs only need to:
- Display active lotteries (GET endpoint)
- Allow ticket purchase (POST endpoint)
- Show user's tickets (GET endpoint)
- Display winners (GET endpoint)

Lottery creation is **admin-only** via React panel.

### **Q: How do users get points?**
**A: Automatically!** Points are awarded automatically when:
- User completes an order (backend signal)
- User's referral completes first order (backend signal)
- Admin manually awards points (via React panel)

**Flutter devs don't need to implement point awarding** - it's all automatic in the backend.

### **Q: What happens when a customer buys lottery tickets?**
**A: Everything is automatic!** 
1. Flutter app sends POST request with ticket count
2. Backend validates (lottery active, enough points, valid dates)
3. Backend automatically deducts points
4. Backend automatically creates ticket records
5. Backend automatically creates transaction record
6. Returns success with updated balance

**Flutter devs only need to call the API and update the UI.**

### **Q: Who can create lotteries?**
**A: Only Admins/Managers** via React panel. Customers cannot create lotteries. Flutter devs don't need to implement lottery creation.

### **Q: Who can draw lottery winners?**
**A: Only Admins/Managers** via React panel. Customers cannot draw winners. Flutter devs don't need to implement winner drawing.

---

## 📝 Configuration

### **Point Amounts (Configurable)**

Points can be configured via the `Configuration` model:

1. **Order Points**: 
   - Configuration name: `'order_points'`
   - Default: 1 point per order
   - Format: `{"amount": 1}`

2. **Referral Points**:
   - Configuration name: `'referral_points'`
   - Default: 2 points per referral
   - Format: `{"amount": 2}`

**To change point amounts:**
- Admin creates/updates Configuration records via React panel or Django admin
- Changes take effect immediately for new orders/referrals

---

## 🚀 Implementation Checklist for Flutter Devs

### **Must Implement (Customer Features):**
- [ ] Display points balance (`GET /api/v1/points/my-balance`)
- [ ] Show points history (`GET /api/v1/points/my-history`)
- [ ] Display referral code (`GET /api/v1/referrals/my-code`)
- [ ] Show referral history (`GET /api/v1/referrals/my-referrals`)
- [ ] List active lotteries (`GET /api/v1/lotteries/active`)
- [ ] Show lottery details (`GET /api/v1/lotteries/{id}/detail`)
- [ ] Buy lottery tickets (`POST /api/v1/lotteries/{id}/buy-tickets`)
- [ ] Show user's tickets (`GET /api/v1/lotteries/my-tickets`)
- [ ] Display winners (`GET /api/v1/lotteries/winners`)

### **NOT Needed (Admin Only):**
- ❌ Create lotteries (admin only via React panel)
- ❌ Draw winners (admin only via React panel)
- ❌ Award points manually (admin only via React panel)
- ❌ Manage lottery status (admin only via React panel)

---

## 📚 API Endpoints Reference

### **Customer Endpoints (Flutter Apps):**
- `GET /api/v1/points/my-balance` - Get points balance
- `GET /api/v1/points/my-history` - Get points history
- `GET /api/v1/referrals/my-code` - Get referral code
- `GET /api/v1/referrals/my-referrals` - Get referral history
- `GET /api/v1/lotteries/active` - Get active lotteries
- `GET /api/v1/lotteries/{id}/detail` - Get lottery details
- `POST /api/v1/lotteries/{id}/buy-tickets` - Buy tickets
- `GET /api/v1/lotteries/my-tickets` - Get my tickets
- `GET /api/v1/lotteries/winners` - Get winners

### **Admin Endpoints (React Panel):**
- `POST /api/v1/lotteries/search` - Search lotteries
- `POST /api/v1/lotteries` - Create lottery
- `GET /api/v1/lotteries/{id}` - Get lottery
- `PUT /api/v1/lotteries/{id}` - Update lottery
- `DELETE /api/v1/lotteries/{id}` - Delete lottery
- `POST /api/v1/lotteries/{id}/draw-winner` - Draw winner
- `POST /api/v1/lotteries/{id}/end` - End lottery
- `GET /api/v1/lotteries/{id}/participants` - Get participants
- `POST /api/v1/points/manual-award` - Manually award points

---

## 🎯 Summary

**The system is designed to be automatic and user-friendly:**

1. **Points are earned automatically** - No manual entry needed
2. **Lotteries are created by admins** - Customers just participate
3. **Ticket purchases are automatic** - Backend handles everything
4. **Winner drawing is admin-only** - Fair and controlled
5. **Flutter devs implement customer UI** - Backend handles all logic
6. **Clients never touch backend** - They only use the mobile app

**Everything works automatically once the Flutter app implements the API calls!**

