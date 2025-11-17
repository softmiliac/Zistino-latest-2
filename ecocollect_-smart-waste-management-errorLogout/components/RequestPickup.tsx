import React, { useState, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import Button from './common/Button';
import Card from './common/Card';
import Icon from './common/Icon';
import { AppContext } from '../App';
import MapModal from './common/MapModal';

const RequestPickup: React.FC = () => {
    const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
    const [weight, setWeight] = useState(5);
    const [selectedTime, setSelectedTime] = useState<string>('هر زمان');
    const [isConfirmed, setIsConfirmed] = useState(false);
    const [isEditingAddress, setIsEditingAddress] = useState(false);
    const [location, setLocation] = useState<{lat: number, lng: number} | null>(null);
    const [isMapOpen, setIsMapOpen] = useState(false);
    
    const context = useContext(AppContext);
    const navigate = useNavigate();
    
    const [address, setAddress] = useState(context?.currentUser?.address || '');
    const [city, setCity] = useState(context?.currentUser?.city || '');

    const WASTE_CATEGORIES = context?.wasteCategories || [];

    const toggleCategory = (categoryId: string) => {
        setSelectedCategories(prev => 
            prev.includes(categoryId)
                ? prev.filter(id => id !== categoryId)
                : [...prev, categoryId]
        );
    };
    
    const handleAddressSave = () => {
        context?.updateAddress(address, city);
        setIsEditingAddress(false);
    }
    
    const handleLocationSelect = (coords: {lat: number, lng: number}) => {
        setLocation(coords);
        setIsMapOpen(false);
    }

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        if (selectedCategories.length === 0) {
            alert('لطفاً حداقل یک دسته از پسماند را انتخاب کنید.');
            return;
        }

        if (context?.currentUser) {
            context.addRequest({
                address: context.currentUser.address,
                city: context.currentUser.city,
                categories: selectedCategories.map(catId => WASTE_CATEGORIES.find(c => c.id === catId)?.name || catId),
                estimatedWeight: weight,
                timeSlot: selectedTime,
                latitude: location?.lat,
                longitude: location?.lng,
            });
        }
        setIsConfirmed(true);
    };
    
    if (isConfirmed) {
        return (
            <div className="text-center py-10">
                <Card>
                    <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-primary-light mb-4">
                        <Icon name="Check" className="h-8 w-8 text-primary-dark" />
                    </div>
                    <h2 className="text-2xl font-bold text-textPrimary">درخواست شما ثبت شد!</h2>
                    <p className="text-textSecondary mt-2">راننده به زودی به محل شما اعزام خواهد شد. درخواست شما در پنل رانندگان قابل مشاهده است.</p>
                    <Button onClick={() => navigate('/')} className="mt-6">
                        بازگشت به داشبورد
                    </Button>
                </Card>
            </div>
        )
    }

    return (
        <>
        <form onSubmit={handleSubmit} className="space-y-6">
            <Card>
                <h3 className="font-semibold text-lg mb-3 text-textPrimary">۱. انتخاب دسته‌بندی پسماند</h3>
                <div className="grid grid-cols-2 gap-3">
                    {WASTE_CATEGORIES.map(category => (
                        <button
                            type="button"
                            key={category.id}
                            onClick={() => toggleCategory(category.id)}
                            className={`p-3 border rounded-lg text-right transition-all duration-200 ${
                                selectedCategories.includes(category.id)
                                    ? 'bg-primary-light border-primary ring-2 ring-primary'
                                    : 'bg-gray-50 border-gray-200 hover:border-gray-400'
                            }`}
                        >
                            <Icon name={category.icon} className="w-6 h-6 mb-2 text-primary-dark" />
                            <span className="font-semibold text-sm text-textPrimary">{category.name}</span>
                            <p className="text-xs text-textSecondary">{category.description}</p>
                        </button>
                    ))}
                </div>
            </Card>
            
            <Card>
                <h3 className="font-semibold text-lg mb-3 text-textPrimary">۲. تخمین وزن</h3>
                <div className="flex items-center space-x-4 rtl:space-x-reverse">
                    <input
                        type="range"
                        min="1"
                        max="50"
                        value={weight}
                        onChange={(e) => setWeight(parseInt(e.target.value, 10))}
                        className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-primary"
                    />
                    <span className="font-bold text-primary w-24 text-center">{weight} کیلوگرم</span>
                </div>
            </Card>

            <Card>
                <h3 className="font-semibold text-lg mb-3 text-textPrimary">۳. بازه زمانی تحویل</h3>
                <div className="grid grid-cols-2 gap-3">
                    {['۹ صبح - ۱۲ ظهر', '۱۲ ظهر - ۳ عصر', '۳ عصر - ۶ عصر', 'هر زمان'].map(time => (
                        <button
                            type="button"
                            key={time}
                            onClick={() => setSelectedTime(time)}
                            className={`p-3 border rounded-lg text-center transition-all duration-200 text-sm ${
                                selectedTime === time
                                    ? 'bg-primary-light border-primary ring-2 ring-primary'
                                    : 'bg-gray-50 border-gray-200 hover:border-gray-400'
                            }`}
                        >
                            {time}
                        </button>
                    ))}
                </div>
            </Card>

            <Card>
                <div className="flex justify-between items-center">
                    <h3 className="font-semibold text-lg text-textPrimary">۴. آدرس و موقعیت مکانی</h3>
                     <button type="button" onClick={() => setIsEditingAddress(!isEditingAddress)} className="text-sm text-primary hover:underline">
                        {isEditingAddress ? 'لغو' : 'تغییر آدرس'}
                    </button>
                </div>
                {isEditingAddress ? (
                    <div className="mt-4 space-y-3">
                         <input type="text" value={address} onChange={e => setAddress(e.target.value)} placeholder="آدرس جدید" className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-primary focus:border-primary"/>
                         <input type="text" value={city} onChange={e => setCity(e.target.value)} placeholder="شهر جدید" className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-primary focus:border-primary"/>
                         <Button type="button" onClick={handleAddressSave} size="small">ذخیره آدرس</Button>
                    </div>
                ) : (
                    <div className="flex items-start space-x-3 rtl:space-x-reverse p-3 bg-gray-50 rounded-lg border mt-3">
                        <Icon name="Location" className="w-6 h-6 text-primary flex-shrink-0 mt-1" />
                        <div>
                            <p className="font-semibold text-sm">{context?.currentUser?.address}</p>
                            <p className="text-xs text-textSecondary">{context?.currentUser?.city}</p>
                        </div>
                    </div>
                )}
                <div className="mt-4">
                    {location ? (
                         <div className="flex items-center justify-between p-3 bg-green-50 rounded-lg border border-green-200">
                             <div className="flex items-center space-x-2 rtl:space-x-reverse">
                                <Icon name="CheckCircle" className="w-5 h-5 text-green-600" />
                                <span className="text-sm font-medium text-green-800">موقعیت مکانی شما با موفقیت ثبت شد.</span>
                             </div>
                             <button type="button" onClick={() => setLocation(null)} className="text-xs text-gray-500 hover:text-red-500">حذف</button>
                         </div>
                    ) : (
                        <Button type="button" onClick={() => setIsMapOpen(true)} fullWidth variant="secondary" className="bg-gray-100 text-gray-700 hover:bg-gray-200 focus:ring-gray-300">
                            <Icon name="Map" className="w-5 h-5 ms-2" />
                            ثبت موقعیت روی نقشه
                        </Button>
                    )}
                </div>
            </Card>

            <div className="pt-2">
                <Button type="submit" fullWidth size="large">
                    تأیید نهایی و ثبت درخواست
                </Button>
            </div>
        </form>
        {isMapOpen && <MapModal onSelectLocation={handleLocationSelect} onClose={() => setIsMapOpen(false)} />}
        </>
    );
};

export default RequestPickup;
