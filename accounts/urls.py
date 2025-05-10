from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('logout/', views.logout_view, name='logout'),
    path('approve-users/', views.approve_users_view, name='approve_users'),
    path('', views.home_view, name='home'),
]