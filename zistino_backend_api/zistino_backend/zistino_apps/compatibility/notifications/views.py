"""
Compatibility views for Notifications endpoints.
All endpoints will appear under "Notifications" folder in Swagger UI.

Based on Flutter Swagger format.
"""
from rest_framework import status, serializers
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from drf_spectacular.utils import extend_schema, OpenApiExample, OpenApiResponse
from zistino_apps.users.permissions import IsManager

from zistino_apps.compatibility.utils import create_success_response, create_error_response
from .serializers import NotificationSendRequestSerializer


@extend_schema(
    tags=['Notifications'],
    operation_id='notifications_send',
    summary='Send notification (SMS)',
    description='Send SMS notification to a user/driver matching old Swagger format.',
    request=NotificationSendRequestSerializer,
    examples=[
        OpenApiExample(
            'Send notification to user',
            value={
                'phoneNumber': '09123456789',
                'message': 'Your order has been confirmed',
                'userId': 'user-uuid-here'
            }
        ),
        OpenApiExample(
            'Send notification without userId',
            value={
                'phoneNumber': '+989123456789',
                'message': 'Your delivery is scheduled for tomorrow'
            }
        )
    ],
    responses={
        200: OpenApiResponse(
            response=serializers.Serializer,
            description='Notification sent successfully',
            examples=[
                OpenApiExample(
                    'Success response',
                    value={
                        'data': {
                            'phoneNumber': '09123456789',
                            'message': 'Your order has been confirmed',
                            'sent': True
                        },
                        'messages': ['SMS sent successfully'],
                        'succeeded': True
                    }
                )
            ]
        ),
        400: {'description': 'Validation error'},
        500: {'description': 'SMS sending failed'}
    }
)
class NotificationSendView(APIView):
    """POST /api/v1/notifications/send - Send notification (SMS)"""
    permission_classes = [IsAuthenticated, IsManager]

    def post(self, request):
        """Send SMS notification matching old Swagger format."""
        try:
            # Validate input
            serializer = NotificationSendRequestSerializer(data=request.data)
            if not serializer.is_valid():
                errors = {}
                for field, error_list in serializer.errors.items():
                    errors[field] = [str(error) for error in error_list]
                return create_error_response(
                    error_message='Validation failed',
                    status_code=status.HTTP_400_BAD_REQUEST,
                    errors=errors
                )
            
            validated_data = serializer.validated_data
            phone_number = validated_data['phoneNumber']
            message = validated_data['message']
            
            # Send SMS using existing SMS service
            try:
                from zistino_apps.payments.sms_service import send_sms
                success, error_message = send_sms(phone_number, message)
                
                if success:
                    return create_success_response(
                        data={
                            'phoneNumber': phone_number,
                            'message': message,
                            'sent': True
                        },
                        messages=['SMS sent successfully'],
                        status_code=status.HTTP_200_OK
                    )
                else:
                    return create_error_response(
                        error_message=f'Failed to send SMS: {error_message}',
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        errors={'sms': [error_message or 'Unknown error']}
                    )
            except Exception as sms_error:
                return create_error_response(
                    error_message=f'Error sending SMS: {str(sms_error)}',
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    errors={'sms': [str(sms_error)]}
                )
        
        except Exception as e:
            error_detail = str(e)
            error_type = type(e).__name__
            
            return create_error_response(
                error_message=f'An error occurred while processing the request: {error_detail}',
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                errors={'error': [f'{error_type}: {error_detail}']}
            )

