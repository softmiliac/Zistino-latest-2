import React, { useContext } from 'react';
import { NavLink } from 'react-router-dom';
import Icon from './common/Icon';
import { DRIVER_NAV_LINKS } from '../constants';
import { AppContext } from '../App';

const DriverLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const context = useContext(AppContext);

    return (
        <div className="min-h-screen bg-gray-100 text-textPrimary flex flex-col items-center">
            <div className="w-full max-w-md bg-white flex flex-col h-screen shadow-lg">
                <header className="w-full p-4 bg-gray-800 text-white shadow-md z-10 flex justify-between items-center">
                    <div className="flex items-center">
                        <Icon name="Truck" className="w-6 h-6 me-3" />
                        <h1 className="text-xl font-bold">پنل راننده</h1>
                    </div>
                    <button onClick={() => context?.driverLogout()} title="خروج از حساب" className="text-sm flex items-center text-gray-300 hover:text-white">
                        <Icon name="Logout" className="w-6 h-6" />
                    </button>
                </header>
                <main className={`flex-grow p-4 overflow-y-auto bg-background pb-20`}>
                    {children}
                </main>
                <nav className="fixed bottom-0 w-full max-w-md bg-gray-800 border-t border-gray-700">
                    <div className="flex justify-around items-center h-16">
                        {DRIVER_NAV_LINKS.map((link) => (
                            <NavLink
                                key={link.path}
                                to={link.path}
                                end={link.path === '/driver'}
                                className={({ isActive }) =>
                                    `flex flex-col items-center justify-center w-full transition-colors duration-200 ${
                                        isActive ? 'text-white' : 'text-gray-400 hover:text-white'
                                    }`
                                }
                            >
                                <Icon name={link.icon as any} className="w-6 h-6 mb-1" />
                                <span className="text-xs font-medium">{link.label}</span>
                            </NavLink>
                        ))}
                    </div>
                </nav>
            </div>
        </div>
    );
};

export default DriverLayout;
