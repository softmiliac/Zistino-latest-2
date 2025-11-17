import React, { useContext } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { ADMIN_NAV_LINKS } from '../constants';
import Icon from './common/Icon';
import { AppContext } from '../App';

const AdminLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const location = useLocation();
    const context = useContext(AppContext);
    
    const getPageTitle = () => {
        const currentLink = ADMIN_NAV_LINKS.find(link => link.path === location.pathname);
        return currentLink ? currentLink.label : 'پنل مدیریت';
    };

    return (
        <div className="min-h-screen bg-gray-100 text-textPrimary flex flex-col md:flex-row">
            {/* Sidebar for Desktop */}
            <aside className="hidden md:flex flex-col w-64 bg-gray-800 text-white">
                <div className="flex items-center justify-center h-20 border-b border-gray-700">
                    <Icon name="Cog" className="w-8 h-8 mr-2"/>
                    <h1 className="text-2xl font-bold">پنل مدیریت</h1>
                </div>
                <nav className="flex-grow px-4 py-6">
                    {ADMIN_NAV_LINKS.map(link => (
                        <NavLink 
                            key={link.path}
                            to={link.path} 
                            end={link.path === '/admin'}
                            className={({ isActive }) => `flex items-center px-4 py-3 my-2 rounded-lg transition-colors ${isActive ? 'bg-primary text-white' : 'text-gray-300 hover:bg-gray-700'}`}
                        >
                            <Icon name={link.icon as any} className="w-5 h-5 mr-3"/>
                            <span>{link.label}</span>
                        </NavLink>
                    ))}
                </nav>
                 <div className="p-4 border-t border-gray-700">
                    <button onClick={() => context?.adminLogout()} className="w-full flex items-center justify-center px-4 py-2 rounded-lg text-gray-300 hover:bg-red-600 hover:text-white">
                        <Icon name="Logout" className="w-5 h-5 mr-2" />
                        <span>خروج</span>
                    </button>
                </div>
            </aside>
            
            <div className="flex-1 flex flex-col">
                 {/* Header for Mobile */}
                <header className="md:hidden w-full p-4 bg-gray-800 text-white shadow-md z-10 flex justify-between items-center">
                    <h1 className="text-xl font-bold">{getPageTitle()}</h1>
                     <button onClick={() => context?.adminLogout()} className="text-gray-300 hover:text-white">
                        <Icon name="Logout" className="w-6 h-6" />
                    </button>
                </header>
                <main className="flex-grow p-6 overflow-y-auto">
                    {children}
                </main>
                
                 {/* Bottom Nav for Mobile */}
                <nav className="md:hidden fixed bottom-0 w-full bg-gray-800 border-t border-gray-700 flex justify-around">
                     {ADMIN_NAV_LINKS.map(link => (
                        <NavLink
                            key={link.path}
                            to={link.path}
                            end={link.path === '/admin'}
                            className={({ isActive }) => `flex flex-col items-center justify-center py-2 px-4 w-full transition-colors ${isActive ? 'text-primary' : 'text-gray-400'}`}
                        >
                            <Icon name={link.icon as any} className="w-6 h-6 mb-1" />
                            <span className="text-xs">{link.label}</span>
                        </NavLink>
                    ))}
                </nav>
            </div>

        </div>
    );
};

export default AdminLayout;
