# Points-Based Lottery Flow (React Panel + Backend)

This document explains how the current lottery system works end-to-end so you can respond to client questions with confidence. The React panel now reflects the new “points-only, no ticket sales” workflow that management requested.

---

## 1. Customer Experience (React → Backend)

| UI section (React) | File | Backend endpoint | Notes |
| --- | --- | --- | --- |
| Points balance card | `panel_zistino-main/src/components/pages/Lottery.tsx` | `GET /api/v1/points/my-balance` | Shows total points (earned via orders/referrals). |
| Points history tab | same file | `GET /api/v1/points/my-history` | Lists every earn/spend transaction (sources: `order`, `referral`, `manual`, `lottery`). |
| Referral code card + referrals tab | same file | `GET /api/v1/referrals/my-code`, `GET /api/v1/referrals/my-referrals` | Customers can share code; referrals award points via backend `award_referral_points`. |
| Lottery winners tab | same file | `GET /api/v1/lotteries/winners` | Purely informational: shows past lotteries, winners, prizes, draw dates. |

**Important:** Customers no longer buy tickets. The customer lottery screen is read-only: they just monitor balance/history, referral status, and view winners. This matches the business requirement (“no tickets, admins handle the draw manually”).

---

## 2. Admin / Manager Experience (React → Backend)

| Task | React action (file / hook) | Backend endpoint | Details |
| --- | --- | --- | --- |
| List lotteries | `LotteryManagement.tsx` + `useLotteries(page, size, keyword)` | `POST /api/v1/lotteries/search` | Returns paginated list with status filters (`active`, `pending`, `ended`, `drawn`, etc.). |
| Create lottery | Drawer form → `useCreateLottery` | `POST /api/v1/lotteries` | Required fields: `title`, `description`, `prizeName`, `startDate`, `endDate`, `status`. Ticket price is forced to `0`. |
| Update lottery | Drawer form → `useUpdateLottery(lotteryId)` | `PUT /api/v1/lotteries/{id}` | Same payload as create. React form auto-fills from `useLotteryGet`. |
| Delete lottery | `useDeleteLottery` | `DELETE /api/v1/lotteries/{id}` | Requires confirmation in UI. |
| View eligible drivers | `useLotteryEligibleDrivers(lotteryId, minPoints)` | `GET /api/v1/lotteries/{id}/eligible-drivers?min_points={N}` | Returns all active drivers with points ≥ min (sorted by balance). React modal lets admin adjust the min-points threshold to filter. |
| Draw winner | `useDrawLotteryWinner` (invoked from Eligible Drivers modal) | `POST /api/v1/lotteries/{id}/draw-winner` | Payload: `{ method: "random", min_points: X }`. Backend performs weighted random selection (drivers with more points have higher chance). SMS is triggered via `sms_service` (`response.sms_sent` indicates status). |
| End lottery | `useEndLottery` | `POST /api/v1/lotteries/{id}/end` | Marks lottery as `ended` so it no longer appears in active lists. |

### Weighted random selection details (backend `points/views.py`)
1. Admin optionally filters eligible drivers by minimum points.
2. Backend fetches all qualifying drivers (`User.is_driver=True`, `UserPoints.balance >= min_points`).
3. For random draw, the code builds a weighted pool where each driver is entered `max(points, 1)` times and chooses a random entry.
4. Winner data (`winner_id`, `winner_ticket_id=None`, `drawn_at`, `sms_sent`) is stored on the `Lottery` record.

---

## 3. Points Lifecycle (Why drivers/customers have points)

| Trigger | Backend function | How it is stored |
| --- | --- | --- |
| Successful order | `award_order_points(user, order_id)` | Adds configurable “order points” (default 1 per order) into `UserPoints`. |
| Successful referral | `award_referral_points(referrer, referred_user, referral_id)` | Adds configurable “referral points” (default 2). |
| Manual adjustments | `PointTransaction` entries (e.g., admin scripts, data migrations) | Reflected in `points/my-history`. |
| Lottery spending | (Legacy) `buy_tickets` deducted points; currently React panel does **not** expose buy flow. |

