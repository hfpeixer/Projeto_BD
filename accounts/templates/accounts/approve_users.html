from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib import messages
from django.shortcuts import render, redirect
from .models import CustomUser

# View de login
def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            if user.is_approved:
                login(request, user)
                messages.success(request, 'Login realizado com sucesso!')
                return redirect('home')
            else:
                messages.error(request, 'Sua conta ainda não foi aprovada pelo administrador.')
        else:
            messages.error(request, 'Usuário ou senha inválidos.')
    return render(request, 'accounts/login.html')

# View de cadastro
def register_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        email = request.POST['email']
        password1 = request.POST['password1']
        password2 = request.POST['password2']
        
        if password1 != password2:
            messages.error(request, 'As senhas não coincidem.')
            return render(request, 'accounts/register.html')
        
        if CustomUser.objects.filter(username=username).exists():
            messages.error(request, 'Este usuário já existe.')
            return render(request, 'accounts/register.html')
        
        if CustomUser.objects.filter(email=email).exists():
            messages.error(request, 'Este email já está em uso.')
            return render(request, 'accounts/register.html')
        
        # Criar usuário com is_approved=False
        user = CustomUser.objects.create_user(
            username=username,
            email=email,
            password=password1,
            is_approved=False
        )
        messages.success(request, 'Cadastro realizado! Aguarde a aprovação do administrador.')
        return redirect('login')
    
    return render(request, 'accounts/register.html')

# View de logout
def logout_view(request):
    logout(request)
    messages.success(request, 'Logout realizado com sucesso!')
    return redirect('login')

# View para aprovar usuários (apenas admin)
@user_passes_test(lambda u: u.is_superuser)
@login_required
def approve_users_view(request):
    if request.method == 'POST':
        user_id = request.POST.get('user_id')
        user = CustomUser.objects.get(id=user_id)
        user.is_approved = True
        user.save()
        messages.success(request, f'Usuário {user.username} aprovado com sucesso!')
        return redirect('approve_users')
    
    pending_users = CustomUser.objects.filter(is_approved=False)
    return render(request, 'accounts/approve_users.html', {'pending_users': pending_users})

# View da página inicial (após login)
@login_required
def home_view(request):
    return render(request, 'home.html')