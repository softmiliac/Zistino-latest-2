import React, { ReactNode } from 'react';
import Card from './Card';
import Icon from './Icon';

interface ModalProps {
    title: string;
    children: ReactNode;
    onClose: () => void;
}

const Modal: React.FC<ModalProps> = ({ title, children, onClose }) => {
    return (
        <div className="fixed inset-0 bg-black bg-opacity-60 flex items-center justify-center z-50 p-4" onClick={onClose}>
            <Card className="max-w-md w-full" onClick={(e) => e.stopPropagation()}>
                <div className="flex justify-between items-center mb-4">
                    <h2 className="text-xl font-bold text-textPrimary">{title}</h2>
                    <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
                        <Icon name="Close" className="w-6 h-6" />
                    </button>
                </div>
                <div>{children}</div>
            </Card>
        </div>
    );
};

export default Modal;
