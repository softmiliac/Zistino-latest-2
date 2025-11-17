import React, { useContext, useState } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Icon from './common/Icon';
import Button from './common/Button';
import Modal from './common/Modal';
import { PickupRequest } from '../types';

const statusConfig = {
    pending: { text: 'در انتظار', color: 'bg-yellow-100 text-yellow-800' },
    accepted: { text: 'پذیرفته شده', color: 'bg-blue-100 text-blue-800' },
    completed: { text: 'تکمیل شده', color: 'bg-green-100 text-green-800' },
    declined: { text: 'رد شده', color: 'bg-red-100 text-red-800' },
};

// Simulate distance calculation
const calculateDistance = (lat1?: number, lon1?: number) => {
    if (lat1 === undefined || lon1 === undefined) return null;
    // Driver's mock location in Tehran
    const lat2 = 35.76; 
    const lon2 = 51.39;
    
    const R = 6371; // Radius of the earth in km
    const dLat = (lat2 - lat1) * (Math.PI / 180);
    const dLon = (lon2 - lon1) * (Math.PI / 180);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1 * (Math.PI/180)) * Math.cos(lat2 * (Math.PI/180)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const d = R * c; // Distance in km
    return parseFloat(d.toFixed(1));
}

const RequestCard: React.FC<{ request: PickupRequest, onAction: (action: 'accept' | 'decline' | 'complete' | 'map', request: PickupRequest) => void }> = ({ request, onAction }) => {
    const distance = calculateDistance(request.latitude, request.longitude);
    return (
    <Card className="border border-gray-200 shadow-md">
        <div className="flex justify-between items-start">
            <div>
                <p className="font-bold text-textPrimary">{request.userName}</p>
                <p className="text-sm text-textSecondary">{request.timeSlot}</p>
            </div>
            <div className={`text-xs font-bold px-2 py-1 rounded-full ${statusConfig[request.status].color}`}>
                {statusConfig[request.status].text}
            </div>
        </div>
        <div className="flex items-start justify-between p-3 bg-gray-50 rounded-lg border mt-3">
             <div className="flex items-start space-x-3 rtl:space-x-reverse">
                <Icon name="Location" className="w-5 h-5 text-gray-500 flex-shrink-0 mt-1" />
                <div>
                    <p className="font-semibold text-sm">{request.address}</p>
                    <p className="text-xs text-textSecondary">{request.city}</p>
                </div>
            </div>
            {distance !== null && <div className="text-sm font-bold text-primary">{distance.toLocaleString('fa-IR')} km</div>}
        </div>
        <div className="mt-3 text-sm space-y-2">
            <div className="flex justify-between">
                <span className="text-textSecondary">وزن تخمینی:</span>
                <span className="font-medium">{request.estimatedWeight} کیلوگرم</span>
            </div>
            <div className="flex justify-between">
                <span className="text-textSecondary">دسته‌بندی‌ها:</span>
                <span className="font-medium">{request.categories.join('، ')}</span>
            </div>
        </div>
        
        <div className="mt-4 flex space-x-2 rtl:space-x-reverse">
            {request.latitude && (
                <Button onClick={() => onAction('map', request)} size="small" fullWidth variant="secondary" className="bg-gray-200 text-gray-800 hover:bg-gray-300 focus:ring-gray-400">
                    <Icon name="Map" className="w-4 h-4 ms-1"/>
                    مشاهده نقشه
                </Button>
            )}
            {request.status === 'pending' && (
                <>
                    <Button onClick={() => onAction('accept', request)} size="small" fullWidth>پذیرش</Button>
                    <Button onClick={() => onAction('decline', request)} size="small" fullWidth variant="secondary" className="bg-red-500 hover:bg-red-600 focus:ring-red-500">رد</Button>
                </>
            )}
            {request.status === 'accepted' && (
                <Button onClick={() => onAction('complete', request)} size="small" fullWidth className="bg-green-600 hover:bg-green-700 focus:ring-green-500">
                   تکمیل جمع‌آوری
                </Button>
            )}
        </div>
    </Card>
)};

