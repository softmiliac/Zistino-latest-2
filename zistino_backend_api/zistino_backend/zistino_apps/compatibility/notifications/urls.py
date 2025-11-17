"""
Notifications compatibility URL routes for Flutter apps.

Flutter expects: /api/v1/notifications/{endpoint}
All endpoints are tagged with 'Notifications' to appear grouped in Swagger UI.

Endpoints:
1. POST /api/v1/notifications/send - Send notification (SMS) to user/driver
"""
from django.urls import path
from . import views

urlpatterns = [
    path('send', views.NotificationSendView.as_view(), name='notifications-send'),
]

