import React, { useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppContext } from '../App';
import Card from './common/Card';
import Icon from './common/Icon';

const StatCard: React.FC<{ title: string; value: string | number; icon: any; color: string; onClick?: () => void }> = ({ title, value, icon, color, onClick }) => (
    <Card className={`flex items-center p-4 transition-transform transform hover:scale-105 ${onClick ? 'cursor-pointer' : ''}`} onClick={onClick}>
        <div className={`p-3 rounded-full ${color} bg-opacity-20 mr-4`}>
            <Icon name={icon} className={`w-6 h-6 ${color}`} />
        </div>
        <div>
            <p className="text-sm text-textSecondary">{title}</p>
            <p className="text-2xl font-bold text-textPrimary">{value.toLocaleString('fa-IR')}</p>
        </div>
    </Card>
);

const AdminDashboard: React.FC = () => {
    const context = useContext(AppContext);
    const navigate = useNavigate();

    if (!context) {
        return <div>در حال بارگذاری...</div>;
    }

    const { requests, users, drivers } = context;
    
    const pendingRequests = requests.filter(r => r.status === 'pending').length;

    return (
        <div className="space-y-6">
            <h1 className="text-2xl font-bold text-gray-800">داشبورد مدیریت</h1>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <StatCard title="کل درخواست‌ها" value={requests.length} icon="Paper" color="text-blue-500" onClick={() => navigate('/admin/reports')} />
                <StatCard title="کاربران فعال" value={users.filter(u => u.status === 'active').length} icon="Users" color="text-green-500" onClick={() => navigate('/admin/users')} />
                <StatCard title="رانندگان فعال" value={drivers.filter(d => d.status === 'active').length} icon="Truck" color="text-indigo-500" onClick={() => navigate('/admin/users')} />
                <StatCard title="درخواست‌های در انتظار" value={pendingRequests} icon="Loading" color="text-yellow-500" onClick={() => navigate('/admin/reports')} />
            </div>
            
             <Card>
                <h2 className="text-lg font-bold mb-4">آخرین درخواست‌ها</h2>
                <div className="space-y-2">
                    {requests.slice(0, 5).map(req => (
                        <div key={req.id} className="flex justify-between items-center p-2 bg-gray-50 rounded">
                            <div>
                                <p className="font-semibold text-sm">{req.userName}</p>
                                <p className="text-xs text-gray-500">{req.address}</p>
                            </div>
                            <span className={`text-xs px-2 py-1 rounded-full ${ {pending: 'bg-yellow-100 text-yellow-800', accepted: 'bg-blue-100 text-blue-800'}[req.status] || 'bg-gray-100' }`}>
                                { {pending: 'در انتظار', accepted: 'پذیرفته شده', completed: 'تکمیل', declined: 'رد شده'}[req.status] }
                            </span>
                        </div>
                    ))}
                </div>
            </Card>
        </div>
    );
};

export default AdminDashboard;
