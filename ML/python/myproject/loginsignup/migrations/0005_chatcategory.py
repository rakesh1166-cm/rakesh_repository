# Generated by Django 4.1.9 on 2023-06-09 09:36

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('loginsignup', '0004_english_translate_grammer_correction_natural_api_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='Chatcategory',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('category', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='loginsignup.category')),
            ],
        ),
    ]
