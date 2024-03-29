#base img + install python
FROM rocker/shiny-verse:4.3.2
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

#install req packages (tidyverse & shiny are included in base img)
COPY ./setup ./setup
RUN Rscript ./setup/requirements.R
RUN pip3 install -r ./setup/requirements.txt

#copy source files, set working dir, expose port 3838 (shifted lower to take advantage of cache)
COPY ./src/* /root/shiny_app/
WORKDIR /root/shiny_app/
EXPOSE 3838

#run app
CMD ["R", "-e", "shiny::runApp(host='127.0.0.1', port=3838)"]
