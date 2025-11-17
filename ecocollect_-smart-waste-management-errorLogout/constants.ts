import { WasteCategory } from './types';

export const NAV_LINKS = [
  { path: '/', label: 'خانه', icon: 'Home' },
  { path: '/store', label: 'فروشگاه', icon: 'Store' },
  { path: '/guide', label: 'راهنما', icon: 'Guide' },
  { path: '/lottery', label: 'قرعه‌کشی', icon: 'Ticket' },
  { path: '/profile', label: 'پروفایل', icon: 'Settings' },
];

export const DRIVER_NAV_LINKS = [
  { path: '/driver', label: 'ماموریت‌ها', icon: 'Truck' },
  { path: '/driver/profile', label: 'پروفایل', icon: 'User' },
];

export const ADMIN_NAV_LINKS = [
    { path: '/admin', label: 'داشبورد', icon: 'ChartBar' },
    { path: '/admin/reports', label: 'گزارشات', icon: 'Paper' },
    { path: '/admin/users', label: 'کاربران', icon: 'Users' },
    { path: '/admin/store', label: 'فروشگاه', icon: 'Store' },
    { path: '/admin/lottery', label: 'قرعه‌کشی', icon: 'Ticket' },
    { path: '/admin/settings', label: 'تنظیمات', icon: 'Settings' },
];
