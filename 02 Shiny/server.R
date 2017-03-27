require(dplyr)
require(ggplot2)

require("jsonlite")
require("RCurl")

# Change the USER and PASS below to be your credentials. Get your password from Edit profile -> Settings -> Advanced -> Copy API Token to clipboard. Also change cannata:test-emp-and-dept to yourAccount:yourDataset.

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ",'oraclerest.cs.utexas.edu:5000/rest/native/?query="SELECT depth as Depth,cumulative_production as Production FROM `enigma-us.states.tx.rrc.oil.field-2a9f0e97ab8ae1544f0fd6fe9d3dba25` where cumulative_production!=0 and cumulative_production<200000 and depth<25000 Limit 30"')),httpheader=c(DB='jdbc:data:world:sql:mwillett:s-17-edv-project-1', USER='jadair117', PASS='eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwcm9kLXVzZXItY2xpZW50OmphZGFpcjExNyIsImlzcyI6ImFnZW50OmphZGFpcjExNzo6MDMxZGU0ODQtODJiZS00Zjg3LTg2NDAtMmQ0YTllNWRhNjA2IiwiaWF0IjoxNDkwMzEwMjI0LCJyb2xlIjpbInVzZXJfYXBpX3dyaXRlIiwidXNlcl9hcGlfcmVhZCJdLCJnZW5lcmFsLXB1cnBvc2UiOnRydWV9.d_x212tXovQTm3UTYoGgJtHMB5k83ZDALQAZiuT9RmMUJEl4Z6tzOhQXXOTkWad1zoxkD0g9DCUTHTp_RUm0Vw', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(df)+geom_point(aes(x=v_0,y=v_1,color=v_1,size=4))+theme_light()+labs(x="Reservior Depth",y="Production per Reservior")
  })
  
  output$plot2 <- renderPlot({
    brush = brushOpts(id="plot_brush", delayType = "throttle", delay = 30)
    bdf=brushedPoints(df, input$plot_brush)
    
    #View(bdf)
    if( !is.null(input$plot_brush) ) {
      df %>% dplyr::filter(v_0 %in% bdf[, "v_0"]) %>% ggplot()+geom_point(aes(x=v_0,y=v_1,color=v_1,size=4))+theme_light()+labs(x="Reservior Depth",y="Production per Reservior") + guides(size=FALSE)
    } 
  })
}

