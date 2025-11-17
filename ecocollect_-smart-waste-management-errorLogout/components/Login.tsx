import React, { useState, useContext } from 'react';
import { Link } from 'react-router-dom';
import { AppContext } from '../App';
import Button from './common/Button';
import Card from './common/Card';
import Icon from './common/Icon';

const Login: React.FC = () => {
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const context = useContext(AppContext);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        setError('');
        if (!context?.login(password)) {
            setError('رمز عبور نامعتبر است. (راهنمایی: 1234)');
        }
    };

    return (
        <div className="flex items-center justify-center min-h-screen bg-background">
            <div className="w-full max-w-sm p-4">
                <div className="text-center mb-8">
                    <Icon name="Trash" className="w-16 h-16 text-primary mx-auto"/>
                    <h1 className="text-3xl font-bold text-primary mt-2">اکوکالکت</h1>
                    <p className="text-textSecondary">به سامانه مدیریت هوشمند پسماند خوش آمدید</p>
                </div>
                <Card>
                    <form onSubmit={handleSubmit} className="space-y-6">
                        <div>
                            <label className="block text-sm font-medium text-textPrimary mb-1">نام کاربری</label>
                            <input
                                type="text"
                                value="demo@ecocollect.app"
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

                        <Button type="submit" fullWidth size="large">
                            ورود به حساب کاربری
                        </Button>
                    </form>
                </Card>
                <div className="text-center mt-6 space-y-3">
                    <Link to="/driver/login" className="text-sm font-medium text-primary hover:text-primary-dark inline-flex items-center">
                        <Icon name="Truck" className="w-5 h-5 ms-2" />
                        ورود به پنل رانندگان
                    </Link>
                    <br />
                    <Link to="/admin/login" className="text-sm font-medium text-gray-600 hover:text-gray-800 inline-flex items-center">
                        <Icon name="Cog" className="w-5 h-5 ms-2" />
                        ورود به پنل مدیریت
                    </Link>
                </div>
                 <p className="text-center text-xs text-gray-400 mt-6">
                    این یک نسخه نمایشی است. نیازی به ثبت نام نیست.
                </p>
            </div>
        </div>
    );
};

export default Login;
