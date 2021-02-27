shinyUI(fluidPage(
    navbarPage("Covid immunization Strategy",
               tabPanel("About",
                        tabsetPanel(
                          tabPanel("About the Project",
                                   HTML("<p> This project was intended to look at the impact of vaccination on the number of active cases of covid 19 and the role of vaccine in beating the pandemic.</p>
                        <p>The COVID-19 spread dynamics was characterised by a few key parameters in building the simulation model. The key parameters and assumptions were: 
                        <p>(1) The infection rate parameter ‘Ro’</p>
                        <p>(2) The limit of the number of people and the vaccinated proportion in a study population could be pre-determined by the user. 
                        <p>(3) Other initial conditions including the initial number of infectious persons, the observation period (in days), and the simulation period (in days) of a simulation study.
                        <p>I have performed a simulation which is based on the infection rate mainly. The idea is to reduce the infection rate by increasing the vaccination. Currently the infection rate for covid 19 ranges between 2.2 to 2.3 which is basically the average number of people and infected person would infect. I have worked with an assumption of people working in high risk occupation have a higher infection rate than normal people if infected. Therefore if we vaccinate them first we can reduce the number of active cases by a lot and eventually reduce the total number of cases and deaths.
                        I have prepared a model that simulates the data from the start of the pandemic and it allows the user to change the conditions that it runs in or the initial situation to start with too.</p> 
                        <p>Although, there are a lot of ways to reduce the infection rate but I believe that  the population that is working in the frontline and is really required to work through the pandemic to keep things in control a bit needs to be vaccinated first. This would reduce the spread to a great extent considered the population behaves perfectly (i.e they abide by the restrictions)</p>
                        <p> The goal of this strategy (which I believe is the best one) is to reduce the number of infections eventually. If the number of new infections is reduced, the number of deaths would also go down and the situation could be controlled there after with everything getting back to normal in no time once this goal is achieved.</p>
                        <p> Once we have vaccinated the high risk occupation population, we can start vaccinating the people aged 60 and above or the people with weaker immune system due to other complications to their health in the second phase up until we reach herd immunity (i.e enough population is immune to the virus and there is no scope of spread), which according to me would mean the completion of the vaccination.
                        ") #HTML end
                                   ),
                          tabPanel("About Me",
                                              HTML("<p>I am Dakshdeep Singh. I am pursuing MSc (Statistics) from Carleton University. I have just started learning R and this is my first project in Shiny App. I have a background in Actuarial Science. You can find all the information on my Linkedin Profile, the link to which is given below.</p>"),
                                   uiOutput("Linkedin")
                          ))
                        
                        
                        
               ), #tabPanel1 ends
               
               tabPanel("Assumptions",
                        HTML("<p>Following are the assumptions that I made for the simulation:</p>
                        <p>1. The population is a closed population.</p> 
                        <p>2. Only considering spread through domestic acquisition.</p>
                        <p>3. The person gets immune immediately after getting vaccinated</p>
                        <p>4. The virus is being spread by people going to work mainly.</p>
                        <p>5. The actual number of people being infected by each of the active cases is determined by a Poisson distribution with mean Ro.</p>
                        <p>6. The exact number of days for someone getting infected follows a negative binomial distribution with the mean/expected time (parameter ‘muT’) in days.</p>
                        <p>7. We have enough vaccines to maintain a constant rate of vaccination throughout the entire process</p>
                        <p>8. The population behaviour is perfect and none of the people other than the ones working in frontline, have to go to work and are under lockdown, thus limiting any contact with others. this means that the main source of spread is the people working in occupations that are necessary to run in order to keep things in control a bit.</p>
                           "), #HTML end
                        
                        
                        
               ), # tabPanel 2 ends
               
               
               tabPanel("Simulation",
                        
                        # Application title
                        titlePanel("Immunization Strategy"),
                        
                        # Sidebar with a slider input for number of bins
                        sidebarLayout(
                          sidebarPanel(
                            fluidRow(
                              column(width = 6,
                                     h4(div(HTML("<em>Set parameters</m>"))),
                                     sliderInput("population", "Population",0,100000,10000, step = 1000, post = "people"),
                                     sliderInput("simper", "Simulation period", 0,210,100,step = 1, post = "days"),
                                     sliderInput("initi", "Number of people infected initially",1,2000,1,step = 1,post = "people"),
                                     sliderInput("vac", "Percentage of people getting vaccinated daily",0,0.5,0.01,step = 0.01)
                              ),
                              column(width = 6,
                                     sliderInput("vaceff", "Vaccine Efficacy",50,99,1,step = 0.01, post = "%"),
                                     sliderInput("hrinfrate","Infection rate with high risk occupation",3,5,3.9,step = 0.1)
                            ),
                            actionButton("goButton","Submit")
                          )),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                                plotOutput("Plot1"),
                                plotOutput("Plot2")
                            ) )
               )
               
               
    )
))

