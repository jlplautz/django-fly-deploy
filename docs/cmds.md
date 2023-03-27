mkdir django-fly-deploy
cd django-fly-deploy
pyenv local
pyenv local 3.11.0
python -m venv .venv --upgrade-deps
source /home/plautz/VSCProjects/django-fly-deploy/.venv/bin/activate
pip install django 
django-admin startproject fly .
code .
source /home/plautz/VSCProjects/django-fly-deploy/.venv/bin/activate
mng runserver
mng migrate
flyctl
fly auth login
source /home/plautz/VSCProjects/django-fly-deploy/.venv/bin/activate
pip freeze > requirements.txt

flyctl auth login
mng runserver
pip install gunicorn
pip freeze > requirements.txt
flyctl 
fly deploy
fly open

# Para fazer o lanch do projeto com FLY
  -  necessario ter o requirements.txt no projeto 
  - fly lanch
     - choose a app name : django-fly
     - choose a region   : São Paulo
     - would you like to set up a Postgresql : yes
     - selecter configuration: Development - Single node, 1x CPU, 256 MB Ran, 1GB disk
     - would you like to set up a upstash Redis ...: n

  - foi criado arquivo fly.toml, e um Dockerfile

     - execute fly deploy
     - execute fly open


# inserir no setting o parametro ALLOWED_HOSTS com python-decouple + database
  - from decouple import config, Csv
  - from dj_database_url import parse as db_url

  - SECRET_KEY = config('SECRET_KEY')
  - DEBUG = config('DEBUG', cast=bool, default=False)
  - ALLOWED_HOSTS = config('ALLOWED_HOSTS', cast=Csv, default='localhost',)

  - DATABASES = {
    'default': config(
        'DATABASE_URL',
        default='sqlite:///' + str(BASE_DIR / 'db.sqlite3'),
        cast=db_url
        )
    }   

    pip install python-decouple
    pip freeze > requirements.txt  


# criar o file .env na raiz do projeto 3 tambem o 
    SECRET_KEY=inserir a senha real
    DEBUG=True
    ALLOW_HOSTS=localhost,

# .env.example
    SECRET_KEY=secret
    DEBUG=True
    ALLOW_HOSTS=localhost,  

# criar o file gitignore


# verificar o fly secrets
╰─$ fly secrets list
Update available 0.0.495 -> v0.0.496.
Run "flyctl version update" to upgrade.
NAME            DIGEST                  CREATED AT           
ALLOWED_HOSTS   44885bdf1801317e        2022-12-28T23:23:06Z
DATABASE_URL    24e2cba73b389ac0        2022-12-14T23:02:08Z
SECRET_KEY      e1ed7aacc1049d5c        2022-12-14T22:44:49Z

Obs: o valor real não é mostrado 

╰─$ fly secrets set ALLOWED_HOSTS=django-fly-jlp.fly.dev,       
Update available 0.0.437 -> v0.0.441.
Run "flyctl version update" to upgrade.
Release v5 created
==> Monitoring deployment

Obs> toda vez que executa um secret ocorre a atualizaçã da imagem

# settings
https://fly.io/docs/reference/secrets/
https://djecrety.ir/ # para gerar senha


pip install python-decouple
pip freeze > requirements.txt

# arquivos statics


# Criar fly token , depois de criado fazer o acesso
fly ssh console -t <inserir o token>

7d_BQISp6GfP8IU_5E12nbKbV5MeXsEFyLRvybdS6sU
7d_BQISp6GfP8IU_5E12nbKbV5MeXsEFyLRvybdS6sU
7d_BQISp6GfP8IU_5E12nbKbV5MeXsEFyLRvybdS6sU

# para fazer acesso ssh ao console do fly

    ╰─$ fly ssh console -t 7d_BQISp6GfP8IU_5E12nbKbV5MeXsEFyLRvybdS6sU
    Update available 0.0.495 -> v0.0.496.
    Run "flyctl version update" to upgrade.
    Connecting to fdaa:0:fcdb:a7b:70:849b:cadb:2... complete
    # ls -la
# conectado na maquina entrar  na diretorio /code


#  Nas versões mais novas do Django precisa configurar o CSRF settings

