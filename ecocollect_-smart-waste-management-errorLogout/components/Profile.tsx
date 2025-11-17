import React, { useContext, useState } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Icon from './common/Icon';
import Button from './common/Button';
import ShareModal from './common/ShareModal';
import { PickupRequest } from '../types';
import Modal from './common/Modal';

const ComplaintModal: React.FC<{ request: PickupRequest, onClose: () => void, onSubmit: (id: string, text: string) => void }> = ({ request, onClose, onSubmit }) => {
    const [complaint, setComplaint] = useState('');
    
    const handleSubmit = () => {
        if (complaint.trim()) {
            onSubmit(request.id, complaint);
        } else {
            alert('لطفاً متن شکایت خود را وارد کنید.');
        }
    };

    return (
        <Modal title={`ثبت شکایت برای درخواست #${request.id.slice(-6)}`} onClose={onClose}>
            <p className="text-sm text-textSecondary mb-4">لطفاً مشکل خود را در مورد این درخواست به طور خلاصه شرح دهید تا توسط تیم پشتیبانی بررسی شود.</p>
            <textarea
                value={complaint}
                onChange={(e) => setComplaint(e.target.value)}
                rows={4}
                className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-primary focus:border-primary"
                placeholder="مشکل خود را اینجا بنویسید..."
            ></textarea>
            <div className="mt-4 flex justify-end space-x-2 rtl:space-x-reverse">
                <Button onClick={onClose} variant="secondary" className="bg-gray-200 text-gray-800 hover:bg-gray-300">لغو</Button>
                <Button onClick={handleSubmit} className="bg-red-500 hover:bg-red-600">ارسال شکایت</Button>
            </div>
        </Modal>
    );
};

const Profile: React.FC = () => {
  const context = useContext(AppContext);
  const [isShareModalOpen, setIsShareModalOpen] = useState(false);
  const [complaintRequest, setComplaintRequest] = useState<PickupRequest | null>(null);

  if (!context || !context.currentUser) {
    return <div>در حال بارگذاری...</div>;
  }
  
  const { currentUser, requests, addComplaint, logout } = context;
  const userRequests = requests.filter(r => r.userId === currentUser.id);
  
  const handleComplaintSubmit = (id: string, text: string) => {
    addComplaint(id, text);
    setComplaintRequest(null);
  };

  return (
    <>
    <div className="space-y-6">
      <Card>
        <div className="flex items-center space-x-4 rtl:space-x-reverse">
          <div className="w-20 h-20 rounded-full bg-primary-light flex items-center justify-center">
            <Icon name="User" className="w-10 h-10 text-primary-dark" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-textPrimary">{currentUser.name}</h2>
            <p className="text-sm text-textSecondary">{currentUser.city}</p>
          </div>
        </div>
      </Card>

      <Card>
        <h3 className="text-lg font-semibold mb-4 text-textPrimary">اطلاعات کاربری</h3>
        <div className="space-y-3 text-sm">
          <div className="flex justify-between items-center">
            <span className="text-textSecondary">آدرس</span>
            <span className="font-medium text-textPrimary text-left">{currentUser.address}</span>
          </div>
           <div className="flex justify-between items-center">
            <span className="text-textSecondary">کد معرف شما</span>
            <span className="font-mono bg-gray-100 text-primary-dark px-2 py-1 rounded">{currentUser.referralCode}</span>
          </div>
        </div>
      </Card>

      <Card>
          <h3 className="text-lg font-semibold mb-4 text-textPrimary">تاریخچه درخواست‌ها</h3>
          <div className="space-y-3 max-h-60 overflow-y-auto pr-2">
            {userRequests.length > 0 ? userRequests.map(req => (
                <div key={req.id} className="p-3 bg-gray-50 rounded-lg">
                    <div className="flex justify-between items-start">
                        <div>
                            <p className="text-sm font-bold">{req.categories.join('، ')}</p>
                            <p className="text-xs text-textSecondary">{new Date(parseInt(req.id.split('_')[1])).toLocaleDateString('fa-IR')}</p>
                        </div>
                         <span className={`text-xs px-2 py-1 rounded-full ${ {pending: 'bg-yellow-100 text-yellow-800', accepted: 'bg-blue-100 text-blue-800', completed: 'bg-green-100 text-green-800', declined: 'bg-red-100 text-red-800'}[req.status] }`}>
                                { {pending: 'در انتظار', accepted: 'پذیرفته شده', completed: 'تکمیل شده', declined: 'رد شده'}[req.status] }
                         </span>
                    </div>
                    {(req.status === 'completed' || req.status === 'declined') && !req.customerComplaint && (
                        <div className="mt-2 text-right">
                            <Button size="small" variant="secondary" className="text-xs !bg-gray-200 !text-gray-700" onClick={() => setComplaintRequest(req)}>
                                گزارش مشکل
                            </Button>
                        </div>
                    )}
                    {req.customerComplaint && (
                        <p className="mt-2 text-xs text-red-700 bg-red-50 p-2 rounded">شکایت شما ثبت شد.</p>
                    )}
                </div>
            )) : <p className="text-sm text-textSecondary text-center">تاریخچه‌ای برای نمایش وجود ندارد.</p>}
          </div>
      </Card>
      
      <Card>
          <h3 className="text-lg font-semibold mb-4 text-textPrimary">معرفی دوستان</h3>
          <p className="text-sm text-textSecondary mb-4">
              دوستان خود را با کد معرف خود دعوت کنید و پس از اولین جمع‌آوری موفق آن‌ها، ۵۰۰ امتیاز هدیه بگیرید.
          </p>
          <Button fullWidth variant="secondary" onClick={() => setIsShareModalOpen(true)}>
            <Icon name="Share" className="w-5 h-5 ms-2" />
            ارسال دعوت‌نامه
          </Button>
      </Card>

      <div className="pt-4">
          <Button onClick={logout} fullWidth className="bg-red-500 text-white hover:bg-red-600 focus:ring-red-500">
              <Icon name="Logout" className="w-5 h-5 ms-2" />
              خروج از حساب کاربری
          </Button>
      </div>
    </div>
    {isShareModalOpen && (
        <ShareModal 
            code={currentUser.referralCode} 
            onClose={() => setIsShareModalOpen(false)} 
        />
    )}
    {complaintRequest && (
        <ComplaintModal
            request={complaintRequest}
            onClose={() => setComplaintRequest(null)}
            onSubmit={handleComplaintSubmit}
        />
    )}
    </>
  );
};

export default Profile;
