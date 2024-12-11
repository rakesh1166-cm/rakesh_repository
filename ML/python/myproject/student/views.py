from django.shortcuts import render, redirect
from .forms import StudentForm
from .models import Student

# Create your views here.


def student_list(request):
    context = {'student_list': Student.objects.all()}
    return render(request, "student_form/student_list.html", context)

def home_view(request):
    return render(request, 'student_form/home.html')

def student_form(request, id=0):
    if request.method == "GET":
        if id == 0:
            form = StudentForm()
        else:
            student = Student.objects.get(pk=id)
            form = StudentForm(instance=student)
        return render(request, "student_form/student_form.html", {'form': form})
    else:
        if id == 0:
            form = StudentForm(request.POST)
        else:
            student = Student.objects.get(pk=id)
            form = StudentForm(request.POST,instance= student)
        if form.is_valid():
            form.save()
        return redirect('student_list')


def student_delete(request,id):
    student = Student.objects.get(pk=id)
    student.delete()
    return redirect('student_list')