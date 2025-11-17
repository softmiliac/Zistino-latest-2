import React, { useContext, useState } from 'react';
import Card from './common/Card';
import Button from './common/Button';
import { AppContext } from '../App';
import Icon from './common/Icon';
import { Product } from '../types';

const Store: React.FC = () => {
  const context = useContext(AppContext);
  const [modalState, setModalState] = useState<{show: boolean, success: boolean, product: Product | null, quantity: number}>({show: false, success: false, product: null, quantity: 1});
  const [quantities, setQuantities] = useState<Record<number, number>>({});

  const products = context?.products || [];

  const getInitialQuantities = () => products.reduce((acc, p) => ({...acc, [p.id]: 1 }),{});

  // Initialize quantities when products are loaded
  useState(() => {
    setQuantities(getInitialQuantities());
  });


  const handleQuantityChange = (productId: number, delta: number) => {
    setQuantities(prev => ({
        ...prev,
        [productId]: Math.max(1, (prev[productId] || 1) + delta)
    }));
  };

  const handlePurchase = (product: Product) => {
    if (context) {
        const quantity = quantities[product.id] || 1;
        const totalCost = product.price * quantity;
        const success = context.purchaseItem(totalCost);
        setModalState({ show: true, success, product, quantity });
    }
  };
  
  const closeModal = () => {
    setModalState({ show: false, success: false, product: null, quantity: 1 });
  };

  return (
    <div className="space-y-4">
        <Card>
            <div className="flex justify-between items-center bg-primary-light p-3 rounded-lg">
                <div className="text-primary-dark">
                    <p className="font-medium">موجودی شما</p>
                    <p className="text-2xl font-bold">{context?.currentUser?.walletBalance.toLocaleString('fa-IR')} امتیاز</p>
                </div>
                <Icon name="Wallet" className="w-8 h-8 text-primary-dark"/>
            </div>
        </Card>
      <div className="grid grid-cols-2 gap-4">
        {products.map((product) => {
            const quantity = quantities[product.id] || 1;
            const totalCost = product.price * quantity;
            const canAfford = context?.currentUser?.walletBalance !== undefined && context.currentUser.walletBalance >= totalCost;
          return (
          <Card key={product.id} className="p-0 overflow-hidden flex flex-col">
            <img src={product.imageUrl} alt={product.name} className="w-full h-32 object-cover" />
            <div className="p-3 flex flex-col flex-grow">
              <h3 className="font-semibold text-sm text-textPrimary flex-grow mb-2">{product.name}</h3>
              <p className="text-primary font-bold">{product.price.toLocaleString('fa-IR')} امتیاز</p>

              <div className="flex items-center justify-center space-x-2 rtl:space-x-reverse my-3">
                <Button size="small" className="px-2 py-1" onClick={() => handleQuantityChange(product.id, -1)}>-</Button>
                <span className="font-bold text-lg w-8 text-center">{quantity}</span>
                <Button size="small" className="px-2 py-1" onClick={() => handleQuantityChange(product.id, 1)}>+</Button>
              </div>

              <Button onClick={() => handlePurchase(product)} size="small" disabled={!canAfford}>
                دریافت ({totalCost.toLocaleString('fa-IR')} ام.)
              </Button>
            </div>
          </Card>
        )})}
      </div>
      
      {modalState.show && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
            <Card className="max-w-sm w-full">
                <div className="text-center">
                    <div className={`mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full mb-4 ${modalState.success ? 'bg-green-100' : 'bg-red-100'}`}>
                        {modalState.success ? <Icon name="Check" className="h-6 w-6 text-green-600" /> : <Icon name="Close" className="h-6 w-6 text-red-600" />}
                    </div>
                    <h3 className="text-lg leading-6 font-medium text-gray-900">{modalState.success ? 'خرید موفق!' : 'عملیات ناموفق'}</h3>
                    <div className="mt-2 px-7 py-3">
                        <p className="text-sm text-gray-500">
                            {modalState.success 
                                ? `شما با موفقیت ${modalState.quantity.toLocaleString('fa-IR')} عدد ${modalState.product?.name} دریافت کردید.`
                                : 'متاسفانه امتیاز شما برای دریافت این محصول کافی نیست.'
                            }
                        </p>
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

export default Store;
