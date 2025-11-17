import React, { useContext, useState } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Icon from './common/Icon';
import { User, Driver } from '../types';
import Button from './common/Button';

const UserRow: React.FC<{ user: User, onToggle: (id: string) => void }> = ({ user, onToggle }) => (
    <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg mb-2">
        <div>
            <p className="font-bold">{user.name}</p>
            <p className="text-sm text-textSecondary">{user.address}</p>
        </div>
        <div className="flex items-center space-x-2 rtl:space-x-reverse">
             <span className={`text-xs font-bold px-2 py-1 rounded-full ${user.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                {user.status === 'active' ? 'فعال' : 'معلق'}
            </span>
            <button onClick={() => onToggle(user.id)} className="p-2 rounded-full hover:bg-gray-200">
                <Icon name={user.status === 'active' ? 'Ban' : 'CheckCircle'} className={`w-5 h-5 ${user.status === 'active' ? 'text-red-500' : 'text-green-500'}`} />
            </button>
        </div>
    </div>
);

const DriverRow: React.FC<{ driver: Driver, onVerify: (id: string) => void, onToggle: (id: string) => void, onCommissionChange: (id: string, rate: number) => void }> = ({ driver, onVerify, onToggle, onCommissionChange }) => {
    const [commission, setCommission] = useState(driver.commissionRate * 100);

    const handleSaveCommission = () => {
        onCommissionChange(driver.id, commission);
        alert(`کمیسیون برای ${driver.name} به‌روزرسانی شد.`);
    };
    
    return (
    <div className="p-3 bg-gray-50 rounded-lg mb-2">
        <div className="flex items-center justify-between">
            <div>
                <p className="font-bold">{driver.name}</p>
                <p className="text-sm text-textSecondary">{driver.vehicle}</p>
            </div>
            <div className="flex items-center space-x-2 rtl:space-x-reverse">
                <span className={`text-xs font-bold px-2 py-1 rounded-full ${driver.isVerified ? 'bg-blue-100 text-blue-800' : 'bg-yellow-100 text-yellow-800'}`}>
                    {driver.isVerified ? 'تأیید شده' : 'در انتظار'}
                </span>
                 <span className={`text-xs font-bold px-2 py-1 rounded-full ${driver.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                    {driver.status === 'active' ? 'فعال' : 'معلق'}
                </span>
                <button onClick={() => onVerify(driver.id)} title="تغییر وضعیت تأیید" className="p-2 rounded-full hover:bg-gray-200">
                    <Icon name="Check" className={`w-5 h-5 ${driver.isVerified ? 'text-blue-500' : 'text-gray-400'}`} />
                </button>
                 <button onClick={() => onToggle(driver.id)} title="تغییر وضعیت فعالیت" className="p-2 rounded-full hover:bg-gray-200">
                    <Icon name={driver.status === 'active' ? 'Ban' : 'CheckCircle'} className={`w-5 h-5 ${driver.status === 'active' ? 'text-red-500' : 'text-green-500'}`} />
                </button>
            </div>
        </div>
        <div className="border-t my-2"></div>
        <div className="flex items-center justify-between mt-2">
            <span className="text-sm font-medium text-textSecondary">نرخ کمیسیون:</span>
            <div className="flex items-center space-x-2 rtl:space-x-reverse">
                <input 
                    type="number" 
                    value={commission} 
                    onChange={(e) => setCommission(Number(e.target.value))}
                    className="w-20 px-2 py-1 border border-gray-300 rounded-md shadow-sm"
                    min="0"
                    max="100"
                />
                <span className="text-sm font-bold">%</span>
                <Button size="small" onClick={handleSaveCommission}>ذخیره</Button>
            </div>
        </div>
    </div>
)};


const AdminUsers: React.FC = () => {
    const context = useContext(AppContext);
    
    if (!context) return <div>در حال بارگذاری...</div>;

    const { users, drivers, toggleUserStatus, toggleDriverVerification, toggleDriverStatusAdmin, updateDriverCommission } = context;

    return (
        <div className="space-y-6">
            <h1 className="text-2xl font-bold text-gray-800">مدیریت کاربران و رانندگان</h1>

            <Card>
                <h2 className="text-xl font-bold mb-4">کاربران</h2>
                <div>
                    {users.map(user => <UserRow key={user.id} user={user} onToggle={toggleUserStatus} />)}
                </div>
            </Card>

            <Card>
                <h2 className="text-xl font-bold mb-4">رانندگان</h2>
                 <div>
                    {drivers.map(driver => <DriverRow key={driver.id} driver={driver} onVerify={toggleDriverVerification} onToggle={toggleDriverStatusAdmin} onCommissionChange={updateDriverCommission} />)}
                </div>
            </Card>
        </div>
    );
};

export default AdminUsers;