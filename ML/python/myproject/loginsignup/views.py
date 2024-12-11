from django.shortcuts import render

# Create your views here.
from django.shortcuts import render,HttpResponse,redirect
from django.contrib.auth.models import User
from django.contrib.auth import authenticate,login,logout
from django.contrib.auth.decorators import login_required
from rest_framework import generics
from django.contrib.auth.models import User
import joblib
import re

from django.core.exceptions import ObjectDoesNotExist
from rest_framework.views import APIView
from transformers import pipeline, AutoTokenizer,AutoModelForSequenceClassification,AutoModelForSeq2SeqLM
from sklearn.preprocessing import OneHotEncoder
from sklearn.feature_extraction.text import TfidfVectorizer
import torch
import pandas as pd
import pickle
import numpy as np
from sklearn.metrics import mean_squared_error
from sklearn.compose import make_column_transformer
from sklearn.pipeline import make_pipeline
from sklearn.metrics import r2_score
from sklearn.pipeline import Pipeline

from sklearn.model_selection import train_test_split

from sklearn.metrics import classification_report
import torch.nn.functional as F
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import LabelEncoder
from loginsignup.serializers import UserSerializer
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.tokens import AccessToken
from rest_framework.response import Response
from rest_framework import status
from sklearn.linear_model import LinearRegression,LogisticRegression
import json
from django.urls import reverse
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.decorators import user_passes_test


from .forms import EmployeeForm,Vr_fitness_idea_generator_Form,Notes_to_summary_Form,Parse_unstructured_data_Form,Classification_Form,Python_to_natural_language_Form
from .forms import CategoryForm,Movie_to_emoji_Form,Calculate_time_complexity_Form,Translate_programming_language_Form,Advanced_tweet_classifier_Form,RecipeForm

from .forms import Question_Analysis_Form,Explain_code_Form,Keywords_Form,Factual_answering_Form,Ad_form_product_description_Form,Summarization_Form,CarForm
from .forms import Grammer_Correction_Form,Python_bug_fixer_Form,Spreadsheet_creator_Form,Java_script_helper_chat_bot_Form,Mi_language_model_tutor_Form,Assistant_chat_Form
from .forms import Summarize_Gender_Form,Science_fiction_book_list_maker_Form,Tweet_classifier_Form,Airport_code_extractor_Form,Create_study_notes_Form,Interview_Question_Form
from .forms import Text_Command_Form,Sql_request_Form,Extract_contact_information_Form,Java_script_to_python_Form,Friend_chart_Form,Mood_to_color_Form,Reastaurant_review_creator_Form
from .forms import English_Translate_Form,Write_a_python_doc_string_Form,Analogy_maker_Form,Java_script_online_function_Form,Micro_horror_story_creator_Form,Turn_by_turn_direction_Form
from .forms import Natural_Language_stripe_Form,Third_person_convertor_Form,Eassy_outline_Form,Recipe_creator_Form,Chat_Form,Marv_the_sarcastic_chat_bot_Form

from .models import Employee,Question_Analysis,Summarize_gender,Recipe,Car,Sentiment,predict_sentiment
from .models import ChatMessage,Extract_contact_information,Java_script_to_python,Friend_chart,Mood_to_color,Write_a_python_doc_string,Analogy_maker,Assistant_chat
from .models import Grammer_Correction,Science_fiction_book_list_maker,Tweet_classifier,Airport_code_extractor,Sql_request,Java_script_online_function,Interview_Question
from .models import Natural_Api,Summarization,Python_bug_fixer,Spreadsheet_creator,Java_script_helper_chat_bot,Mi_language_model_tutor,Micro_horror_story_creator,Create_study_notes
from .models import Text_Command,Advanced_tweet_classifier,Explain_code,Keywords,Factual_answering,Ad_form_product_description,Third_person_convertor,Reastaurant_review_creator
from .models import English_Translate,Python_to_natural_language,Movie_to_emoji,Calculate_time_complexity,Translate_programming_language,Eassy_outline,Turn_by_turn_direction
from .models import Natural_Language_Stripe,Vr_fitness_idea_generator,Notes_to_summary,Parse_unstructured_data,Classification,Recipe_creator,Chat,Marv_the_sarcastic_chat_bot

import requests
from .serializers import Question_analysisSerializer,Movie_to_emoji_Serializer,Calculate_time_complexity_Serializer,Translate_programming_language_Serializer
from .serializers import Natural_Language_StripSerializer,Advanced_tweet_classifier_Serializer_Serializer,Explain_code_Serializer,Keywords_Serializer,Factual_answering_Serializer
from .serializers import English_TranslateSerializer,Ad_form_product_description_Serializer,Summarization_Serializer,Python_bug_fixer_Serializer
from .serializers import Text_CommandSerializer,Spreadsheet_creator_Serializer,Java_script_helper_chat_bot_Serializer,Mi_language_model_tutor_Serializer,Science_fiction_book_list_maker_Serializer
from .serializers import Natural_ApiSerializer,Tweet_classifier_Serializer,Airport_code_extractor_Serializer,Sql_request_Serializer,Extract_contact_information_Serializer
from .serializers import Grammer_CorrectionSerializer,Java_script_to_python_Serializer,Friend_chart_Serializer,Mood_to_color_Serializer,Write_a_python_doc_string_Serializer
from .serializers import Vr_fitness_idea_generator_Serializer,Analogy_maker_Serializer,Java_script_online_function_Serializer
from .serializers import Notes_to_summary_Serializer,Micro_horror_story_creator_Serializer,Third_person_convertor_Serializer
from .serializers import Parse_unstructured_data_Serializer,Eassy_outline_Serializer,Recipe_creator_Serializer
from .serializers import Classification_Serializer,Chat_Serializer,Marv_the_sarcastic_chat_bot_Serializer,Summarize_GenderSerializer
from .serializers import Python_to_natural_language_Serializer,Turn_by_turn_direction_Serializer,Reastaurant_review_creator_Serializer
from .serializers import EmployeeSerializer,Create_study_notes_Serializer,Interview_Question_Serializer,Assistant_chat_Serializer
from .serializers import ChatMessageSerializer
from rest_framework.authentication import  TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import openai
import nltk
from django.http import HttpResponse
from django.conf import settings
from .forms import ChatForm
from rest_framework import authentication, permissions
from .models import Category
from .models import Chatcategory
from loginsignup.sentiment_analysis import perform_sentiment_analysis
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, permission_classes,authentication_classes

# Create your views here.

@login_required(login_url='login')
def HomePage(request):   
    return render(request, 'employee_list.html')
def user_authenticated(user):
    return user.is_authenticated