`UserPoints` maintains `balance`, `lifetime_earned`, and `lifetime_spent`. Every change creates a `PointTransaction` row, which feeds both the points history tab and manager reporting.

---

## 4. Typical Admin Workflow (Step-by-Step)

1. **Define the lottery**  
   - Open React admin → Lottery Management.  
   - Click “ایجاد قرعه‌کشی” and fill title, description, prize, start/end dates, status (`active` to make it visible immediately).  
   - Submit → React calls `POST /lotteries`, backend stores the record.

2. **Wait for point accrual**  
   - Drivers perform deliveries / get points. The system continuously updates `UserPoints`. No manual action required.

3. **Preview eligible drivers**  
   - In the list, click the blue “drivers” icon (HiUsers).  
   - React fetches `GET /lotteries/{id}/eligible-drivers?min_points=...`.  
   - Adjust `min_points` in the modal to match campaign rules (e.g., only drivers ≥ 1,000 points).

4. **Draw the winner**  
   - In the same modal press “قرعه‌کشی”. React sends `POST /lotteries/{id}/draw-winner` with `{ method: "random", min_points }`.  
   - Backend selects winner, records metadata, optionally sends SMS (`response.sms_sent`).  
   - React invalidates queries, so the list + winners tab update automatically.

5. **End the lottery**  
   - Use the stop icon to call `POST /lotteries/{id}/end`.  
   - Prevents further draws and hides the lottery from active endpoints.

6. **Communicate to stakeholders**  
   - Winners appear instantly for customers in the app (`GET /lotteries/winners`).  
   - Admin can share winner info or re-open the eligible drivers modal to demonstrate the draw log (by checking winner info on the record).

---

## 5. Common Questions & Ready Answers

| Question | Answer |
| --- | --- |
| “How do drivers enter the lottery?” | Drivers participate automatically by earning points. No ticket purchase UI exists (React panel removed “Buy Ticket”). |
| “Can we restrict draws to top-performers?” | Yes: before drawing, set `min_points` in the eligible drivers modal. Only drivers above that balance are included in the weighted random draw. |
| “How is the winner chosen?” | Backend builds a weighted pool proportionate to each driver’s point balance and selects randomly; more points = higher probability. Method `random` is default; manual selection is also supported by sending `winner_user_id`. |
| “How do we prove the draw happened?” | The `Lottery` record stores `winner_id`, `winnerName`, `drawn_at`, `winner_ticket_id (null in driver-based mode)`, and the modal immediately shows the success alert (including whether SMS was sent). |
| “Where do customers see the winner?” | Customer-facing `Lottery.tsx` loads `/lotteries/winners` and displays every past draw with winner names and prizes. |
| “How are points earned?” | Automatically via deliveries (`award_order_points`) and referrals (`award_referral_points`). Configuration entries (`order_points`, `referral_points`) let you tune reward sizes. |

---

## 6. Quick Reference of API Endpoints Used

| Purpose | Method & Path | Notes |
| --- | --- | --- |
| List lotteries | `POST /api/v1/lotteries/search` | Pagination + status filter. |
| Create / Update / Delete lottery | `POST /api/v1/lotteries`, `PUT /api/v1/lotteries/{id}`, `DELETE /api/v1/lotteries/{id}` | React form maps fields (`title`, `prizeName`, etc.). |
| Eligible drivers | `GET /api/v1/lotteries/{id}/eligible-drivers?min_points=N` | Returns driver list with point balances. |
| Draw winner | `POST /api/v1/lotteries/{id}/draw-winner` | Body: `{ method: "random", min_points: N }`. |
| End lottery | `POST /api/v1/lotteries/{id}/end` | Marks lottery finished. |
| Public winners | `GET /api/v1/lotteries/winners` | Displayed to customers. |
| Points balance/history | `GET /api/v1/points/my-balance`, `GET /api/v1/points/my-history` | Customer view. |
| Referral info | `GET /api/v1/referrals/my-code`, `GET /api/v1/referrals/my-referrals` | Customer view. |

Keep this sheet handy when explaining the system—refer to React files for UI behavior and to `zistino_apps.points.views` for backend logic.


