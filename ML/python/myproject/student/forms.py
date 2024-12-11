from django import forms
from .models import Student


class StudentForm(forms.ModelForm):

    class Meta:
        model = Student
        fields = ('fullname','mobile','emp_code','position','county_name','state_name','city_name')
        labels = {
            'fullname':'Full Name',
            'emp_code':'Roll. No'
        }

    def __init__(self, *args, **kwargs):
        super(StudentForm,self).__init__(*args, **kwargs)
        self.fields['position'].empty_label = "Select"
        self.fields['county_name'].empty_label = "Select"
        self.fields['state_name'].empty_label = "Select"
        self.fields['city_name'].empty_label = "Select"     
        self.fields['emp_code'].required = False