FROM python:3.8

# Create app directory
WORKDIR /usr/src/app

# Bundle Source
COPY . .

RUN apt-get update && \
    # apt-get upgrade -y && \
    apt-get install redis-server -y && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

ARG port
EXPOSE $port
CMD [ "sh", "scripts/start.sh" ]