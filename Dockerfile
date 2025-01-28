FROM  python:3.12.3-alpine3.18

WORKDIR /app

COPY requirements.txt /app/requirements.txt

COPY templates /app/templates

COPY app.py /app/app.py

RUN pip install --no-cache-dir -r requirements.txt

ENV FLASK_ENV=development

EXPOSE 81

CMD [ "python", "app.py" ]