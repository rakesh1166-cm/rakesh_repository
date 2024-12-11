from django.db import models
from sorl.thumbnail import ImageField
from django.conf import settings
import openai
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token
import json

@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)

class Position(models.Model):
    title = models.CharField(max_length=50)

    def __str__(self):
        return self.title
    
class Category(models.Model):
    title = models.CharField(max_length=50,null=True)

    def __str__(self):
        return self.title

class Chatcategory(models.Model):
    name = models.CharField(max_length=100)
    category= models.ForeignKey(Category,on_delete=models.CASCADE)
class Employee(models.Model):
    fullname = models.CharField(max_length=100)
    emp_code = models.CharField(max_length=3)
    mobile= models.CharField(max_length=15)
    position= models.ForeignKey(Position,on_delete=models.CASCADE)
    image = ImageField()
class ChatMessage(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
    category= models.ForeignKey(Chatcategory,on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.message
class Question_Analysis(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Grammer_Correction(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Natural_Api(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Text_Command(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class English_Translate(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
    
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Natural_Language_Stripe(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
 
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message   





class Vr_fitness_idea_generator(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message
    

class Summarize_gender(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message    

class Notes_to_summary(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Parse_unstructured_data(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Classification(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Python_to_natural_language(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                          
    
class Movie_to_emoji(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Calculate_time_complexity(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Translate_programming_language(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Advanced_tweet_classifier(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
    
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Explain_code(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
    
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                          
class Keywords(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Factual_answering(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Ad_form_product_description(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Summarization(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
    
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Python_bug_fixer(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                          
class Spreadsheet_creator(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Java_script_helper_chat_bot(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Mi_language_model_tutor(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Science_fiction_book_list_maker(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Tweet_classifier(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                          
class Airport_code_extractor(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Sql_request(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Extract_contact_information(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Java_script_to_python(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Friend_chart(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                          
class Mood_to_color(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Write_a_python_doc_string(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Analogy_maker(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Java_script_online_function(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
 
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Micro_horror_story_creator(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                          
class Third_person_convertor(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Eassy_outline(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message

class Recipe_creator(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Chat(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Marv_the_sarcastic_chat_bot(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                          
class Turn_by_turn_direction(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message
class Recipe(models.Model):
    name = models.CharField(max_length=255)
    amount = models.CharField(max_length=255)
    about = models.TextField()
    recipe_about = models.TextField()
    message = models.TextField()
    about_message = models.TextField()
    nutrition_message = models.TextField()
    nutrition = models.JSONField()

class Sentiment(models.Model):
    text  = models.CharField(max_length=255)
    reason = models.TextField()
    sentiment = models.TextField()
    solution = models.TextField() 
    pre_sentiment = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
class SentimentAnalysisModel(models.Model):
    text = models.TextField()
    label = models.CharField(max_length=10)     

class predict_sentiment(models.Model):
    sentiments  = models.TextField()
       

class Reastaurant_review_creator(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message
class Car(models.Model):
    make = models.CharField(max_length=100)
    model = models.CharField(max_length=100)
    year = models.IntegerField()
    mileage = models.IntegerField()
    fuel = models.CharField(max_length=100)
    price = models.FloatField(null=True, blank=True)
class Create_study_notes(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Interview_Question(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
   
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message 
class Assistant_chat(models.Model):
    message = models.CharField(max_length=100)
    generated_message = models.TextField()
  
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message                                                      