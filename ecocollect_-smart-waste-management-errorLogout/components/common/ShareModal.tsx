import React, { useState } from 'react';
import Modal from './Modal';
import Icon from './Icon';
import Button from './Button';

interface ShareModalProps {
    code: string;
    onClose: () => void;
}

const ShareModal: React.FC<ShareModalProps> = ({ code, onClose }) => {
    const [copied, setCopied] = useState(false);

    const handleCopy = () => {
        navigator.clipboard.writeText(code).then(() => {
            setCopied(true);
            setTimeout(() => setCopied(false), 2000);
        });
    };

    return (
        <Modal title="دعوت از دوستان" onClose={onClose}>
            <p className="text-sm text-textSecondary mb-4">
                کد معرف زیر را با دوستان خود به اشتراک بگذارید تا هر دو از مزایای آن بهره‌مند شوید!
            </p>
            <div className="flex items-center justify-between p-3 bg-gray-100 border-2 border-dashed border-gray-300 rounded-lg">
                <span className="font-mono font-bold text-lg text-primary">{code}</span>
                <Button onClick={handleCopy} size="small">
                    {copied ? 'کپی شد!' : 'کپی'}
                </Button>
            </div>
            <div className="mt-6 text-center">
                <Button onClick={onClose} fullWidth>بستن</Button>
            </div>
        </Modal>
    );
};

export default ShareModal;
