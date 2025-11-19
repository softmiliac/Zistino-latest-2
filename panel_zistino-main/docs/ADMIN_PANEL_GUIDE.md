# Complete Admin Panel Guide for New Users

## 📖 Introduction

Welcome to the Zistino Admin Panel! This guide will teach you how to use the admin panel step by step. Even if you're not a programmer, this guide will help you understand how to manage the entire system.

**What is this panel?** This is the control center for the Zistino system. From here, you can:
- See all orders from customers
- Manage products that customers can buy
- Manage drivers who deliver orders
- Run lotteries for drivers
- View reports and statistics
- And much more!

**Important**: This panel is only for managers and administrators. Regular customers and drivers use the mobile app (Flutter app), not this panel.

---

## 🔐 STEP 1: Logging Into the Admin Panel

**Why do you need this?** Before you can use the admin panel, you need to log in with your manager/admin account.

### How to Login:

1. **Open the Admin Panel**: Navigate to the admin panel URL in your web browser (usually something like `http://localhost:5173` or your server URL)

2. **You'll see the Login Page**: The page will show a login form with:
   - **Username/Email field**: Enter your email address
   - **Password field**: Enter your password
   - **Tenant selector**: Usually set to "root" (you can leave this as default)

3. **Enter Your Credentials**:
   - **Email**: `akmalnawabi007@gmail.com`
   - **Password**: `admin`
   - **Tenant**: Select "root" (if there are multiple options)

4. **Click the "Login" Button**: After entering your credentials, click the login button.

5. **What Happens Next**: 
   - If your credentials are correct, you'll be automatically redirected to the dashboard
   - If your credentials are wrong, you'll see an error message saying "نام کاربری یا کلمه عبور اشتباه است" (Wrong username or password)
   - Your login session will be saved, so you won't need to log in again until you log out or your session expires

**Important Notes**:
- Make sure you're using the correct email and password
- If you forget your password, contact the system administrator
- Never share your login credentials with anyone
- Always log out when you're done (click the logout button in the menu)

**What you need to do**:
- Try logging in with the provided credentials
- Make sure you can see the dashboard after login
- If you can't log in, check your email and password, or contact support

---

## 🏠 STEP 2: Understanding the Dashboard

**Why do you need this?** The dashboard is your home page. It shows you an overview of the system and gives you access to all features.

### What You'll See:

After logging in, you'll be automatically redirected to the dashboard. The dashboard has:

1. **Left Sidebar Menu**: This is your navigation menu. It contains links to all sections:
   - Dashboard (home)
   - Collection Request (default page)
   - Orders
   - Products
   - Categories
   - Users
   - Drivers
   - Lottery
   - Lottery Management
   - And many more...

2. **Main Content Area**: This is where the actual content appears. When you first log in, you'll see the "Collection Request" page by default.

3. **Top Bar**: Usually contains:
   - Your user information
   - Logout button
   - Language selector (if available)

**What you need to do**:
- Familiarize yourself with the sidebar menu
- Click on different menu items to see what's available
- Notice that the main content area changes when you click different menu items

**Important**: The dashboard automatically redirects you to "Collection Request" page when you first log in. This is normal behavior.

---

## 📦 STEP 3: Understanding Where Orders Come From

**Why do you need this?** Orders are the heart of the business. You need to understand where they come from and how they work.

### Where Orders Come From:

**Orders come from customers using the mobile app (Flutter app)**, NOT from this admin panel. Here's how it works:

1. **Customer Creates Order**:
   - A customer opens the mobile app on their phone
   - They browse products, add items to their cart
   - They enter their delivery address and phone number
   - They click "Place Order"
   - The order is sent to the backend server

2. **Order Appears in Admin Panel**:
   - The order is stored in the database
   - You can see it in the "Orders" section of the admin panel
   - The order status is initially "در حال بررسی" (Pending/Under Review)

3. **You Manage the Order**:
   - You can view order details
   - You can change the order status (confirm, cancel, mark as delivered, etc.)
   - You can see customer information, delivery address, and order items

**What this means for you**:
- You don't create orders in the admin panel - customers create them via the mobile app
- Your job is to **manage** orders: review them, confirm them, track their progress, and mark them as completed
- Orders appear automatically in the admin panel as soon as customers place them

