# myapp/serializers.py

from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Employee
from .models import ChatMessage,Extract_contact_information,Java_script_to_python,Friend_chart,Mood_to_color,Write_a_python_doc_string,Analogy_maker,Assistant_chat
from .models import Grammer_Correction,Question_Analysis,Science_fiction_book_list_maker,Tweet_classifier,Airport_code_extractor,Sql_request,Java_script_online_function,Interview_Question
from .models import Natural_Api,Summarization,Python_bug_fixer,Spreadsheet_creator,Java_script_helper_chat_bot,Mi_language_model_tutor,Micro_horror_story_creator,Create_study_notes
from .models import Text_Command,Advanced_tweet_classifier,Explain_code,Keywords,Factual_answering,Ad_form_product_description,Third_person_convertor,Reastaurant_review_creator
from .models import English_Translate,Python_to_natural_language,Movie_to_emoji,Calculate_time_complexity,Translate_programming_language,Eassy_outline,Turn_by_turn_direction
from .models import Natural_Language_Stripe,Vr_fitness_idea_generator,Notes_to_summary,Parse_unstructured_data,Classification,Recipe_creator,Chat,Marv_the_sarcastic_chat_bot

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email')

class EmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = '__all__'
class ChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatMessage
        fields = '__all__'
class Grammer_CorrectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Grammer_Correction
        fields = '__all__'

class Summarize_GenderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Grammer_Correction
        fields = '__all__'        

class Natural_ApiSerializer(serializers.ModelSerializer):
    class Meta:
        model = Natural_Api
        fields = '__all__'

class Text_CommandSerializer(serializers.ModelSerializer):
    class Meta:
        model = Text_Command
        fields = '__all__'
class English_TranslateSerializer(serializers.ModelSerializer):
    class Meta:
        model = English_Translate
        fields = '__all__'
class Natural_Language_StripSerializer(serializers.ModelSerializer):
    class Meta:
        model = Natural_Language_Stripe
        fields = '__all__'       

class Question_analysisSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question_Analysis
        fields = '__all__' 

class Vr_fitness_idea_generator_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Vr_fitness_idea_generator
        fields = '__all__'

class Notes_to_summary_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Notes_to_summary
        fields = '__all__'

class Parse_unstructured_data_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Parse_unstructured_data
        fields = '__all__'
class Classification_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Classification
        fields = '__all__'
class Python_to_natural_language_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Python_to_natural_language
        fields = '__all__'       

class Movie_to_emoji_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Movie_to_emoji
        fields = '__all__'

class Calculate_time_complexity_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Calculate_time_complexity
        fields = '__all__'

class Translate_programming_language_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Translate_programming_language
        fields = '__all__'
class Advanced_tweet_classifier_Serializer_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Advanced_tweet_classifier
        fields = '__all__'
class Explain_code_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Explain_code
        fields = '__all__'       
class Keywords_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Keywords
        fields = '__all__'

class Factual_answering_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Factual_answering
        fields = '__all__'

class Ad_form_product_description_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Ad_form_product_description
        fields = '__all__'
class Summarization_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Summarization
        fields = '__all__'
class Python_bug_fixer_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Python_bug_fixer
        fields = '__all__'       


class Spreadsheet_creator_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Spreadsheet_creator
        fields = '__all__'

class Java_script_helper_chat_bot_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Java_script_helper_chat_bot
        fields = '__all__'

class Mi_language_model_tutor_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Mi_language_model_tutor
        fields = '__all__'
class Science_fiction_book_list_maker_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Science_fiction_book_list_maker
        fields = '__all__'
class Tweet_classifier_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Tweet_classifier
        fields = '__all__'       
class Airport_code_extractor_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Airport_code_extractor
        fields = '__all__'


class Sql_request_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Sql_request
        fields = '__all__'

class Extract_contact_information_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Extract_contact_information
        fields = '__all__'
class Java_script_to_python_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Java_script_to_python
        fields = '__all__'
class Friend_chart_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Friend_chart
        fields = '__all__'       
class Mood_to_color_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Mood_to_color
        fields = '__all__'

class Write_a_python_doc_string_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Write_a_python_doc_string
        fields = '__all__'

class Analogy_maker_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Analogy_maker
        fields = '__all__'
class Java_script_online_function_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Java_script_online_function
        fields = '__all__'
class Micro_horror_story_creator_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Micro_horror_story_creator
        fields = '__all__'       

class Third_person_convertor_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Third_person_convertor
        fields = '__all__'

class Eassy_outline_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Eassy_outline
        fields = '__all__'

class Recipe_creator_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Recipe_creator
        fields = '__all__'
class Chat_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Chat
        fields = '__all__'
class Marv_the_sarcastic_chat_bot_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Marv_the_sarcastic_chat_bot
        fields = '__all__'       

class Turn_by_turn_direction_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Turn_by_turn_direction
        fields = '__all__'

class Reastaurant_review_creator_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Reastaurant_review_creator
        fields = '__all__'

class Create_study_notes_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Create_study_notes
        fields = '__all__'
class Interview_Question_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Interview_Question
        fields = '__all__'
class Assistant_chat_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Assistant_chat
        fields = '__all__'       
   

      