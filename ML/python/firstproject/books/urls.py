from django.urls import path
from .views import book_list, book_detail, book_create, book_edit, book_delete

urlpatterns = [
    path('', book_list, name='book_list'),
    path('book/<int:pk>/', book_detail, name='book_detail'),
    path('book/new/', book_create, name='book_create'),
    path('book/<int:pk>/edit/', book_edit, name='book_edit'),
    path('book/<int:pk>/delete/', book_delete, name='book_delete'),
]