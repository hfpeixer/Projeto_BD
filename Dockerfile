ARG PYTHON_VERSION=3.13-slim

FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /code

VOLUME /data

COPY requirements.txt /tmp/requirements.txt
RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/
COPY . /code

ENV SECRET_KEY "nfXjIR7WTPNm3UOqDMDmzAhFu7wBYg2iny46xFXVatyhROQqyA"
ENV DJANGO_SETTINGS_MODULE=reurb_BD.reurb_BD.settings

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn","--bind",":8000","--workers","2","reurb_BD.reurb_BD.wsgi"]
