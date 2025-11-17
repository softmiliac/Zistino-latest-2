import React, { useState, createContext, useContext, ReactNode } from 'react';
import { HashRouter, Routes, Route, Navigate } from 'react-router-dom';
import Layout from './components/Layout';
import DriverLayout from './components/DriverLayout';
import AdminLayout from './components/AdminLayout';
import Dashboard from './components/Dashboard';
import Store from './components/Store';
import SortingGuide from './components/SortingGuide';
import RequestPickup from './components/RequestPickup';
import Profile from './components/Profile';
import Login from './components/Login';
import Lottery from './components/Lottery';
import DriverLogin from './components/DriverLogin';
import DriverDashboard from './components/DriverDashboard';
import DriverProfile from './components/DriverProfile';
import AdminLogin from './components/AdminLogin';
import AdminDashboard from './components/AdminDashboard';
import AdminReports from './components/AdminReports';
import AdminUsers from './components/AdminUsers';
import AdminSettings from './components/AdminSettings';
import AdminStore from './components/AdminStore';
import AdminLottery from './components/AdminLottery';
import { User, Activity, PickupRequest, Driver, AppSettings, WasteCategory, Product } from './types';

const initialUsers: User[] = [
    { id: 'user_123', name: 'آرش حسینی', walletBalance: 1250, recentActivity: [{ type: 'پلاستیک', weight: 5 }, { type: 'کاغذ', weight: 10 }, { type: 'شیشه', weight: 3 }, { type: 'ارگانیک', weight: 8 }], address: 'خیابان سبز، پلاک ۱۲۳', city: 'تهران، ایران', referralCode: 'ECO-A1B2C3', lotteryTickets: 3, status: 'active' },
    { id: 'user_456', name: 'سارا محمدی', walletBalance: 800, recentActivity: [], address: 'میدان ولیعصر، کوچه نسترن، پلاک ۴', city: 'تهران', referralCode: 'ECO-S4M5D6', lotteryTickets: 1, status: 'active' },
    { id: 'user_789', name: 'رضا قاسمی', walletBalance: 2500, recentActivity: [], address: 'خیابان آزادی، جنب پارک المهدی', city: 'تهران', referralCode: 'ECO-R7G8S9', lotteryTickets: 10, status: 'suspended' },
];

const initialDrivers: Driver[] = [
    { id: 'driver_1', name: 'بهنام محمدی', vehicle: 'وانت نیسان - ۱۲ع۳۴۵ ایران ۶۷', completedPickups: 18, status: 'active', isVerified: true, commissionRate: 0.75 },
    { id: 'driver_2', name: 'کیانوش تهرانی', vehicle: 'مزدا وانت - ۸۸د۹۱۲ ایران ۲۱', completedPickups: 32, status: 'active', isVerified: false, commissionRate: 0.80 },
    { id: 'driver_3', name: 'مریم صالحی', vehicle: 'پراید وانت - ۴۵ج۴۵۶ ایران ۱۱', completedPickups: 5, status: 'suspended', isVerified: true, commissionRate: 0.70 },
];

const initialRequests: PickupRequest[] = [
    { id: 'req_1', userId: 'user_456', userName: 'سارا محمدی', address: 'میدان ولیعصر، کوچه نسترن، پلاک ۴', city: 'تهران', categories: ['پلاستیک', 'کاغذ و مقوا'], estimatedWeight: 8, timeSlot: '۳ عصر - ۶ عصر', status: 'pending', latitude: 35.709, longitude: 51.408, },
    { id: 'req_2', userId: 'user_789', userName: 'رضا قاسمی', address: 'خیابان آزادی، جنب پارک المهدی', city: 'تهران', categories: ['شیشه'], estimatedWeight: 15, timeSlot: '۹ صبح - ۱۲ ظهر', status: 'completed', actualWeight: 14, latitude: 35.699, longitude: 51.373, },
    { id: 'req_3', userId: 'user_123', userName: 'آرش حسینی', address: 'بزرگراه همت، خروجی شیخ فضل‌الله', city: 'تهران', categories: ['پسماند آلی', 'پلاستیک'], estimatedWeight: 12, timeSlot: 'هر زمان', status: 'accepted', latitude: 35.751, longitude: 51.383, },
    { id: 'req_4', userId: 'user_123', userName: 'آرش حسینی', address: 'بزرگراه همت، خروجی شیخ فضل‌الله', city: 'تهران', categories: ['شیشه'], estimatedWeight: 5, timeSlot: '۹ صبح - ۱۲ ظهر', status: 'declined', declineReason: "عدم حضور مشتری در محل", latitude: 35.751, longitude: 51.383, }
];

