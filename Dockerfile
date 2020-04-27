FROM python:3.8

# Create app directory
WORKDIR /usr/src/app

# Bundle Source
COPY . .

RUN apt-get update && \
    # apt-get upgrade -y && \
    apt-get install redis-server -y && \
    pip install -r requirements.txt
# If you are building your code for production
# RUN npm install --only=production

EXPOSE 3000
CMD [ "sh", "scripts/start.sh" ]