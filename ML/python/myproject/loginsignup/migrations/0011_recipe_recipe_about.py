# Generated by Django 4.1.9 on 2023-06-15 07:48

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('loginsignup', '0010_recipe_about_message_recipe_nutrition_message'),
    ]

    operations = [
        migrations.AddField(
            model_name='recipe',
            name='recipe_about',
            field=models.TextField(default=1),
            preserve_default=False,
        ),
    ]