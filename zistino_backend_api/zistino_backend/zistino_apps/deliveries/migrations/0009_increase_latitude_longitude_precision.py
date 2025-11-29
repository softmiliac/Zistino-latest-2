# Generated manually for increasing latitude and longitude precision

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('deliveries', '0008_surveyquestion_surveyanswer'),
    ]

    operations = [
        migrations.AlterField(
            model_name='locationupdate',
            name='latitude',
            field=models.DecimalField(decimal_places=10, help_text='Latitude with up to 10 decimal places for precise location', max_digits=13),
        ),
        migrations.AlterField(
            model_name='locationupdate',
            name='longitude',
            field=models.DecimalField(decimal_places=10, help_text='Longitude with up to 10 decimal places for precise location', max_digits=13),
        ),
    ]

