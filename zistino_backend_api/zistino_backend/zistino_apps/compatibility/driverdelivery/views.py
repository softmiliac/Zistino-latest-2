"""
Views for DriverDelivery compatibility layer.
Provides all 5 endpoints matching Flutter app expectations.
"""
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.views import APIView
from drf_spectacular.utils import extend_schema, OpenApiExample, OpenApiResponse
from django.db.models import Q
from django.contrib.auth import get_user_model
from datetime import datetime

from zistino_apps.deliveries.models import Delivery
from zistino_apps.orders.models import Order
from zistino_apps.users.models import Address
from zistino_apps.deliveries.serializers import DeliverySerializer, DeliverySearchRequestSerializer
from zistino_apps.users.permissions import IsManager
from zistino_apps.compatibility.utils import create_success_response, create_error_response
from .serializers import (
    DriverDeliveryCreateRequestSerializer,
    DriverDeliveryUpdateRequestSerializer,
    DriverDeliverySearchRequestSerializer,
    DriverDeliveryMyRequestsResponseSerializer,
)

User = get_user_model()


def _status_number_column_exists():
    """Check if status_number column exists in deliveries table. Cache the result."""
    # Use a simple cache to avoid checking on every request
    if not hasattr(_status_number_column_exists, '_cached_result'):
        try:
            from django.db import connection
            with connection.cursor() as cursor:
                # Check current database schema
                table_name = Delivery._meta.db_table
                cursor.execute("""
                    SELECT column_name 
                    FROM information_schema.columns 
                    WHERE table_name=%s AND column_name='status_number'
                """, [table_name])
                _status_number_column_exists._cached_result = cursor.fetchone() is not None
        except Exception as e:
            # If check fails, assume column doesn't exist
            # Also clear cache on error to retry next time
            _status_number_column_exists._cached_result = False
    return _status_number_column_exists._cached_result


# List of all Delivery model fields (excluding status_number)
# These are the fields that exist in the database before migration
# Note: We include foreign key fields (driver_id, order_id) for select_related to work
# But we don't need to include them in only() if we use select_related
_DELIVERY_FIELDS_WITHOUT_STATUS_NUMBER = [
    'id',
    'driver_id',  # ForeignKey field name in DB (needed for select_related)
    'order_id',   # ForeignKey field name in DB (needed for select_related)
    'status',
    'latitude',
    'longitude',
    'address',
    'phone_number',
    'delivery_date',
    'delivered_weight',
    'reminder_sms_sent',
    'description',
    'license_plate_number',
    'customer_confirmation_status',
    'denial_reason',
    'cancel_reason',
    'confirmed_at',
    'created_at',
    'updated_at',
]


def _apply_status_number_safe_query(qs):
    """
    Apply only() to queryset if status_number column doesn't exist.
    This prevents Django from trying to SELECT a non-existent column.
    """
    column_exists = _status_number_column_exists()
    if not column_exists:
        # Column doesn't exist - use only() to explicitly select fields (excluding status_number)
        return qs.only(*_DELIVERY_FIELDS_WITHOUT_STATUS_NUMBER)
    return qs


def _get_delivery_queryset(user, use_defer=False):
    """
    Get delivery queryset with proper handling of status_number column.
    Uses only() to explicitly select fields, excluding status_number if column doesn't exist.
    """
    if user.is_driver:
        base_qs = Delivery.objects.filter(driver=user)
    elif user.is_staff:
        base_qs = Delivery.objects.all()
    else:
        base_qs = Delivery.objects.none()
    
    # Check if status_number column exists
    column_exists = _status_number_column_exists()
    
    if column_exists:
        # Column exists - use defer to exclude it (optimization) or include it normally
        if use_defer:
            return base_qs.defer('status_number')
        else:
            # Include all fields including status_number
            return base_qs
    else:
        # Column doesn't exist - use only() to explicitly select fields (excluding status_number)
        return _apply_status_number_safe_query(base_qs)


