import { lazy } from "react";
import { NavigateFunction, RouteObject } from "react-router-dom";
import {
  HiCollection,
  HiCube,
  HiKey,
  HiOutlineLogout,
  HiShoppingBag,
  HiUser,
  HiLightBulb,
  HiViewGrid,
  HiLightningBolt,
  HiTag,
  HiColorSwatch,
  HiChat,
  HiClipboardCopy,
  HiUserGroup,
  HiLocationMarker,
  HiClipboardList,
  HiTruck,
  HiCog,
  HiBan,
  HiArchive,
  HiReceiptTax,
  HiTrash,
  HiBell,
} from "react-icons/hi";
import { NavItemProps } from "react-minimal-side-navigation/lib";
import { TFunction } from "react-i18next";
/* Gaurds */
import { AuthGuard } from "./";

/* Pages */
const Dashboard = lazy(() => import("./components/pages/Dashboard"));
const Login = lazy(() => import("./components/pages/Login"));
const Users = lazy(() => import("./components/pages/Users"));
const ReSealer = lazy(() => import("./components/pages/ReSealer"));
const Driver = lazy(() => import("./components/pages/Driver"));
const Faqs = lazy(() => import("./components/pages/Faqs"));
const Faqscategories = lazy(() => import("./components/pages/FaqsCategories"));
const Localizations = lazy(() => import("./components/pages/Localizations"));
const Categories = lazy(() => import("./components/pages/Categories"));
const Specifications = lazy(() => import("./components/pages/Specifications"));
const Comment = lazy(() => import("./components/pages/Comment"));
const RecycleCategories = lazy(
  () => import("./components/pages/RecycleCategories")
);
const Products = lazy(() => import("./components/pages/Products"));
const ProductsRecycle = lazy(
  () => import("./components/pages/ProductsRecycle")
);
const Tags = lazy(() => import("./components/pages/Tags"));
const AppointmentConfig = lazy(
  () => import("./components/pages/AppointmentConfig")
);
const Warranties = lazy(() => import("./components/pages/Warranties"));
const Zone = lazy(() => import("./components/pages/Zone"));
const Testimonials = lazy(() => import("./components/pages/Testimonials"));
const Problems = lazy(() => import("./components/pages/Problems"));
const Coupons = lazy(() => import("./components/pages/Coupons"));
const Orders = lazy(() => import("./components/pages/Orders"));
const Logout = lazy(() => import("./components/pages/Logout"));
const ProductSections = lazy(
  () => import("./components/pages/ProductSections")
);
const CollectionRequest = lazy(
  () => import("./components/pages/CollectionRequest")
);
const Lottery = lazy(() => import("./components/pages/Lottery"));
const LotteryManagement = lazy(() => import("./components/pages/LotteryManagement"));
const MenuLinks = lazy(() => import("./components/pages/MenuLinks"));
const CouponUses = lazy(() => import("./components/pages/CouponUses"));
const NotFound = lazy(() => import("./components/pages/NotFound"));
const CreditorsCustomersDrivers = lazy(
  () => import("./components/pages/CreditorsCustomersDrivers")
);
const DriverAppointments = lazy(
  () => import("./components/pages/DriverAppointments")
);
const DriverTracking = lazy(() => import("./components/pages/DriverTracking"));
const Disapprovals = lazy(() => import("./components/pages/Disapprovals"));
const Notifications = lazy(() => import("./components/pages/Notifications"));

export const routes: RouteObject[] = [
  {
    path: "/",
    element: (
      <AuthGuard>
        <Dashboard />
      </AuthGuard>
    ),
    children: [
      { path: "appointment-config", element: <AppointmentConfig /> },
      { path: "users", element: <Users /> },
      { path: "re-sealer", element: <ReSealer /> },
      { path: "drivers", element: <Driver /> },
      { path: "faqs", element: <Faqs /> },
      { path: "faq-categories", element: <Faqscategories /> },
      { path: "localizations", element: <Localizations /> },
      { path: "categories", element: <Categories /> },
      { path: "specifications", element: <Specifications /> },
      { path: "products", element: <Products /> },
      { path: "products-recycle", element: <ProductsRecycle /> },
      { path: "orders", element: <Orders /> },
      { path: "tags", element: <Tags /> },
      { path: "warranties", element: <Warranties /> },
      { path: "zones", element: <Zone /> },
      { path: "testimonials", element: <Testimonials /> },
      { path: "problems", element: <Problems /> },
      { path: "coupons", element: <Coupons /> },
      { path: "product-sections", element: <ProductSections /> },
      { path: "collection-request", element: <CollectionRequest /> },
      { path: "lottery", element: <Lottery /> },
      { path: "lottery-management", element: <LotteryManagement /> },
      { path: "menu-links", element: <MenuLinks /> },
      { path: "coupon-uses", element: <CouponUses /> },
      { path: "recycle-ategories", element: <RecycleCategories /> },
      { path: "comment", element: <Comment /> },
      {
        path: "creditors-customers-drivers",
        element: <CreditorsCustomersDrivers />,
      },
      { path: "driver-appointments", element: <DriverAppointments /> },
      { path: "driver-tracking", element: <DriverTracking /> },
      { path: "disapprovals", element: <Disapprovals /> },
      { path: "notifications", element: <Notifications /> },
      { path: "Logout", element: <Logout /> },
    ],
  },
  { path: "/login", element: <Login /> },
  { path: "*", element: <NotFound /> },
];

