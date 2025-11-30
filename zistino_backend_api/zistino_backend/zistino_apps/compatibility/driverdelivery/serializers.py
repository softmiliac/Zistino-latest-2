"""
Serializers for DriverDelivery endpoints.
These import from deliveries app serializers and add compatibility request/response serializers.
"""
from rest_framework import serializers
from zistino_apps.deliveries.serializers import DeliverySerializer, DeliverySearchRequestSerializer
from zistino_apps.deliveries.models import Delivery

# Reuse DeliverySerializer and DeliverySearchRequestSerializer from deliveries app
# These are already compatible with Flutter app expectations


class DriverDeliveryCreateRequestSerializer(serializers.Serializer):
    """Request serializer for creating driver delivery matching old Swagger format."""
    userId = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='User ID (UUID string)')
    deliveryUserId = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Delivery User ID (UUID string)')
    deliveryDate = serializers.DateTimeField(required=False, allow_null=True, help_text='Delivery date')
    setUserId = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Set User ID (UUID string)')
    addressId = serializers.IntegerField(required=False, allow_null=True, default=0, help_text='Address ID')
    orderId = serializers.CharField(required=False, allow_blank=True, allow_null=True, default='0', help_text='Order ID (UUID string)')
    examId = serializers.CharField(required=False, allow_blank=True, allow_null=True, default='0', help_text='Exam ID')
    requestId = serializers.IntegerField(required=False, allow_null=True, default=0, help_text='Request ID')
    zoneId = serializers.IntegerField(required=False, allow_null=True, default=0, help_text='Zone ID')
    preOrderId = serializers.CharField(required=False, allow_blank=True, allow_null=True, default='0', help_text='Pre Order ID')
    status = serializers.IntegerField(required=False, default=0, help_text='Delivery status (0-30: 0=assigned, 1=in_progress, 2=completed, 3=cancelled, 4-30=in_progress)')
    description = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Description')


class DriverDeliveryUpdateRequestSerializer(serializers.Serializer):
    """Request serializer for updating driver delivery matching old Swagger format."""
    userId = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='User ID (UUID string)')
    deliveryUserId = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Delivery User ID (UUID string)')
    deliveryDate = serializers.DateTimeField(required=False, allow_null=True, help_text='Delivery date')
    setUserId = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Set User ID (UUID string)')
    addressId = serializers.IntegerField(required=False, allow_null=True, help_text='Address ID')
    address = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Delivery address')
    phoneNumber = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Phone number')
    latitude = serializers.DecimalField(required=False, allow_null=True, max_digits=9, decimal_places=6, help_text='Latitude')
    longitude = serializers.DecimalField(required=False, allow_null=True, max_digits=9, decimal_places=6, help_text='Longitude')
    orderId = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Order ID (UUID string or integer hash)')
    examId = serializers.CharField(required=False, allow_blank=True, allow_null=True, default='0', help_text='Exam ID')
    requestId = serializers.IntegerField(required=False, allow_null=True, help_text='Request ID')
    zoneId = serializers.IntegerField(required=False, allow_null=True, help_text='Zone ID')
    preOrderId = serializers.CharField(required=False, allow_blank=True, allow_null=True, default='0', help_text='Pre Order ID')
    status = serializers.IntegerField(required=False, allow_null=True, help_text='Delivery status (0-30: 0=assigned, 1=in_progress, 2=completed, 3=cancelled, 4-30=in_progress)')
    description = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Description')
    deliveredWeight = serializers.DecimalField(required=False, allow_null=True, max_digits=10, decimal_places=2, help_text='Delivered weight in kg')
    reminderSmsSent = serializers.BooleanField(required=False, allow_null=True, help_text='Whether reminder SMS has been sent')
    licensePlateNumber = serializers.CharField(required=False, allow_blank=True, allow_null=True, max_length=20, help_text='License plate number')
    customerConfirmationStatus = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Customer confirmation status (pending, confirmed, denied)')
    denialReason = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Reason if delivery is denied')
    cancelReason = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='Reason if delivery is cancelled')
    confirmedAt = serializers.DateTimeField(required=False, allow_null=True, help_text='Timestamp when customer confirmed the delivery')


class DriverDeliverySearchRequestSerializer(serializers.Serializer):
    """Request serializer for driver delivery search matching old Swagger format."""
    advancedSearch = serializers.DictField(required=False, allow_null=True, help_text='Advanced search options')
    keyword = serializers.CharField(required=False, allow_blank=True, default="")
    pageNumber = serializers.IntegerField(required=False, min_value=0, default=0)
    pageSize = serializers.IntegerField(required=False, min_value=0, default=0)
    orderBy = serializers.ListField(
        child=serializers.CharField(allow_blank=True),
        required=False,
        allow_empty=True
    )
    status = serializers.IntegerField(required=False, allow_null=True, help_text='Delivery status (0=assigned, 1=in_progress, 2=completed, 3=cancelled)')
    userid = serializers.CharField(required=False, allow_blank=True, allow_null=True, help_text='User ID (UUID string)')
    fromDate = serializers.DateTimeField(required=False, allow_null=True, help_text='Start date filter')
    toDate = serializers.DateTimeField(required=False, allow_null=True, help_text='End date filter')


