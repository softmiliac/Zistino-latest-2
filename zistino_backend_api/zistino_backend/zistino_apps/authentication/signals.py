"""
Signals for User model.
"""
from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from .models import User
import random
import string


def generate_representative_code():
    """Generate a random alphanumeric code for representative field."""
    # Generate 8-character code with uppercase letters and digits
    while True:
        code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        # Check if code already exists
        if not User.objects.filter(representative=code).exists():
            return code


@receiver(pre_save, sender=User)
def generate_user_representative_code(sender, instance, **kwargs):
    """
    Generate a random representative code when user is created.
    Only generate if representative is empty or is placeholder value.
    """
    # Only generate if representative is empty, None, or placeholder
    if not instance.representative or instance.representative.strip() == '' or instance.representative.lower() == 'string':
        instance.representative = generate_representative_code()

