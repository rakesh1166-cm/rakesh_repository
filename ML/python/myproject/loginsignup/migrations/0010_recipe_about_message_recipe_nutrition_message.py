# Generated by Django 4.1.9 on 2023-06-15 06:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('loginsignup', '0009_recipe_message'),
    ]

    operations = [
        migrations.AddField(
            model_name='recipe',
            name='about_message',
            field=models.TextField(default=1),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='recipe',
            name='nutrition_message',
            field=models.TextField(default=1),
            preserve_default=False,
        ),
    ]