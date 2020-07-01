
library(shiny)
#devtools::install_github("sdumble1/ODKTools")
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Add Question Numbers To ODK"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(selectInput("main",label="Main Question type",choices=c("1,2,3,4"="numbers","a,b,c,d"="letters",
                                                                             "A,B,C,D"="LETTERS"),selected="numbers"),
        selectInput("sub",label="Sub Question type",choices=c("1,2,3,4"="numbers","a,b,c,d"="letters",
                                                              "A,B,C,D"="LETTERS"),selected="numbers"))
    ,
mainPanel(
        # Show a plot of the generated distribution
             tabsetPanel(
                 tabPanel("Upload Form",
           fileInput("file1", "Choose XLS Form File",
                      multiple = FALSE,
                      accept = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
           tableOutput("table1"),
           downloadLink('downloadData', 'Download Modified File')
            )
           ,tabPanel("View Modified Survey Sheet",tableOutput("formview"))
            )
           
        )
    )
)



# Define server logic required to draw a histogram
server <- function(input, output) {

    
infile<-reactive({ 
    inFile<-input$file1

if (is.null(inFile))
    return(NULL)
    
    inFile$datapath %>%
        read.odk() 
})


output$table1<-renderTable({
    if (is.null(infile()))
        return(NULL)
    summary(infile())
   })
    
outfile<-reactive({
        infile()    %>%
        add_question_numbers(maintype = input$main,subtype = input$sub)
    })



output$formview<-renderTable(
    outfile()$survey
)

output$downloadData <- downloadHandler(

filename = function() {
    name<-gsub(".xlsx","",basename(input$file1$name))
    
    paste(name,'_odknumbered', '.xlsx', sep='')
}
,

content = function(con) {
    write.odk(outfile(), con)
}
,contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")


}

# Run the application 
shinyApp(ui = ui, server = server)
