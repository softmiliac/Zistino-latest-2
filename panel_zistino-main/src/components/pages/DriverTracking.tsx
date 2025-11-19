import { FC, useState } from "react";
import { useTranslation } from "react-i18next";
import { HiTruck, HiLocationMarker, HiClock, HiMap } from "react-icons/hi";
import moment from "jalali-moment";
import { Tag, Card, Divider } from "antd";
import DatePicker from "react-multi-date-picker";
import persian from "react-date-object/calendars/persian";
import persian_fa from "react-date-object/locales/persian_fa";

import {
    Select,
    Button,
    useDriverRoutes,
    useDriverAvailableDates,
    useDriversAll,
    errorAlert,
} from "../..";

const DriverTracking: FC = () => {
    const [selectedDriverId, setSelectedDriverId] = useState<string>("");
    const [selectedDate, setSelectedDate] = useState<string>("");
    const { t } = useTranslation();

    const { data: driversData } = useDriversAll();
    // Handle nested response structure
    const drivers = driversData?.data || driversData || [];
    const { data: routesData, isLoading: loadingRoutes } = useDriverRoutes(
        selectedDriverId,
        selectedDate
    );
    const { data: availableDates } = useDriverAvailableDates(selectedDriverId);

    const handleDateChange = (date: any) => {
        if (date) {
            // Convert Jalali date to Gregorian YYYY-MM-DD
            const gregorianDate = moment(date.toDate()).format("YYYY-MM-DD");
            setSelectedDate(gregorianDate);
        } else {
            setSelectedDate("");
        }
    };

    const formatDuration = (seconds: number) => {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        if (hours > 0) {
            return `${hours} ساعت ${minutes} دقیقه`;
        }
        return `${minutes} دقیقه`;
    };

    const formatTime = (isoString: string) => {
        return moment(isoString).format("HH:mm");
    };

    const formatDate = (isoString: string) => {
        return moment(isoString).calendar("jalali").locale("fa").format("YYYY/MM/DD");
    };

    return (
        <div className="p-6 space-y-6">
            <div className="flex items-center gap-2 mb-6">
                <HiMap className="text-3xl text-blue-600" />
                <h1 className="text-2xl font-bold">
                    {t("driver_tracking") || "سامانه ناوبری و ردیابی راننده‌ها"}
                </h1>
            </div>

            {/* Filters */}
            <Card>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label className="block mb-2 font-semibold">
                            {t("select_driver") || "انتخاب راننده"}
                        </label>
                        <Select
                            value={selectedDriverId}
                            onChange={(e) => {
                                setSelectedDriverId(e.target.value);
                                setSelectedDate(""); // Reset date when driver changes
                            }}
                        >
                            <option value="">{t("select_driver") || "انتخاب راننده"}</option>
                            {drivers?.map((driver: any) => (
                                <option key={driver.id} value={driver.id}>
                                    {driver.firstName} {driver.lastName} - {driver.phoneNumber}
                                </option>
                            ))}
                        </Select>
                    </div>

                    <div>
                        <label className="block mb-2 font-semibold">
                            {t("select_date") || "انتخاب تاریخ"}
                        </label>
                        <DatePicker
                            value={selectedDate ? moment(selectedDate).toDate() : null}
                            onChange={handleDateChange}
                            calendar={persian}
                            locale={persian_fa}
                            format="YYYY/MM/DD"
                            className="w-full"
                            placeholder={t("select_date") || "انتخاب تاریخ"}
                        />
                        {availableDates?.availableDates && availableDates.availableDates.length > 0 && (
                            <div className="mt-2 text-sm text-gray-600">
                                <span className="font-semibold">
                                    {t("available_dates") || "تاریخ‌های موجود:"}
                                </span>{" "}
                                {availableDates.availableDates
                                    .slice(0, 5)
                                    .map((d: any) => d.date)
                                    .join(", ")}
                                {availableDates.availableDates.length > 5 && "..."}
                            </div>
                        )}
                    </div>
                </div>

            </Card>

            {/* Routes Data */}
            {routesData && selectedDriverId && selectedDate && (
                <div className="space-y-4">
                    {/* Summary */}
                    <Card>
                        <h2 className="text-xl font-bold mb-4">
                            {t("summary") || "خلاصه"}
                        </h2>
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <div className="text-center p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
                                <div className="text-2xl font-bold text-blue-600">
                                    {routesData.summary?.totalTrips || 0}
                                </div>
                                <div className="text-sm text-gray-600">
                                    {t("total_trips") || "کل سفرها"}
                                </div>
                            </div>
                            <div className="text-center p-4 bg-green-50 dark:bg-green-900/20 rounded-lg">
                                <div className="text-2xl font-bold text-green-600">
                                    {routesData.summary?.totalDistance?.toFixed(2) || "0.00"} km
                                </div>
                                <div className="text-sm text-gray-600">
                                    {t("total_distance") || "کل مسافت"}
                                </div>
                            </div>
                            <div className="text-center p-4 bg-yellow-50 dark:bg-yellow-900/20 rounded-lg">
                                <div className="text-2xl font-bold text-yellow-600">
                                    {routesData.summary?.totalPickups || 0}
                                </div>
                                <div className="text-sm text-gray-600">
                                    {t("total_pickups") || "کل تحویل‌ها"}
                                </div>
                            </div>
                            <div className="text-center p-4 bg-purple-50 dark:bg-purple-900/20 rounded-lg">
                                <div className="text-2xl font-bold text-purple-600">
                                    {formatDuration(routesData.summary?.averageTimePerPickup || 0)}
                                </div>
                                <div className="text-sm text-gray-600">
                                    {t("avg_time_per_pickup") || "میانگین زمان هر تحویل"}
                                </div>
                            </div>
                        </div>
                    </Card>

                    {/* Trips */}
                    {routesData.trips && routesData.trips.length > 0 ? (
                        <div className="space-y-4">
                            {routesData.trips.map((trip: any, tripIndex: number) => (
                                <Card key={trip.tripId || tripIndex} className="mb-4">
                                    <div className="flex items-center gap-2 mb-4">
                                        <HiTruck className="text-xl text-blue-600" />
                                        <h3 className="text-lg font-bold">
                                            {t("trip")} #{trip.tripId}
                                        </h3>
                                    </div>

                                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                                        <div>
                                            <span className="text-sm text-gray-600">
                                                {t("start_time") || "زمان شروع:"}
                                            </span>
                                            <div className="font-semibold">{formatTime(trip.startTime)}</div>
                                        </div>
                                        <div>
                                            <span className="text-sm text-gray-600">
                                                {t("end_time") || "زمان پایان:"}
                                            </span>
                                            <div className="font-semibold">
                                                {trip.endTime ? formatTime(trip.endTime) : "-"}
                                            </div>
                                        </div>
                                        <div>
                                            <span className="text-sm text-gray-600">
                                                {t("distance") || "مسافت:"}
                                            </span>
                                            <div className="font-semibold">
                                                {trip.distance?.toFixed(2) || "0.00"} km
                                            </div>
                                        </div>
                                        <div>
                                            <span className="text-sm text-gray-600">
                                                {t("duration") || "مدت زمان:"}
                                            </span>
                                            <div className="font-semibold">
                                                {formatDuration(trip.duration || 0)}
                                            </div>
                                        </div>
                                    </div>

                                    {/* Pickup Locations */}
                                    {trip.pickupLocations && trip.pickupLocations.length > 0 && (
                                        <div className="mt-4">
                                            <h4 className="font-semibold mb-2 flex items-center gap-2">
                                                <HiLocationMarker className="text-lg text-green-600" />
                                                {t("pickup_locations") || "محل‌های تحویل"} ({trip.pickupLocations.length})
                                            </h4>
                                            <div className="space-y-3">
                                                {trip.pickupLocations.map((pickup: any, pickupIndex: number) => (
                                                    <Card
                                                        key={pickup.deliveryId || pickupIndex}
                                                        size="small"
                                                        className="bg-green-50 dark:bg-green-900/10"
                                                    >
                                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                                                            <div>
                                                                <span className="text-sm text-gray-600">
                                                                    {t("customer_address") || "آدرس مشتری:"}
                                                                </span>
                                                                <div className="font-semibold">{pickup.customerAddress || "-"}</div>
                                                            </div>
                                                            <div>
                                                                <span className="text-sm text-gray-600">
                                                                    {t("customer_phone") || "تلفن مشتری:"}
                                                                </span>
                                                                <div className="font-semibold">{pickup.customerPhone || "-"}</div>
                                                            </div>
                                                            <div>
                                                                <span className="text-sm text-gray-600">
                                                                    {t("arrival_time") || "زمان رسیدن:"}
                                                                </span>
                                                                <div className="font-semibold">
                                                                    {pickup.arrivalTime ? formatTime(pickup.arrivalTime) : "-"}
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <span className="text-sm text-gray-600">
                                                                    {t("departure_time") || "زمان ترک:"}
                                                                </span>
                                                                <div className="font-semibold">
                                                                    {pickup.departureTime
                                                                        ? formatTime(pickup.departureTime)
                                                                        : "-"}
                                                                </div>
                                                            </div>
                                                            <div className="flex items-center gap-2">
                                                                <HiClock className="text-lg text-yellow-600" />
                                                                <span className="text-sm text-gray-600">
                                                                    {t("time_spent") || "زمان صرف شده:"}
                                                                </span>
                                                                <Tag color="orange">
                                                                    {pickup.timeSpentFormatted || formatDuration(pickup.timeSpentSeconds || 0)}
                                                                </Tag>
                                                            </div>
                                                            <div>
                                                                <span className="text-sm text-gray-600">
                                                                    {t("delivered_weight") || "وزن تحویل شده:"}
                                                                </span>
                                                                <div className="font-semibold">
                                                                    {pickup.deliveredWeight || "0.00"} kg
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </Card>
                                                ))}
                                            </div>
                                        </div>
                                    )}

                                    {/* Route Points Count */}
                                    {trip.routePoints && trip.routePoints.length > 0 && (
                                        <div className="mt-4">
                                            <span className="text-sm text-gray-600">
                                                {t("route_points") || "نقاط مسیر:"}
                                            </span>
                                            <Tag>{trip.routePoints.length} {t("points") || "نقطه"}</Tag>
                                        </div>
                                    )}
                                </Card>
                            ))}
                        </div>
                    ) : (
                        <Card>
                            <div className="text-center py-8 text-gray-500">
                                {t("no_routes_found") || "هیچ مسیری برای این تاریخ یافت نشد"}
                            </div>
                        </Card>
                    )}
                </div>
            )}

            {!selectedDriverId && (
                <Card>
                    <div className="text-center py-8 text-gray-500">
                        {t("please_select_driver_and_date") || "لطفا راننده و تاریخ را انتخاب کنید"}
                    </div>
                </Card>
            )}
        </div>
    );
};

export default DriverTracking;