export const getSideBarItem = (t: TFunction<"translation", undefined>) => {
  const item: NavItemProps[] = [
    // {
    //   title: t("dashboard"),
    //   itemId: "/",
    //   elemBefore: () => <HiViewGrid className="text-2xl" />,
    // },
    {
      title: t("users"),
      itemId: "/users",
      elemBefore: () => <HiUser className="text-2xl" />,
      subNav: [
        {
          title: t("users"),
          itemId: "/users",
          elemBefore: () => <HiUser className="text-2xl" />,
        },
        {
          title: t("drivers"),
          itemId: "/drivers",
          elemBefore: () => <HiTruck className="text-2xl" />,
        },
        {
          title: t("comment"),
          itemId: "/comment",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
        {
          title: t("معرفی ها"),
          itemId: "/re-sealer",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
      ],
    },
    {
      title: t("orders"),
      itemId: "/orders",
      elemBefore: () => <HiCollection className="text-2xl" />,
      subNav: [
        {
          title: t("orders"),
          itemId: "/orders",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
        // {
        //   title: t("coupons"),
        //   itemId: "/coupons",
        //   elemBefore: () => <HiReceiptTax className="text-2xl" />,
        // },
        // {
        //   title: t("coupon_uses"),
        //   itemId: "/coupon-uses",
        //   elemBefore: () => <HiArchive className="text-2xl" />,
        // },
      ],
    },
    {
      title: t("product_management"),
      itemId: "/products",
      elemBefore: () => <HiShoppingBag className="text-2xl" />,
      subNav: [
        {
          title: t("products"),
          itemId: "/products",
          elemBefore: () => <HiShoppingBag className="text-2xl" />,
        },
        {
          title: t("categories"),
          itemId: "/categories",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
      ],
    },
    {
      title: t("recycle_management"),
      itemId: "/products-recycle",
      elemBefore: () => <HiTrash className="text-2xl" />,
      subNav: [
        {
          title: t("recycles"),
          itemId: "/products-recycle",
          elemBefore: () => <HiTrash className="text-2xl" />,
        },
        {
          title: t("recycle_categories"),
          itemId: "/recycle-ategories",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
      ],
    },
    {
      title: t("faq"),
      itemId: "/faqs",
      elemBefore: () => <HiLightBulb className="text-2xl" />,
      subNav: [
        {
          title: t("faqs"),
          itemId: "/faqs",
          elemBefore: () => <HiLightBulb className="text-2xl" />,
        },
        {
          title: t("faq_categories"),
          itemId: "/faq-categories",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
      ],
    },
    {
      title: t("financial"),
      itemId: "/creditors-customers-drivers",
      elemBefore: () => <HiClipboardList className="text-2xl" />,
      subNav: [
        {
          title: t("creditors_customers_and_drivers"),
          itemId: "/creditors-customers-drivers",
          elemBefore: () => <HiClipboardList className="text-2xl" />,
        },
      ],
    },
    {
      title: t("driver_tracking") || "ردیابی راننده",
      itemId: "/driver-tracking",
      elemBefore: () => <HiLocationMarker className="text-2xl" />,
    },
    {
      title: t("request"),
      itemId: "/collection-request",
      elemBefore: () => <HiClipboardCopy className="text-2xl" />,
      subNav: [
        {
          title: t("collection_request"),
          itemId: "/collection-request",
          elemBefore: () => <HiClipboardCopy className="text-2xl" />,
        },
        {
          title: t("driver_appointments"),
          itemId: "/driver-appointments",
          elemBefore: () => <HiTruck className="text-2xl" />,
        },
        {
          title: t("disapprovals") || "ردها و عدم تحویل‌ها",
          itemId: "/disapprovals",
          elemBefore: () => <HiBan className="text-2xl" />,
        },
      ],
    },
    {
      title: t("lottery"),
      itemId: "/lottery",
      elemBefore: () => <HiLightningBolt className="text-2xl" />,
      subNav: [
        {
          title: t("lottery"),
          itemId: "/lottery",
          elemBefore: () => <HiLightningBolt className="text-2xl" />,
        },
        {
          title: t("lottery_management"),
          itemId: "/lottery-management",
          elemBefore: () => <HiCog className="text-2xl" />,
        },
      ],
    },
    {
      title: t("setting"),
      itemId: "/product-sections",
      elemBefore: () => <HiCog className="text-2xl" />,
      subNav: [
        {
          title: t("banners_and_items"),
          itemId: "/product-sections",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
        {
          title: t("appointment-config"),
          itemId: "/appointment-config",
          elemBefore: () => <HiCollection className="text-2xl" />,
        },
        {
          title: t("zones"),
          itemId: "/zones",
          elemBefore: () => <HiLocationMarker className="text-2xl" />,
        },
        {
          title: t("notifications") || "اعلان‌ها",
          itemId: "/notifications",
          elemBefore: () => <HiBell className="text-2xl" />,
        },
      ],
    },
    {
      title: t("logout"),
      itemId: "logout",
      elemBefore: () => <HiOutlineLogout className="text-2xl" />,
    },
  ];
  return item;
};
export const navigateHandler = (itemId: string, navigate: NavigateFunction) => {
  if (!itemId.includes("_")) navigate(itemId);
};
