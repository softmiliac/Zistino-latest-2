# Generated migration - Make address and phone fields nullable

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0007_change_status_to_string'),
    ]

    operations = [
        # Make address and phone fields nullable
        migrations.AlterField(
            model_name='order',
            name='external_user_id',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.AlterField(
            model_name='order',
            name='address1',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='order',
            name='address2',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='order',
            name='phone1',
            field=models.CharField(blank=True, max_length=15, null=True),
        ),
        migrations.AlterField(
            model_name='order',
            name='phone2',
            field=models.CharField(blank=True, max_length=15, null=True),
        ),
        migrations.AlterField(
            model_name='order',
            name='user_full_name',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.AlterField(
            model_name='order',
            name='user_phone_number',
            field=models.CharField(blank=True, max_length=15, null=True),
        ),
    ]

