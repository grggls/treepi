FROM python:3.7.3-alpine3.8
MAINTAINER Greg Damiani "gregory.damiani@gmail.com"
ADD requirements.txt /app/
WORKDIR /app
RUN pip3 install -r requirements.txt
ADD . /app
RUN addgroup treepi && adduser -D -G treepi -s /bin/sh treepi
USER treepi
ENTRYPOINT ["python3"]
CMD ["app.py"]
