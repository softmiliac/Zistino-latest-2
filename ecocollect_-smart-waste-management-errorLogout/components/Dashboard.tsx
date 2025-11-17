import React, { useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from 'recharts';
import { AppContext } from '../App';
import Button from './common/Button';
import Card from './common/Card';
import Icon from './common/Icon';

const Dashboard: React.FC = () => {
  const context = useContext(AppContext);
  const navigate = useNavigate();

  // FIX: Property 'user' does not exist on type 'AppContextType'. It should be 'currentUser'.
  if (!context || !context.currentUser) {
    return <div>در حال بارگذاری...</div>;
  }
  
  // FIX: Property 'user' does not exist on type 'AppContextType'. Destructure 'currentUser' as 'user'.
  const { currentUser: user } = context;

  return (
    <div className="space-y-6">
      <Card>
        <div className="flex items-center justify-between">
            <div>
                <p className="text-sm text-textSecondary">خوش آمدید،</p>
                <h2 className="text-2xl font-bold text-textPrimary">{user.name}</h2>
            </div>
            <div className="w-12 h-12 rounded-full bg-primary-light flex items-center justify-center">
                <Icon name="User" className="w-6 h-6 text-primary-dark" />
            </div>
        </div>
      </Card>

      <Card>
        <div className="text-center">
          <p className="text-sm text-textSecondary">موجودی اعتبار شما</p>
          <p className="text-4xl font-extrabold text-primary my-2">
            {user.walletBalance.toLocaleString('fa-IR')} امتیاز
          </p>
          <p className="text-xs text-gray-400">با بازیافت بیشتر، امتیاز بیشتری کسب کنید!</p>
        </div>
      </Card>
      
      <div className="w-full">
        <Button onClick={() => navigate('/request')} size="large" fullWidth>
            <Icon name="Plus" className="w-5 h-5 ms-2" />
            درخواست جمع‌آوری جدید
        </Button>
      </div>

      <Card>
        <h3 className="text-lg font-semibold mb-4 text-textPrimary">تأثیر بازیافت شما</h3>
        <div style={{ width: '100%', height: 200 }}>
          <ResponsiveContainer>
            <BarChart data={user.recentActivity} margin={{ top: 5, right: 10, left: -25, bottom: 5 }} layout="vertical">
              <CartesianGrid strokeDasharray="3 3" horizontal={false} />
              <XAxis type="number" tick={{ fill: '#6B7280', fontSize: 12 }} />
              <YAxis dataKey="type" type="category" tick={{ fill: '#6B7280', fontSize: 12 }} width={60} />
              <Tooltip cursor={{fill: 'rgba(16, 185, 129, 0.1)'}} contentStyle={{ backgroundColor: '#fff', border: '1px solid #ddd', borderRadius: '8px' }} labelStyle={{ color: '#1F2937' }} itemStyle={{ color: '#10B981' }} formatter={(value: number) => [`${value.toLocaleString('fa-IR')} کیلوگرم`, 'وزن']} />
              <Bar dataKey="weight" fill="#10B981" name="وزن (کیلوگرم)" barSize={20} radius={[0, 4, 4, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </Card>
    </div>
  );
};

export default Dashboard;