class ListUsers(APIView):
    """
    View to list all users in the system.

    * Requires token authentication.
    * Only admin users are able to access this view.
    """
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        """
        Return a list of all users.
        """
        usernames = [user.username for user in User.objects.all()]
        return Response(usernames)
    
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_question_analysis(request):
    
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0,                
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=1
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_grammer_correction(request):
    
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=1.0,                
                top_p=1.0,
                frequency_penalty=0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=2
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_sql_translates(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=7
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_product_generator(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=7
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_summarize_gender(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=1.0,                
                top_p=1.0,
                frequency_penalty=0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=3
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_natural_api(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=4
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_text_command(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.2,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=5
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_english_translate(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=6
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_natural_language_stripe(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=7
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_Vr_fitness_idea_generator(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0.6,
                top_p=1.0,
                frequency_penalty=1,
                presence_penalty=1,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=40
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_notes_to_summary(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=40
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_parse_unstructured_data(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=9
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_classification(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=10
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_python_to_natural_language(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=11
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_movie_to_emoji(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=13
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_calculate_time_complexity(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=13
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_translate_programming_language(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=14
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_advanced_tweet_classifier(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=15
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_explain_code(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.8,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=16
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_keywords(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.8,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=17
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_factual_answering(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=18
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_ad_form_product_description(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=19
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_summarization(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=1,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=21
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_python_bug_fixer(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=182,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=22
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_spreadsheet_creator(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=23
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_java_script_helper_chat_bot(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=24
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_mi_language_model_tutor(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=25
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_science_fiction_book_list_maker(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=200,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.52,
                presence_penalty=0.5
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=26
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_tweet_classifier(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                temperature=0,
                max_tokens=60,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=27
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_airport_code_extractor(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=28
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_sql_request(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=29
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_extract_contact_information(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=30
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_java_script_to_python(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=31
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_friend_chart(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=32
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_mood_to_color(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=33
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_write_a_python_doc_string(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=34
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_analogy_maker(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=35
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_java_script_online_function(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=36
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_micro_horror_story_creator(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.8,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=37
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_third_person_convertor(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=38
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_eassy_outline(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=41
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_recipe_creator(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=42
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_chat(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=60,
                temperature=0.5,
                top_p=0.3,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=44
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_marv_the_sarcastic_chat_bot(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=100,
                temperature=0,                
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0,
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=44
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_turn_by_turn_direction(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0.3,
                top_p=0.3,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=45
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_reastaurant_review_creator(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=64,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=46
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)
openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_create_study_notes(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=47
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)

openai.api_key = settings.OPENAI_API_KEY
@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])   
@csrf_exempt    
def api_interview_Question(request):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    openai.api_key = settings.OPENAI_API_KEY
    message = request.POST.get('message')
    response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=message,
                max_tokens=150,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
    else:
                print('data else choices')
                generated_message = 'Failed to generate response'
                
    category=48
    product = ChatMessage.objects.create(message=message, generated_message=generated_message,category_id=category)
    data = {'product': {
        'generated_message': product.generated_message       
    }}

    return JsonResponse(data)



class CustomAuthToken(ObtainAuthToken):

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data,
                                           context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user_id': user.pk,
            'email': user.email
        })
def SignupPage(request):
    if request.method=='POST':
        uname=request.POST.get('username')
        email=request.POST.get('email')
        pass1=request.POST.get('password1')
        pass2=request.POST.get('password2')
        user = authenticate(username=uname, password=pass1)

        if pass1!=pass2:
            return HttpResponse("Your password and confrom password are not Same!!")
        else:
        
            my_user=User.objects.create_user(uname,email,pass1)
            my_user.save()
            return redirect('login')

    return render (request,'signup.html')


openai.api_key = settings.OPENAI_API_KEY # Replace with your OpenAI API key

@csrf_exempt
def chat_with_gpt(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message'] 
         
            dynamic_max_tokens =  request.POST.get('max_tokens')  
            dynamic_top_p = request.POST.get('top_p') 
            dynamic_temperature = request.POST.get('temperature') 
            dynamic_modal = request.POST.get('modal')
            dynamic_frequency_penalty = request.POST.get('frequency_penalty') 
            dynamic_presence_penalty = request.POST.get('presence_penalty') 
            
            max_tokens = int(dynamic_max_tokens) if dynamic_max_tokens and dynamic_max_tokens != '0' else 100          
            modal = dynamic_modal if dynamic_modal and dynamic_modal != '0' else "text-davinci-003"
            temperature = float(dynamic_temperature) if dynamic_temperature and dynamic_temperature != '0' else 0.5
            top_p = float(dynamic_top_p) if dynamic_top_p and dynamic_top_p != '0' else 0.5
            frequency_penalty = float(dynamic_frequency_penalty) if dynamic_frequency_penalty and dynamic_frequency_penalty != '0' else 0.5
            presence_penalty = float(dynamic_presence_penalty) if dynamic_presence_penalty and dynamic_presence_penalty != '0' else 0
            data = {
                'user_input':form.cleaned_data['message'],
                'temperature':temperature,
                'max_tokens':request.POST.get('max_tokens'),
                'top_p':top_p,
            }
            # Print all the request data
            print('Request Data:', data)
            # Make a request to ChatGPT using the OpenAI library 
        
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                model=modal,
                prompt=user_input,
                temperature=temperature,
                max_tokens=max_tokens,
                top_p=top_p,
                frequency_penalty=frequency_penalty,
                presence_penalty=presence_penalty,
                logprobs=0,
                echo=True
            )
            
            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'
            # Save the user input and generated response to the database
            category=2
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatgpt.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()
  
    return render(request, 'chatgpt.html', {'form': form})
          

openai.api_key = settings.OPENAI_API_KEY # Replace with your OpenAI API key



@csrf_exempt
def question_analysis(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0,                
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

                
            category=1
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/question_analysis.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/question_analysis.html', {'form': form})
@csrf_exempt
def paneer_form(request):
   
           
        
           user_input = "paneer recipe"
           about_recipe = "tell me about paneer"
           nutrition_value = "Generate nutrition values for a paneer"

            # Make a request to ChatGPT using the OpenAI library
           openai.api_key = settings.OPENAI_API_KEY
           response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
           response_about = openai.Completion.create(
                engine='text-davinci-003',
                prompt=about_recipe,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
           response_nutrition = openai.Completion.create(
                engine='text-davinci-003',
                prompt=nutrition_value,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

           if response.choices and response_about.choices and response_nutrition.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                parsed_message = generated_message.split("\n")
                

                generated_message_about = response_about.choices[0].text.strip()
                
              

                generated_message_nutrition = response_nutrition.choices[0].text
                
                parsed_message_nutrition = generated_message_nutrition.split("\n")
  
                
                context = {'paneer': parsed_message,'paneer_about': generated_message_about,'paneer_nutrition': parsed_message_nutrition}
              
                print(parsed_message_nutrition)
           else:
                print('data else choices')
                generated_message = 'Failed to generate response'

                
           category=42
           chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
           chat_message.save()

           return render(request, 'openai/dashboard.html', context)
    
          
@csrf_exempt
def chicken_form(request):
   
           form = ChatForm(request.POST)
        
           user_input = "Chiecken curry recipe"
           about_recipe = "tell me about paneer"
           nutrition_value = "Generate nutrition values for a Chiecken curry"
            # Make a request to ChatGPT using the OpenAI library
           openai.api_key = settings.OPENAI_API_KEY
           response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
           response_about = openai.Completion.create(
                engine='text-davinci-003',
                prompt=about_recipe,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
           response_nutrition = openai.Completion.create(
                engine='text-davinci-003',
                prompt=nutrition_value,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

           if response.choices and response_about.choices and response_nutrition.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                parsed_message = generated_message.split("\n")
                

                generated_message_about = response_about.choices[0].text.strip()
                
              

                generated_message_nutrition = response_nutrition.choices[0].text
                
                parsed_message_nutrition = generated_message_nutrition.split("\n")
  
                
                context = {'chicken': parsed_message,'chicken_about': generated_message_about,'chicken_nutrition': parsed_message_nutrition}
                print(generated_message_nutrition)
                print(parsed_message_nutrition)
           else:
                print('data else choices')
                generated_message = 'Failed to generate response'

                
           category=42
           chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
           chat_message.save()

           return render(request, 'openai/dashboard.html', context)
    
@csrf_exempt
def vegcurry_form(request):
    
        
          form = ChatForm(request.POST)
        
          user_input = "Vegetable curry recipe"
          about_recipe = "tell me about paneer"
          nutrition_value = "Generate nutrition values for a Vegetable curry"
            # Make a request to ChatGPT using the OpenAI library
          openai.api_key = settings.OPENAI_API_KEY
          response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
          response_about = openai.Completion.create(
                engine='text-davinci-003',
                prompt=about_recipe,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
          response_nutrition = openai.Completion.create(
                engine='text-davinci-003',
                prompt=nutrition_value,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

          if response.choices and response_about.choices and response_nutrition.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                parsed_message = generated_message.split("\n")
                

                generated_message_about = response_about.choices[0].text.strip()
                
              

                generated_message_nutrition = response_nutrition.choices[0].text
                
                parsed_message_nutrition = generated_message_nutrition.split("\n")
  
                
                context = {'vegetable': parsed_message,'vegetable_about': generated_message_about,'vegetable_nutrition': parsed_message_nutrition}
                print(generated_message_nutrition)
                print(parsed_message_nutrition)
          else:
                print('data else choices')
                generated_message = 'Failed to generate response'

                
          category=42
          chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
          chat_message.save()

          return render(request, 'openai/dashboard.html', context)



@csrf_exempt
def grammer_correction(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=1.0,                
                top_p=1.0,
                frequency_penalty=0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

                
            category=2
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/question_analysis.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/question_analysis.html', {'form': form})

@csrf_exempt
def summarize_gender(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=1.0,                
                top_p=1.0,
                frequency_penalty=0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

                
            category=3
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/summarize_gender.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/summarize_gender.html', {'form': form})
def generate_chat_completion(prompt):
    response = openai.Completion.create(
        engine='text-davinci-003',
        prompt=prompt,
        max_tokens=50,
        n=1,
        stop=None,
        temperature=0.7
    )

    completion = response.choices[0].text.strip()
    return completion

def process_completion_response(completion):
    # Process the completion response and extract recommendations
    # Implement your logic here to parse and extract relevant information from the completion
    recommendations = []  # Placeholder, replace with actual recommendations

    return recommendations
@csrf_exempt
def natural_api(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=4 
            
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/natural_api.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/natural_api.html', {'form': form})

@csrf_exempt
def text_command(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.2,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=5
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/text_command.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/text_command.html', {'form': form})

@csrf_exempt
def english_translate(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=6
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/english_translate.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/english_translate.html', {'form': form})

@csrf_exempt
def natural_language_stripe(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=7
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/natural_language_stripe.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/natural_language_stripe.html', {'form': form})
@csrf_exempt
def sql_translates(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=7
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/sql_translate.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/sql_translate.html', {'form': form})
@csrf_exempt
def product_generator(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=7
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/product_generator.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/product_generator.html', {'form': form})
@csrf_exempt
def chat_with_api(request): 
   
   if request.method == 'POST':
       user_input = request.POST.get('message')
       openai.api_key = settings.OPENAI_API_KEY
       response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=50,
                temperature=0
            )
       if response.choices:
                
                generated_message = response.choices[0].text.strip()
                
       else:
            
            generated_message = 'Failed to generate response'
            chat_message = ChatMessage(message=user_input, generated_message=generated_message)
            chat_message.save()
            return render(request, 'chat.html', {'generated_message': generated_message})
   else:
        
               
        return render(request, 'chat.html', {})
@csrf_exempt
def chat(request):
    
    if  request.method == 'POST':
            print("data is here")
            openai.api_key = api_key        
            user_input = request.POST.get('user_input')
            # Make a request to ChatGPT using the OpenAI library
            
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=256, 
                temprature=0.5               
            )
            print(response)
    if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message) 
    else:
            print('data else choices')
            generated_message = 'Failed to generate response'
            chat_message = ChatMessage(message=user_input, generated_message=generated_message)
            chat_message.save()              
    return render(request, 'mychat.html', { 'generated_message': generated_message})       
   
api_key = settings.OPENAI_API_KEY # Replace with your OpenAI API key
@csrf_exempt
def get_image_api(request):
    chatbot_response=None
    if api_key is not None and request.method == 'POST':
            print("data is here")
            openai.api_key = api_key        
            user_input = request.POST.get('user_input')
            # Make a request to ChatGPT using the OpenAI library
            
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=256, 
                temprature=0.5               
            )
            print(response)
    return render(request, 'mychat.html', {}) 
def LoginPage(request):
    if request.method=='POST':
        username=request.POST.get('username')
        pass1=request.POST.get('pass')
        user=authenticate(request,username=username,password=pass1)
        if user is not None:  
            url = 'http://localhost:8000/myemployee/' 
            auth_response = requests.post('http://localhost:8000/api/token/', data={'username': username, 'password': pass1})
            token = auth_response.json().get('token') 
            print(token)
            headers = {                                                                                                                                                                                                                
           'Authorization': f'token {token}',
                }
            response = requests.get(url, headers=headers)
            data = response.json() 
            print(data)   
        
            return render(request, 'employee_list.html', {'employees': data,'token': token}) 
        else:
            return HttpResponse ("Username or Password is incorrect!!!")
    return render (request,'login.html')
def LogoutPage(request):
    logout(request)
    return redirect('login')

class UserList(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
class EmployeeAPIView(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated] 
    def get(self, request):
        employee = Employee.objects.all()
        serializer = EmployeeSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)    
class ChatgptAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=2)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Question_analysisAPIView(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=1)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class GrammerAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=2)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class SummarizeAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=3)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class NaturalapiAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=4)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class TextcommandAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=5)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class English_translateAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=6)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class Natural_languageAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=7)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class Fitness_ideaAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=40)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class NotessummaryAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=39)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class Parse_unstructureAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=9)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class ClassificationAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=10)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class Python_naturalAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=11)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data) 
class MovieemojiAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=12)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)                                              
           

class TimecomplexityAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=13)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Translate_proAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=14)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class AdvancetweetAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=15)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class ExplaincodeAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=16)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class KeywordsAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=17)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class FactualansAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=18)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Pro_descAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=19)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class SummarizationAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=21)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class PythonbugAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=22)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class SpreadsheetAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=23)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class Javascript_chatbotAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=24)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class LanguagemodalAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=25)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)


class ChatappsAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=43)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)

class Science_fictionAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=26)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class Tweet_classifierAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=27)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class Airport_codeAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=28)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class SqlrequestAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=29)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Extract_contactAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=30)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Javascript_pythonAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=31)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class FriendchatAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=32)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class MoodcolorAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=33)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class WritepythondocAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=34)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class AnalogymakerAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=35)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class JavascriptAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=36)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class MicrohorrorAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=37)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class ThirdpersonAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=38)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Eassy_outlineAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=41)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Recipe_creatorAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=42)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class MarvchatbotAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=44)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
    
class Turn_byAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=45)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)

class Restaurant_reviewAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=46)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class StudynotesAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=47)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class Interview_questionAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=48)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class SqltranslateAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=8)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)
class ProductgeneratorAPIView(APIView):
    def get(self, request):
        employee = ChatMessage.objects.filter(category_id=20)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)        
