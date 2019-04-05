FROM python:3.7.3-alpine3.8
MAINTAINER Greg Damiani "gregory.damiani@gmail.com"
COPY . /app
WORKDIR /app
RUN source env/bin/activate
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python3"]
CMD ["app.py"]