const initialProducts: Product[] = [
  { id: 1, name: 'فنجان قهوه قابل استفاده مجدد', price: 500, imageUrl: 'https://picsum.photos/seed/reusable-cup/400/400' },
  { id: 2, name: 'ست مسواک بامبو', price: 350, imageUrl: 'https://picsum.photos/seed/bamboo-toothbrush/400/400' },
  { id: 3, name: 'کیف پارچه‌ای نخی ارگانیک', price: 750, imageUrl: 'https://picsum.photos/seed/tote-bag/400/400' },
  { id: 4, name: 'شارژر خورشیدی', price: 2500, imageUrl: 'https://picsum.photos/seed/solar-charger/400/400' },
  { id: 5, name: 'دفترچه یادداشت بازیافتی', price: 200, imageUrl: 'https://picsum.photos/seed/recycled-notebook/400/400' },
  { id: 6, name: 'مدادهای قابل کاشت', price: 400, imageUrl: 'https://picsum.photos/seed/plantable-pencils/400/400' },
];

const initialWasteCategories: WasteCategory[] = [
    { id: 'plastic', name: 'پلاستیک', description: 'بطری، ظروف، کیسه', icon: 'Plastic', pointsPerKg: 15 },
    { id: 'paper', name: 'کاغذ و مقوا', description: 'روزنامه، جعبه، مجله', icon: 'Paper', pointsPerKg: 10 },
    { id: 'glass', name: 'شیشه', description: 'شیشه، بطری، ظروف', icon: 'Glass', pointsPerKg: 8 },
    { id: 'organic', name: 'پسماند آلی', description: 'باقیمانده غذا، شاخ و برگ', icon: 'Trash', pointsPerKg: 5 }
];

interface AppContextType {
  currentUser: User | null;
  currentDriver: Driver | null;
  users: User[];
  drivers: Driver[];
  products: Product[];
  wasteCategories: WasteCategory[];
  isAuthenticated: boolean;
  isDriverAuthenticated: boolean;
  isAdminAuthenticated: boolean;
  driverStatus: 'online' | 'offline';
  appSettings: AppSettings;
  requests: PickupRequest[];
  login: (password: string) => boolean;
  logout: () => void;
  driverLogin: (password: string) => boolean;
  driverLogout: () => void;
  adminLogin: (password: string) => boolean;
  adminLogout: () => void;
  purchaseItem: (price: number) => boolean;
  updateAddress: (newAddress: string, newCity: string) => void;
  purchaseLotteryTickets: (ticketCount: number) => boolean;
  addRequest: (requestData: Omit<PickupRequest, 'id' | 'status' | 'userId' | 'userName'>) => void;
  acceptRequest: (requestId: string) => void;
  declineRequest: (requestId: string, reason: string) => void;
  completeRequest: (requestId: string, weight: number) => void;
  toggleDriverStatus: () => void;
  updateSettings: (newSettings: Partial<AppSettings>) => void;
  toggleUserStatus: (userId: string) => void;
  toggleDriverVerification: (driverId: string) => void;
  toggleDriverStatusAdmin: (driverId: string) => void;
  updateWastePrice: (categoryId: string, points: number) => void;
  updateProduct: (productId: number, newProduct: Partial<Product>) => void;
  addComplaint: (requestId: string, complaint: string) => void;
  drawLotteryWinner: () => User | null;
  updateDriverCommission: (driverId: string, rate: number) => void;
}