const DriverDashboard: React.FC = () => {
    const context = useContext(AppContext);
    const [modal, setModal] = useState<'decline' | 'complete' | 'map' | null>(null);
    const [selectedRequest, setSelectedRequest] = useState<PickupRequest | null>(null);
    const [declineReason, setDeclineReason] = useState('');
    const [actualWeight, setActualWeight] = useState(5);
    
    if (!context) return <div>در حال بارگذاری...</div>;
    
    const { requests, acceptRequest, declineRequest, completeRequest, driverStatus, toggleDriverStatus } = context;

    const handleAction = (action: 'accept' | 'decline' | 'complete' | 'map', request: PickupRequest) => {
        setSelectedRequest(request);
        if (action === 'accept') {
            acceptRequest(request.id);
        } else {
            setModal(action);
        }
    };

    const closeModal = () => {
        setModal(null);
        setSelectedRequest(null);
        setDeclineReason('');
        setActualWeight(5);
    };

    const handleDeclineSubmit = () => {
        if (selectedRequest && declineReason) {
            declineRequest(selectedRequest.id, declineReason);
            closeModal();
        } else {
            alert('لطفاً دلیل رد درخواست را وارد کنید.');
        }
    };

    const handleCompleteSubmit = () => {
        if (selectedRequest) {
            completeRequest(selectedRequest.id, actualWeight);
            closeModal();
        }
    };
    
    const pendingRequests = requests
        .filter(r => r.status === 'pending')
        .sort((a,b) => (calculateDistance(a.latitude, a.longitude) ?? 999) - (calculateDistance(b.latitude, b.longitude) ?? 999));
        
    const acceptedRequests = requests.filter(r => r.status === 'accepted');

    return (
        <div className="space-y-6">
            <Card>
                <div className="flex justify-between items-center">
                    <div>
                        <p className="font-bold text-lg">وضعیت شما</p>
                        <p className={`font-bold ${driverStatus === 'online' ? 'text-green-600' : 'text-red-500'}`}>{driverStatus === 'online' ? 'آنلاین' : 'آفلاین'}</p>
                    </div>
                    <button onClick={toggleDriverStatus} className={`p-2 rounded-full transition-colors ${driverStatus === 'online' ? 'bg-green-100' : 'bg-red-100'}`}>
                        <Icon name={driverStatus === 'online' ? 'ToggleRight' : 'ToggleLeft'} className={`w-8 h-8 ${driverStatus === 'online' ? 'text-green-600' : 'text-red-500'}`}/>
                    </button>
                </div>
            </Card>

            {driverStatus === 'online' ? (
            <>
                <div>
                    <div className="flex items-center mb-4">
                        <Icon name="Plus" className="w-6 h-6 text-primary-dark me-2" />
                        <h2 className="text-xl font-bold text-textPrimary">درخواست‌های جدید</h2>
                    </div>
                    {pendingRequests.length > 0 ? (
                        <div className="space-y-4">
                            {pendingRequests.map(req => <RequestCard key={req.id} request={req} onAction={handleAction} />)}
                        </div>
                    ) : (
                        <Card><p className="text-textSecondary text-center py-4">در حال حاضر درخواست جدیدی برای شما وجود ندارد.</p></Card>
                    )}
                </div>

                <div>
                    <div className="flex items-center mb-4">
                        <Icon name="Truck" className="w-6 h-6 text-blue-600 me-2" />
                        <h2 className="text-xl font-bold text-textPrimary">ماموریت‌های در حال انجام</h2>
                    </div>
                    {acceptedRequests.length > 0 ? (
                        <div className="space-y-4">
                            {acceptedRequests.map(req => <RequestCard key={req.id} request={req} onAction={handleAction} />)}
                        </div>
                    ) : (
                        <Card><p className="text-textSecondary text-center py-4">شما هیچ ماموریت فعالی ندارید.</p></Card>
                    )}
                </div>
            </>
            ) : (
                 <Card>
                    <div className="text-center py-8">
                        <Icon name="EyeOff" className="w-12 h-12 text-gray-400 mx-auto mb-4"/>
                        <h3 className="text-lg font-bold text-textPrimary">شما آفلاین هستید</h3>
                        <p className="text-textSecondary mt-2">برای دریافت ماموریت‌های جدید، وضعیت خود را به آنلاین تغییر دهید.</p>
                    </div>
                </Card>
            )}

            {modal === 'decline' && (
                <Modal title="رد درخواست" onClose={closeModal}>
                    <p className="text-sm text-textSecondary mb-4">لطفاً دلیل رد کردن این درخواست را مشخص کنید.</p>
                    <textarea value={declineReason} onChange={(e) => setDeclineReason(e.target.value)} rows={3} className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-primary focus:border-primary" placeholder="مثال: آدرس مشتری در دسترس نبود."></textarea>
                    <div className="mt-4 flex justify-end space-x-2 rtl:space-x-reverse">
                        <Button onClick={closeModal} variant="secondary" className="bg-gray-200 text-gray-800 hover:bg-gray-300">لغو</Button>
                        <Button onClick={handleDeclineSubmit} className="bg-red-500 hover:bg-red-600">ثبت دلیل</Button>
                    </div>
                </Modal>
            )}

            {modal === 'complete' && (
                 <Modal title="تکمیل جمع‌آوری" onClose={closeModal}>
                    <p className="text-sm text-textSecondary mb-4">لطفاً وزن واقعی پسماند جمع‌آوری شده را وارد کنید.</p>
                    <div className="flex items-center space-x-4 rtl:space-x-reverse my-4">
                        <input type="range" min="1" max="100" value={actualWeight} onChange={(e) => setActualWeight(parseInt(e.target.value))} className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-primary" />
                        <span className="font-bold text-primary w-24 text-center">{actualWeight} کیلوگرم</span>
                    </div>
                    <div className="mt-6 flex justify-end space-x-2 rtl:space-x-reverse">
                        <Button onClick={closeModal} variant="secondary" className="bg-gray-200 text-gray-800 hover:bg-gray-300">لغو</Button>
                        <Button onClick={handleCompleteSubmit} className="bg-green-600 hover:bg-green-700">تأیید و ثبت</Button>
                    </div>
                </Modal>
            )}

            {modal === 'map' && selectedRequest?.latitude && (
                <Modal title="موقعیت مکانی مشتری" onClose={closeModal}>
                    <p className="text-sm text-textSecondary mb-4">موقعیت ثبت شده توسط مشتری روی نقشه نمایش داده شده است.</p>
                    <div className="w-full h-64 bg-gray-200 rounded-lg flex items-center justify-center overflow-hidden relative">
                       <img src={`https://i.imgur.com/c4g0n4u.png`} alt="Map Preview" className="w-full h-full object-cover"/>
                        <div className="absolute flex flex-col items-center" style={{top: '50%', left: '50%', transform: 'translate(-50%, -50%)'}}>
                            <Icon name="Location" className="w-10 h-10 text-red-500"/>
                            <span className="bg-white px-2 py-1 rounded-md shadow-lg text-xs font-bold">{selectedRequest.userName}</span>
                        </div>
                    </div>
                     <div className="mt-4 flex justify-end space-x-2 rtl:space-x-reverse">
                        <Button onClick={closeModal} variant="secondary" className="bg-gray-200 text-gray-800 hover:bg-gray-300">بستن</Button>
                        <Button onClick={() => alert('مسیریابی به سمت مقصد آغاز شد!')}>شروع مکانیابی</Button>
                    </div>
                </Modal>
            )}
        </div>
    );
};

export default DriverDashboard;
