from django import forms
from .models import Employee
from .models import Category
from .models import Recipe
from .models import Chatcategory,Car


class EmployeeForm(forms.ModelForm):

    class Meta:
        model = Employee
        fields = ('fullname','mobile','emp_code','position')
        labels = {
            'fullname':'Full Name',
            'emp_code':'EMP. Code'
        }

    def __init__(self, *args, **kwargs):
        super(EmployeeForm,self).__init__(*args, **kwargs)
        self.fields['position'].empty_label = "Select"
        self.fields['emp_code'].required = False
class RecipeForm(forms.ModelForm):
    class Meta:
        model = Recipe
        fields = ('name','amount')
        labels = {
            'name':'Name',
            'amount':'Amount'
        }
class CarForm(forms.ModelForm):
    class Meta:
        model = Car
        fields = ['make', 'model', 'year','fuel', 'mileage']
class CategoryForm(forms.ModelForm):

    class Meta:
        model = Chatcategory
        fields = ('name','category')
        labels = {
            'name':'Application Name',
            'category':'Category'
        }

    def __init__(self, *args, **kwargs):
        super(CategoryForm,self).__init__(*args, **kwargs)
        self.fields['category'].empty_label = "Select"
       
        
class ChatForm(forms.Form):
    message = forms.CharField(label='Message',widget=forms.Textarea(attrs={'id': 'my-textarea','maxlength': '1000','class': 'centered-textarea',
            'style': 'height: 300px; width: 500px; margin-left: 2%;'}))

class Question_Analysis_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Grammer_Correction_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Summarize_Gender_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Text_Command_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class English_Translate_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Natural_Language_stripe_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  




class Vr_fitness_idea_generator_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Notes_to_summary_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Parse_unstructured_data_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Classification_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Python_to_natural_language_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  



class Movie_to_emoji_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Calculate_time_complexity_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Translate_programming_language_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Advanced_tweet_classifier_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Explain_code_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  
class Keywords_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Factual_answering_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Ad_form_product_description_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Summarization_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Python_bug_fixer_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  
class Spreadsheet_creator_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Java_script_helper_chat_bot_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Mi_language_model_tutor_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Science_fiction_book_list_maker_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Tweet_classifier_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  


class Airport_code_extractor_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Sql_request_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Extract_contact_information_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Java_script_to_python_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Friend_chart_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  
class Mood_to_color_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Write_a_python_doc_string_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Analogy_maker_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Java_script_online_function_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Micro_horror_story_creator_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  
class Third_person_convertor_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Eassy_outline_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Recipe_creator_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Chat_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Marv_the_sarcastic_chat_bot_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)  
class Turn_by_turn_direction_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Reastaurant_review_creator_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Create_study_notes_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Interview_Question_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)

class Assistant_chat_Form(forms.Form):
    message = forms.CharField(label='Message', max_length=100)          