export const AppContext = createContext<AppContextType | null>(null);

const AppProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [currentDriver, setCurrentDriver] = useState<Driver | null>(null);
  const [users, setUsers] = useState<User[]>(initialUsers);
  const [drivers, setDrivers] = useState<Driver[]>(initialDrivers);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isDriverAuthenticated, setIsDriverAuthenticated] = useState(false);
  const [isAdminAuthenticated, setIsAdminAuthenticated] = useState(false);
  const [requests, setRequests] = useState<PickupRequest[]>(initialRequests);
  const [driverStatus, setDriverStatus] = useState<'online' | 'offline'>('offline');
  const [appSettings, setAppSettings] = useState<AppSettings>({ pointsPerKg: 10 });
  const [products, setProducts] = useState<Product[]>(initialProducts);
  const [wasteCategories, setWasteCategories] = useState<WasteCategory[]>(initialWasteCategories);


  const login = (password: string) => {
    if (password === '1234') {
      setCurrentUser(initialUsers[0]);
      setIsAuthenticated(true);
      return true;
    }
    return false;
  };
  const logout = () => {
    if (window.confirm('آیا برای خروج از حساب کاربری خود اطمینان دارید؟')) {
        setIsAuthenticated(false);
        setCurrentUser(null);
    }
  };
  
  const driverLogin = (password: string) => {
    if (password === 'drive') {
        setCurrentDriver(initialDrivers[0]);
        setIsDriverAuthenticated(true);
        return true;
    }
    return false;
  };
  const driverLogout = () => {
    if (window.confirm('آیا برای خروج از پنل رانندگان اطمینان دارید؟')) {
        setIsDriverAuthenticated(false);
        setCurrentDriver(null);
    }
  };
  
  const adminLogin = (password: string) => {
      if (password === 'admin') {
          setIsAdminAuthenticated(true);
          return true;
      }
      return false;
  }
  const adminLogout = () => {
    if (window.confirm('آیا برای خروج از پنل مدیریت اطمینان دارید؟')) {
      setIsAdminAuthenticated(false);
    }
  };

  const addActivity = (userId: string, activity: Activity) => {
    const updateUser = (user: User | null): User | null => {
        if (!user || user.id !== userId) return user;
        const newActivity = [activity, ...user.recentActivity].slice(0, 5);
        return { ...user, recentActivity: newActivity };
    };
    
    setUsers(prevUsers => prevUsers.map(u => updateUser(u) || u));
    setCurrentUser(prevUser => updateUser(prevUser));
  };
  
  const addPointsToUser = (userId: string, points: number) => {
      setUsers(prevUsers => prevUsers.map(u => u.id === userId ? { ...u, walletBalance: u.walletBalance + points } : u));
      if (currentUser?.id === userId) {
          setCurrentUser(prev => prev ? { ...prev, walletBalance: prev.walletBalance + points } : null);
      }
  }

  const purchaseItem = (price: number) => {
      if (currentUser && currentUser.walletBalance >= price) {
          setCurrentUser({ ...currentUser, walletBalance: currentUser.walletBalance - price });
          return true;
      }
      return false;
  };
  
  const purchaseLotteryTickets = (ticketCount: number) => {
      const TICKET_PRICE = 100;
      const totalCost = ticketCount * TICKET_PRICE;
      if (currentUser && currentUser.walletBalance >= totalCost) {
          setCurrentUser({
              ...currentUser,
              walletBalance: currentUser.walletBalance - totalCost,
              lotteryTickets: currentUser.lotteryTickets + ticketCount
          });
          return true;
      }
      return false;
  };

  const updateAddress = (newAddress: string, newCity: string) => {
      if (currentUser) {
          setCurrentUser({ ...currentUser, address: newAddress, city: newCity });
      }
  };

  const addRequest = (requestData: Omit<PickupRequest, 'id' | 'status' | 'userId' | 'userName'>) => {
      if (!currentUser) return;
      const newRequest: PickupRequest = {
          ...requestData,
          id: `req_${Date.now()}`,
          status: 'pending',
          userId: currentUser.id,
          userName: currentUser.name,
      };
      setRequests(prev => [newRequest, ...prev]);
  };

  const acceptRequest = (requestId: string) => {
      setRequests(prev => prev.map(req => req.id === requestId ? { ...req, status: 'accepted' } : req));
  };
  
  const declineRequest = (requestId: string, reason: string) => {
      setRequests(prev => prev.map(req => req.id === requestId ? { ...req, status: 'declined', declineReason: reason } : req));
  };

  const completeRequest = (requestId: string, weight: number) => {
      let completedRequest: PickupRequest | undefined;
      setRequests(prev => prev.map(req => {
          if (req.id === requestId) {
              completedRequest = { ...req, status: 'completed', actualWeight: weight };
              return completedRequest;
          }
          return req;
      }));
      
      if (completedRequest) {
          const requestUserId = completedRequest.userId;
          // Calculate points based on specific category pricing
          const pointsPerCategory = completedRequest.categories.reduce((total, catName) => {
              const category = wasteCategories.find(c => c.name === catName);
              return total + (category ? category.pointsPerKg : appSettings.pointsPerKg);
          }, 0) / completedRequest.categories.length; // Average points if multiple categories

          const points = weight * pointsPerCategory;
          addPointsToUser(requestUserId, points);
          addActivity(requestUserId, { type: completedRequest.categories.join('، '), weight });
      }
      
      setCurrentDriver(prev => prev ? { ...prev, completedPickups: prev.completedPickups + 1} : null);
  };
  
  const toggleDriverStatus = () => setDriverStatus(s => s === 'online' ? 'offline' : 'online');
  
  const updateSettings = (newSettings: Partial<AppSettings>) => {
      setAppSettings(prev => ({ ...prev, ...newSettings }));
  };

  const toggleUserStatus = (userId: string) => {
      setUsers(prev => prev.map(u => u.id === userId ? { ...u, status: u.status === 'active' ? 'suspended' : 'active' } : u));
  };
  
  const toggleDriverVerification = (driverId: string) => {
      setDrivers(prev => prev.map(d => d.id === driverId ? { ...d, isVerified: !d.isVerified } : d));
  };

  const toggleDriverStatusAdmin = (driverId: string) => {
      setDrivers(prev => prev.map(d => d.id === driverId ? { ...d, status: d.status === 'active' ? 'suspended' : 'active' } : d));
  };

  const updateWastePrice = (categoryId: string, points: number) => {
    setWasteCategories(prev => prev.map(cat => cat.id === categoryId ? { ...cat, pointsPerKg: points } : cat));
  };

  const updateProduct = (productId: number, newProductData: Partial<Product>) => {
    setProducts(prev => prev.map(p => p.id === productId ? { ...p, ...newProductData } : p));
  };

  const addComplaint = (requestId: string, complaint: string) => {
    setRequests(prev => prev.map(r => r.id === requestId ? { ...r, customerComplaint: complaint } : r));
  };
  
  const drawLotteryWinner = () => {
    const participants = users.filter(u => u.lotteryTickets > 0);
    if (participants.length === 0) {
        alert("هیچ شرکت‌کننده‌ای در قرعه‌کشی وجود ندارد.");
        return null;
    }
    const winner = participants[Math.floor(Math.random() * participants.length)];
    alert(`🎉 برنده این دوره قرعه‌کشی: ${winner.name}! 🎉`);
    // Optional: Reset tickets after draw
    // setUsers(prev => prev.map(u => ({...u, lotteryTickets: 0})));
    return winner;
  };

  const updateDriverCommission = (driverId: string, rate: number) => {
    const newRate = Math.max(0, Math.min(100, rate)) / 100;
    setDrivers(prev => prev.map(d => d.id === driverId ? { ...d, commissionRate: newRate } : d));
    if (currentDriver?.id === driverId) {
        setCurrentDriver(prev => prev ? { ...prev, commissionRate: newRate } : null);
    }
  };


  return (
    <AppContext.Provider value={{ 
        currentUser, 
        currentDriver,
        users,
        drivers,
        products,
        wasteCategories,
        isAuthenticated, 
        isDriverAuthenticated,
        isAdminAuthenticated,
        driverStatus,
        appSettings,
        requests,
        login, logout, 
        driverLogin, driverLogout,
        adminLogin, adminLogout,
        purchaseItem, 
        updateAddress, 
        purchaseLotteryTickets,
        addRequest, acceptRequest, declineRequest, completeRequest,
        toggleDriverStatus,
        updateSettings,
        toggleUserStatus,
        toggleDriverVerification,
        toggleDriverStatusAdmin,
        updateWastePrice,
        updateProduct,
        addComplaint,
        drawLotteryWinner,
        updateDriverCommission,
    }}>
      {children}
    </AppContext.Provider>
  );
};

