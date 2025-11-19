"""
Serializers for Notifications endpoints.
Matching old Swagger format for Flutter compatibility.
"""
from rest_framework import serializers


class NotificationSendRequestSerializer(serializers.Serializer):
    """Request serializer for sending notification matching old Swagger format."""
    phoneNumber = serializers.CharField(required=False, allow_blank=True, help_text='Phone number to send notification to (e.g., 09123456789 or +989123456789). Leave empty to send to all active users.')
    message = serializers.CharField(required=True, help_text='Message content to send')
    userId = serializers.CharField(required=False, allow_blank=True, help_text='User ID (optional, for tracking purposes)')
    sendToAll = serializers.BooleanField(required=False, default=False, help_text='If true, send to all active users (ignores phoneNumber)')

