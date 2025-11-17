import React, { useContext } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Button from './common/Button';
import Icon from './common/Icon';

const AdminLottery: React.FC = () => {
    const context = useContext(AppContext);

    if (!context) return <div>در حال بارگذاری...</div>;

    const { users, drawLotteryWinner } = context;

    const totalTickets = users.reduce((acc, user) => acc + user.lotteryTickets, 0);

    const handleDraw = () => {
        drawLotteryWinner();
    };

    return (
        <div className="space-y-6">
            <h1 className="text-2xl font-bold text-gray-800">مدیریت قرعه‌کشی</h1>

            <Card>
                <h2 className="text-xl font-bold mb-4">آمار قرعه‌کشی فعلی</h2>
                <div className="flex space-x-4 rtl:space-x-reverse">
                    <div className="flex-1 p-4 bg-blue-50 rounded-lg text-center">
                        <p className="text-sm text-blue-800">کاربران شرکت‌کننده</p>
                        <p className="text-3xl font-bold text-blue-900">{users.filter(u => u.lotteryTickets > 0).length.toLocaleString('fa-IR')}</p>
                    </div>
                     <div className="flex-1 p-4 bg-green-50 rounded-lg text-center">
                        <p className="text-sm text-green-800">کل بلیط‌های ثبت‌شده</p>
                        <p className="text-3xl font-bold text-green-900">{totalTickets.toLocaleString('fa-IR')}</p>
                    </div>
                </div>
            </Card>

            <Card className="text-center">
                <Icon name="Ticket" className="w-16 h-16 mx-auto text-primary mb-4" />
                <h2 className="text-xl font-bold mb-2">اجرای قرعه‌کشی</h2>
                <p className="text-textSecondary mb-6">با کلیک روی دکمه زیر، یک برنده به صورت تصادفی از میان تمام بلیط‌های ثبت‌شده انتخاب خواهد شد.</p>
                <Button size="large" onClick={handleDraw}>
                    شروع قرعه‌کشی و انتخاب برنده
                </Button>
            </Card>
        </div>
    );
};

export default AdminLottery;
