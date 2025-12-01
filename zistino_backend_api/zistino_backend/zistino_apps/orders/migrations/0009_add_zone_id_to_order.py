# Generated manually for zone_id field

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0008_make_address_phone_fields_nullable'),
    ]

    operations = [
        migrations.AddField(
            model_name='order',
            name='zone_id',
            field=models.IntegerField(blank=True, help_text='Zone ID assigned to this order (can be set directly or calculated from latitude/longitude)', null=True),
        ),
    ]

