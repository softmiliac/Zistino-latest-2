from django.apps import AppConfig


class AuthenticationConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'zistino_apps.authentication'
    
    def ready(self):
        """Import signals when app is ready."""
        import zistino_apps.authentication.signals
