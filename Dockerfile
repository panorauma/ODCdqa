#base img + install python (suspend lines: 4-7,11 in hosted)
FROM rocker/shiny-verse:4.4.1
RUN apt-get update && apt-get install -y 
    # python3 \
    # python3-pip \
    # python3-venv

#install req packages (tidyverse & shiny are included in base img)
COPY ./setup ./setup
RUN Rscript ./setup/requirements.R
# RUN pip3 install -r ./setup/requirements.txt

#copy source files, set working dir, expose port 3838 (shifted lower to take advantage of cache)
COPY ./src/* /root/src/
WORKDIR /root/src/
EXPOSE 3838

#run app
CMD ["R", "-e", "shiny::runApp(host='0.0.0.0', port=3838)"]
