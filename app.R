library(ChemmineR)
library(plotly)
library(httr)
library(rcdk)
library(shiny)

source("R/get_sdf.R")
source("R/plot_3d_molecule.R")
source("R/utils.R")

# Example data
veggies <- c("Broccoli", "Brussels Sprouts", "Cabbage", "Cauliflower", "Kale", "Bok Choy", "Arugula", "Watercress", "Radish", "Mustard Greens")
isothiocyanates <- list(
  "Broccoli" = c("Sulforaphane", "Glucoraphanin", "Phenethyl Isothiocyanate (PEITC)", "Benzyl Isothiocyanate", "Allyl Isothiocyanate"),
  "Brussels Sprouts" = c("Sulforaphane", "Phenethyl Isothiocyanate (PEITC)", "Allyl Isothiocyanate", "Benzyl Isothiocyanate (BITC)", "3-Butenyl Isothiocyanate"),
  "Cabbage" = c("Sulforaphane", "Indole-3-Carbinol (I3C)", "Phenethyl Isothiocyanate (PEITC)", "Allyl Isothiocyanate", "Benzyl Isothiocyanate", "Glucobrassicin"),
  "Cauliflower" = c("Sulforaphane", "Phenethyl Isothiocyanate (PEITC)", "Benzyl Isothiocyanate", "Allyl Isothiocyanate"),
  "Kale" = c("Sulforaphane", "Indole-3-Carbinol", "Phenethyl Isothiocyanate (PEITC)", "Benzyl Isothiocyanate", "Allyl Isothiocyanate"),
  "Bok Choy" = c("Sulforaphane", "Glucobrassicin", "Gluconapin", "Sinigrin"),
  "Arugula" = c("Erucin", "Sulforaphane"),
  "Watercress" = c("Phenethyl Isothiocyanate (PEITC)", "Sulforaphane", "Benzyl Isothiocyanate"),
  "Radish" = c("Sulforaphane", "Sulforaphene", "Allyl isothiocyanate"),
  "Mustard Greens" = c("Allyl Isothiocyanate", "Benzyl Isothiocyanate", "Phenethyl Isothiocyanate (PEITC)", "Sulforaphane")
)

nootropic_categories <- list(
  "Bacopa Monnieri" = c("Bacoside A", "Bacoside A1", "Bacoside A2", "Bacopaside I", "Bacopaside II"),
  "Rhodiola Rosea" = c("Salidroside", "Rosavin", "Rosarin"),
  "Ginkgo Biloba" = c("Quercetin", "Kaempferol", "Isorhamnetin", "Ginkgolide A", "Ginkgolide B", "Ginkgolide C", "Bilobalide"),
  "Panax Ginseng" = c("Ginsenoside Rg1", "Ginsenoside Rb1", "Ginsenoside C", "Ginsenoside B2", "Ginsenoside Rd2", "Ginsenoside Rg3", "Ginsenoside Rh1", "Ginsenoside Rh2", "Compound K"),
  "Omega-3 Fatty Acids" = c("Eicosapentaenoic Acid (EPA)", "Docosahexaenoic Acid (DHA)", "Alpha-Linolenic Acid (ALA)"),
  "Ashwagandha" = c("Withaferin A", "Withanolide A", "Withanone", "Withanolide", "Withanolide D", "Withanoside IV", "Withanoside V", "Withanolide B"),
  "Lion's Mane Mushroom" = c("Hericenone A", "Hericenone B", "Hericenone C", "Hericenone D", "Hericenone E", "Hericenone F", "Hericenone G", "Hericenone H", 
                             "Erinacine A", "Erinacine B", "Erinacine C", "Erinacine D", "Erinacine E", "Erinacine F", "Erinacine G", "Erinacine H", 
                             "Erinacine I", "Erinacine J", "Erinacine K", "Erinacine L", "Erinacine M", "Erinacine N", "Erinacine P", "Erinacine Q")
)

nootropics <- c("Caffeine", "L-Theanine", "Bacopa Monnieri", "Rhodiola Rosea", "Ginkgo Biloba", "Panax Ginseng", "Creatine", "Omega-3 Fatty Acids", "Phosphatidylserine", "Acetyl-L-Carnitine (ALCAR)", "Ashwagandha", "Lion's Mane Mushroom", "CDP-Choline (Citicoline)", "Huperzine A")

chocolate <- c("Theobromine", "Caffeine", "Phenylethylamine", "Anandamide", "Tryptophan", "Epicatechin", "Cianidanol")

