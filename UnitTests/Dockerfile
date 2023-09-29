#can change to different python versions listed here: https://hub.docker.com/_/python/tags
FROM python:3.10-slim

#set working directory
WORKDIR .

#update & install
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

#copy all to container root directory
COPY . .

#install packages
RUN pip3 install -r requirements.txt