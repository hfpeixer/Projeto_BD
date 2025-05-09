from django.contrib import admin
from .models import Projeto, Beneficiario, Confrontante, Vertice


@admin.register(Projeto)
class ProjetoAdmin(admin.ModelAdmin):
    list_display = ['nome', 'endereco', 'area', 'perimetro']


@admin.register(Beneficiario)
class BeneficiarioAdmin(admin.ModelAdmin):
    list_display = ['nome', 'cpf_cnpj', 'projeto']
    list_filter = ['projeto']


@admin.register(Confrontante)
class ConfrontanteAdmin(admin.ModelAdmin):
    list_display = ['nome', 'cpf_cnpj', 'direcao', 'projeto']
    list_filter = ['projeto', 'direcao']


@admin.register(Vertice)
class VerticeAdmin(admin.ModelAdmin):
    list_display = ['de_vertice', 'para_vertice', 'longitude', 'latitude',
                    'distancia', 'confrontante', 'confrontante_texto', 'projeto']
    list_filter = ['projeto']