**What you need to do**:
- Go to the "Orders" section in the sidebar menu
- You'll see a list of all orders from customers
- Notice that each order shows: customer name, order date, total price, and status
- Click on an order to see more details

---

## 🛍️ STEP 4: Understanding Where Products Come From

**Why do you need this?** Products are items that customers can order. You need to know where they come from and how to manage them.

### Where Products Come From:

**Products are created and managed by YOU (managers/admins) in this admin panel**. Here's how it works:

1. **You Add Products**:
   - Go to the "Products" section in the sidebar menu
   - Click the "Add" or "Create" button
   - Fill in product information:
     - Product name
     - Description
     - Price
     - Category
     - Images
     - Stock quantity
     - And other details
   - Click "Save"

2. **Products Become Available**:
   - Once you save a product, it's immediately available in the mobile app
   - Customers can see it, add it to cart, and order it
   - You can edit or delete products anytime

3. **Why You Add Products**:
   - To offer items for sale to customers
   - To manage inventory (stock levels)
   - To set prices
   - To organize products by categories

**What this means for you**:
- You are responsible for adding all products to the system
- You can edit product information (price, description, images, etc.)
   - You can delete products that are no longer available
   - You can manage product categories and organization

**What you need to do**:
- Go to the "Products" section in the sidebar menu
- Click "Add" to create a new product
- Fill in the required information
- Save the product
- Notice that the product now appears in the list
- Try editing an existing product
- Try searching for products using the search box

---

## 📋 STEP 5: Managing Orders

**Why do you need this?** Orders need to be reviewed, confirmed, and tracked. This is one of your main responsibilities.

### How to Manage Orders:

1. **View All Orders**:
   - Click "Orders" in the sidebar menu
   - You'll see a table/list of all orders
   - Each order shows:
     - Order ID
     - Customer name
     - Order date
     - Total price
     - Status (Pending, Confirmed, In Progress, Completed, Cancelled)

2. **View Order Details**:
   - Click on an order (or click the "View Details" button)
   - You'll see:
     - Customer information (name, phone, email)
     - Delivery address
     - List of items in the order
     - Total price
     - Order status
     - Order date

3. **Change Order Status**:
   - In the order list, you'll see a status dropdown or buttons
   - Available statuses:
     - **در حال بررسی** (Pending/Under Review) - New orders start here
     - **تایید شده** (Confirmed) - Order is confirmed and ready to process
     - **ارسال به مرکز** (In Progress) - Order is being processed/shipped
     - **تحویل داده شد** (Completed) - Order has been delivered
     - **رد شده** (Cancelled) - Order was cancelled
   - Select the appropriate status from the dropdown
   - The status will be updated immediately

4. **Search Orders**:
   - Use the search box at the top of the orders page
   - You can search by:
     - Customer name
     - Order ID
     - Phone number
   - Type your search term and press Enter

5. **Filter Orders**:
   - You can filter orders by status
   - You can sort orders by date, price, etc.
   - Use pagination to view more orders (if there are many)

**What you need to do**:
- Go to the Orders section
- View a few orders to understand the information shown
- Try changing an order's status
- Try searching for a specific order
- Practice reviewing new orders and updating their status

**Important Notes**:
- Always review new orders carefully
- Confirm orders that are valid and ready to process
- Cancel orders that have issues (wrong address, customer request, etc.)
- Mark orders as "Completed" only after they've been delivered
- Keep track of orders in "In Progress" status

---

## 🎁 STEP 6: Managing Products

**Why do you need this?** Products need to be added, updated, and organized. This is essential for the business.

### How to Manage Products:

1. **View All Products**:
   - Click "Products" in the sidebar menu
   - You'll see a table/list of all products
   - Each product shows:
     - Product name
     - Category
     - Price
     - Stock quantity
     - Status (Active/Inactive)
     - Images

2. **Add a New Product**:
   - Click the "Add" or "Create" button (usually at the top right)
   - Fill in the form:
     - **Product Name**: Enter a clear, descriptive name
     - **Description**: Describe the product in detail
     - **Price**: Enter the price (in the currency used)
     - **Category**: Select a category from the dropdown
     - **Stock Quantity**: Enter how many items are available
     - **Images**: Upload product images (usually drag and drop or click to upload)
     - **Status**: Set to "Active" to make it visible to customers
   - Click "Save" or "Create"

