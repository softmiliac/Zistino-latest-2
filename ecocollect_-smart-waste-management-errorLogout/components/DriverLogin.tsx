import React, { useState, useContext } from 'react';
import { AppContext } from '../App';
import Button from './common/Button';
import Card from './common/Card';
import Icon from './common/Icon';

const DriverLogin: React.FC = () => {
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const context = useContext(AppContext);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        setError('');
        if (!context?.driverLogin(password)) {
            setError('رمز عبور نامعتبر است. (راهنمایی: drive)');
        }
    };

    return (
        <div className="flex items-center justify-center min-h-screen bg-gray-100">
            <div className="w-full max-w-sm p-4">
                <div className="text-center mb-8">
                    <Icon name="Truck" className="w-16 h-16 text-gray-700 mx-auto"/>
                    <h1 className="text-3xl font-bold text-gray-800 mt-2">پنل رانندگان اکوکالکت</h1>
                    <p className="text-textSecondary">برای مشاهده درخواست‌های جمع‌آوری وارد شوید</p>
                </div>
                <Card>
                    <form onSubmit={handleSubmit} className="space-y-6">
                        <div>
                            <label className="block text-sm font-medium text-textPrimary mb-1">نام کاربری</label>
                            <input
                                type="text"
                                value="driver@ecocollect.app"
                                disabled
                                className="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-100 cursor-not-allowed"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-textPrimary mb-1">رمز عبور</label>
                             <div className="relative">
                                <input
                                    type={showPassword ? 'text' : 'password'}
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                    placeholder="••••••••"
                                    className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-primary focus:border-primary"
                                    required
                                />
                                <button
                                    type="button"
                                    onClick={() => setShowPassword(!showPassword)}
                                    className="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400"
                                >
                                    <Icon name={showPassword ? 'EyeOff' : 'Eye'} className="h-5 w-5" />
                                </button>
                            </div>
                            {error && <p className="text-red-500 text-xs mt-2">{error}</p>}
                        </div>

                        <Button type="submit" fullWidth size="large" className="bg-gray-800 hover:bg-gray-900 focus:ring-gray-700">
                            ورود به پنل
                        </Button>
                    </form>
                </Card>
                 <p className="text-center text-xs text-gray-400 mt-6">
                    این پنل مخصوص رانندگان است.
                </p>
            </div>
        </div>
    );
};

export default DriverLogin;
