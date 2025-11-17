import React, { useState } from 'react';
import Modal from './Modal';
import Icon from './Icon';

interface MapModalProps {
    onClose: () => void;
    onSelectLocation: (coords: { lat: number, lng: number }) => void;
}

const MapModal: React.FC<MapModalProps> = ({ onClose, onSelectLocation }) => {
    const [markerPosition, setMarkerPosition] = useState<{ x: number; y: number } | null>(null);

    const handleMapClick = (e: React.MouseEvent<HTMLDivElement>) => {
        const rect = e.currentTarget.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        setMarkerPosition({ x, y });
        
        // Mock conversion of pixel coords to lat/lng
        const mockLat = 35.7 + (y / rect.height) * 0.1;
        const mockLng = 51.3 + (x / rect.width) * 0.2;
        onSelectLocation({ lat: parseFloat(mockLat.toFixed(4)), lng: parseFloat(mockLng.toFixed(4)) });
    };

    return (
        <Modal title="انتخاب موقعیت مکانی" onClose={onClose}>
            <p className="text-sm text-textSecondary mb-4">روی نقشه کلیک کنید تا موقعیت دقیق خود را برای راننده مشخص نمایید.</p>
            <div 
                className="w-full h-80 bg-gray-200 rounded-lg overflow-hidden relative cursor-pointer"
                onClick={handleMapClick}
            >
                <img src="https://i.imgur.com/c4g0n4u.png" alt="Map of Tehran" className="w-full h-full object-cover" />
                {markerPosition && (
                    <div
                        className="absolute"
                        style={{ left: `${markerPosition.x}px`, top: `${markerPosition.y}px`, transform: 'translate(-50%, -100%)' }}
                    >
                       <Icon name="Location" className="w-10 h-10 text-red-500" />
                    </div>
                )}
            </div>
             <p className="text-center text-xs text-gray-400 mt-2">
                این یک نقشه شبیه‌سازی شده برای نسخه نمایشی است.
            </p>
        </Modal>
    );
};

export default MapModal;