const App: React.FC = () => {
  return (
    <AppProvider>
      <HashRouter>
        <Main />
      </HashRouter>
    </AppProvider>
  );
};

const Main: React.FC = () => {
  const context = useContext(AppContext);

  if (!context) {
    return null; // Or a loading spinner
  }

  return (
    <Routes>
      <Route path="/login" element={!context.isAuthenticated && !context.isDriverAuthenticated && !context.isAdminAuthenticated ? <Login /> : <Navigate to="/" />} />
      <Route path="/driver/login" element={!context.isDriverAuthenticated ? <DriverLogin /> : <Navigate to="/driver" />} />
      <Route path="/admin/login" element={!context.isAdminAuthenticated ? <AdminLogin /> : <Navigate to="/admin" />} />
      
      <Route path="/driver/*" element={context.isDriverAuthenticated ? <ProtectedDriverRoutes /> : <Navigate to="/driver/login" />} />
      <Route path="/admin/*" element={context.isAdminAuthenticated ? <ProtectedAdminRoutes /> : <Navigate to="/admin/login" />} />
      <Route path="/*" element={context.isAuthenticated ? <ProtectedRoutes /> : <Navigate to="/login" />} />
    </Routes>
  );
};

const ProtectedRoutes: React.FC = () => (
  <Layout>
    <Routes>
      <Route path="/" element={<Dashboard />} />
      <Route path="/store" element={<Store />} />
      <Route path="/guide" element={<SortingGuide />} />
      <Route path="/lottery" element={<Lottery />} />
      <Route path="/request" element={<RequestPickup />} />
      <Route path="/profile" element={<Profile />} />
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  </Layout>
);

const ProtectedDriverRoutes: React.FC = () => {
    return (
    <DriverLayout>
        <Routes>
            <Route path="/" element={<DriverDashboard />} />
            <Route path="/profile" element={<DriverProfile />} />
            <Route path="*" element={<Navigate to="/driver" />} />
        </Routes>
    </DriverLayout>
    )
};

const ProtectedAdminRoutes: React.FC = () => {
    return (
    <AdminLayout>
        <Routes>
            <Route path="/" element={<AdminDashboard />} />
            <Route path="/reports" element={<AdminReports />} />
            <Route path="/users" element={<AdminUsers />} />
            <Route path="/settings" element={<AdminSettings />} />
            <Route path="/store" element={<AdminStore />} />
            <Route path="/lottery" element={<AdminLottery />} />
            <Route path="*" element={<Navigate to="/admin" />} />
        </Routes>
    </AdminLayout>
    )
};

export default App;
