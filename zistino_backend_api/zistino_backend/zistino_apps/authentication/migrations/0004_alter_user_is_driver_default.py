# Generated manually for changing is_driver default value
# Users should be customers by default, manager must approve them as drivers

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authentication', '0003_alter_user_is_active_alter_user_is_active_driver'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='is_driver',
            field=models.BooleanField(default=False, help_text='Whether user is a driver. Must be approved by manager.'),
        ),
    ]

