FROM python:3.10-slim

#----------------------------#
ENV ENVIRONMENT="container"
ENV PORT=5000
ENV FQDN=locahost:{PORT}
ENV ENVSCHEME=https
ENV KEYCLOAK_URL=https://web.localhost.com/auth/
ENV CLIENT_ID=proverbs-front-client
ENV CLIENT_SECRET="changit"
ENV REALM=proverb-realm
ENV BACK_URL=http://localhost:8000
#----------------------------#


WORKDIR /code


COPY ./requirements.txt /code/requirements.txt


RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


COPY /app /code/app

EXPOSE ${PORT}

CMD ["python", "app/app.py"]