peppers <- c("Capsaicin", "Dihydrocapsaicin", "Nordihydrocapsaicin", "Homocapsaicin", "Homodihydrocapsaicin")

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "lux"),
  titlePanel("Molecule Explorer"),
  tabsetPanel( type = "pills",
    tabPanel("Vegetables",
             sidebarLayout(
               sidebarPanel(
                 selectInput("veggie", "Cruciferous Vegetables", choices = veggies),
                 conditionalPanel(
                   condition = "input.veggie != ''",
                   selectInput("veggie_compound", "Compound", choices = c())
                 )
               ),
               mainPanel(
                 plotlyOutput("molecule3d_veggie")
               )
             )
    ),
    tabPanel("Nootropics",
             sidebarLayout(
               sidebarPanel(
                 selectInput("nootropic", "Nootropics", choices = nootropics),
                 conditionalPanel(
                   condition = "input.nootropic != '' && ['Bacopa Monnieri', 'Rhodiola Rosea', 'Ginkgo Biloba', 'Panax Ginseng', 'Omega-3 Fatty Acids', 'Ashwagandha', 'Lion\\'s Mane Mushroom'].includes(input.nootropic)",
                   selectInput("nootropic_compound", "Compound", choices = c())
                 )
               ),
               mainPanel(
                 plotlyOutput("molecule3d_nootropic")
               )
             )
    ),
    tabPanel("Chocolate",
             sidebarLayout(
               sidebarPanel(
                 selectInput("chocolate", "Chocolate", choices = chocolate)
               ),
               mainPanel(
                 plotlyOutput("molecule3d_chocolate")
               )
             )
    ),
    tabPanel("Peppers",
             sidebarLayout(
               sidebarPanel(
                 selectInput("peppers", "Peppers", choices = peppers)
               ),
               mainPanel(
                 plotlyOutput("molecule3d_peppers")
               )
             )
    ),
    tabPanel("Smoothie Recipe",
             h3(style = "color: #87CEEB;", "Spicy Blueberry Brain-Boost Smoothie"),
             h4("Antioxidant Protection"),
             p("The combination of anthocyanins from blueberries, sulforaphane from broccoli microgreens, and vitamins from all ingredients provide strong antioxidant protection, reducing oxidative stress in the brain."),
             h4("Neuroprotection and Cognitive Support"),
             p("Hericenones and erinacines from lion's mane, along with the anti-inflammatory properties of sulforaphane and capsaicin, support brain cell growth, protect against neurodegenerative diseases, and improve cognitive function."),
             h4("Immune Support"),
             p("The vitamins and polysaccharides from various ingredients boost the immune system, which is linked to better brain health."),
             h4("Hydration and Nutrient Delivery"),
             p("The milk base aids in the efficient delivery of nutrients to the brain by providing essential proteins and fats that facilitate nutrient absorption. The milk aslo has a cooling effect that balances the heat from the hot pepper."),
             h4("Ingredients:"),
             tags$ul(
               tags$li("1/2 cup microgreens (e.g., radish, broccoli, or mixed microgreens)"),
               tags$li("1 cup blueberries (fresh or frozen)"),
               tags$li("1 teaspoon Lion's Mane mushroom powder"),
               tags$li("A small amount of hot peppers (to taste, finely chopped or a pinch of hot pepper powder)"),
               tags$li("1 tablespoon honey (optional, for sweetness)"),
               tags$li("1 cup water or almond milk (or enough to reach desired consistency)"),
               tags$li("A handful of ice cubes (optional, for a colder smoothie)")
             ),
             h4("Instructions:"),
             tags$ol(
               tags$li("Prepare Ingredients: Wash and measure all the fresh ingredients."),
               tags$li("Blend: Add the microgreens, blueberries, yogurt, Lion's Mane mushroom powder, hot peppers, and honey (if using) into a blender. Pour in the water or almond milk. Add ice cubes if desired."),
               tags$li("Blend Until Smooth: Blend all the ingredients until smooth and creamy. Add more liquid if necessary to reach your preferred consistency."),
               tags$li("Serve: Pour the smoothie into a glass and enjoy immediately for the best taste and nutritional benefits.")
             )
            )
  )
)

server <- function(input, output, session) {
  observeEvent(input$veggie, {
    updateSelectInput(session, "veggie_compound", choices = isothiocyanates[[input$veggie]])
  })
  
  observeEvent(input$nootropic, {
    if (input$nootropic %in% names(nootropic_categories)) {
      updateSelectInput(session, "nootropic_compound", choices = nootropic_categories[[input$nootropic]])
    } else {
      updateSelectInput(session, "nootropic_compound", choices = c())
    }
  })
  
  observeEvent(input$veggie_compound, {
    if (input$veggie != "" && input$veggie_compound != "") {
      sdf_file <- paste0("data/", input$veggie_compound, ".sdf")
      sdf <- read.SDFset(sdf_file)
      output$molecule3d_veggie <- renderPlotly({
        plot_3d_molecule(sdf[[1]], title = input$veggie_compound)
      })
    }
  })
  
  observeEvent(input$nootropic, {
    if (input$nootropic != "" && !input$nootropic %in% names(nootropic_categories)) {
      sdf_file <- paste0("data/", input$nootropic, ".sdf")
      sdf <- read.SDFset(sdf_file)
      output$molecule3d_nootropic <- renderPlotly({
        plot_3d_molecule(sdf[[1]], title = input$nootropic)
      })
    } else {
      updateSelectInput(session, "nootropic_compound", choices = nootropic_categories[[input$nootropic]])
    }
  })
  
  observeEvent(input$nootropic_compound, {
    if (input$nootropic != "" && input$nootropic_compound != "") {
      sdf_file <- paste0("data/", input$nootropic_compound, ".sdf")
      sdf <- read.SDFset(sdf_file)
      output$molecule3d_nootropic <- renderPlotly({
        plot_3d_molecule(sdf[[1]], title = input$nootropic_compound)
      })
    } else if(!input$nootropic %in% names(nootropic_categories)) {
      sdf_file <- paste0("data/", input$nootropic, ".sdf")
      sdf <- read.SDFset(sdf_file)
      output$molecule3d_nootropic <- renderPlotly({
        plot_3d_molecule(sdf[[1]], title = input$nootropic)
      })
    }
  })
  
  observeEvent(input$chocolate, {
    if(input$chocolate != "") {
      sdf_file <- paste0("data/", input$chocolate, ".sdf")
      sdf <- read.SDFset(sdf_file)
      output$molecule3d_chocolate <- renderPlotly({
        plot_3d_molecule(sdf[[1]], title = input$chocolate)
      })
    }
  })
  
  observeEvent(input$peppers, {
    if(input$chocolate != "") {
      sdf_file <- paste0("data/", input$peppers, ".sdf")
      sdf <- read.SDFset(sdf_file)
      output$molecule3d_peppers <- renderPlotly({
        plot_3d_molecule(sdf[[1]], title = input$peppers)
      })
    }
  })
  
}

shinyApp(ui, server)
