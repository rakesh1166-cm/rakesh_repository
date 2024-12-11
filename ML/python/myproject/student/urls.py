from django.urls import path,include
from . import views

urlpatterns = [
    path('', views.student_list,name='student_list'), # get and post req. for insert operation
    path('add', views.student_form,name='student_insert'),
    path('<int:id>/', views.student_form,name='student_update'), # get and post req. for update operation
    path('delete/<int:id>/',views.student_delete,name='student_delete'),
   
]