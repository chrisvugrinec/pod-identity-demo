FROM python:3.9.0b4-alpine3.12
ADD . /code
RUN apk add --update-cache 
RUN apk add --update alpine-sdk &&\
  apk add libffi-dev openssl-dev &&\
  apk --no-cache --update add build-base
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