class DriverDeliveryMyRequestsResponseSerializer(serializers.Serializer):
    """Response serializer for myrequests endpoint matching old Swagger format."""
    id = serializers.SerializerMethodField()
    userId = serializers.SerializerMethodField()
    creator = serializers.SerializerMethodField()
    deliveryUserId = serializers.SerializerMethodField()
    deliveryDate = serializers.DateTimeField(source='delivery_date', allow_null=True)
    dirver = serializers.SerializerMethodField()
    setUserId = serializers.SerializerMethodField()
    setUser = serializers.SerializerMethodField()
    addressId = serializers.SerializerMethodField()
    address = serializers.CharField()
    latitude = serializers.DecimalField(max_digits=9, decimal_places=6, allow_null=True)
    longitude = serializers.DecimalField(max_digits=9, decimal_places=6, allow_null=True)
    phoneNumber = serializers.CharField(source='phone_number')
    vatNumber = serializers.SerializerMethodField()
    status = serializers.SerializerMethodField()
    createdOn = serializers.DateTimeField(source='created_at')
    requestId = serializers.SerializerMethodField()
    zoneId = serializers.SerializerMethodField()
    orderId = serializers.SerializerMethodField()
    preOrderId = serializers.SerializerMethodField()
    examId = serializers.SerializerMethodField()
    dirverphone = serializers.SerializerMethodField()
    description = serializers.CharField(allow_blank=True)
    
    def get_id(self, obj):
        """Return delivery ID as integer hash for compatibility."""
        import hashlib
        delivery_id_str = str(obj.id).replace('-', '')
        delivery_id_int = int(hashlib.md5(delivery_id_str.encode()).hexdigest()[:8], 16) % 100000000
        return delivery_id_int
    
    def get_userId(self, obj):
        """Return order user ID as string."""
        if obj.order and obj.order.user:
            return str(obj.order.user.id)
        return None
    
    def get_creator(self, obj):
        """Return creator name (order user full name)."""
        if obj.order and obj.order.user:
            user = obj.order.user
            full_name = f"{user.first_name or ''} {user.last_name or ''}".strip()
            return full_name or user.phone_number or ""
        return ""
    
    def get_deliveryUserId(self, obj):
        """Return driver ID as string."""
        if obj.driver:
            return str(obj.driver.id)
        return None
    
    def get_dirver(self, obj):
        """Return driver full name."""
        if obj.driver:
            full_name = f"{obj.driver.first_name or ''} {obj.driver.last_name or ''}".strip()
            return full_name or obj.driver.phone_number or ""
        return ""
    
    def get_setUserId(self, obj):
        """Return set user ID (if exists)."""
        # This field might not be used, return None for now
        return None
    
    def get_setUser(self, obj):
        """Return set user name (if exists)."""
        # This field might not be used, return empty string for now
        return ""
    
    def get_addressId(self, obj):
        """Return address ID (if exists in order)."""
        # Try to get address ID from order if it has one
        # For now, return 0 as default
        return 0
    
    def get_vatNumber(self, obj):
        """Return VAT number (if exists in order/user)."""
        # This field might not be used, return empty string for now
        return ""
    
    def get_status(self, obj):
        """Return status as integer (0=assigned, 1=in_progress, 2=completed, 3=cancelled)."""
        status_map = {'assigned': 0, 'in_progress': 1, 'completed': 2, 'cancelled': 3}
        return status_map.get(obj.status, 0)
    
    def get_requestId(self, obj):
        """Return request ID (if exists)."""
        # This field might not be used, return 0 for now
        return 0
    
    def get_zoneId(self, obj):
        """Return zone ID based on delivery location."""
        if obj.latitude and obj.longitude:
            try:
                from zistino_apps.deliveries.utils import find_zone_for_location
                zone = find_zone_for_location(float(obj.latitude), float(obj.longitude))
                if zone:
                    return zone.id
            except Exception:
                pass
        return 0
    
    def get_orderId(self, obj):
        """Return order ID as string (integer hash for compatibility, matching OrderCompatibilitySerializer)."""
        if obj.order:
            import hashlib
            # Use same hash calculation as OrderCompatibilitySerializer.get_id()
            uuid_str = str(obj.order.id)
            hash_obj = hashlib.md5(uuid_str.encode('utf-8'))
            hash_int = int(hash_obj.hexdigest(), 16)
            order_id_hash = hash_int % 2147483647  # Max 32-bit integer (matching OrderCompatibilitySerializer)
            return str(order_id_hash)  # Return as string to match request format
        return "0"
    
    def get_preOrderId(self, obj):
        """Return preOrderId as string (same as orderId for now)."""
        # preOrderId should be the same as orderId in most cases
        # Use same calculation as get_orderId to ensure consistency
        return self.get_orderId(obj)
    
    def get_examId(self, obj):
        """Return examId as string (default '0' for compatibility)."""
        # examId is not used in the current system, return '0' as default
        return "0"
    
    def get_dirverphone(self, obj):
        """Return driver phone number."""
        if obj.driver:
            return obj.driver.phone_number or ""
        return ""