class AssistantchatAPIView(APIView):
    def get(self, request):
        employee = Assistant_chat.objects.filter(category_id=49)        
        serializer = ChatMessageSerializer(employee, many=True)
        print(serializer.data)
        return Response(serializer.data)                                                                 
@login_required(login_url='login')          
def employee_list(request):
    api_url = 'http://localhost:8000/myemployee/'
    response = requests.get(api_url)
    employees = response.json()
    print("all_employees here")
    print(employees)
    return render(request, 'employee_list.html', {'employees': employees})
         
def aidashboard_list(request):
    aiitems = Chatcategory.objects.all()
    print(aiitems)
    context = {'items': aiitems}
    print(context)
    return render(request, 'aidashboard_list.html', {'items': aiitems})

def chatdashboard_list(request):
    items = Category.objects.all()
    print(items)
    context = {'items': items}
    print(context)
    return render(request, 'chat_dashboard_list.html', context)

def employee_form(request, id=0):
    if request.method == "GET":
        if id == 0:
            form = EmployeeForm()
        else:
            employee = Employee.objects.get(pk=id)
            form = EmployeeForm(instance=employee)
        return render(request, "employee_form.html", {'form': form})
    else:
        if id == 0:
            form = EmployeeForm(request.POST)
        else:
            employee = Employee.objects.get(pk=id)
            form = EmployeeForm(request.POST,instance= employee)
        if form.is_valid():
            form.save()
        return redirect('/employee')

