# Generated manually for adding sender field to Transaction

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payments', '0003_depositrequest'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name='transaction',
            name='sender',
            field=models.ForeignKey(
                blank=True,
                help_text='User who initiated/sent this transaction (admin/manager)',
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name='sent_transactions',
                to=settings.AUTH_USER_MODEL
            ),
        ),
    ]

