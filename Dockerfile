# ARG PYTHON_VERSION=3.11-slim-buster

# FROM python:${PYTHON_VERSION}

# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# RUN mkdir -p /code

# WORKDIR /code

# COPY requirements.txt /tmp/requirements.txt

# RUN set -ex && \
#     pip install --upgrade pip && \
#     pip install -r /tmp/requirements.txt && \
#     rm -rf /root/.cache/

# COPY . /code/

# RUN python manage.py collectstatic --noinput



# EXPOSE 8000

# # replace demo.wsgi with <project_name>.wsgi
# CMD ["gunicorn", "--bind", ":8000", "--workers", "2", "fly.wsgi"]
ARG PYTHON_VERSION=3.11-slim-buster

FROM python:${PYTHON_VERSION}

LABEL org.opencontainers.image.source=https://github.com/jlplautz/django-fly-deploy
LABEL org.opencontainers.image.licenses=MIT

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY requirements.txt ./requirements.txt

RUN set -ex && \
    pip install -U pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . /code/

EXPOSE 8000

CMD ["gunicorn", "--bind", ":8000", "--workers", "2", "fly.wsgi"]
