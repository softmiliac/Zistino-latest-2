import React, { useState, useContext, useEffect } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Button from './common/Button';
import Icon from './common/Icon';

const TICKET_PRICE = 100;
const GRAND_PRIZE = {
  name: 'اسکوتر برقی',
  imageUrl: 'https://picsum.photos/seed/scooter/800/400'
};
const PAST_WINNERS = [
  { name: 'مریم رضایی', prize: 'گوشی هوشمند' },
  { name: 'علی احمدی', prize: 'ساعت هوشمند' },
  { name: 'زهرا قاسمی', prize: 'بلیط سفر' },
];

const Lottery: React.FC = () => {
  const context = useContext(AppContext);
  const [ticketsToBuy, setTicketsToBuy] = useState(1);
  const [modalState, setModalState] = useState<{show: boolean, success: boolean, message: string}>({show: false, success: false, message: ''});

  const calculateTimeLeft = () => {
    // Set a fixed future date for demonstration
    const difference = +new Date('2024-12-31T23:59:59') - +new Date();
    let timeLeft: { [key: string]: number } = {};

    if (difference > 0) {
      timeLeft = {
        days: Math.floor(difference / (1000 * 60 * 60 * 24)),
        hours: Math.floor((difference / (1000 * 60 * 60)) % 24),
        minutes: Math.floor((difference / 1000 / 60) % 60),
        seconds: Math.floor((difference / 1000) % 60),
      };
    }
    return timeLeft;
  };
  
  const [timeLeft, setTimeLeft] = useState(calculateTimeLeft());

  useEffect(() => {
    const timer = setTimeout(() => {
      setTimeLeft(calculateTimeLeft());
    }, 1000);
    return () => clearTimeout(timer);
  });

  const handlePurchase = () => {
    if (context) {
        const success = context.purchaseLotteryTickets(ticketsToBuy);
        if (success) {
            setModalState({ show: true, success: true, message: `شما با موفقیت ${ticketsToBuy.toLocaleString('fa-IR')} بلیط خریداری کردید.` });
        } else {
            setModalState({ show: true, success: false, message: 'متاسفانه امتیاز شما برای خرید این تعداد بلیط کافی نیست.' });
        }
        setTicketsToBuy(1);
    }
  };

  const closeModal = () => {
    setModalState({ show: false, success: false, message: '' });
  };
  
  // FIX: Property 'user' does not exist on type 'AppContextType'. It should be 'currentUser'.
  if (!context || !context.currentUser) {
    return <div>در حال بارگذاری...</div>;
  }

  // FIX: Property 'user' does not exist on type 'AppContextType'. Destructure 'currentUser' as 'user'.
  const { currentUser: user } = context;
  const totalCost = ticketsToBuy * TICKET_PRICE;
  const timerComponents: JSX.Element[] = [];

  Object.keys(timeLeft).forEach((interval) => {
    if (typeof timeLeft[interval] === 'number') {
        timerComponents.push(
            <div key={interval} className="flex flex-col items-center">
                <span className="text-3xl font-bold text-primary">{String(timeLeft[interval]).padStart(2, '0')}</span>
                <span className="text-xs text-textSecondary">{ {days: 'روز', hours: 'ساعت', minutes: 'دقیقه', seconds: 'ثانیه'}[interval] }</span>
            </div>
        );
    }
  });


  return (
    <div className="space-y-6">
      <Card className="p-0 overflow-hidden">
        <img src={GRAND_PRIZE.imageUrl} alt={GRAND_PRIZE.name} className="w-full h-40 object-cover"/>
        <div className="p-4 bg-primary text-white">
          <h2 className="text-2xl font-bold">جایزه بزرگ: {GRAND_PRIZE.name}</h2>
          <p className="text-sm opacity-90">شانس خود را برای برنده شدن امتحان کنید!</p>
        </div>
      </Card>

      <Card>
        <h3 className="text-lg font-semibold mb-3 text-center text-textPrimary">زمان باقی‌مانده تا قرعه‌کشی</h3>
        <div className="flex justify-center space-x-4 rtl:space-x-reverse text-center">
            {timerComponents.length ? timerComponents : <p>قرعه‌کشی به پایان رسیده است!</p>}
        </div>
      </Card>

      <Card>
        <h3 className="text-lg font-semibold mb-3 text-textPrimary">بلیط‌های شما</h3>
        <div className="flex justify-between items-center bg-primary-light p-3 rounded-lg">
            <div className="text-primary-dark">
                <p className="font-medium">تعداد بلیط‌های شما</p>
                <p className="text-2xl font-bold">{user.lotteryTickets.toLocaleString('fa-IR')} عدد</p>
            </div>
            <Icon name="Ticket" className="w-8 h-8 text-primary-dark"/>
        </div>
      </Card>

       <Card>
        <h3 className="text-lg font-semibold mb-3 text-textPrimary">خرید بلیط</h3>
        <div className="space-y-4">
            <p className="text-sm text-textSecondary">هر بلیط <span className="font-bold text-primary">{TICKET_PRICE.toLocaleString('fa-IR')}</span> امتیاز. شانس بیشتر با خرید بلیط بیشتر!</p>
            <div className="flex items-center space-x-2 rtl:space-x-reverse">
                <Button onClick={() => setTicketsToBuy(Math.max(1, ticketsToBuy - 1))}>-</Button>
                <input type="number" value={ticketsToBuy} readOnly className="w-full text-center font-bold text-lg border-y border-gray-200 h-10 bg-white"/>
                <Button onClick={() => setTicketsToBuy(ticketsToBuy + 1)}>+</Button>
            </div>
             <Button onClick={handlePurchase} fullWidth disabled={user.walletBalance < totalCost}>
                خرید {ticketsToBuy.toLocaleString('fa-IR')} بلیط ({totalCost.toLocaleString('fa-IR')} امتیاز)
             </Button>
        </div>
      </Card>
      
      <Card>
          <h3 className="text-lg font-semibold mb-4 text-textPrimary">برندگان دوره‌های قبل</h3>
          <ul className="space-y-3">
              {PAST_WINNERS.map((winner, index) => (
                  <li key={index} className="flex items-center justify-between p-2 bg-gray-50 rounded-md">
                      <div className="flex items-center space-x-3 rtl:space-x-reverse">
                        <Icon name="User" className="w-5 h-5 text-gray-400"/>
                        <span className="text-sm font-medium text-textPrimary">{winner.name}</span>
                      </div>
                      <span className="text-xs text-white bg-secondary px-2 py-1 rounded-full">{winner.prize}</span>
                  </li>
              ))}
          </ul>
      </Card>
      
      {modalState.show && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
            <Card className="max-w-sm w-full">
                <div className="text-center">
                    <div className={`mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full mb-4 ${modalState.success ? 'bg-green-100' : 'bg-red-100'}`}>
                        {modalState.success ? <Icon name="Check" className="h-6 w-6 text-green-600" /> : <Icon name="Close" className="h-6 w-6 text-red-600" />}
                    </div>
                    <h3 className="text-lg leading-6 font-medium text-gray-900">{modalState.success ? 'خرید موفق!' : 'عملیات ناموفق'}</h3>
                    <div className="mt-2 px-7 py-3">
                        <p className="text-sm text-gray-500">{modalState.message}</p>
                    </div>
                    <div className="mt-4">
                        <Button onClick={closeModal}>
                            {modalState.success ? 'عالی!' : 'متوجه شدم'}
                        </Button>
                    </div>
                </div>
            </Card>
        </div>
      )}
    </div>
  );
};

export default Lottery;