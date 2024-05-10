#base img + install python
FROM rocker/shiny-verse:4.4.0
RUN apt-get update && apt-get install -y

#install req packages (tidyverse & shiny are included in base img)
COPY ./setup ./setup
RUN Rscript ./setup/requirements.R

#copy source files, set working dir, expose port 3838 (shifted lower to take advantage of cache)
COPY ./src/* /root/src/
WORKDIR /root/src/
EXPOSE 3838

#run app
CMD ["R", "-e", "shiny::runApp(host='0.0.0.0', port=3838)"]