CSRF_TRUSTED_ORIGINS = ["https://django-fly-jlp.fly.dev"]



# .dockerignore tem um padrao na para ser copiado
-> https://github.com/GoogleCloudPlatform/getting-started-python/blob/main/optional-kubernetes-engine/.dockerignore

Copiar e colocar na raiz do projeto e adicionar o .env


# para fazer o migrate no fly inserir no fly.toml
    [deploy]
    release_command = "python manage.py migrate --noinput" 


# para criar o superuseradmin no fly é necessario

# para criar acess token no https://fly.io/user/personnal_access_tokens -> create token


# CMD para criar uma imagem + um container docker 
  ## cria a imagem
     - docker build -t devpro .
  ## cria o containewr docker
  - docker run --rm -p 8000:8000 -e SECRET_KEY=secret ALLOWED_HOSTS=localhost, devpro

# para executar script bash
#!/bin/bash
set -euxo pipefail # se um deste cmds abaixa falhar o script sera abortado
python manage.py collectstatic --noinput
gunicorn --bind :8000 --works 2 fly.wsgi


# opção com a lib whitenoise
  - pip install whitenoise
  - pip freeze > requirements.txt
  - comentar no fly.toms
    # [[statics]]
    # guest_path = "/code/public"
    # url_prefix = "/static"
  - instalar o middleware
    -"whitenoise.middleware.WhiteNoiseMiddleware",
    # deve ficar abixo o django.middleware
    MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    # inserir STATICFILES_STORAGE
    STATIC_ROOT = BASE_DIR / "public"
    STATIC_URL = 'static/'
    STATICFILES_STORE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'


# Para automatizar atraves de um template
https://cookiecutter.readthedocs.io/en/stable/



# Procedimento para criar o projeto no github
  - criar o project no github
    - especificar o nome
    - Descrição
    - como o prjeto esta pronto no VSCode não vamos criar gitignore e licença
    - . . . or create a new repository on the command line

      echo "# django-fly-deploy" >> README.md
      git init
      git config --global init.defaultBranch main
      git add README.md
      git commit -m "first commit"
      git branch -M main
      git remote add origin git@github.com:jlplautz/django-fly-deploy.git
      git push -u origin main



# Criar o file github actions
  - name: Django CI

    on:
      push:
        branches: [ "main" ]
      pull_request:
        branches: [ "main" ]

    jobs:
      build:

        runs-on: ubuntu-latest
        env:
          DATABASE_URL: postgres://jlplautz:lingara@postgres:5432/db_fly

        services:
          postgres:
            image: postgres
            env:
              POSTGRES_PASSWORD: lingara
              POSTGRES_USER: jlplautz
            options: >-
              --health-cmd pg_isready
              --health-interval 10s
              --health-timeout 5s
              --health-retries 5
            ports:
              - 5432:5432    
        
        steps:
        - uses: actions/checkout@v3
        - name: Set up Python 3.11.0
          uses: actions/setup-python@v3
          with:
            python-version: '3.11.0'
        - name: Install Dependencies
          run: |
            python -m pip install --upgrade pip
            pip install -r requirements.txt
        - name: Setup .env
          run: cp .env.example .env
        - name: Run Tests
          run: |
            python manage.py test


# No setting do project no github
  - Secrets and variables -> Actions secrets / New secret
  (.venv) ╭─plautz@ProBook-6470b ~/VSCProjects/django-fly-deploy ‹main› 
          ╰─$ fly auth token         
          <secret token> copy / paste no github

## criar uma pagina inicial
  - criar uma app
    - mng startapp core
  - inserir a app no settings.py -> INSTALLED_APPS
  - criar file core/urls.py
    - from django.urls import path
      from . import views

      urlpatterns = [
          path('', views.home)
      ]
  - criar a fiunção na views
    - from django.http import HttpResponse
      from django.shortcuts import render
 
      # Create your views here.
      def home(request):
          return HttpResponse('Django Fly')

## criar um teste
  - from django.test import TestCase
    class TestPages(TestCase):
        def test_home(self):
            response = self.client.get('/')
            self.assertEquals(response.status_code, 200)