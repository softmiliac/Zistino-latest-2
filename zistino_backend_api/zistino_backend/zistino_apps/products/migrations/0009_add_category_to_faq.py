# Generated manually
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('products', '0008_add_in_stock_field'),
    ]

    operations = [
        migrations.AddField(
            model_name='faq',
            name='category',
            field=models.ForeignKey(blank=True, help_text='FAQ category (type=0)', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='faqs', to='products.category'),
        ),
    ]

