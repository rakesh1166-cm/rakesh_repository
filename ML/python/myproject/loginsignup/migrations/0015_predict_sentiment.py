# Generated by Django 4.1.9 on 2023-06-26 11:26

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('loginsignup', '0014_sentiment'),
    ]

    operations = [
        migrations.CreateModel(
            name='predict_sentiment',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('sentiments', models.TextField()),
            ],
        ),
    ]
