FROM python:3.9

#----------------------------#
ENV ENVIRONMENT="container"
ENV DATABASE_URL=127.0.0.1
ENV DATABASE_PASSWORD="changit"
ENV DATABASE_USER=root
ENV DATABASE_NAME=proverbs_db
ENV SERVER_URL=http://localhost:8080/
ENV CLIENT_ID=proverbs-front-client
ENV CLIENT_SECRET="changit"
ENV REALM=proverb-realm
ENV PORT=8000
#----------------------------#


WORKDIR /code


COPY ./requirements.txt /code/requirements.txt


RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


COPY /app /code/app


CMD ["sh", "-c", "fastapi run app/main.py --port ${PORT}"]