3. **Edit an Existing Product**:
   - Find the product in the list
   - Click the "Edit" button (usually a pencil icon)
   - Modify the information you want to change
   - Click "Save"

4. **Delete a Product**:
   - Find the product in the list
   - Click the "Delete" button (usually a trash icon)
   - Confirm the deletion
   - **Warning**: Deleting a product will remove it from the system. Customers won't be able to see or order it anymore.

5. **Search Products**:
   - Use the search box to find products by name
   - Filter by category using the category dropdown

**What you need to do**:
- Go to the Products section
- Try adding a new product (use test data if you're learning)
- Try editing an existing product
- Practice searching for products
- Understand how categories work (you'll learn about categories in the next step)

**Important Notes**:
- Always upload clear, high-quality product images
- Set accurate prices - customers will pay these prices
- Keep stock quantities updated - this helps prevent overselling
- Set products to "Inactive" if they're temporarily unavailable (instead of deleting them)
- Organize products into appropriate categories

---

## 📂 STEP 7: Managing Categories

**Why do you need this?** Categories help organize products. Customers can browse products by category in the mobile app.

### How Categories Work:

1. **What are Categories?**:
   - Categories are groups that organize products
   - Examples: "Electronics", "Clothing", "Food", "Books", etc.
   - Each product belongs to one category
   - Customers can browse products by category in the mobile app

2. **View All Categories**:
   - Click "Categories" in the sidebar menu
   - You'll see a list of all categories
   - Each category shows:
     - Category name
     - Description
     - Image (if available)
     - Status (Active/Inactive)

3. **Add a New Category**:
   - Click the "Add" button
   - Fill in:
     - **Category Name**: Enter a clear name (e.g., "Electronics")
     - **Description**: Describe what products belong in this category
     - **Image**: Upload a category image (optional but recommended)
     - **Status**: Set to "Active"
   - Click "Save"

4. **Edit a Category**:
   - Find the category in the list
   - Click "Edit"
   - Modify the information
   - Click "Save"

5. **Delete a Category**:
   - Find the category
   - Click "Delete"
   - **Warning**: You can only delete categories that have no products. If a category has products, you must first move or delete those products.

**What you need to do**:
- Go to the Categories section
- View existing categories
- Try adding a new category
- Understand how categories relate to products
- When creating a product, notice that you select a category

**Important Notes**:
- Create categories before adding products (so products can be assigned to categories)
- Use clear, descriptive category names
- Keep categories organized and logical
- Don't create too many categories - keep it simple and user-friendly

---

## 🎰 STEP 8: Understanding the Lottery System

**Why do you need this?** The lottery system rewards drivers with points and gives them chances to win prizes. This is important for driver motivation and engagement.

### How the Lottery System Works:

**Important**: The lottery system is for **DRIVERS**, not customers. Drivers earn points and can participate in lotteries to win prizes.

#### Part 1: How Drivers Earn Points

1. **Drivers Earn Points Automatically**:
   - When a driver completes a delivery, they earn points
   - Points are automatically added to their account
   - Drivers can see their points balance in the driver mobile app

2. **You Can Manually Award Points** (as a manager):
   - You can give points to drivers for special reasons (bonuses, rewards, etc.)
   - This is done in the "Lottery Management" section (we'll cover this later)

#### Part 2: How Lotteries Work

1. **You Create a Lottery** (as a manager):
   - Go to "Lottery Management" in the sidebar
   - Click "Create Lottery" or "Add"
   - Fill in:
     - **Lottery Name**: Give it a descriptive name (e.g., "Monthly Prize Draw")
     - **Description**: Explain what the lottery is for
     - **Prize**: What the winner will receive (e.g., "500,000 IRR", "Gift Card", etc.)
     - **Start Date**: When the lottery starts
     - **End Date**: When the lottery ends
     - **Status**: Set to "Active" to make it available
   - Click "Save"

2. **Drivers Participate**:
   - Drivers with points can see active lotteries in their mobile app
   - They don't need to "buy tickets" - they're automatically eligible based on their points
   - The more points a driver has, the slightly better their chance of winning (but it's still random)

3. **You Draw a Winner** (as a manager):
   - When the lottery ends (or when you want to draw a winner), go to "Lottery Management"
   - Find the lottery in the list
   - Click the "Draw Winner" button (usually a star icon ⭐)
   - The system will:
     - Look at all drivers who have at least 1 point (or the minimum points you set)
     - Randomly select one driver as the winner
     - Drivers with more points have a slightly higher chance, but it's still random
   - The winner will be displayed, and you can notify them

4. **Lottery Eligibility**:
   - **Minimum Points**: By default, drivers need at least 1 point to be eligible
   - You can set a higher minimum if you want (e.g., only drivers with 10+ points)
   - All eligible drivers are included in the random draw

5. **Viewing Eligible Drivers**:
   - In "Lottery Management", click the "Eligible Drivers" button (usually a person icon 👤)
   - You'll see a list of all drivers who can participate
   - Each driver shows:
     - Name
     - Phone number
     - Current points balance
   - You can also manually award points to drivers from this list

#### Part 3: Managing Points for Drivers

1. **View All Drivers' Points**:
   - Go to "Lottery" section (not "Lottery Management")
   - Click on the "Points History" tab
   - You'll see a list of ALL drivers with their current points balance
   - This includes drivers with 0 points

2. **Manually Award Points**:
   - In "Lottery Management", click "Eligible Drivers" button
   - Find the driver you want to give points to
   - Click the "Award Points" button (usually a gift icon 🎁)
   - Enter:
     - **Amount**: How many points to give (must be at least 1)
     - **Description**: Why you're giving these points (optional, but recommended)
   - Click "Award"
   - The points will be immediately added to the driver's account

**What you need to do**:
- Go to "Lottery Management" section
- Try creating a new lottery
- View the list of lotteries
- Click "Eligible Drivers" to see which drivers can participate
- Try manually awarding points to a driver
- Go to "Lottery" section and view the "Points History" tab to see all drivers' points
- Understand that the lottery is random, but drivers with more points have a slightly better chance

**Important Notes**:
- **Lottery is Random**: Even though drivers with more points have a slightly better chance, the winner is still chosen randomly. A driver with 10 points can still win over a driver with 100 points - it's just less likely.
- **Minimum Points**: Only drivers with at least 1 point (or your set minimum) are eligible
- **Fair System**: The system is designed to be fair - higher points give a slight advantage, but everyone has a chance
- **Manual Points**: Use manual point awards for bonuses, rewards, or correcting point balances
- **Lottery Status**: Set lotteries to "Active" when they're ready, and "Ended" when they're finished

---

## 👥 STEP 9: Managing Users

**Why do you need this?** Users are customers who use the mobile app to place orders. You may need to view user information or manage user accounts.

### How to Manage Users:

1. **View All Users**:
   - Click "Users" in the sidebar menu
   - You'll see a list of all registered users (customers)
   - Each user shows:
     - Name
     - Email
     - Phone number
     - Registration date
     - Status (Active/Inactive)

2. **View User Details**:
   - Click on a user to see their full profile
   - You'll see:
     - Personal information
     - Order history
     - Addresses
     - Account status

3. **Search Users**:
   - Use the search box to find users by:
     - Name
     - Email
     - Phone number

4. **Activate/Deactivate Users**:
   - You can activate or deactivate user accounts
   - Inactive users cannot log in or place orders
   - Use this for:
     - Suspending problematic accounts
     - Temporarily disabling accounts

**What you need to do**:
- Go to the Users section
- View the list of users
- Try searching for a specific user
- Click on a user to see their details
- Understand that users are customers who use the mobile app

**Important Notes**:
- Users register themselves via the mobile app - you don't create user accounts
- You can view user information but be careful with privacy
- Only deactivate users if necessary (e.g., for security reasons)
- Users can update their own information via the mobile app

---

## 🚚 STEP 10: Managing Drivers

**Why do you need this?** Drivers deliver orders to customers. You need to manage driver accounts and track their activities.

### How to Manage Drivers:

1. **View All Drivers**:
   - Click "Drivers" in the sidebar menu
   - You'll see a list of all registered drivers
   - Each driver shows:
     - Name
     - Phone number
     - Status (Active/Inactive)
     - Registration date

2. **View Driver Details**:
   - Click on a driver to see:
     - Personal information
     - Delivery history
     - Points balance (for lottery)
     - Vehicle information (if available)

3. **Activate/Deactivate Drivers**:
   - You can activate or deactivate driver accounts
   - Inactive drivers cannot log in or accept deliveries
   - Use this to:
     - Temporarily suspend drivers
     - Remove drivers from the system

4. **Driver Appointments**:
   - Some drivers may have scheduled appointments
   - Check the "Driver Appointments" section to manage schedules

5. **Driver Tracking**:
   - The "Driver Tracking" section shows real-time location of drivers (if available)
   - This helps you see where drivers are and assign deliveries

**What you need to do**:
- Go to the Drivers section
- View the list of drivers
- Click on a driver to see their details
- Understand that drivers use the driver mobile app (different from customer app)
- Check driver points if you're managing lotteries

**Important Notes**:
- Drivers register themselves via the driver mobile app
- Drivers earn points for completing deliveries
- Driver points are used for lottery participation
- Keep driver accounts active only for drivers who are currently working
- Drivers can see available deliveries in their app and accept them

---

## 📊 STEP 11: Understanding Collection Requests

**Why do you need this?** Collection requests are requests from customers to have items collected (for recycling or disposal). This is the default page you see after login.

### How Collection Requests Work:

1. **What are Collection Requests?**:
   - Customers can request to have items collected from their location
   - This is different from regular orders (where customers buy products)
   - Collection requests are for picking up items (like recyclables, old electronics, etc.)

2. **View Collection Requests**:
   - After logging in, you're automatically taken to the "Collection Request" page
   - You'll see a list of all collection requests
   - Each request shows:
     - Customer information
     - Collection address
     - Items to be collected
     - Request date
     - Status

3. **Manage Collection Requests**:
   - Review each request
   - Confirm requests that are valid
   - Assign drivers to collect items
   - Update status as collection progresses
   - Mark as completed when items are collected

**What you need to do**:
- Notice that you're on the "Collection Request" page after login
- View the list of requests
- Understand that these are different from regular orders
- Practice managing collection requests

---

## 🔔 STEP 12: Managing Notifications

**Why do you need this?** You can send notifications (SMS messages) to users, drivers, or all users. This is useful for announcements, updates, or important messages.

### How to Send Notifications:

1. **Go to Notifications**:
   - Click "Notifications" in the sidebar menu

2. **Send a Notification**:
   - Click "Send Notification" or "Create"
   - Fill in:
     - **Recipient**: Select who to send to (All Users, Specific User, All Drivers, etc.)
     - **Message**: Enter the notification text
     - **Type**: Select notification type (SMS, Push Notification, etc.)
   - Click "Send"

3. **View Notification History**:
   - See all notifications you've sent
   - Check delivery status
   - View sent messages

**What you need to do**:
- Go to the Notifications section
- Understand how to send notifications
- Be careful - only send important messages (users receive these on their phones)

**Important Notes**:
- Notifications are sent via SMS or push notifications
- Use notifications sparingly - don't spam users
- Make sure messages are clear and important
- Check notification history to see what was sent

---

## 🎯 Summary: Complete Workflow for New Users

Here's the complete workflow you should follow as a new admin/manager:

### Daily Tasks:

1. **Login** → Enter your email and password (Step 1)
2. **Check Collection Requests** → Review new collection requests (default page after login)
3. **Review Orders** → Go to "Orders" section, review new orders, update their status (Step 5)
4. **Manage Products** → Add new products, update prices, manage stock (Step 6)
5. **Check Categories** → Ensure products are properly categorized (Step 7)

### Weekly/Monthly Tasks:

6. **Manage Lottery** → Create lotteries, draw winners, award points to drivers (Step 8)
7. **Review Users** → Check user accounts, handle any issues (Step 9)
8. **Manage Drivers** → Review driver accounts, check their points (Step 10)
9. **Send Notifications** → Send important announcements if needed (Step 12)

### Understanding the System:

- **Orders come from customers** using the mobile app (Step 3)
- **Products are created by you** in the admin panel (Step 4)
- **Lottery is for drivers** - they earn points and can win prizes (Step 8)
- **You manage everything** - orders, products, users, drivers, lotteries

---

## 🛠️ Common Issues and Solutions

### Issue 1: Can't Log In
**Problem**: Login page shows "Wrong username or password"

**Solution**:
1. Double-check your email: `akmalnawabi007@gmail.com`
2. Double-check your password: `admin`
3. Make sure you selected the correct tenant (usually "root")
4. Clear your browser cache and try again
5. Contact the system administrator if the problem persists

### Issue 2: Can't See Orders
**Problem**: Orders section is empty or not loading

**Solution**:
1. Make sure customers have placed orders via the mobile app
2. Check your internet connection
3. Refresh the page
4. Check if there's a filter applied (clear filters)
5. Try logging out and logging back in

### Issue 3: Can't Add Products
**Problem**: Product creation form doesn't save

**Solution**:
1. Make sure all required fields are filled (marked with *)
2. Check that you selected a category
3. Make sure images are uploaded (if required)
4. Check for error messages on the page
5. Try refreshing the page and trying again

### Issue 4: Lottery Not Working
**Problem**: Can't draw a winner or no eligible drivers

**Solution**:
1. Make sure drivers have points (at least 1 point minimum)
2. Check that the lottery status is "Active"
3. Verify the lottery dates (start date and end date)
4. Check "Eligible Drivers" to see who can participate
5. Make sure you're using the "Draw Winner" button (⭐ icon)

### Issue 5: Page Not Loading
**Problem**: Page is blank or shows an error

**Solution**:
1. Refresh the page (F5 or Ctrl+R)
2. Check your internet connection
3. Clear browser cache
4. Try a different browser
5. Log out and log back in
6. Contact technical support if the problem persists

---

## 📚 Additional Features

The admin panel has many more features. Here are some you might encounter:

- **Coupons**: Create discount codes for customers
- **FAQs**: Manage frequently asked questions
- **Testimonials**: Manage customer testimonials
- **Zones**: Manage delivery zones
- **Specifications**: Manage product specifications
- **Tags**: Organize products with tags
- **Warranties**: Manage product warranties
- **Comments**: Review and moderate customer comments

Explore these features as needed. The interface is similar - you'll see lists, add/edit/delete buttons, and search functionality.

---

## ✅ Testing Checklist

Before you start working, make sure you can:

- [ ] Log in successfully
- [ ] Navigate the sidebar menu
- [ ] View orders list
- [ ] View a single order's details
- [ ] Change an order's status
- [ ] View products list
- [ ] Add a new product
- [ ] Edit an existing product
- [ ] View categories
- [ ] Create a category
- [ ] View users list
- [ ] View drivers list
- [ ] Go to Lottery Management
- [ ] View eligible drivers for lottery
- [ ] Manually award points to a driver
- [ ] Create a lottery
- [ ] Draw a lottery winner

If you can do all of these, you're ready to manage the system! 🎉

---

## 📝 Important Reminders

1. **Always Log Out**: When you're done, click the logout button. Don't leave your session open on shared computers.

2. **Save Your Work**: When adding or editing items, always click "Save" before navigating away.

3. **Double-Check Before Deleting**: Deleting items is permanent. Make sure you really want to delete before confirming.

4. **Keep Information Updated**: Regularly update product prices, stock quantities, and order statuses.

5. **Communicate with Team**: If you're working with other managers, communicate about important changes (new products, order statuses, etc.).

6. **Backup Important Data**: If you make major changes, make sure there's a backup system in place.

7. **Respect Privacy**: User and driver information is private. Only access it when necessary for your work.

---

## 🎓 Learning Path

As a new user, follow this learning path:

**Week 1**: Focus on understanding the basics
- Master logging in and navigation
- Learn to view and manage orders
- Understand where orders come from

**Week 2**: Learn product management
- Add, edit, and delete products
- Manage categories
- Understand product organization

**Week 3**: Advanced features
- Master the lottery system
- Learn to manage users and drivers
- Understand collection requests

**Week 4**: Become proficient
- Handle all daily tasks confidently
- Troubleshoot common issues
- Help train other new users

---

**End of Guide**

Congratulations! You now understand how to use the Zistino Admin Panel. Remember:
- **Orders come from customers** (mobile app)
- **Products are created by you** (admin panel)
- **Lottery is for drivers** (they earn points and can win prizes)
- **You manage everything** from this panel

Good luck with managing the system! If you have questions, refer to this guide or contact the technical support team.