def recipe_detail(request, id):           
    recipe = Recipe.objects.get(pk=id)
    field_value = recipe.nutrition
    my_string = recipe.about
    my_string = my_string[2:]
    my_string = my_string[:-2]
    print(field_value)
    field_values = [getattr(recipe, field.name) for field in recipe._meta.fields]
    print("value ka name aata hai")
    print(field_values)
    field_recipe = recipe.recipe_about
    parsed_message = field_recipe.split("\n")
    
    rows = Recipe.objects.all() 
    split_data = [item.split(':') if ':' in item else item for item in field_value]
    print(split_data)
    return render(request, 'openai/dashboard.html', {'recipe': recipe,'nutrition': split_data,'text': my_string,'data': rows,'field_recipe': parsed_message})           
    
    
@csrf_exempt
def recipe_form(request):
    if request.method == 'POST':
        
            name = request.POST.get('name')
            amount=request.POST.get('amount')
            input="tell me about recipe of"
            about="tell me about"
            nutrition="Generate nutrition values for a"
            user_input = about + " " + name
            about_recipe = input + " " +  name
            nutrition_value = nutrition + " " +  name

            data = {
                'name': user_input,
                'amount':request.POST.get('amount')            
            }

            # Print all the request data
            print('Request Data:', data)
            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
            response_about = openai.Completion.create(
                engine='text-davinci-003',
                prompt=about_recipe,
                max_tokens=350,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )
            response_nutrition = openai.Completion.create(
                engine='text-davinci-003',
                prompt=nutrition_value,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices and response_about.choices and response_nutrition.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                parsed_message = generated_message.split("\n")               

                generated_message_about = response_about.choices[0].text.strip()

                generated_message_nutrition = response_nutrition.choices[0].text                
                parsed_message_nutrition = generated_message_nutrition.split("\n")
                
                context = {'paneer': parsed_message,'paneer_about': generated_message_about,'paneer_nutrition': parsed_message_nutrition}
              
                print(parsed_message_nutrition)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

                
            
            chat_message = Recipe(name=name,message=user_input,about_message=about_recipe,recipe_about=generated_message_about,nutrition_message=nutrition_value,amount=amount, about=parsed_message,nutrition=parsed_message_nutrition)
            chat_message.save()
           

            rows = Recipe.objects.all()
            
            print(rows)

            return redirect('/dashboard')
            # return render(request, 'openai/dashboard.html', {'data': rows})
   
@csrf_exempt
def mysentiment_form(request):
    if request.method == 'POST':                    
            name = request.POST.get('name') 
            print('mysentiment_form')
            print(name)
            chat_message = predict_sentiment(sentiments=name)
            chat_message.save()           
            return redirect('/sentiment')

def sentiment_detail(request):
    rows = predict_sentiment.objects.all()
    print(rows)
    context = {'items': rows}
              
    return render(request, 'sentiment/predict_sentiment.html',context)     

def aidashboard_form(request, id=0):
    if request.method == "GET":
        if id == 0:
            form = CategoryForm()
        else:
            employee = Chatcategory.objects.get(pk=id)
            form = CategoryForm(instance=employee)
        return render(request, "aidashboard_form.html", {'form': form})
    else:
        if id == 0:
            form = CategoryForm(request.POST)
        else:
            employee = Chatcategory.objects.get(pk=id)
            form = CategoryForm(request.POST,instance= employee)
        if form.is_valid():
            form.save()
        return redirect('/aidashboard')    
@login_required(login_url='login')    
def employee_delete(request,id):
    employee = Employee.objects.get(pk=id)
    employee.delete()
    return redirect('/employee') 

def aidashboard_delete(request,id):
    employee = Chatcategory.objects.get(pk=id)
    employee.delete()
    return redirect('/aidashboard')

def dashboard(request):
    user = request.user
    api_url = 'http://localhost:8000/myemployee/'
    response = requests.get(api_url)
    myemployees = response.json()
    rows = Recipe.objects.all()            
    print(rows)   
    return render(request, 'openai/dashboard.html', {'user': user,'employee':myemployees,'data': rows})
def sentiments_dashboard(request):
   rows = predict_sentiment.objects.all()
   sentiment = Sentiment.objects.all()
   neg_sentiment = Sentiment.objects.exclude(sentiment='Positive').all()
   print(rows)
   context = {'items': rows,'sentiment': sentiment,'neg_sentiment': neg_sentiment}
   return render(request, 'sentiment/dashboard.html',context)
 
def nlp_dashboard(request):
     
    return render(request, 'nlp/dashboard.html')
def feature_dashboard(request):
     
    return render(request, 'nlp/featuredashboard.html')
def fill_maskdashboard(request):
     
    return render(request, 'nlp/filldashboard.html')
def ner_dashboard(request):
     
    return render(request, 'nlp/nerdashboard.html')
def question_dashboard(request):
     
    return render(request, 'nlp/questiondashboard.html')
def sentiment_dashboard(request):
     
    return render(request, 'nlp/sentimentdashboard.html')
def summarization_dashboard(request):
     
    return render(request, 'nlp/summarizationdashboard.html')

def text_gen_dashboard(request):
     
    return render(request, 'nlp/textgendashboard.html')
def translation_dashboard(request):
     
    return render(request, 'nlp/translationdashboard.html')
def zeroshot_dashboard(request):
    data = pd.read_csv('data/classification.csv')
    X = data['goal']
    y = data['label']
    unique_classes = y.unique()
    table_html = data.to_html(classes='table table-striped')
    print("unique_classes data aayega na")
    print(unique_classes)
    vectorizer = TfidfVectorizer()
    X_vectorized = vectorizer.fit_transform(X)
    X_train, X_test, y_train, y_test = train_test_split(X_vectorized, y, test_size=0.2, random_state=42, stratify=y)
    print(y_train.value_counts())
    print(y_test.value_counts())
    model = LogisticRegression()
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    print("y_pred aayega")
    print(y_pred)
    report = classification_report(y_test, y_pred)
    print(report)
    return render(request, 'nlp/zeroshotdashboard.html', {'report': report,'table_html':table_html})
 
@csrf_exempt
def Vr_fitness_idea_generator(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0.6,
                top_p=1.0,
                frequency_penalty=1,
                presence_penalty=1,
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=40
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/Vr_fitness_idea_generator.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/Vr_fitness_idea_generator.html', {'form': form})

@csrf_exempt
def notes_to_summary(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=40
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/notes_to_summary.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/notes_to_summary.html', {'form': form})
@csrf_exempt
def parse_unstructured_data(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

            category=9
            # Save the user input and generated response to the database
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/parse_unstructured_data.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/parse_unstructured_data.html', {'form': form})

@csrf_exempt
def classification(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=10
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/classification.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/classification.html', {'form': form})

@csrf_exempt
def python_to_natural_language(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=11
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/python_to_natural_language.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/python_to_natural_language.html', {'form': form})

@csrf_exempt
def movie_to_emoji(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.8,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=12
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/movie_to_emoji.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/movie_to_emoji.html', {'form': form})

@csrf_exempt
def calculate_time_complexity(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'
            category=13
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/calculate_time_complexity.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/calculate_time_complexity.html', {'form': form})

@csrf_exempt
def translate_programming_language(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=14
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/translate_programming_language.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/translate_programming_language.html', {'form': form})

@csrf_exempt
def advanced_tweet_classifier(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=15
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/advanced_tweet_classifier.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/advanced_tweet_classifier.html', {'form': form})

@csrf_exempt
def explain_code(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=16
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/explain_code.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/explain_code.html', {'form': form})

@csrf_exempt
def keywords(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.8,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=17
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/keywords.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/keywords.html', {'form': form})

@csrf_exempt
def factual_answering(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']
            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'
            category=18
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/factual_answering.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/factual_answering.html', {'form': form})

@csrf_exempt
def ad_form_product_description(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=100,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'
            category=19
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/ad_form_product_description.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/ad_form_product_description.html', {'form': form})

@csrf_exempt
def summarization(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=1,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=21
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/summarization.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/summarization.html', {'form': form})

@csrf_exempt
def python_bug_fixer(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=182,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0

            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=22
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/python_bug_fixer.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/python_bug_fixer.html', {'form': form})

@csrf_exempt
def spreadsheet_creator(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=23
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/spreadsheet_creator.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/spreadsheet_creator.html', {'form': form})

@csrf_exempt
def java_script_helper_chat_bot(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=24
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/java_script_helper_chat_bot.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/java_script_helper_chat_bot.html', {'form': form})

@csrf_exempt
def mi_language_model_tutor(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=25
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/mi_language_model_tutor.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/mi_language_model_tutor.html', {'form': form})

@csrf_exempt
def science_fiction_book_list_maker(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=200,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.52,
                presence_penalty=0.5
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=26
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/science_fiction_book_list_maker.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/science_fiction_book_list_maker.html', {'form': form})

@csrf_exempt
def tweet_classifier(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
          
            response = openai.Completion.create(
               model="text-davinci-003",
                prompt="The new update of the app is terrible. It's full of bugs and crashes frequently. #disappointed:",
                temperature=0,
                max_tokens=60,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )
            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=27
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/tweet_classifier.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/tweet_classifier.html', {'form': form})

@csrf_exempt
def airport_code_extractor(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=28
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/airport_code_extractor.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/airport_code_extractor.html', {'form': form})

@csrf_exempt
def sql_request(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=29
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/sql_request.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/sql_request.html', {'form': form})

@csrf_exempt
def extract_contact_information(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=30
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/extract_contact_information.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/extract_contact_information.html', {'form': form})

@csrf_exempt
def java_script_to_python(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=31
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/java_script_to_python.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/java_script_to_python.html', {'form': form})

@csrf_exempt
def friend_chart(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=32
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/friend_chart.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/friend_chart.html', {'form': form})

@csrf_exempt
def mood_to_color(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=33
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/mood_to_color.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/mood_to_color.html', {'form': form})

@csrf_exempt
def write_a_python_doc_string(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=34
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/write_a_python_doc_string.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/write_a_python_doc_string.html', {'form': form})

@csrf_exempt
def analogy_maker(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=35
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/analogy_maker.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/analogy_maker.html', {'form': form})

@csrf_exempt
def java_script_online_function(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=36
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/java_script_online_function.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/java_script_online_function.html', {'form': form})

@csrf_exempt
def micro_horror_story_creator(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.8,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=37
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/micro_horror_story_creator.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/micro_horror_story_creator.html', {'form': form})

@csrf_exempt
def third_person_convertor(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=38
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/third_person_convertor.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/third_person_convertor.html', {'form': form})
@csrf_exempt
def eassy_outline(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=41
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/eassy_outline.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/eassy_outline.html', {'form': form})

@csrf_exempt
def recipe_creator(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=120,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=42
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/recipe_creator.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/recipe_creator.html', {'form': form})

@csrf_exempt
def marv_the_sarcastic_chat_bot(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0.5,
                top_p=0.3,
                frequency_penalty=0.5,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=44
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/marv_the_sarcastic_chat_bot.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/marv_the_sarcastic_chat_bot.html', {'form': form})

@csrf_exempt
def turn_by_turn_direction(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0.3,
                top_p=0.3,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'
            category=45
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()
            return render(request, 'chatbot/turn_by_turn_direction.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/turn_by_turn_direction.html', {'form': form})

@csrf_exempt
def reastaurant_review_creator(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=64,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=46
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/reastaurant_review_creator.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/reastaurant_review_creator.html', {'form': form})

@csrf_exempt
def create_study_notes(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0.3,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'

        
            category=47
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/create_study_notes.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/create_study_notes.html', {'form': form})
@csrf_exempt
def interview_Question(request):
    if request.method == 'POST':
        form = ChatForm(request.POST)
        if form.is_valid():
            user_input = form.cleaned_data['message']

            # Make a request to ChatGPT using the OpenAI library
            openai.api_key = settings.OPENAI_API_KEY
            response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=150,
                temperature=0.5,
                top_p=1.0,
                frequency_penalty=0.0,
                presence_penalty=0.0
            )

            if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
            else:
                print('data else choices')
                generated_message = 'Failed to generate response'
        
            category=48
            chat_message = ChatMessage(message=user_input, generated_message=generated_message,category_id=category)
            chat_message.save()

            return render(request, 'chatbot/interview_Question.html', {'form': form, 'generated_message': generated_message})
    else:
        form = ChatForm()

    return render(request, 'chatbot/interview_Question.html', {'form': form})
def assistant_chat(request):
   context = {}

   if request.method == 'POST':
        message = request.POST['message']
        context['message'] = message

        # Retrieve previous chat messages from session or initialize an empty list
        chat_history = request.session.get('chat_history', [])

        # Append the user's message to the chat history
        chat_history.append({'role': 'user', 'content': message})

        # Prepare the messages for the OpenAI API
        messages = [{'role': 'system', 'content': message}]

        for chat in chat_history:
            messages.append({'role': chat['role'], 'content': chat['content']})

        # Call the GPT Chat API to generate a response
        response = get_chat_response(messages)

        # Append the AI's response to the chat history
        chat_history.append({'role': 'assistant', 'content': response})

        # Store the updated chat history in the session
        request.session['chat_history'] = chat_history

        context['response'] = response

    # Retrieve the chat history from the session or initialize an empty list
   chat_history = request.session.get('chat_history', [])

   context['chat_history'] = chat_history

   return render(request, 'chatbot/assistant_chat.html', context)
def get_chat_response(messages):
    response = openai.Completion.create(
        engine='text-davinci-003',
        messages=messages,
        max_tokens=50,
        temperature=0.7,
    )
    return response.choices[0].text.strip()

def fillmask_form(request):
    # Retrieve the input text from the POST request
    fill_mask_pipeline = pipeline("fill-mask")
    input_text = request.POST.get('name')
    static_word = "<mask>"
    concatenated_word = input_text + " " + static_word
    # Load the tokenizer
    predictions = fill_mask_pipeline(concatenated_word)
    print(predictions)
    # Process the results
    
    context = {
        'input_text': input_text,
        'predictions': predictions
    }

    # Return the predictions as a JSON response
    return render(request, 'nlp/filldashboard.html', context)
def ner_form(request):
    # Retrieve the input text from the POST request
    ner_pipeline = pipeline("ner", grouped_entities=True)
    input_text = request.POST.get('name')

    # Load the tokenizer
    predictions = ner_pipeline(input_text)
    processed_predictions = []
    current_entity = None
    current_full_word = ""

    for prediction in predictions:
        word = prediction['word']
        entity = prediction['entity_group']
        score = prediction['score']

        if word.startswith('##') or word.startswith(' '):
            current_full_word += word[2:]
        else:
            if current_entity and current_full_word:
                processed_predictions.append({'entity': current_entity, 'word': current_full_word})
            current_entity = entity
            current_full_word = word

    # Append the last word if it exists
    if current_entity and current_full_word:
        processed_predictions.append({'entity': current_entity, 'word': current_full_word})
    # Process the results
        print(processed_predictions)

        entity_types = list(set(entry['entity'] for entry in processed_predictions))
    context = {
        'input_text': input_text,
        'entity_data': entity_types,
        'predictions': processed_predictions
    }

    # Return the predictions as a JSON response
    return render(request, 'nlp/nerdashboard.html', context)
def question_form(request):
    if request.method == 'POST':
        # Get the input text from the POST request
        text = request.POST['context']
        question = request.POST['name']

        # Load the pre-trained question answering model
        model = pipeline('question-answering', model="distilbert-base-uncased-distilled-squad", tokenizer="distilbert-base-uncased")

        # Perform question answering on the input text
        answer = model(question=question, context=text)

        # Render the result in the template
        return render(request, 'nlp/questiondashboard.html', {'answer': answer,'context': text,'question': question})

    # Render the initial form
    return render(request, 'nlp/questiondashboard.html')


def sentiment_form(request):
    # Load the pre-trained tokenizer and model
    tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
    model = AutoModelForSequenceClassification.from_pretrained("bert-base-uncased")

    # Get the input text from the request
    input_text = request.POST['name']

    # Tokenize the input text
    tokens = tokenizer.tokenize(input_text)
    input_ids = tokenizer.convert_tokens_to_ids(tokens)

    # Create an input tensor
    input_tensor = torch.tensor([input_ids])

    # Make predictions
    output = model(input_tensor)
    probabilities = F.softmax(output[0], dim=1)
    predicted_class = torch.argmax(probabilities, dim=1)
    predicted_label = predicted_class.item()

    # Map the predicted label to sentiment
    sentiment_map = {0: 'negative', 1: 'neutral', 2: 'positive'}
    predicted_sentiment = sentiment_map[predicted_label]

    # Prepare the response
    context = {
        'input_text': input_text,
        'predicted_sentiment': predicted_sentiment
    }
    return render(request, 'nlp/sentimentdashboard.html', context)
# def summarize_form(request):
#     # Load the pre-trained tokenizer and model
#     # Load the pre-trained tokenizer and model
#     tokenizer = AutoTokenizer.from_pretrained("t5-base", model_max_length=4096)
#     model = AutoModelForSeq2SeqLM.from_pretrained("t5-base")

#     # Get the input text from the request
#     input_text = request.POST['name']

#     # Tokenize the input text
#     inputs = tokenizer.encode("summarize: " + input_text, return_tensors="pt", max_length=512, truncation=True)

#     # Generate the summary
#     summary_ids = model.generate(inputs, max_length=150, num_beams=4, early_stopping=True)
#     summary = tokenizer.decode(summary_ids[0], skip_special_tokens=True)
#     print("summary is there see")
#     print(summary)
#     # Prepare the response
#     context = {
#         'input_text': input_text,
#         'summary': summary
#     }
#     return render(request, 'nlp/summarizationdashboard.html', context)

def summarize_form(request):
    if request.method == 'POST':
        # Get the input text from the form
        input_text =  request.POST['name']

        # Load the trained model
        # model = LinearRegression()
        model = joblib.load('data/model.pkl')

        # Load the vectorizer
        vectorizer = CountVectorizer()
        vectorizer = joblib.load('data/vectorizer.pkl')

        # Vectorize the input text
        input_vectorized = vectorizer.transform([input_text])
        print(input_vectorized)
        # Predict the summary using the trained model
     
        summary = model.predict(input_vectorized)
        print(summary)
        # Pass the input text and summary to the template for rendering
        context = {
            'input_text': input_text,
            'summary': summary[0]
        }
   
    return render(request, 'nlp/summarizationdashboard.html', context)


def textgen_form(request):
    # Load the pre-trained tokenizer and model
    # Load the pre-trained tokenizer and model
    if request.method == 'POST':
        # Get the input text from the POST request
        data = pd.read_csv('data/dataset.csv', encoding='latin-1')

        # Split the dataset into input (X) and target (y)
        X = data['article']
        y = data['highlights']

        # Step 2: Encode the target variable
        label_encoder = LabelEncoder()
        y_encoded = label_encoder.fit_transform(y)

        # Step 3: Create a vectorizer to convert text into numerical features
        vectorizer = TfidfVectorizer()
        X_vectorized = vectorizer.fit_transform(X)

        # Step 4: Train the linear regression model
        model = LinearRegression()
        model.fit(X_vectorized, y_encoded)

        # Step 5: Save the trained model and vectorizer for future use
        joblib.dump(model, 'data/model.pkl')
        joblib.dump(vectorizer, 'data/vectorizer.pkl')



        text = request.POST['name']

        # Load the pre-trained text generation model
        model = pipeline('text-generation')

        # Generate text based on the input text
        generated_text = model(text, max_length=100, num_return_sequences=1)

        # Extract the generated text from the response
        generated_text = generated_text[0]['generated_text']

        # Render the result in the template
        return render(request, 'nlp/textgendashboard.html', {'generated_text': generated_text})
    
def translation_form(request):
    # Load the pre-trained tokenizer and model
    # Load the pre-trained tokenizer and model
    if request.method == 'POST':
        # Get the input text and target language from the POST request
        text =  request.POST['name']

        # Perform translation using the pre-trained translation model
        translation = pipeline("translation_en_to_fr")
        translated_text = translation(text, max_length=50)[0]["translation_text"]

        # Perform question answering using the pre-trained question answering model
        question_answering = pipeline("question-answering")
        answer = question_answering({
            "question": text,
            "context": translated_text
        })["answer"]

        # Save the translation and answer to the zer
        

        # Pass the translated text and answer to the template
        context = {
            'translated_text': translated_text,
            'answer': answer
        }
        print("context hai naa")
        print(context)
        return render(request, 'nlp/translationdashboard.html', context)

        # Render the result in the template
# def prediction_form(request):
#     if request.method == 'POST':
#         form = CarForm(request.POST)
#         if form.is_valid():
#             cars = form.save(commit=False)
#             car=pd.read_csv('data/Cleaned_Car_data.csv')
#             print(car) 
#             x=car.drop(columns='Price')
#             y=car['Price']            
#             my=x.info()
#             print(my)
#             x = x.drop('Unnamed: 0', axis=1)               
#             print('cleaned data x target')
#             z=x.info()
#             print(z)
#             X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=0.2)
#             ohe = OneHotEncoder()
#             encoded_data = ohe.fit_transform(x[['name','company','fuel_type']])

            
#             column_trans = make_column_transformer((OneHotEncoder(categories=ohe.categories_),['name','company','fuel_type']),
#                                     remainder='passthrough')

#             # Define the pipeline
#             lr  =LinearRegression()
#             pipe=make_pipeline(column_trans,lr)

#             pipe.fit(X_train, y_train)
#             y_pred=pipe.predict(X_test)
#             r2_score(y_test,y_pred)

#             scores=[]
#             for i in range(1000):
#                 X_train,X_test,y_train,y_test=train_test_split(x,y,test_size=0.1,random_state=i)
#                 lr=LinearRegression()
#                 pipe=make_pipeline(column_trans,lr)
#                 pipe.fit(X_train,y_train)
#                 y_pred=pipe.predict(X_test)
#                 scores.append(r2_score(y_test,y_pred))  
#                 my_score=np.argmax(scores) 
#                 scores[np.argmax(scores)]
                
            
#                 input_data = ['Maruti Suzuki Swift', 'Maruti', 2019, 100, 'Petrol']

# # Create a DataFrame with the input data
#                 pred_data = pd.DataFrame([input_data], columns=X_train.columns)
#                 # Check the shape and column indices
#                 print("Shape:", pred_data.shape)
#                 print("Column Indices:", pred_data.columns)
#                 output=pipe.predict(pd.DataFrame(columns=X_test.columns,data=np.array(['Maruti Suzuki Swift','Maruti',2019,100,'Petrol']).reshape(1,5)))    
#                 print('output data x target')
#                 print(output)
#                 X_train,X_test,y_train,y_test=train_test_split(x,y,test_size=0.1,random_state=np.argmax(scores))
#                 lr=LinearRegression()
#                 pipe=make_pipeline(column_trans,lr)
#                 pipe.fit(X_train,y_train)
#                 y_pred=pipe.predict(X_test)
#                 r2_score(y_test,y_pred)

#                 print(type(pipe))
#                 with open('data/LinearRegressionModel.pkl', 'wb') as file:
#                  pickle.dump(pipe, file)
#                 pred=pipe.predict(pd.DataFrame(columns=['name','company','year','kms_driven','fuel_type'],data=np.array(['Maruti Suzuki Swift','Maruti',2019,100,'Petrol']).reshape(1,5)))
#                 print('pred data x target')
#                 print(pred)
  

#             with open('data/LinearRegressionModel.pkl', 'rb') as file:
#              model = pickle.load(file)
#              print("model kaa prediction")
#              print(type(model))

#             company=form.cleaned_data['make']
#             car_model=form.cleaned_data['model']
#             year=int(form.cleaned_data['year'])
#             fuel_type=form.cleaned_data['fuel']
#             driven=float(form.cleaned_data['mileage'])
#             # data = pd.DataFrame({'name': [car_model], 'company': [company], 'year': [year], 'kms_driven': [driven], 'fuel_type': [fuel_type]})
#             prediction=model.predict(pd.DataFrame(columns=['name','company','year','kms_driven','fuel_type'],data=np.array([car_model,company,year,driven,fuel_type]).reshape(1,5)))
             
            
       
#             # prediction = model.predict(data)
          
#             print("prediction")
#             print(prediction)


#             # Render the result template with the predicted price
#             context = {'price': prediction}

#             return render(request, 'nlp/prediction.html', {'car': np.round(prediction[0],2)})

#     else:
#         form = CarForm()

#     return render(request, 'nlp/prediction.html', {'form': form})     


def prediction_form(request):
    if request.method == 'POST':
        form = CarForm(request.POST)
        if form.is_valid():
            cars = form.save(commit=False)
            data=pd.read_csv('data/quikr_car.csv')
            data=data[data['year'].str.isnumeric()]
            data['year']=data['year'].astype(int)
            data=data[data['Price']!='Ask For Price']
            data['Price']=data['Price'].str.replace(',','').astype(int)
            data['Price'] = data['Price'].astype(str).str.replace(',', '')
            data['Price']=data['Price'].astype(int)
            data['kms_driven']=data['kms_driven'].str.split().str.get(0).str.replace(',','')
            data=data[data['kms_driven'].str.isnumeric()]
            data['kms_driven']=data['kms_driven'].astype(int)
            data=data[~data['fuel_type'].isna()]
            data['name']=data['name'].str.split().str.slice(start=0,stop=3).str.join(' ')

            type=data.info()
            desc=data.head()
           
           
            x=data.drop(columns='Price')
            y=data['Price']            
            my=x.info()
            print(my)
                          
            print('cleaned data x target')
            z=x.info()
            print(z)
            X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=0.2)
            ohe = OneHotEncoder()
            encoded_data = ohe.fit_transform(x[['name','company','fuel_type']])

            
            column_trans = make_column_transformer((OneHotEncoder(categories=ohe.categories_),['name','company','fuel_type']),
                                    remainder='passthrough')

            # Define the pipeline
            lr  =LinearRegression()
            pipe=make_pipeline(column_trans,lr)

            pipe.fit(X_train, y_train)
            y_pred=pipe.predict(X_test)
            r2_score(y_test,y_pred)

            scores=[]
            for i in range(1000):
                X_train,X_test,y_train,y_test=train_test_split(x,y,test_size=0.1,random_state=i)
                lr=LinearRegression()
                pipe=make_pipeline(column_trans,lr)
                pipe.fit(X_train,y_train)
                y_pred=pipe.predict(X_test)
                scores.append(r2_score(y_test,y_pred))  
                my_score=np.argmax(scores) 
                scores[np.argmax(scores)]
                
            
                input_data = ['Maruti Suzuki Swift', 'Maruti', 2019, 100, 'Petrol']

# Create a DataFrame with the input data
                pred_data = pd.DataFrame([input_data], columns=X_train.columns)
                # Check the shape and column indices
                print("Shape:", pred_data.shape)
                print("Column Indices:", pred_data.columns)
                output=pipe.predict(pd.DataFrame(columns=X_test.columns,data=np.array(['Maruti Suzuki Swift','Maruti',2019,100,'Petrol']).reshape(1,5)))    
                print('output data x target')
                print(output)
                X_train,X_test,y_train,y_test=train_test_split(x,y,test_size=0.1,random_state=np.argmax(scores))
                lr=LinearRegression()
                pipe=make_pipeline(column_trans,lr)
                pipe.fit(X_train,y_train)
                y_pred=pipe.predict(X_test)
                r2_score(y_test,y_pred)
                mse = mean_squared_error(y_test, y_pred)
                print("Mean Squared Error:", mse)


               
                with open('data/LinearRegressionModel.pkl', 'wb') as file:
                 pickle.dump(pipe, file)
                pred=pipe.predict(pd.DataFrame(columns=['name','company','year','kms_driven','fuel_type'],data=np.array(['Maruti Suzuki Swift','Maruti',2019,100,'Petrol']).reshape(1,5)))
                print('pred data x target')
                print(pred)
  

            with open('data/LinearRegressionModel.pkl', 'rb') as file:
             model = pickle.load(file)
                      

            company=form.cleaned_data['make']
            car_model=form.cleaned_data['model']
            year=int(form.cleaned_data['year'])
            fuel_type=form.cleaned_data['fuel']
            driven=float(form.cleaned_data['mileage'])
            
            prediction=model.predict(pd.DataFrame(columns=['name','company','year','kms_driven','fuel_type'],data=np.array([car_model,company,year,driven,fuel_type]).reshape(1,5)))
             
            
       
            
          
            print("prediction")
            


            # Render the result template with the predicted price
            context = {'price': prediction}

            return render(request, 'nlp/prediction.html', {'car': np.round(prediction[0],2)})

    else:
        form = CarForm()

    return render(request, 'nlp/prediction.html', {'form': form}) 
@csrf_exempt
def allsentiment_form(request):
    if request.method == 'POST':
            selected_items = request.POST.getlist('selected_items')
            print("selected_items coming in the form")
            print(selected_items)
            table_data = predict_sentiment.objects.filter(id__in=selected_items)
            
            column_data = predict_sentiment.objects.filter(id__in=selected_items).values_list('sentiments','id')
            for item in column_data:
             print(item)
             value = item[1]
             print(value)
             value2=item[0]
             
             prompt="Decide whether a Tweet's sentiment is positive, neutral, or negative"
             user_input=prompt + " " + item[0]
             openai.api_key = settings.OPENAI_API_KEY
             response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=60,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
             )
            
             if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
             
                if generated_message.startswith('.'):
                 generated_message = generated_message[1:]                 
                 try:
                   instance = Sentiment.objects.get(pre_sentiment=value)
                   instance.delete()
                   chat_message = Sentiment(text=value2,sentiment=generated_message,pre_sentiment=value)
                   chat_message.save()
                 except ObjectDoesNotExist: 
                   chat_message = Sentiment(text=value2,sentiment=generated_message,pre_sentiment=value)
                   chat_message.save()
                      
                else:
                   try:                  
                    instance = Sentiment.objects.get(pre_sentiment=value)
                    instance.delete()
                    chat_message = Sentiment(text=value2,sentiment=generated_message,pre_sentiment=value)
                    chat_message.save()
                   except ObjectDoesNotExist: 
                    chat_message = Sentiment(text=value2,sentiment=generated_message,pre_sentiment=value)
                    chat_message.save() 
                # context = {'text': item,'sentiment': generated_message}
             else:
                
                print('data else choices')
                generated_message = 'Failed to generate response'            
            return redirect('/sentiment')
           
@csrf_exempt
def allsentiment_reason(request):
    if request.method == 'POST':
            selected_items = request.POST.getlist('selected_sentiment')
            print("selected_items coming in the form")
            print(selected_items)
            table_data = Sentiment.objects.filter(id__in=selected_items)
            
            print("table_data aata hai")
            for item in table_data:
             print("item aata hai")
             print(item)
             tables_data = Sentiment.objects.filter(id=item.id)
             columnone_data = Sentiment.objects.filter(id=item.id).values_list('sentiment', flat=True)
             columntwo_data = Sentiment.objects.filter(id=item.id).values_list('text', flat=True)
             positive_value = columnone_data[0]  # Access the first element using indexing
             positive_textvalue = columntwo_data[0]
             print(positive_value)
             print(columnone_data)
             print(columntwo_data)             
             prompt="Decide reason why a"
             prompt_one="in detail atleast 5 point wise in list format"
             prompt_two="is"
             user_input=prompt + " " + positive_textvalue + " " + prompt_two + " " + positive_value + " " + prompt_one
             print("user_input ka data aata hain")
             print(user_input)
             openai.api_key = settings.OPENAI_API_KEY
             response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=4000,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
             )            
             if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
                                 
                obj = Sentiment.objects.get(id=item.id)
                obj.reason = generated_message
                obj.save()
                # context = {'text': item,'sentiment': generated_message}
             else:
                print('data else choices')
                generated_message = 'Failed to generate response'
            
            return redirect('/sentiment')   
           
def allsentiment_reasondetail(request, id):           
    recipe = Sentiment.objects.get(pk=id)
    print("all recipe recipe")
    field_recipe = recipe.reason
    text = recipe.text
    sentiment = recipe.sentiment
   
    parsed_message = field_recipe.split("\n")
    print(parsed_message)

    
    return render(request, 'sentiment/sentiment_reason.html',{'data': parsed_message,'text': text,'sentiment': sentiment})
   
@csrf_exempt
def allsentiment_solution(request):
    if request.method == 'POST':
            selected_items = request.POST.getlist('selected_sentiment')
            print("selected_items coming in the form")
            print(selected_items)
            table_data = Sentiment.objects.filter(id__in=selected_items)            
            print("table_data aata hai")
            for item in table_data:
             print("item aata hai")
             print(item)
             tables_data = Sentiment.objects.filter(id=item.id)
             columnone_data = Sentiment.objects.filter(id=item.id).values_list('sentiment', flat=True)
             columntwo_data = Sentiment.objects.filter(id=item.id).values_list('text', flat=True)
             positive_value = columnone_data[0]  # Access the first element using indexing
             positive_textvalue = columntwo_data[0]
             print(positive_value)
             print(columnone_data)
             print(columntwo_data)             
             prompt="Find Solution how to improve this sentiment"
             prompt_one=" to bring positive atleast 5 point wise in list format"
             prompt_two="is"
             user_input=prompt + " " + positive_textvalue + " " + prompt_one
             print("user_input ka data aata hain")
             print(user_input)
             openai.api_key = settings.OPENAI_API_KEY
             response = openai.Completion.create(
                engine='text-davinci-003',
                prompt=user_input,
                max_tokens=4000,
                temperature=0,
                top_p=1.0,
                frequency_penalty=0.5,
                presence_penalty=0.0
             )            
             if response.choices:
                print('data 200 choices')
                generated_message = response.choices[0].text.strip()
                print(generated_message)
                                 
                obj = Sentiment.objects.get(id=item.id)
                obj.solution = generated_message
                obj.save()
                # context = {'text': item,'sentiment': generated_message}
             else:
                print('data else choices')
                generated_message = 'Failed to generate response'
            
            return redirect('/sentiment')  

def allsentiment_solutiondetail(request, id):           
    recipe = Sentiment.objects.get(pk=id)
    print("all recipe recipe")
    field_recipe = recipe.solution
    text = recipe.text
    sentiment = recipe.sentiment
   
    parsed_message = field_recipe.split("\n")
    print(parsed_message)

    
    return render(request, 'sentiment/sentiment_solution.html',{'data': parsed_message,'text': text,'sentiment': sentiment})
   
      
def sentiment_analysis_view(request):
    if request.method == 'POST':
        text = request.POST.get('text')
        sentiment = perform_sentiment_analysis(text)
        context = {'text': text, 'sentiment': sentiment}
        return render(request, 'sentiment_analysis.html', context)

    return render(request, 'sentiment/sentiment_analysis_view.html')       
    
    
    




  
