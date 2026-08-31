FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN addgroup --system app && adduser --system --ingroup app app

COPY app/ .

ENV SECRET_KEY=dummy-secret \
    DEBUG=False \
    ALLOWED_HOSTS=* \
    DATABASE_NAME=dummy \
    DATABASE_USER=dummy \
    DATABASE_PASSWORD=dummy \
    DATABASE_HOST=dummy \
    DATABASE_PORT=5432

RUN python manage.py collectstatic --noinput

RUN chown -R app:app /app
USER app

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]