# #package ver
library(shiny)
library(shinyjs)
library(tidyverse)
library(waiter)
library(DT)

options(shiny.maxRequestSize = 100*1024^2)
source("functions.R")

js_code <- "
shinyjs.browseURL = function(url) {
  window.open(url,'_blank');
}
"

#checks definitions
definition_check<-read.csv("checks definitions.csv")

#MARK: UI
ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(text = js_code, functions = 'browseURL'),
  useWaiter(),
  tags$style("#checkText{width: 95%; white-space: pre-wrap;
                                        word-wrap: break-word;overflow-x:visible;
                                        font-family: monospace;}"),
  
  navbarPage("Open Data Commons (ODC) data quality app (v0.1, beta)",
             tabPanel("Home",
                      tags$div(style = "width:40%; text-align: center;margin-left: auto;margin-right: auto;", 
                      class = "well",
                           tags$h3("Welcome"),
                           tags$p("This app is in beta, meaning we are still working on it! 
                                    You can use it and it should work fine for most of the cases. 
                                  But if you find a bug or have feedback, let us know at info@odc-sci.org or info@odc-tbi.org"),
                           tags$hr(),
                           tags$p("There are two main functionalities in this app,
                                  the ODC data checks and the Data explorer"),
                           tags$br(),

                           tags$p(tags$strong("ODC data checks:"), "It perform data checks to ensure minimal quality for 
                                  data publication through the ODCs"),

                      
                           tags$p(tags$strong("Data explorer:"), "It provides an interactive report of the content of your data!")
                        )
              ),
             
             tabPanel("Start Here",
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     tags$h3("Instructions"),
                                     tags$ol(
                                       tags$li("Check which ODC community the data is for.
                                     Each community has implemented slighly different checks"),
                                       tags$li("Load the .CSV file for the dataset"),
                                       tags$li("Load the .CSV file for the data dictionary"),
                                       tags$li("Move to the ODC data checker or Data explorer 
                                               tab"),
                                       tags$hr(),
                                       radioButtons("community", "ODC community:",
                                                    c("SCI" = "SCI",
                                                      "TBI" = "TBI")),
                                       fileInput("data", "Dataset (*.CSV)",
                                                 multiple = FALSE,
                                                 accept = c("text/csv",
                                                            "text/comma-separated-values,text/plain",
                                                            ".csv")),
                                       fileInput("dic", "Data dic (*.CSV)",
                                                 multiple = FALSE,
                                                 accept = c("text/csv",
                                                            "text/comma-separated-values,text/plain",
                                                            ".csv"))
                                     ),
                        ),
                        
                        mainPanel(
                          tabsetPanel(
                            id = 'dataset_tab',
                            tabPanel("Dataset", value = "dataset",
                                     div(style="overflow-x:scroll;height:95%;",
                                         DT::dataTableOutput("dataset_out"))),
                            tabPanel("Data dictionary", value = "datadic",
                                     div(style="overflow-x:scroll;height:95%;",
                                         DT::dataTableOutput("datadic_out"))),
                            tabPanel("AutoFilled Data Dictionary", value = "autodatadic",
                                     div(style="overflow-x:scroll;height:95%;",
                                         DT::dataTableOutput("altDataDict")))
                          )
                        )
                
             )),
             
             tabPanel("ODC data checks",
                      sidebarLayout(
                        sidebarPanel(tags$p("Visit the about page to get more information on the
                                     checks and the results"),
                                     tags$hr(),
                                     
                                     #tags$hr(),
                                     disabled(actionButton("checkButton", "Run checks")),
                                     tags$br(),
                                     tags$p("Once the results show up, click on each check to know more
                                            and to get tips on what to do")
                                     ,width = 3
                        ),
                        
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Check Results",
                                     DT::dataTableOutput("result_table"),
                                     tags$script("
                                        $(document).on('click','#result_table td',function(){
                                          var cellData = $(this).text();
                                          Shiny.setInputValue('selectedCell',cellData);
                                        });
                                      ")
                                     ),
                            tabPanel("Suggested Variable Name(s)",
                                     DT::dataTableOutput("suggested_varname"))
                            )
                          )
                        )
                      ),
             tabPanel("Data Explorer",
                    tags$div(style = "width:40%; text-align: center;
                    margin-left: auto;margin-right: auto;", class = "well",
                      tags$h4("Exploratory data analysis (EDA)"),
                      tags$p("By clicking the button you will generate an interactive data
                                   exploration page from the uploaded dataset and data dictionary.
                                            This process may take a while depending on the size of the dataset"),
                      tags$p("A new tab should open once the interactive page is created.
                                            You can also download the html using the download button.
                                            Once downloaded the file will be delated from the server"),
                      tags$p("Note: pop-up blockers may prevent the EDA page to show up"),
                      disabled(actionButton("profilingButton", "Generate EDA")),
                      disabled(downloadButton("profilingDownButton", "Download EDA (.html)"))
                    )
             ),
             tabPanel("About the ODC and this app",htmlOutput("about"))
  )
)

#MARK: server
# Define server logic to read selected file ----
server <- function(input, output, session) {
  dataframes <- reactiveValues()
  
  w = Waiter$new(
    html = spin_3(), 
    color = transparent(.5)
  ) # Initialize
  
  #about page
  output$about <- renderUI({
    includeHTML("./about.html")
  })
  
  ## Observe loading dataset
  observeEvent(input$data, {
    updateTabsetPanel(session, "dataset_tab",
                      selected = "dataset")
    
    dataframes$df_data <- read_csv(input$data$datapath)
    
    # names(dataframes$df_data) <- names(dataframes$df_data) %>%
    #   str_replace("[^A-z0-9._]","_")
  })
  
  ## Observe loading data dictionary
  observeEvent(input$dic,{
    updateTabsetPanel(session, "dataset_tab",
                      selected = "datadic")
    
    dataframes$df_dic <- read_csv(input$dic$datapath,
                                  col_types = cols(.default = col_character()))
    
    enable("checkButton")
    enable("profilingButton")
  })
  
  ## Render dataset to DT
  output$dataset_out <- DT::renderDataTable({
    
    req(input$data)
    
    tryCatch(
      {
        DT::datatable(dataframes$df_data,
                      # editable = TRUE,
                      extensions = 'Buttons', options = list(
                        dom = 'Blfrtip',
                        buttons = 'csv',
                        pageLength = 6
                      ))
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
  })
  
  ## render data dic to DT
  output$datadic_out <- DT::renderDataTable({
    
    req(input$dic)
    
    tryCatch(
      {
        DT::datatable(dataframes$df_dic,
                      # editable = TRUE,
                      extensions = 'Buttons', options = list(
                        dom = 'Blfrtip',
                        buttons = 'csv',
                        pageLength = 6
                      ))
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
  })
  
  ## Observe clicking on checkbutton and running the checks
  observeEvent(input$checkButton,{
    req(input$dic)
    req(input$data)
    
    #odc sci
    if(input$community == "SCI"){
      dataframes$valid<-validate_odc(dataset=dataframes$df_data,
                                     datadic=dataframes$df_dic,
                                     str_checks = "all",
                                     sch_checks = "all")
    }else{ #odc tbi
      
      #'"a" is placeholder, modify str_checks & sch_checks in functions.R
      dataframes$valid<-validate_odc(dataset=dataframes$df_data,
                                     datadic=dataframes$df_dic,
                                     str_checks = "a",
                                     sch_checks = "a")
      
      temp <- dataframes$valid$structure
    }
    
    updateTabsetPanel(session, "dataset_tab",
                      selected = "check_result")
  })
  
  ## render the results
  output$result_table <- DT::renderDT({ #convert Data check tab to DT
    req(input$checkButton)
    
    dataframes$render_checks<-render_check_table(dataframes$valid$structure, 
                                                 dataframes$valid$schema)
    
    dataframes$render_checks$table_html
  })

  #suggested varname(s)
  output$suggested_varname <- DT::renderDT({
    req(input$checkButton)
    
    #'1.unlist varname(s)
    #'2.rm duplicates
    #'3.nchar(orig_name)
    #'4.add suggested name
    #'5.nchar(suggested name)
    #'6.rename cols
    suggested_varname <- data.frame(orig_name=unlist(
        dataframes[["valid"]][["schema"]][["over_60char"]][["which_over_60char_headers"]])
      ) %>%
      dplyr::distinct() %>%
      dplyr::mutate(orig_nchar=nchar(orig_name)) %>%
      dplyr::mutate(new_name=orig_name %>%
                      str_replace_all("[^A-z0-9_.]","_") %>%
                      str_replace_all("[\\^`]","") %>%
                      str_replace_all("[\\[\\]]","") %>%
                      str_replace_all("_{2}","")) %>%
      dplyr::mutate(new_nchar=nchar(new_name))
    
    names(suggested_varname) <- c("Variable name","Variable name (# characters)",
                                  "Suggested name",'Suggested name (# characters)')
    
    suggested_varname
  })
  
  #auto generate partially filled data dict
  output$altDataDict <- DT::renderDT({
    empty_data_dict(dataframes$df_data)
  })
  
  #run profiling report
  observeEvent(input$profilingButton,{
    
    showNotification("The report is in process. This may take a few seconds or minutes",
                     closeButton =TRUE)
    
    w$show()

    # Save temporary files based on the unique session. This prevent multiple sessions to re-write
    # the temp files.

    #create temp path (will be rm when shiny closes) + recreated if no longer exists
    temp_dir <- tempdir(check=TRUE)
    filenames <- c("dataset.csv","datadic.csv")
    fullpaths <- lapply(filenames,function(x){
      paste(temp_dir,x,sep="/")
    })
    
    write.csv(dataframes$df_data,filenames[[1]],row.names=FALSE)
    write.csv(dataframes$df_dic,filenames[[2]],row.names=FALSE)
    
    #'Run ydata-profiling
    #'  run from terminal (4 total args)
    #'  temp_dir = arg[2] python is index 0
    #'  orig_filename = pass original filename into profile report
    orig_filename <- str_replace_all(input$data$name, " ", "_")
    system(paste0("python3 EDA_report.py ",temp_dir,"/ ",orig_filename))
    js$browseURL(paste0(temp_dir,"/Profile.html"))
    
    # Temp files are deleted after profiler is done
    # unlink(paste0(session$token,"dataset.csv"), force = T) # delete temp files
    # unlink(paste0(session$token,"data_dic.csv"), force = T) # delete temp files
    
    ## enable download button
    enable("profilingDownButton")
    w$hide()
  })
  
  ## action for downloading EDA profiling
  output$profilingDownButton <- downloadHandler(
    filename = "ProfileReport.html",
    content = function(file) {
      file.copy(paste0(temp_dir,"/Profile.html"),file)
      # unlink(paste0(temp_dir,"Profile.html"))
    },
    contentType = "text/html"
  )
  
  #info popup when click on check name
  observeEvent(input[["selectedCell"]], {
    #create subset to use in HTML(paste())
    index <- which(definition_check$check_label == input$selectedCell,arr.ind=TRUE)
    temp_row <- definition_check[index,]
    
    showModal(
      modalDialog(
        title = temp_row[["check_label"]],
        HTML(
          paste(
            "<p>",
              "<strong>Check name: </strong>",temp_row[["check_name"]]),"<br><br>",
              "<strong>Definition: </strong>",temp_row[["check_definition"]],"<br><br>",
              "<strong>Tip: </strong>",temp_row[["check_tip"]],
            "</p>"
          ),
        size = "m",
        easyClose = TRUE
      )
    )
  })
}

#MARK: Run app
# Run the application
shinyApp(ui = ui, server = server)
