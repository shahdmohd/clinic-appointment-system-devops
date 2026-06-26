FROM python:3.12-slim

# Prevent Python from writing .pyc files and buffer logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN addgroup --system app && \
    adduser --system --ingroup app app && \
    chown -R app:app /app

USER app

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]