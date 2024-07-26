element_names <- list(
  "H" = "Hydrogen",
  "C" = "Carbon",
  "N" = "Nitrogen",
  "O" = "Oxygen",
  "S" = "Sulfur",
  "P" = "Phosphorus",
  "F" = "Fluorine",
  "Cl" = "Chlorine",
  "Br" = "Bromine",
  "I" = "Iodine"
  # Add other elements as needed
)

element_colors <- list(
  "H" = "#ff9999",     # Light pink for Hydrogen
  "C" = "#000000",     # Black for Carbon
  "N" = "#1f77b4",     # Blue for Nitrogen
  "O" = "#ff7f0e",     # Orange for Oxygen
  "S" = "#ffbb78",     # Yellow for Sulfur
  "P" = "#2ca02c",     # Green for Phosphorus
  "F" = "#d62728",     # Red for Fluorine
  "Cl" = "#9467bd",    # Purple for Chlorine
  "Br" = "#8c564b",    # Brown for Bromine
  "I" = "#17becf"      # Cyan for Iodine
  # Add other colors as needed
)

veggies <- c("Broccoli", "Brussel Sprouts", "Cabbage", "Cauliflower", "Kale", "Bok Choy", "Arugula", 
             "Watercress", "Radish", "Mustard")

nootroics <- c("Caffeine", "L-Theanine", "Bacopa Monnieri", "Rhodiola Rosea", "Ginkgo Biloba", "Panax Ginseng",
               "Creatine", "Omega-3 Fatty Acids", "Phosphatidylserine", "Ashwagandha", "Lion's Mane", "CPD-Choline", "Huperzine A")

chocolate <- c("Theobromine", "Caffeine", "Flavanols", "Phenylethylamine (PEA)", "Anandamide", "Tryptophan", "Serotonin", 
               "Magnesium", "Iron", "Phenolic Acids", "Lipids", "Volatile Organic Compounds")

# Define the compounds in hot peppers
Capsaicinoids <- c("Capsaicin", "Dihydrocapsaicin", "Nordihydrocapsaicin", "Homocapsaicin", "Homodihydrocapsaicin")
Carotenoids <- c("Capsanthin", "Capsorubin", "Beta-carotene", "Lutein", NA)
Flavonoids <- c("Quercetin", "Luteolin", "Apigenin", NA, NA)
Vitamins_and_Minerals <- c("Vitamin C", "Vitamin A", "Vitamin B6", "Vitamin K1", "Potassium")

# Create a DataFrame
peppers <- data.frame(Capsaicinoids, Carotenoids, Flavonoids, Vitamins_and_Minerals)

