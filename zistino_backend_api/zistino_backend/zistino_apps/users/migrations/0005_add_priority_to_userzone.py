# Generated manually
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0004_add_address_fax_website_title'),
    ]

    operations = [
        migrations.AddField(
            model_name='userzone',
            name='priority',
            field=models.IntegerField(default=0, help_text='Priority for driver assignment (higher number = higher priority). Default: 0.'),
        ),
        migrations.AddIndex(
            model_name='userzone',
            index=models.Index(fields=['priority'], name='user_zones_priority_idx'),
        ),
        migrations.AlterModelOptions(
            name='userzone',
            options={'ordering': ['-priority', 'last_modified_on'], 'verbose_name': 'User Zone', 'verbose_name_plural': 'User Zones'},
        ),
    ]