@extend_schema(tags=['DriverDelivery'])
class DriverDeliveryViewSet(viewsets.ModelViewSet):
    """
    ViewSet for DriverDelivery endpoints.
    Wraps the existing DeliveryViewSet functionality for driver-specific operations.
    """
    # Queryset will be set dynamically in get_queryset() to handle status_number column
    # We can't use defer() here because if column doesn't exist, it will fail
    queryset = Delivery.objects.none()  # Placeholder, will be overridden in get_queryset()
    serializer_class = DeliverySerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'id'
    lookup_url_kwarg = 'id'

    def get_queryset(self):
        """Filter deliveries to only show those for the current driver."""
        # Don't use defer by default - only use it if column exists and we want to optimize
        # For now, default to False to avoid errors
        return _get_delivery_queryset(self.request.user, use_defer=False)
    
    def get_object(self):
        """Override to handle both UUID and integer IDs for deliveries."""
        lookup_url_kwarg = self.lookup_url_kwarg or self.lookup_field
        pk = self.kwargs.get(lookup_url_kwarg)
        
        if not pk:
            return None
        
        # Try to get delivery by UUID first
        try:
            # Try parsing as UUID
            import uuid
            uuid.UUID(str(pk))
            # Use safe query to avoid errors if column doesn't exist
            qs = Delivery.objects.filter(id=pk)
            qs = _apply_status_number_safe_query(qs)
            return qs.get()
        except (Delivery.DoesNotExist, ValueError, TypeError):
            # If UUID parsing fails, try to find by integer hash
            # This is for backward compatibility with integer IDs
            import hashlib
            # Get all deliveries - use safe query
            deliveries = _apply_status_number_safe_query(Delivery.objects.all())
            
            for delivery in deliveries:
                delivery_id_str = str(delivery.id).replace('-', '')
                delivery_id_int = int(hashlib.md5(delivery_id_str.encode()).hexdigest()[:8], 16) % 100000000
                if str(delivery_id_int) == str(pk):
                    return delivery
            
            # If not found, raise DoesNotExist
            raise Delivery.DoesNotExist(f'Delivery with ID "{pk}" not found.')

    @extend_schema(
        tags=['DriverDelivery'],
        operation_id='driverdelivery_list',
        summary='List all deliveries',
        description='Get a list of all deliveries. Use the "id" field from the response as the "job-id" parameter for vehicle, locations, and trip endpoints.',
    )
    def list(self, request, *args, **kwargs):
        """List all deliveries - returns delivery IDs that can be used as job-id."""
        try:
            queryset = self.get_queryset()
            serializer = DeliverySerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            # If error is due to missing status_number column, retry without defer
            error_str = str(e).lower()
            if 'status_number' in error_str or ('column' in error_str and 'status_number' in str(e)):
                try:
                    # Retry with regular queryset (without defer) - force no defer
                    queryset = _get_delivery_queryset(self.request.user, use_defer=False)
                    serializer = DeliverySerializer(queryset, many=True)
                    return Response(serializer.data, status=status.HTTP_200_OK)
                except Exception as retry_error:
                    return create_error_response(
                        error_message=f'An error occurred: {str(retry_error)}',
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        errors={'error': [str(retry_error)]}
                    )
            return create_error_response(
                error_message=f'An error occurred: {str(e)}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [str(e)]}
            )

    @extend_schema(
        tags=['DriverDelivery'],
        operation_id='driverdelivery_retrieve',
        summary='Retrieve a delivery by ID',
        description='Get a delivery by ID. The returned "id" can be used as "job-id" parameter for vehicle, locations, and trip endpoints.',
    )
    def retrieve(self, request, *args, **kwargs):
        """Retrieve a delivery by ID matching old Swagger format."""
        try:
            delivery = self.get_object()
            # Use DriverDeliveryMyRequestsResponseSerializer to match old Swagger format
            serializer = DriverDeliveryMyRequestsResponseSerializer(delivery)
            return create_success_response(data=serializer.data, messages=[])
        except Delivery.DoesNotExist:
            pk = kwargs.get('id', 'unknown')
            return create_error_response(
                error_message=f'Delivery with ID "{pk}" not found.',
                status_code=status.HTTP_404_NOT_FOUND,
                errors={'id': [f'Delivery with ID "{pk}" not found.']}
            )
        except Exception as e:
            # If error is due to missing status_number column, try to get object without it
            error_str = str(e).lower()
            if 'status_number' in error_str or ('column' in error_str and 'status_number' in str(e)):
                try:
                    # Retry get_object using safe query
                    lookup_url_kwarg = self.lookup_url_kwarg or self.lookup_field
                    pk = self.kwargs.get(lookup_url_kwarg)
                    try:
                        import uuid
                        uuid_obj = uuid.UUID(str(pk))
                        qs = Delivery.objects.filter(id=uuid_obj)
                        qs = _apply_status_number_safe_query(qs)
                        delivery = qs.get()
                    except (ValueError, TypeError):
                        # Try integer hash lookup
                        import hashlib
                        deliveries = _apply_status_number_safe_query(Delivery.objects.all())
                        delivery = None
                        for d in deliveries:
                            delivery_id_str = str(d.id).replace('-', '')
                            delivery_id_int = int(hashlib.md5(delivery_id_str.encode()).hexdigest()[:8], 16) % 100000000
                            if delivery_id_int == int(pk):
                                delivery = d
                                break
                        if not delivery:
                            raise Delivery.DoesNotExist
                    
                    serializer = DriverDeliveryMyRequestsResponseSerializer(delivery)
                    return create_success_response(data=serializer.data, messages=[])
                except Exception as retry_error:
                    return create_error_response(
                        error_message=f'An error occurred: {str(retry_error)}',
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        errors={'error': [str(retry_error)]}
                    )
            else:
                return create_error_response(
                    error_message=f'An error occurred: {str(e)}',
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    errors={'error': [str(e)]}
                )

    @extend_schema(
        tags=['DriverDelivery'],
        operation_id='driverdelivery_create',
        summary='Create a new driver delivery',
        request=DriverDeliveryCreateRequestSerializer,
        examples=[
            OpenApiExample(
                'Create Driver Delivery (default)',
                value={
                    "userId": "string",
                    "deliveryUserId": "string",
                    "deliveryDate": "2025-11-10T19:27:57.824Z",
                    "setUserId": "string",
                    "addressId": 0,
                    "orderId": "0",
                    "examId": 0,
                    "requestId": 0,
                    "zoneId": 0,
                    "preOrderId": "0",
                    "status": 0,
                    "description": "string"
                },
                request_only=True
            )
        ],
        responses={
            200: OpenApiResponse(
                response=dict,
                description='Driver delivery created successfully',
                examples=[
                    OpenApiExample(
                        'Success Response',
                        value={
                            "data": 10012,
                            "messages": [],
                            "succeeded": True
                        }
                    )
                ]
            )
        }
    )
    def create(self, request, *args, **kwargs):
        """Create a new driver delivery matching old Swagger format."""
        try:
            serializer = DriverDeliveryCreateRequestSerializer(data=request.data)
            if not serializer.is_valid():
                return create_error_response(
                    error_message='Validation error',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors=serializer.errors
                )
            
            validated_data = serializer.validated_data
            
            # Get driver (deliveryUserId or userId)
            driver_id = validated_data.get('deliveryUserId') or validated_data.get('userId')
            if not driver_id:
                return create_error_response(
                    error_message='deliveryUserId or userId is required',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors={'deliveryUserId': ['deliveryUserId or userId is required']}
                )
            
            try:
                driver = User.objects.get(id=driver_id)
            except User.DoesNotExist:
                return create_error_response(
                    error_message=f'User with ID "{driver_id}" not found.',
                    status_code=status.HTTP_404_NOT_FOUND,
                    errors={'deliveryUserId': [f'User with ID "{driver_id}" not found.']}
                )
            
            # Get order (orderId is required for Delivery model)
            order_id = validated_data.get('orderId', '0')
            if not order_id or order_id == '0' or order_id == '':
                # Try to get the first available order or create a placeholder
                order = Order.objects.first()
                if not order:
                    return create_error_response(
                        error_message='No orders available. Please create an order first.',
                        status_code=status.HTTP_400_BAD_REQUEST,
                        errors={'orderId': ['No orders available. Please create an order first.']}
                    )
            else:
                try:
                    # Try UUID first
                    import uuid
                    order_uuid = uuid.UUID(str(order_id))
                    order = Order.objects.get(id=order_uuid)
                except (ValueError, TypeError):
                    # If not a valid UUID, try as integer hash (old Swagger format)
                    try:
                        integer_id = int(order_id)
                        # Find order whose UUID hash matches the integer ID
                        import hashlib
                        orders = Order.objects.all()
                        order = None
                        for ord in orders:
                            # Use same hash calculation as OrderCompatibilitySerializer.get_id()
                            uuid_str = str(ord.id)
                            hash_obj = hashlib.md5(uuid_str.encode('utf-8'))
                            hash_int = int(hash_obj.hexdigest(), 16)
                            order_id_hash = hash_int % 2147483647  # Max 32-bit integer (matching OrderCompatibilitySerializer)
                            if order_id_hash == integer_id:
                                order = ord
                                break
                        if not order:
                            return create_error_response(
                                error_message=f'Order with ID "{order_id}" not found.',
                                status_code=status.HTTP_404_NOT_FOUND,
                                errors={'orderId': [f'Order with ID "{order_id}" not found.']}
                            )
                    except (ValueError, TypeError):
                        return create_error_response(
                            error_message=f'Invalid order ID format: "{order_id}". Expected UUID or integer.',
                            status_code=status.HTTP_400_BAD_REQUEST,
                            errors={'orderId': [f'Invalid order ID format: "{order_id}". Expected UUID or integer.']}
                        )
                except Order.DoesNotExist:
                    return create_error_response(
                        error_message=f'Order with ID "{order_id}" not found.',
                        status_code=status.HTTP_404_NOT_FOUND,
                        errors={'orderId': [f'Order with ID "{order_id}" not found.']}
                    )
            
            # Map status (0-30) to Delivery model statuses
            # 0 = assigned, 1 = in_progress, 2 = completed, 3 = cancelled
            # 4-30 = map to in_progress (intermediate/custom statuses)
            status_value = validated_data.get('status', 0)
            if status_value == 0:
                delivery_status = 'assigned'
            elif status_value == 1:
                delivery_status = 'in_progress'
            elif status_value == 2:
                delivery_status = 'completed'
            elif status_value == 3:
                delivery_status = 'cancelled'
            else:
                # Status values 4-30 map to in_progress (intermediate/custom statuses)
                delivery_status = 'in_progress'
            
            # Store original status number
            status_number = status_value
            
            # Get address from addressId if provided, otherwise use order address
            address_text = ''
            phone_number = ''
            
            address_id = validated_data.get('addressId', 0)
            if address_id and address_id != 0:
                try:
                    # Get address from Address model
                    address_obj = Address.objects.get(id=address_id)
                    address_text = address_obj.address or ''
                    phone_number = address_obj.phone_number or ''
                except Address.DoesNotExist:
                    return create_error_response(
                        error_message=f'Address with ID "{address_id}" not found.',
                        status_code=status.HTTP_404_NOT_FOUND,
                        errors={'addressId': [f'Address with ID "{address_id}" not found.']}
                    )
            
            # Get address and phoneNumber from validated_data if provided
            if validated_data.get('address'):
                address_text = validated_data.get('address')
            if validated_data.get('phoneNumber'):
                phone_number = validated_data.get('phoneNumber')
            
            # Fallback to order address if addressId not provided or address is empty
            if not address_text and order:
                address_text = order.address1 or ''
            if not phone_number and order:
                phone_number = order.phone1 or ''
            
            # Ensure address is not empty (required field)
            if not address_text:
                return create_error_response(
                    error_message='Address is required. Please provide addressId or ensure order has an address.',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors={'address': ['Address is required.']}
                )
            
            # Ensure phone_number is not empty (required field)
            if not phone_number:
                phone_number = driver.phone_number if hasattr(driver, 'phone_number') and driver.phone_number else ''
                if not phone_number:
                    return create_error_response(
                        error_message='Phone number is required.',
                        status_code=status.HTTP_400_BAD_REQUEST,
                        errors={'phone_number': ['Phone number is required.']}
                    )
            
            # Get latitude/longitude from zoneId (highest priority), validated_data, order, or address
            delivery_latitude = None
            delivery_longitude = None
            
            # Method 1: Get from zoneId if provided (highest priority - as per Flutter requirement)
            # Flutter says: "هر آدرس یک زون داره و هر زون یک latitude و longitude داره"
            if validated_data.get('zoneId') and validated_data.get('zoneId') != 0:
                try:
                    from zistino_apps.users.models import Zone
                    zone = Zone.objects.get(id=validated_data.get('zoneId'))
                    if zone.center_latitude and zone.center_longitude:
                        delivery_latitude = zone.center_latitude
                        delivery_longitude = zone.center_longitude
                except Zone.DoesNotExist:
                    pass
            
            # Method 2: Get directly from validated_data if zoneId not provided
            if not delivery_latitude and validated_data.get('latitude'):
                try:
                    delivery_latitude = float(validated_data.get('latitude'))
                except (ValueError, TypeError):
                    pass
            
            if not delivery_longitude and validated_data.get('longitude'):
                try:
                    delivery_longitude = float(validated_data.get('longitude'))
                except (ValueError, TypeError):
                    pass
            
            # Method 3: Get from order if not in request
            if not delivery_latitude and order:
                if order.latitude and order.longitude:
                    delivery_latitude = order.latitude
                    delivery_longitude = order.longitude
            
            # Method 4: Get from address if not in order
            if not delivery_latitude and address_id and address_id != 0:
                try:
                    address_obj = Address.objects.get(id=address_id)
                    if address_obj.latitude and address_obj.longitude:
                        delivery_latitude = address_obj.latitude
                        delivery_longitude = address_obj.longitude
                except Address.DoesNotExist:
                    pass
            
            # Create delivery
            create_kwargs = {
                'driver': driver,
                'order': order,
                'status': delivery_status,
                'delivery_date': validated_data.get('deliveryDate'),
                'description': validated_data.get('description', ''),
                'address': address_text,
                'phone_number': phone_number
            }
            
            # Add latitude/longitude if available
            if delivery_latitude:
                create_kwargs['latitude'] = delivery_latitude
            if delivery_longitude:
                create_kwargs['longitude'] = delivery_longitude
            # Only add status_number if the column exists in database (after migration)
            # Check if column exists in database, not just in model
            # Force fresh check (clear cache) to ensure accuracy
            if hasattr(_status_number_column_exists, '_cached_result'):
                delattr(_status_number_column_exists, '_cached_result')
            
            column_exists = _status_number_column_exists()
            
            # Try to create delivery - if status_number column doesn't exist, Django will fail
            # We'll catch the error and retry without status_number
            try:
                if column_exists:
                    create_kwargs['status_number'] = status_number
                delivery = Delivery.objects.create(**create_kwargs)
            except Exception as e:
                # If error is due to missing column, retry without status_number
                error_str = str(e).lower()
                if 'status_number' in error_str or ('column' in error_str and 'status_number' in str(e)):
                    # Clear cache to force re-check next time
                    if hasattr(_status_number_column_exists, '_cached_result'):
                        delattr(_status_number_column_exists, '_cached_result')
                    # Remove status_number from kwargs and retry
                    create_kwargs.pop('status_number', None)
                    try:
                        # Use raw SQL to insert without status_number if Django still tries to include it
                        from django.db import connection
                        from django.utils import timezone
                        import uuid as uuid_module
                        delivery_id = uuid_module.uuid4()
                        now = timezone.now()
                        delivery_date_val = validated_data.get('deliveryDate') or None
                        
                        with connection.cursor() as cursor:
                            # Insert without status_number column - include all required fields and defaults
                            # Check if latitude/longitude columns exist
                            has_lat_lng = delivery_latitude is not None or delivery_longitude is not None
                            
                            if has_lat_lng:
                                cursor.execute("""
                                    INSERT INTO deliveries (
                                        id, driver_id, order_id, status, address, phone_number,
                                        latitude, longitude,
                                        delivery_date, description, delivered_weight, reminder_sms_sent,
                                        customer_confirmation_status, created_at, updated_at
                                    ) VALUES (
                                        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                                    )
                                """, [
                                    delivery_id,
                                    driver.id,
                                    order.id,
                                    delivery_status,
                                    address_text,
                                    phone_number,
                                    delivery_latitude,
                                    delivery_longitude,
                                    delivery_date_val,
                                    validated_data.get('description', ''),
                                    0.0,  # delivered_weight default
                                    False,  # reminder_sms_sent default
                                    'pending',  # customer_confirmation_status default
                                    now,
                                    now
                                ])
                            else:
                                cursor.execute("""
                                    INSERT INTO deliveries (
                                        id, driver_id, order_id, status, address, phone_number,
                                        delivery_date, description, delivered_weight, reminder_sms_sent,
                                        customer_confirmation_status, created_at, updated_at
                                    ) VALUES (
                                        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                                    )
                                """, [
                                    delivery_id,
                                    driver.id,
                                    order.id,
                                    delivery_status,
                                    address_text,
                                    phone_number,
                                    delivery_date_val,
                                    validated_data.get('description', ''),
                                    0.0,  # delivered_weight default
                                    False,  # reminder_sms_sent default
                                    'pending',  # customer_confirmation_status default
                                    now,
                                    now
                                ])
                        
                        # Fetch the created delivery using safe query (without status_number)
                        delivery = _apply_status_number_safe_query(Delivery.objects.filter(id=delivery_id)).get()
                    except Exception as retry_error:
                        # If raw SQL also fails, try regular create one more time
                        try:
                            delivery = Delivery.objects.create(**create_kwargs)
                        except Exception as final_error:
                            return create_error_response(
                                error_message=f'An error occurred while creating delivery: {str(final_error)}',
                                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                                errors={'error': [str(final_error)]}
                            )
                else:
                    raise
            
            # Return delivery ID (using integer hash for compatibility)
            import hashlib
            delivery_id_str = str(delivery.id).replace('-', '')
            delivery_id_int = int(hashlib.md5(delivery_id_str.encode()).hexdigest()[:8], 16) % 100000000
            
            return create_success_response(data=delivery_id_int, messages=[])
        except Exception as e:
            return create_error_response(
                error_message=f'An error occurred while creating delivery: {str(e)}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [str(e)]}
            )

    @extend_schema(
        tags=['DriverDelivery'],
        operation_id='driverdelivery_update',
        summary='Update a delivery',
        request=DriverDeliveryUpdateRequestSerializer,
        examples=[
            OpenApiExample(
                'Update Driver Delivery',
                value={
                    "userId": "5f4915ca-d4c1-4e5b-8a55-7ac7cd74d671",
                    "deliveryUserId": None,
                    "deliveryDate": "2025-11-10T19:31:29.981Z",
                    "setUserId": None,
                    "addressId": 1,
                    "orderId": "string",
                    "examId": None,
                    "requestId": None,
                    "zoneId": None,
                    "preOrderId": None,
                    "status": 0,
                    "description": "string"
                },
                request_only=True
            )
        ],
        responses={
            200: OpenApiResponse(
                response=dict,
                description='Driver delivery updated successfully',
                examples=[
                    OpenApiExample(
                        'Success Response',
                        value={
                            "data": 10012,
                            "messages": [],
                            "succeeded": True
                        }
                    )
                ]
            )
        }
    )
    def update(self, request, *args, **kwargs):
        """Update a delivery matching old Swagger format."""
        try:
            delivery = self.get_object()
            # Drivers can only update their own deliveries
            if not request.user.is_staff and delivery.driver != request.user:
                return create_error_response(
                    error_message='You can only update your own deliveries',
                    status_code=status.HTTP_403_FORBIDDEN,
                    errors={'error': ['You can only update your own deliveries']}
                )
            
            # Validate input using old Swagger format serializer
            serializer = DriverDeliveryUpdateRequestSerializer(data=request.data)
            if not serializer.is_valid():
                return create_error_response(
                    error_message='Validation error',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors=serializer.errors
                )
            
            validated_data = serializer.validated_data
            
            # Update driver if provided
            if validated_data.get('deliveryUserId'):
                try:
                    driver = User.objects.get(id=validated_data['deliveryUserId'])
                    delivery.driver = driver
                except User.DoesNotExist:
                    return create_error_response(
                        error_message=f'User with ID "{validated_data["deliveryUserId"]}" not found.',
                        status_code=status.HTTP_404_NOT_FOUND,
                        errors={'deliveryUserId': [f'User with ID "{validated_data["deliveryUserId"]}" not found.']}
                    )
            elif validated_data.get('userId'):
                try:
                    driver = User.objects.get(id=validated_data['userId'])
                    delivery.driver = driver
                except User.DoesNotExist:
                    return create_error_response(
                        error_message=f'User with ID "{validated_data["userId"]}" not found.',
                        status_code=status.HTTP_404_NOT_FOUND,
                        errors={'userId': [f'User with ID "{validated_data["userId"]}" not found.']}
                    )
            
            # Update order if provided
            order_id = validated_data.get('orderId')
            if order_id and order_id != '0' and order_id != '':
                try:
                    # Try UUID first
                    import uuid
                    order_uuid = uuid.UUID(str(order_id))
                    order = Order.objects.get(id=order_uuid)
                    delivery.order = order
                except (ValueError, TypeError):
                    # If not a valid UUID, try as integer hash (old Swagger format)
                    try:
                        integer_id = int(order_id)
                        # Find order whose UUID hash matches the integer ID
                        import hashlib
                        orders = Order.objects.all()
                        order = None
                        for ord in orders:
                            # Use same hash calculation as OrderCompatibilitySerializer.get_id()
                            uuid_str = str(ord.id)
                            hash_obj = hashlib.md5(uuid_str.encode('utf-8'))
                            hash_int = int(hash_obj.hexdigest(), 16)
                            order_id_hash = hash_int % 2147483647  # Max 32-bit integer (matching OrderCompatibilitySerializer)
                            if order_id_hash == integer_id:
                                order = ord
                                break
                        if not order:
                            return create_error_response(
                                error_message=f'Order with ID "{order_id}" not found.',
                                status_code=status.HTTP_404_NOT_FOUND,
                                errors={'orderId': [f'Order with ID "{order_id}" not found.']}
                            )
                        delivery.order = order
                    except (ValueError, TypeError):
                        return create_error_response(
                            error_message=f'Invalid order ID format: "{order_id}". Expected UUID or integer.',
                            status_code=status.HTTP_400_BAD_REQUEST,
                            errors={'orderId': [f'Invalid order ID format: "{order_id}". Expected UUID or integer.']}
                        )
                except Order.DoesNotExist:
                    return create_error_response(
                        error_message=f'Order with ID "{order_id}" not found.',
                        status_code=status.HTTP_404_NOT_FOUND,
                        errors={'orderId': [f'Order with ID "{order_id}" not found.']}
                    )
            
            # Update status if provided (allows changing from any status to any other status)
            # Support status values 0-30 (mapped to Delivery model statuses)
            if validated_data.get('status') is not None:
                status_value = validated_data['status']
                
                # Validate status is within acceptable range (0-30)
                if not isinstance(status_value, int) or status_value < 0 or status_value > 30:
                    return create_error_response(
                        error_message=f'Invalid status value: {status_value}. Valid values are: 0-30.',
                        status_code=status.HTTP_400_BAD_REQUEST,
                        errors={'status': [f'Invalid status value: {status_value}. Valid values are: 0-30.']}
                    )
                
                # Map status values to Delivery model statuses
                # 0 = assigned, 1 = in_progress, 2 = completed, 3 = cancelled
                # 4-30 = map to in_progress (intermediate statuses)
                if status_value == 0:
                    delivery.status = 'assigned'
                elif status_value == 1:
                    delivery.status = 'in_progress'
                elif status_value == 2:
                    delivery.status = 'completed'
                elif status_value == 3:
                    delivery.status = 'cancelled'
                else:
                    # Status values 4-30 map to in_progress (intermediate/custom statuses)
                    delivery.status = 'in_progress'
                
                # Store original status number for response (if column exists in database)
                # Check if column exists in database, not just in model
                if _status_number_column_exists():
                    try:
                        delivery.status_number = status_value
                    except Exception:
                        pass  # Field doesn't exist in database yet (migration not applied)
            
            # Update delivery date if provided
            if validated_data.get('deliveryDate'):
                delivery.delivery_date = validated_data['deliveryDate']
            
            # Update description if provided
            if validated_data.get('description') is not None:
                delivery.description = validated_data['description']
            
            # Update address if provided (from addressId or direct address field)
            address_id = validated_data.get('addressId')
            address_text = validated_data.get('address')
            if address_id and address_id != 0:
                try:
                    address_obj = Address.objects.get(id=address_id)
                    delivery.address = address_obj.address or delivery.address
                    delivery.phone_number = address_obj.phone_number or delivery.phone_number
                except Address.DoesNotExist:
                    pass  # If addressId not found, keep existing address
            elif address_text:
                delivery.address = address_text
            
            # Update phone number if provided
            phone_number = validated_data.get('phoneNumber')
            if phone_number:
                delivery.phone_number = phone_number
            
            # Update latitude if provided
            if validated_data.get('latitude') is not None:
                delivery.latitude = validated_data['latitude']
            
            # Update longitude if provided
            if validated_data.get('longitude') is not None:
                delivery.longitude = validated_data['longitude']
            
            # Update delivered weight if provided
            if validated_data.get('deliveredWeight') is not None:
                delivery.delivered_weight = validated_data['deliveredWeight']
            
            # Update reminder SMS sent if provided
            if validated_data.get('reminderSmsSent') is not None:
                delivery.reminder_sms_sent = validated_data['reminderSmsSent']
            
            # Update license plate number if provided
            if validated_data.get('licensePlateNumber') is not None:
                delivery.license_plate_number = validated_data['licensePlateNumber']
            
            # Update customer confirmation status if provided
            customer_confirmation_status = validated_data.get('customerConfirmationStatus')
            if customer_confirmation_status:
                valid_statuses = ['pending', 'confirmed', 'denied']
                if customer_confirmation_status in valid_statuses:
                    delivery.customer_confirmation_status = customer_confirmation_status
                else:
                    return create_error_response(
                        error_message=f'Invalid customer confirmation status: {customer_confirmation_status}. Valid values are: pending, confirmed, denied.',
                        status_code=status.HTTP_400_BAD_REQUEST,
                        errors={'customerConfirmationStatus': [f'Invalid status. Valid values are: pending, confirmed, denied.']}
                    )
            
            # Update denial reason if provided
            if validated_data.get('denialReason') is not None:
                delivery.denial_reason = validated_data['denialReason']
            
            # Update cancel reason if provided
            if validated_data.get('cancelReason') is not None:
                delivery.cancel_reason = validated_data['cancelReason']
            
            # Update confirmed at if provided
            if validated_data.get('confirmedAt'):
                delivery.confirmed_at = validated_data['confirmedAt']
            
            # Save delivery (handle case where status_number column doesn't exist yet)
            try:
                delivery.save()
            except Exception as e:
                # If error is due to missing status_number column, remove it and retry
                error_str = str(e).lower()
                if 'status_number' in error_str or ('column' in error_str and 'status_number' in str(e)):
                    # Unset status_number attribute and save again
                    if hasattr(delivery, 'status_number'):
                        delattr(delivery, 'status_number')
                    delivery.save()
                else:
                    raise
            
            # Return delivery ID (using integer hash for compatibility)
            import hashlib
            delivery_id_str = str(delivery.id).replace('-', '')
            delivery_id_int = int(hashlib.md5(delivery_id_str.encode()).hexdigest()[:8], 16) % 100000000
            
            return create_success_response(data=delivery_id_int, messages=[])
        except Delivery.DoesNotExist:
            pk = kwargs.get('id', 'unknown')
            return create_error_response(
                error_message=f'Delivery with ID "{pk}" not found.',
                status_code=status.HTTP_404_NOT_FOUND,
                errors={'id': [f'Delivery with ID "{pk}" not found.']}
            )
        except Exception as e:
            return create_error_response(
                error_message=f'An error occurred while updating delivery: {str(e)}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [str(e)]}
            )

    @extend_schema(
        tags=['DriverDelivery'],
        operation_id='driverdelivery_partial_update',
        summary='Partially update a delivery',
        request=DeliverySerializer,
        responses={200: DeliverySerializer},
    )
    def partial_update(self, request, *args, **kwargs):
        """Partially update a delivery matching old Swagger format."""
        try:
            delivery = self.get_object()
            # Drivers can only update their own deliveries
            if not request.user.is_staff and delivery.driver != request.user:
                return create_error_response(
                    error_message='You can only update your own deliveries',
                    status_code=status.HTTP_403_FORBIDDEN,
                    errors={'error': ['You can only update your own deliveries']}
                )
            return super().partial_update(request, *args, **kwargs)
        except Delivery.DoesNotExist:
            pk = kwargs.get('id', 'unknown')
            return create_error_response(
                error_message=f'Delivery with ID "{pk}" not found.',
                status_code=status.HTTP_404_NOT_FOUND,
                errors={'id': [f'Delivery with ID "{pk}" not found.']}
            )
        except Exception as e:
            return create_error_response(
                error_message=f'An error occurred while updating delivery: {str(e)}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [str(e)]}
            )

    @extend_schema(
        tags=['DriverDelivery'],
        operation_id='driverdelivery_destroy',
        summary='Delete a delivery',
        responses={
            200: OpenApiResponse(
                response=dict,
                description='Driver delivery deleted successfully',
                examples=[
                    OpenApiExample(
                        'Success Response',
                        value={
                            "data": None,
                            "messages": [],
                            "succeeded": True
                        }
                    )
                ]
            ),
            403: {'description': 'Only managers can delete deliveries'},
            404: {'description': 'Delivery not found'}
        }
    )
    def destroy(self, request, *args, **kwargs):
        """Delete a delivery matching old Swagger format."""
        try:
            # Only managers can delete deliveries
            if not request.user.is_staff:
                return create_error_response(
                    error_message='Only managers can delete deliveries',
                    status_code=status.HTTP_403_FORBIDDEN,
                    errors={'error': ['Only managers can delete deliveries']}
                )
            delivery = self.get_object()
            delivery.delete()
            return create_success_response(data=None, messages=[])
        except Delivery.DoesNotExist:
            pk = kwargs.get('id', 'unknown')
            return create_error_response(
                error_message=f'Delivery with ID "{pk}" not found.',
                status_code=status.HTTP_404_NOT_FOUND,
                errors={'id': [f'Delivery with ID "{pk}" not found.']}
            )
        except Exception as e:
            return create_error_response(
                error_message=f'An error occurred while deleting delivery: {str(e)}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [str(e)]}
            )

    @extend_schema(
        tags=['DriverDelivery'],
        operation_id='driverdelivery_search',
        summary='Search driver deliveries using available filters',
        request=DriverDeliverySearchRequestSerializer,
        examples=[
            OpenApiExample(
                'Search Request (default)',
                value={
                    "advancedSearch": {
                        "fields": [
                            "string"
                        ],
                        "keyword": "string",
                        "groupBy": [
                            "string"
                        ]
                    },
                    "keyword": "string",
                    "pageNumber": 0,
                    "pageSize": 0,
                    "orderBy": [
                        "string"
                    ],
                    "status": 0,
                    "userid": "string",
                    "fromDate": "2025-11-10T19:30:40.785Z",
                    "toDate": "2025-11-10T19:30:40.785Z"
                },
                request_only=True
            )
        ],
        responses={
            200: OpenApiResponse(
                response=dict,
                description='Search results with nested pagination',
                examples=[
                    OpenApiExample(
                        'Success Response',
                        value={
                            "data": {
                                "data": [],
                                "currentPage": 0,
                                "totalPages": 0,
                                "totalCount": 0,
                                "pageSize": 1,
                                "hasPreviousPage": False,
                                "hasNextPage": False,
                                "messages": None,
                                "succeeded": True
                            },
                            "messages": [],
                            "succeeded": True
                        }
                    )
                ]
            )
        }
    )
    @action(detail=False, methods=['post'], url_path='search')
    def search(self, request):
        """Search driver deliveries with pagination and filters matching old Swagger format."""
        try:
            # Handle empty request body - request.data is read-only, so use get() or empty dict
            request_data = request.data if request.data else {}
            
            serializer = DriverDeliverySearchRequestSerializer(data=request_data)
            if not serializer.is_valid():
                return create_error_response(
                    error_message='Validation error',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors=serializer.errors
                )
            
            validated_data = serializer.validated_data
            
            # Get pagination parameters
            page_number = validated_data.get('pageNumber', 0)
            if page_number == 0:
                page_number = 1
            page_size = validated_data.get('pageSize', 0)
            if page_size == 0:
                page_size = 20
            
            # Build query - use safe query to avoid errors if column doesn't exist
            # Note: select_related must be called before only() to work correctly
            if request.user.is_staff:
                qs = Delivery.objects.all()
            else:
                qs = Delivery.objects.filter(driver=request.user)
            
            # Apply select_related first (before only())
            qs = qs.select_related('driver', 'order', 'order__user')
            
            # Apply safe query to exclude status_number if column doesn't exist
            # This will call only() which should work with select_related
            qs = _apply_status_number_safe_query(qs)
            
            # Filter by userid
            if validated_data.get('userid'):
                try:
                    user = User.objects.get(id=validated_data['userid'])
                    qs = qs.filter(driver=user)
                except User.DoesNotExist:
                    pass  # If user not found, return empty results
            
            # Filter by status
            if validated_data.get('status') is not None:
                status_map = {0: 'assigned', 1: 'in_progress', 2: 'completed', 3: 'cancelled'}
                status_value = status_map.get(validated_data['status'])
                if status_value:
                    qs = qs.filter(status=status_value)
            
            # Filter by date range
            if validated_data.get('fromDate'):
                qs = qs.filter(created_at__gte=validated_data['fromDate'])
            if validated_data.get('toDate'):
                qs = qs.filter(created_at__lte=validated_data['toDate'])
            
            # Apply keyword search
            keyword = validated_data.get('keyword', '').strip()
            if keyword:
                qs = qs.filter(
                    Q(address__icontains=keyword) |
                    Q(phone_number__icontains=keyword) |
                    Q(description__icontains=keyword)
                )
            
            # Handle orderBy
            order_by = validated_data.get('orderBy', [])
            if order_by and isinstance(order_by, list):
                valid_order_by = []
                for field in order_by:
                    if field and isinstance(field, str):
                        # Map common fields
                        mapped_field = None
                        if field.lower() in ['created_at', 'createdat', 'createdon']:
                            mapped_field = 'created_at'
                        elif field.lower() in ['delivery_date', 'deliverydate']:
                            mapped_field = 'delivery_date'
                        elif field.lower() in ['status']:
                            mapped_field = 'status'
                        
                        if mapped_field:
                            valid_order_by.append(mapped_field)
                
                if valid_order_by:
                    qs = qs.order_by(*valid_order_by)
                else:
                    qs = qs.order_by('-created_at')
            else:
                qs = qs.order_by('-created_at')
            
            # Calculate pagination
            total_count = qs.count()
            total_pages = (total_count + page_size - 1) // page_size if page_size > 0 else 0
            current_page = page_number
            has_previous_page = current_page > 1
            has_next_page = current_page < total_pages
            
            # Get paginated items - don't call select_related again if already applied
            start = (page_number - 1) * page_size
            end = start + page_size
            items = qs[start:end]
            
            # Serialize with error handling
            try:
                serializer = DeliverySerializer(items, many=True)
                serialized_data = serializer.data
            except Exception as serialization_error:
                import logging
                logger = logging.getLogger(__name__)
                logger.error(f'Error serializing deliveries: {str(serialization_error)}', exc_info=True)
                # Return empty data if serialization fails
                serialized_data = []
            
            # Return in old Swagger format with nested pagination
            return create_success_response(
                data={
                    'data': serialized_data,
                    'currentPage': current_page,
                    'totalPages': total_pages,
                    'totalCount': total_count,
                    'pageSize': page_size,
                    'hasPreviousPage': has_previous_page,
                    'hasNextPage': has_next_page,
                    'messages': None,
                    'succeeded': True
                },
                messages=[]
            )
        except Exception as e:
            import logging
            import traceback
            logger = logging.getLogger(__name__)
            error_trace = traceback.format_exc()
            logger.error(f'Error in driverdelivery/search endpoint: {str(e)}\n{error_trace}')
            return create_error_response(
                error_message=f'An error occurred while searching deliveries: {str(e)}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [str(e)]}
            )


