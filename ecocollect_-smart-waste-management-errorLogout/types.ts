export interface User {
  id: string;
  name: string;
  walletBalance: number;
  recentActivity: Activity[];
  address: string;
  city: string;
  referralCode: string;
  lotteryTickets: number;
  status: 'active' | 'suspended';
}

export interface Driver {
    id: string;
    name: string;
    vehicle: string;
    completedPickups: number;
    status: 'active' | 'suspended';
    isVerified: boolean;
    commissionRate: number;
}

export interface AppSettings {
    pointsPerKg: number;
}

export interface Product {
  id: number;
  name: string;
  price: number;
  imageUrl: string;
}

export interface WasteCategory {
  id: string;
  name: string;
  description: string;
  icon: 'Trash' | 'Paper' | 'Plastic' | 'Glass';
  pointsPerKg: number;
}

export interface Activity {
    type: string;
    weight: number;
}

export type RequestStatus = 'pending' | 'accepted' | 'completed' | 'declined';

export interface PickupRequest {
  id: string;
  userId: string;
  userName:string;
  address: string;
  city: string;
  categories: string[];
  estimatedWeight: number;
  timeSlot: string;
  status: RequestStatus;
  actualWeight?: number;
  declineReason?: string;
  customerComplaint?: string;
  latitude?: number;
  longitude?: number;
}