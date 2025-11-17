import React, { useContext } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Icon from './common/Icon';

const StatCard: React.FC<{ title: string; value: string | number; icon: any; color: string; }> = ({ title, value, icon, color }) => (
    <Card className="flex-1 text-center p-4 bg-gray-50">
        <Icon name={icon} className={`w-8 h-8 mx-auto ${color}`} />
        <p className="mt-2 text-2xl font-bold text-textPrimary">{value.toLocaleString('fa-IR')}</p>
        <p className="text-xs text-textSecondary">{title}</p>
    </Card>
);

const DriverProfile: React.FC = () => {
  const context = useContext(AppContext);

  if (!context || !context.currentDriver) {
    return <div>در حال بارگذاری...</div>;
  }
  
  const { currentDriver } = context;

  return (
    <div className="space-y-6">
      <Card>
        <div className="flex flex-col items-center text-center">
          <div className="w-24 h-24 rounded-full bg-gray-200 flex items-center justify-center mb-4">
            <Icon name="Truck" className="w-12 h-12 text-gray-600" />
          </div>
          <h2 className="text-2xl font-bold text-textPrimary">{currentDriver.name}</h2>
          <p className="text-sm text-textSecondary">{currentDriver.vehicle}</p>
          <span className={`mt-2 text-xs font-bold px-2 py-1 rounded-full ${currentDriver.isVerified ? 'bg-blue-100 text-blue-800' : 'bg-yellow-100 text-yellow-800'}`}>
            {currentDriver.isVerified ? 'تأیید شده' : 'در انتظار تأیید'}
          </span>
        </div>
      </Card>

      <Card>
        <h3 className="text-lg font-semibold mb-4 text-textPrimary">آمار عملکرد و درآمد</h3>
        <div className="flex space-x-2 rtl:space-x-reverse">
             <StatCard title="جمع‌آوری‌های موفق" value={currentDriver.completedPickups} icon="CheckCircle" color="text-green-500" />
             <StatCard title="نرخ کمیسیون" value={`${currentDriver.commissionRate * 100}%`} icon="Wallet" color="text-indigo-500" />
        </div>
      </Card>

      <Card>
        <h3 className="text-lg font-semibold mb-4 text-textPrimary">وضعیت فعالیت</h3>
         <div className={`p-4 rounded-lg text-center ${currentDriver.status === 'active' ? 'bg-green-50 text-green-800' : 'bg-red-50 text-red-800'}`}>
            <p className="font-bold text-xl">
                {currentDriver.status === 'active' ? 'فعال' : 'معلق'}
            </p>
         </div>
         <p className="text-xs text-center text-textSecondary mt-2">این وضعیت توسط مدیر سیستم تعیین می‌شود.</p>
      </Card>
    </div>
  );
};

export default DriverProfile;