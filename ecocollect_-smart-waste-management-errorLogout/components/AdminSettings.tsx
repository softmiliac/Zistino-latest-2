import React, { useContext, useState, useEffect } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Button from './common/Button';
import { WasteCategory } from '../types';

const AdminSettings: React.FC = () => {
    const context = useContext(AppContext);
    const [points, setPoints] = useState(context?.appSettings.pointsPerKg || 10);
    const [categoryPoints, setCategoryPoints] = useState<Record<string, number>>({});
    const [saved, setSaved] = useState(false);

    useEffect(() => {
        if (context?.wasteCategories) {
            const initialCategoryPoints = context.wasteCategories.reduce((acc, cat) => {
                acc[cat.id] = cat.pointsPerKg;
                return acc;
            }, {} as Record<string, number>);
            setCategoryPoints(initialCategoryPoints);
        }
    }, [context?.wasteCategories]);
    
    if (!context) return <div>در حال بارگذاری...</div>;
    
    const { appSettings, updateSettings, wasteCategories, updateWastePrice } = context;

    const handleGlobalSave = () => {
        updateSettings({ pointsPerKg: points });
        setSaved(true);
        setTimeout(() => setSaved(false), 2000);
    };

    const handleCategoryPointsChange = (id: string, value: number) => {
        setCategoryPoints(prev => ({...prev, [id]: value}));
    };

    const handleCategorySave = (id: string) => {
        updateWastePrice(id, categoryPoints[id]);
        setSaved(true);
        setTimeout(() => setSaved(false), 2000);
    };

    return (
        <div className="space-y-6">
            <h1 className="text-2xl font-bold text-gray-800">تنظیمات سامانه</h1>
            
            <Card>
                <h2 className="text-xl font-bold mb-4">تنظیمات امتیازدهی عمومی</h2>
                <div className="space-y-4">
                    <div>
                        <label htmlFor="pointsPerKg" className="block text-sm font-medium text-textPrimary mb-1">
                            امتیاز عمومی به ازای هر کیلوگرم پسماند (پیش‌فرض)
                        </label>
                        <input
                            id="pointsPerKg"
                            type="number"
                            value={points}
                            onChange={(e) => setPoints(Number(e.target.value))}
                            className="w-full max-w-xs px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-primary focus:border-primary"
                        />
                         <p className="text-xs text-gray-500 mt-1">این عدد به عنوان امتیاز پیش‌فرض در صورت عدم تعیین امتیاز برای یک دسته‌بندی خاص استفاده می‌شود.</p>
                    </div>
                    <div>
                        <Button onClick={handleGlobalSave}>
                            {saved ? 'ذخیره شد!' : 'ذخیره تغییرات عمومی'}
                        </Button>
                    </div>
                </div>
            </Card>

            <Card>
                 <h2 className="text-xl font-bold mb-4">مدیریت قیمت‌های پسماند</h2>
                 <div className="space-y-4">
                    {wasteCategories.map(cat => (
                        <div key={cat.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                            <span className="font-semibold">{cat.name}</span>
                            <div className="flex items-center space-x-2 rtl:space-x-reverse">
                                <input
                                    type="number"
                                    value={categoryPoints[cat.id] || ''}
                                    onChange={(e) => handleCategoryPointsChange(cat.id, Number(e.target.value))}
                                    className="w-24 px-2 py-1 border border-gray-300 rounded-md shadow-sm"
                                />
                                <span className="text-sm text-textSecondary">امتیاز/کیلوگرم</span>
                                <Button size="small" onClick={() => handleCategorySave(cat.id)}>ذخیره</Button>
                            </div>
                        </div>
                    ))}
                 </div>
            </Card>
        </div>
    );
};

export default AdminSettings;
