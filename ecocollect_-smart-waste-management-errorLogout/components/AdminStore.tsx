import React, { useContext, useState, useEffect } from 'react';
import { AppContext } from '../App';
import Card from './common/Card';
import Button from './common/Button';
import { Product } from '../types';

const AdminStore: React.FC = () => {
    const context = useContext(AppContext);
    const [editableProducts, setEditableProducts] = useState<Product[]>([]);

    useEffect(() => {
        if (context?.products) {
            setEditableProducts(JSON.parse(JSON.stringify(context.products)));
        }
    }, [context?.products]);

    if (!context) return <div>در حال بارگذاری...</div>;

    const { updateProduct } = context;

    const handleInputChange = (productId: number, field: 'name' | 'price', value: string | number) => {
        setEditableProducts(prev => 
            prev.map(p => p.id === productId ? { ...p, [field]: value } : p)
        );
    };

    const handleSave = (product: Product) => {
        updateProduct(product.id, { name: product.name, price: Number(product.price) });
        alert(`محصول «${product.name}» با موفقیت به‌روزرسانی شد.`);
    };

    return (
        <div className="space-y-6">
            <h1 className="text-2xl font-bold text-gray-800">مدیریت فروشگاه</h1>
            
            <div className="space-y-4">
                {editableProducts.map(product => (
                    <Card key={product.id}>
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-center">
                            <img src={product.imageUrl} alt={product.name} className="w-20 h-20 object-cover rounded-lg" />
                            <div className="md:col-span-3 grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
                                <div>
                                    <label className="text-xs text-textSecondary">نام محصول</label>
                                    <input
                                        type="text"
                                        value={product.name}
                                        onChange={(e) => handleInputChange(product.id, 'name', e.target.value)}
                                        className="w-full px-2 py-1 border border-gray-300 rounded-md"
                                    />
                                </div>
                                <div>
                                     <label className="text-xs text-textSecondary">قیمت (امتیاز)</label>
                                     <input
                                        type="number"
                                        value={product.price}
                                        onChange={(e) => handleInputChange(product.id, 'price', Number(e.target.value))}
                                        className="w-full px-2 py-1 border border-gray-300 rounded-md"
                                    />
                                </div>
                                <div className="mt-4 md:mt-0">
                                    <Button onClick={() => handleSave(product)} fullWidth>ذخیره</Button>
                                </div>
                            </div>
                        </div>
                    </Card>
                ))}
            </div>
        </div>
    );
};

export default AdminStore;