# Custom APIView classes for URL patterns that don't fit ViewSet actions
@extend_schema(
    tags=['DriverDelivery'],
    operation_id='driverdelivery_myrequests',
    summary='Get my delivery requests',
    description='Get delivery requests for the currently logged-in driver with pagination.',
    request=DriverDeliverySearchRequestSerializer,
    examples=[
        OpenApiExample(
            'My Requests Request (default)',
            value={
                "advancedSearch": {
                    "fields": [
                        "string"
                    ],
                    "keyword": "string",
                    "groupBy": [
                        "string"
                    ]
                },
                "keyword": "string",
                "pageNumber": 0,
                "pageSize": 0,
                "orderBy": [
                    "string"
                ],
                "status": 0,
                "userid": "string",
                "fromDate": "2025-11-10T19:29:26.462Z",
                "toDate": "2025-11-10T19:29:26.462Z"
            },
            request_only=True
        )
    ],
    responses={
        200: OpenApiResponse(
            response=dict,
            description='My delivery requests matching old Swagger format',
            examples=[
                OpenApiExample(
                    'Success Response',
                    value={
                        "messages": [],
                        "succeeded": True,
                        "data": [
                            {
                                "id": 0,
                                "userId": "string",
                                "creator": "string",
                                "deliveryUserId": "string",
                                "deliveryDate": "2025-11-30T09:24:46.944Z",
                                "dirver": "string",
                                "setUserId": "string",
                                "setUser": "string",
                                "addressId": 0,
                                "address": "string",
                                "latitude": 0,
                                "longitude": 0,
                                "phoneNumber": "string",
                                "vatNumber": "string",
                                "status": 0,
                                "createdOn": "2025-11-30T09:24:46.944Z",
                                "requestId": 0,
                                "zoneId": 0,
                                "orderId": 0,
                                "preOrderId": 0,
                                "dirverphone": "string",
                                "description": "string"
                            }
                        ]
                    }
                )
            ]
        )
    }
)
class DriverDeliveryMyRequestsView(APIView):
    """POST /api/v1/driverdelivery/myrequests"""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        """Get delivery requests for the currently logged-in driver matching old Swagger format.
        Includes:
        1. Deliveries already assigned to the driver
        2. Available orders (pending/confirmed without delivery) in driver's zones
        """
        try:
            # Handle empty request body - request.data is read-only, so use get() or empty dict
            request_data = request.data if request.data else {}
            
            serializer = DriverDeliverySearchRequestSerializer(data=request_data)
            if not serializer.is_valid():
                return create_error_response(
                    error_message='Validation error',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors=serializer.errors
                )
            
            validated_data = serializer.validated_data
            
            # Get pagination parameters
            page_number = validated_data.get('pageNumber', 0)
            if page_number == 0:
                page_number = 1
            page_size = validated_data.get('pageSize', 0)
            if page_size == 0:
                page_size = 20
            
            # Get driver's current location from latest LocationUpdate
            driver_lat = None
            driver_lng = None
            if request.user.is_driver:
                from zistino_apps.deliveries.models import LocationUpdate
                latest_location = LocationUpdate.objects.filter(
                    user=request.user
                ).order_by('-created_at').first()
                
                if latest_location:
                    driver_lat = float(latest_location.latitude)
                    driver_lng = float(latest_location.longitude)
            
            # Get all deliveries (not just assigned to driver) - we'll filter by zone proximity
            delivery_qs = Delivery.objects.all().select_related('driver', 'order', 'order__user')
            # Apply safe query to exclude status_number if column doesn't exist
            delivery_qs = _apply_status_number_safe_query(delivery_qs)
            
            # Filter deliveries based on zone proximity to driver's location
            all_items = []
            from zistino_apps.users.models import Zone
            from zistino_apps.deliveries.utils import find_zone_for_location
            
            # Get all active zones
            all_zones = Zone.objects.filter(
                is_active=True,
                center_latitude__isnull=False,
                center_longitude__isnull=False
            )
            
            # Find zones near driver's location (if driver has location)
            nearby_zones = []
            if driver_lat and driver_lng:
                for zone in all_zones:
                    # Check if driver is within zone radius
                    if zone.contains_point(driver_lat, driver_lng):
                        nearby_zones.append(zone.id)
                    else:
                        # Also include zones within reasonable distance (e.g., 20km)
                        distance = zone.calculate_distance_km(driver_lat, driver_lng)
                        if distance is not None and distance <= 20.0:  # 20km threshold
                            nearby_zones.append(zone.id)
            
            # Filter deliveries that are in nearby zones (or all if driver has no location)
            for delivery in delivery_qs:
                delivery_in_nearby_zone = False
                
                # If driver has location, check zone proximity
                if driver_lat and driver_lng and nearby_zones:
                    # Method 1: If delivery has latitude/longitude, find its zone
                    if delivery.latitude and delivery.longitude:
                        delivery_zone = find_zone_for_location(
                            float(delivery.latitude),
                            float(delivery.longitude)
                        )
                        if delivery_zone and delivery_zone.id in nearby_zones:
                            delivery_in_nearby_zone = True
                    
                    # Method 2: If order has latitude/longitude, use that
                    if not delivery_in_nearby_zone and delivery.order:
                        if delivery.order.latitude and delivery.order.longitude:
                            order_zone = find_zone_for_location(
                                float(delivery.order.latitude),
                                float(delivery.order.longitude)
                            )
                            if order_zone and order_zone.id in nearby_zones:
                                delivery_in_nearby_zone = True
                    
                    # Method 3: If order has zone_id, check if it's in nearby zones
                    if not delivery_in_nearby_zone and delivery.order:
                        if hasattr(delivery.order, 'zone_id') and delivery.order.zone_id:
                            if delivery.order.zone_id in nearby_zones:
                                delivery_in_nearby_zone = True
                else:
                    # If driver has no location, show all deliveries (for testing/fallback)
                    # In production, you might want to return empty list or require location
                    delivery_in_nearby_zone = True
                
                if delivery_in_nearby_zone:
                    all_items.append(delivery)
            
            # Now filter the combined list (deliveries + available orders)
            qs = all_items
            
            # Filter by preOrderId if provided (in advancedSearch or as direct field)
            pre_order_id = None
            advanced_search = validated_data.get('advancedSearch', {})
            if isinstance(advanced_search, dict):
                pre_order_id = advanced_search.get('preOrderId')
            
            # Also check if preOrderId is in request data directly
            if not pre_order_id and hasattr(request, 'data') and isinstance(request.data, dict):
                pre_order_id = request.data.get('preOrderId')
            
            # Filter the list (not queryset) by preOrderId if provided
            if pre_order_id:
                try:
                    import hashlib
                    matching_order_ids = []
                    for item in qs:
                        order = item.order if hasattr(item, 'order') else None
                        if order:
                            uuid_str = str(order.id)
                            hash_obj = hashlib.md5(uuid_str.encode('utf-8'))
                            hash_int = int(hash_obj.hexdigest(), 16)
                            order_id_int = hash_int % 2147483647
                            if str(order_id_int) == str(pre_order_id) or order_id_int == pre_order_id:
                                matching_order_ids.append(item)
                    qs = matching_order_ids
                except Exception:
                    pass  # If preOrderId filtering fails, continue without filter
            
            # Filter by status (on list)
            if validated_data.get('status') is not None:
                status_map = {0: ['assigned', 'available'], 1: 'in_progress', 2: 'completed', 3: 'cancelled'}
                status_value = status_map.get(validated_data['status'])
                if status_value:
                    if isinstance(status_value, list):
                        qs = [item for item in qs if hasattr(item, 'status') and item.status in status_value]
                    else:
                        qs = [item for item in qs if hasattr(item, 'status') and item.status == status_value]
            
            # Filter by date range (on list)
            if validated_data.get('fromDate'):
                from_date = validated_data['fromDate']
                qs = [item for item in qs if hasattr(item, 'created_at') and item.created_at >= from_date]
            if validated_data.get('toDate'):
                to_date = validated_data['toDate']
                qs = [item for item in qs if hasattr(item, 'created_at') and item.created_at <= to_date]
            
            # Apply keyword search (on list)
            keyword = validated_data.get('keyword', '').strip()
            if keyword:
                keyword_lower = keyword.lower()
                qs = [item for item in qs if (
                    (hasattr(item, 'address') and keyword_lower in (item.address or '').lower()) or
                    (hasattr(item, 'phone_number') and keyword_lower in (item.phone_number or '').lower()) or
                    (hasattr(item, 'description') and keyword_lower in (item.description or '').lower())
                )]
            
            # Handle orderBy (on list)
            order_by = validated_data.get('orderBy', [])
            if order_by and isinstance(order_by, list):
                valid_order_by = []
                for field in order_by:
                    if field and isinstance(field, str):
                        if field.lower() in ['created_at', 'createdat', 'createdon']:
                            valid_order_by.append(('created_at', True))
                        elif field.lower() in ['-created_at', '-createdat', '-createdon']:
                            valid_order_by.append(('created_at', False))
                        elif field.lower() in ['delivery_date', 'deliverydate']:
                            valid_order_by.append(('delivery_date', True))
                        elif field.lower() in ['-delivery_date', '-deliverydate']:
                            valid_order_by.append(('delivery_date', False))
                
                if valid_order_by:
                    # Sort by first valid field
                    field_name, ascending = valid_order_by[0]
                    reverse = not ascending
                    qs = sorted(qs, key=lambda x: getattr(x, field_name, None) or (datetime.min if ascending else datetime.max), reverse=reverse)
                else:
                    # Default: sort by created_at descending
                    qs = sorted(qs, key=lambda x: getattr(x, 'created_at', datetime.min), reverse=True)
            else:
                # Default: sort by created_at descending
                qs = sorted(qs, key=lambda x: getattr(x, 'created_at', datetime.min), reverse=True)
            
            # Apply pagination if pageSize > 0
            if page_size > 0:
                start = (page_number - 1) * page_size
                end = start + page_size
                items = qs[start:end]
            else:
                # If pageSize is 0, return all results
                items = qs
            
            # Serialize using the new serializer matching old Swagger format
            serializer = DriverDeliveryMyRequestsResponseSerializer(items, many=True)
            
            # Return in old Swagger format (direct array, not nested pagination)
            return create_success_response(data=serializer.data, messages=[])
        except Exception as e:
            return create_error_response(
                error_message=f'An error occurred while fetching delivery requests: {str(e)}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [str(e)]}
            )

