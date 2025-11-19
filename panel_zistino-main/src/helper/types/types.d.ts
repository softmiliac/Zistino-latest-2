interface IRole {
  id?: string;
  name: string;
  description: string;
  tenant?: string;
}

interface IUser {
  id?: string;
  userName: string;
  firstName: string;
  lastName: string;
  email: string;
  isActive?: boolean;
  emailConfirmed?: boolean;
  password?: string;
  confirmPassword?: string;
  phoneNumber: string;
  imageUrl?: string;
  companyName?: string;
  vatNumber?: string;
  zoneId?: string | number;
}

interface IDriver {
  userId: string;
  zoneId: number | string;
}

interface IFaq {
  id?: string;
  categoryId?: number;
  title: string;
  description: string;
  locale: string;
}

interface IWallet {
  userId?: string;
  senderId?: string;
  type: number;
  price: string;
  finished: boolean;
}
interface IDriverDelivery {
  phoneNumber?: string;
  address?: string;
  plate?: string;
  title?: string;
  deliveryUserId?: string;
  setUserId?: string;
  zoneId?: number;
  status?: number;
}

interface ILocale {
  resourceSet: string;
  locale: string;
  key: string;
  text: string;
}

interface ISpecifications {
  id?: string;
  // category: string;
  content: string;
}

interface IBrand {
  id?: string;
  name: string;
  description?: string;
  imageUrl: string;
  locale: string;
}

interface ITag {
  id?: string;
  text: string;
  description?: string;
  locale: string;
}

interface IProduct {
  id?: string;
  name: string;
  description: string;
  viewsCount?: number;
  likesCount?: number;
  commentsCount?: number;
  rate: number;
  category: string;
  // size: string;
  isMaster: boolean;
  colorsList: string;
  masterColor: string;
  pricesList: string;
  masterPrice: number;
  imagesList: string;
  masterImage: string;
  warranty: string;
  specifications: string;
  tags: string;
  brandId: string;
  tenant?: string;
  locale: string;
}

interface IWarranty {
  id?: string;
  name: string;
  description: string;
  imageUrl: string;
  locale: string;
}

interface IColor {
  id?: string;
  name: string;
  code: string;
  locale: string;
}

interface IZone {
  id?: string;
  zone: string;
  zonepath?: string;
  description: string;
  address?: string;
}

interface ITestimonial {
  id?: string;
  name: string;
  text: string;
  imageUrl: string;
  rate: number;
  locale: string;
}

interface ICategory {
  id?: string;
  parentId?: number;
  name: string;
  description: string;
  type?: number;
  imagePath: string;
  locale: string;
}

interface IProblem {
  id?: string;
  title: string;
  description: string;
  iconUrl: string;
  parentId?: number;
  parent?: any;
  repairDuration?: number;
  price: number;
  productId: string;
  product?: IProduct;
  priority: number;
  locale: string;
}

interface ICoupon {
  id?: string;
  key: string;
  startDateTime: string;
  endDateTime: string;
  maxUseCount: number;
  percent: number;
  price: number;
  userId: string;
  roleId: string;
  type: number;
  limitationType: number;
  userLimitationType: number;
}

interface IConfiguration {
  name: string;
  type: number;
  value: string;
}
