import React, { useContext, useState, useMemo } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Icon from './common/Icon';
import { PickupRequest } from '../types';

type FilterType = 'all' | 'declined' | 'complaints';

const statusConfig = {
    pending: { text: 'در انتظار', color: 'bg-yellow-100 text-yellow-800', icon: 'Loading' },
    accepted: { text: 'پذیرفته شده', color: 'bg-blue-100 text-blue-800', icon: 'Truck' },
    completed: { text: 'تکمیل شده', color: 'bg-green-100 text-green-800', icon: 'CheckCircle' },
    declined: { text: 'رد شده', color: 'bg-red-100 text-red-800', icon: 'XCircle' },
};

const ReportItem: React.FC<{ request: PickupRequest }> = ({ request }) => (
    <Card className="mb-4">
        <div className="flex justify-between items-start">
            <div>
                <p className="font-bold">{request.userName}</p>
                <p className="text-sm text-textSecondary">{new Date(parseInt(request.id.split('_')[1])).toLocaleDateString('fa-IR')}</p>
            </div>
            <div className={`flex items-center text-xs font-bold px-2 py-1 rounded-full ${statusConfig[request.status].color}`}>
                <Icon name={statusConfig[request.status].icon as any} className="w-4 h-4 ml-1" />
                {statusConfig[request.status].text}
            </div>
        </div>
        <div className="border-t my-3"></div>
        <div className="text-sm space-y-2">
            <p><strong className="text-textSecondary">آدرس:</strong> {request.address}, {request.city}</p>
            <p><strong className="text-textSecondary">وزن تخمینی:</strong> {request.estimatedWeight} کیلوگرم</p>
            {request.actualWeight && <p><strong className="text-textSecondary">وزن واقعی:</strong> {request.actualWeight} کیلوگرم</p>}
            <p><strong className="text-textSecondary">دسته‌بندی‌ها:</strong> {request.categories.join(', ')}</p>
            {request.declineReason && <p className="p-2 bg-red-50 text-red-700 rounded-lg"><strong className="text-red-900">دلیل رد شدن:</strong> {request.declineReason}</p>}
            {request.customerComplaint && <p className="p-2 bg-yellow-50 text-yellow-700 rounded-lg"><strong className="text-yellow-900">شکایت مشتری:</strong> {request.customerComplaint}</p>}
        </div>
    </Card>
);

const AdminReports: React.FC = () => {
    const context = useContext(AppContext);
    const [filter, setFilter] = useState<FilterType>('all');
    
    if (!context) return <div>Loading...</div>;

    const filteredRequests = useMemo(() => {
        switch (filter) {
            case 'declined':
                return context.requests.filter(r => r.status === 'declined');
            case 'complaints':
                return context.requests.filter(r => r.customerComplaint);
            case 'all':
            default:
                return context.requests;
        }
    }, [context.requests, filter]);

    return (
        <div className="space-y-6">
            <h1 className="text-2xl font-bold text-gray-800">گزارشات جمع‌آوری</h1>

            <Card>
                <div className="flex space-x-2 rtl:space-x-reverse">
                    <button onClick={() => setFilter('all')} className={`px-4 py-2 text-sm font-semibold rounded-lg ${filter === 'all' ? 'bg-primary text-white' : 'bg-gray-200'}`}>همه</button>
                    <button onClick={() => setFilter('declined')} className={`px-4 py-2 text-sm font-semibold rounded-lg ${filter === 'declined' ? 'bg-primary text-white' : 'bg-gray-200'}`}>رد شده‌ها</button>
                    <button onClick={() => setFilter('complaints')} className={`px-4 py-2 text-sm font-semibold rounded-lg ${filter === 'complaints' ? 'bg-primary text-white' : 'bg-gray-200'}`}>شکایات</button>
                </div>
            </Card>
            
            <div>
                {filteredRequests.length > 0 ? filteredRequests.map(req => (
                    <ReportItem key={req.id} request={req} />
                )) : (
                    <Card>
                        <p className="text-center text-textSecondary py-4">هیچ موردی برای نمایش با این فیلتر وجود ندارد.</p>
                    </Card>
                )}
            </div>
        </div>
    );
};

export default AdminReports;
