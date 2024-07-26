get_sdf <- function(molecule_name) {
  # Fetch the compound CID from PubChem
  url <- paste0("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/", molecule_name, "/cids/TXT")
  response <- GET(url)
  cid <- content(response, "text", encoding = "UTF-8")
  cid <- gsub("\n", "", cid) # Remove newline character
  
  # Fetch the SDF file using the CID
  sdf_url <- paste0("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/", cid, "/SDF")
  sdf_response <- GET(sdf_url)
  sdf_content <- content(sdf_response, "text", encoding = "UTF-8")
  
  # Write SDF content to a temporary file
  temp_sdf_file <- tempfile(fileext = ".sdf")
  writeLines(sdf_content, temp_sdf_file)
  
  # Load the molecule from the SDF file using chemmineR
  sdfset <- read.SDFset(temp_sdf_file)
  
  # Extract the coordinates
  sdf_coords <- sdf2coord(sdfset)[[1]]
  coordinates_df <- as.data.frame(sdf_coords, stringsAsFactors = FALSE)
  colnames(coordinates_df) <- c("Atom", "X", "Y", "Z")
  
  return(coordinates_df)
}