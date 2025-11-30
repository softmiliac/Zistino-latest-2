# Generated manually for status_number field

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('deliveries', '0009_increase_latitude_longitude_precision'),
    ]

    operations = [
        migrations.AddField(
            model_name='delivery',
            name='status_number',
            field=models.IntegerField(blank=True, default=0, help_text='Original status number from Flutter app (0-30)', null=True),
        ),
    ]

