required_packages = c("deSolve","rstudioapi","shiny","tidyverse")
need_install <- required_packages[!(required_packages) %in% installed.packages()]
if(length(need_install)>0){
  install.packages(need_install)
}
#load packages
lapply(required_packages, require, character.only = TRUE)

shinyServer(function(input, output) {
  observeEvent(input$goButton, { 
  days = input$simper     # days: observation period
  time_frame = input$simper  # time_frame: simulation period
  Ro = c(rep(input$hrinfrate,round(0.23*input$simper)+1),rep((input$hrinfrate*0.99),round(input$simper*0.072)),rep((input$hrinfrate*0.9),round(0.081*input$simper)+1),rep((input$hrinfrate*0.75),round(0.086*input$simper)+1),rep((input$hrinfrate*0.6),round(0.0953*input$simper)+1),rep((input$hrinfrate*0.5),round(0.048*input$simper)+1),rep((input$hrinfrate*0.3),round(0.143*input$simper)+1),rep((input$hrinfrate*0.2),round(0.0953*input$simper)+1),rep((input$hrinfrate*0.1),round(0.143*input$simper)+1))  # Ro = ro  # infection rate pattern
  muT = 4   #  muT  is the mean time an infected person will transmit the virus to (i.e., infect) another person (Susceptible).
  # We assume that the independence among those ones being infected.  The default value is set as muT = 4 (days).
  s = 1   # s: the dispersion parameter so that variance = mu + mu^2/size. The default value is set as s =1.
  pop= input$population   # pop: target population size
  vac_prop=0.001   # vac_prop: the proportion of people with immunity in the population
  init= input$initi   # init: the initial number of infectious persons.  
  
  # beginning of the function
  data2 = tibble("Day"=NA,"Active_cases"=NA,"Daily_New"=NA,"Total"=NA, .rows = days) %>%
    mutate(Day = c(1:days))
  set.seed(123)
  kk = atrisk = rep(0,days); nn = length(kk)   
  # kk: daily new cases; atrisk: number of active cases each day; simulation period of nn days
  tt = 0   # the cumulative total number of confirmed cases. 
  
  if(time_frame > length(Ro)) stop("The length of Ro should not be smaller than simulation period.")
  susceptibles = pop*(1-vac_prop) #susceptibles in other sense
  
  nk = init   # The initial number of existing infectious persons.  
  # there must be a first patient to kick off the transmission process! 
  for(k in 1:nk) {
    susceptibles = susceptibles - input$population*input$vac*(input$vaceff/100)  
    if(tt>susceptibles)  Ro[1]=0.001
    ni = rpois(1,Ro[1])    # how many people will be infected by this existing virus carrier person.
    imuind = sample(c(0,1), 1, prob=c((1-vac_prop),vac_prop)) #probability that the reciever of the infection was immune
    if(imuind==1) ni=0
    tt=tt+ni
    if(ni > 0) {
      tk = rep(0,ni)
      for (i in 1:ni) {
        tk[i] = rnbinom(1,size=s,mu=muT)+1  # this is the nth day on which a new case occurs
        kk[tk[i]] = kk[tk[i]] + 1
      }
      #       
      pastevent = c(rep(1,(max(tk)-1)),rep(0, (days-max(tk)+1)))
      atrisk = atrisk + pastevent   
    } # end of  if(ni > 0)
  }  # end of k loop
  #   
  
  for(j in 2:time_frame) {
    nk = kk[j-1]    # this is the number of people newly infected (i.e., new cases) on (j-1)th day
    if(nk > 0) {      
      for(k in 1:nk) {
        #   
        if(tt>susceptibles)  Ro[j]=0.001
        ni = rpois(1,Ro[j])    # how many people will be infected by this existing virus carrier person.
        imuind = sample(c(0,1), 1, prob=c((1-vac_prop),vac_prop))
        if(imuind==1) ni=0
        tt=tt+ni
        if(ni > 0) {
          tk = rep(0,ni)
          for (i in 1:ni) {
            tk[i] = rnbinom(1,size=s,mu=muT)+1+j  # this is the nth day on which a new case occurs
            kk[tk[i]] = kk[tk[i]] + 1
          }
          #       
          pastevent = c(rep(0, (j-1) ), rep(1,(max(tk)+1-j)),rep(0, (days-max(tk))))
          atrisk = atrisk + pastevent   
        } # end of  if(ni > 0)
      }  # end of k loop
    }  #  end of  if(nk > 0)
    #        
  } 
  
  
  data2[,2] = atrisk
  data2[,3] = kk
  data2[,4] = tt
  
  
  
  
  
  output$Plot1 <- renderPlot({
    
    
    if (input$goButton == 0)
      return()
    
    
    ggplot(data = data2, aes(x = Day,y = Active_cases))+geom_point()+ ylim(0,input$population/2)
    
  })
  output$Plot2 <- renderPlot({
    
    
    if (input$goButton == 0)
      return()
    
    
    ggplot(data = data2, aes(x = Day,y = Daily_New ,ylab = "daily new cases"))+geom_point()+ ylim(0,input$population/2)
  })
  })
  url2 <- a("Linkedin", href="https://www.linkedin.com/in/dakshdeep-singh-9b308a102/")
  output$Linkedin <- renderUI({
    tagList("Link:", url2)
  })
})
