import React from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { NAV_LINKS } from '../constants';
import Icon from './common/Icon';

const Layout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const location = useLocation();
    
    const getPageTitle = () => {
        if (location.pathname === '/login') return null;
        const currentLink = NAV_LINKS.find(link => link.path === location.pathname);
        if (currentLink) return currentLink.label;
        if (location.pathname === '/request') return 'درخواست جمع‌آوری';
        if (location.pathname === '/lottery') return 'قرعه‌کشی';
        return 'اکوکالکت';
    };

    const pageTitle = getPageTitle();

    return (
        <div className="min-h-screen bg-background text-textPrimary flex flex-col items-center">
            <div className="w-full max-w-md bg-surface flex flex-col h-screen shadow-lg">
                {pageTitle && (
                    <header className="w-full p-4 bg-primary text-white shadow-md z-10">
                        <h1 className="text-xl font-bold text-center">{pageTitle}</h1>
                    </header>
                )}

                <main className={`flex-grow p-4 overflow-y-auto pb-20`}>
                    {children}
                </main>

                {pageTitle && (
                    <nav className="fixed bottom-0 w-full max-w-md bg-white border-t border-gray-200">
                        <div className="flex justify-around items-center h-16">
                            {NAV_LINKS.map((link) => (
                                <NavLink
                                    key={link.path}
                                    to={link.path}
                                    className={({ isActive }) =>
                                        `flex flex-col items-center justify-center w-full transition-colors duration-200 ${
                                            isActive ? 'text-primary' : 'text-gray-500 hover:text-primary-dark'
                                        }`
                                    }
                                >
                                    <Icon name={link.icon as any} className="w-6 h-6 mb-1" />
                                    <span className="text-xs font-medium">{link.label}</span>
                                </NavLink>
                            ))}
                        </div>
                    </nav>
                )}
            </div>
        </div>
    );
};

export default Layout;