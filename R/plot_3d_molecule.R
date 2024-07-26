plot_3d_molecule <- function(sdf, title) {
  atoms <- atomblock(sdf)
  bonds <- bondblock(sdf)
  
  # Extract coordinates
  x <- as.numeric(atoms[, 1])
  y <- as.numeric(atoms[, 2])
  z <- as.numeric(atoms[, 3])
  
  # Extract element symbols (by splitting row names)
  element_symbols <- sapply(strsplit(rownames(atoms), "_"), function(x) x[1])
  
  # Replace symbols with full names and colors
  full_element_names <- sapply(element_symbols, function(symbol) {
    element_names[[symbol]]
  })
  
  colors <- sapply(element_symbols, function(symbol) {
    element_colors[[symbol]]
  })
  
  # Extract bond indices (assuming atom indices are stored in columns 1 and 2)
  atom1_indices <- as.numeric(bonds[, 1])
  atom2_indices <- as.numeric(bonds[, 2])
  
  # Create empty lists to store bond coordinates
  bond_x <- c()
  bond_y <- c()
  bond_z <- c()
  
  # Loop through bonds to get coordinates
  for (i in 1:length(atom1_indices)) {
    bond_x <- c(bond_x, x[atom1_indices[i]], x[atom2_indices[i]], NA)
    bond_y <- c(bond_y, y[atom1_indices[i]], y[atom2_indices[i]], NA)
    bond_z <- c(bond_z, z[atom1_indices[i]], z[atom2_indices[i]], NA)
  }
  
  plot <- plot_ly(type = 'scatter3d', mode = 'markers+lines') %>%
    add_markers(x = x, y = y, z = z, text = full_element_names, marker = list(size = 8, color = colors), showlegend = FALSE) %>%
    add_trace(x = bond_x, y = bond_y, z = bond_z, type = 'scatter3d', mode = 'lines', line = list(color = 'black', width = 4), showlegend = FALSE) %>%
    layout(
      title = title,
      scene = list(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showline = FALSE, tickvals = list(), ticktext = list(), title = ""),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showline = FALSE, tickvals = list(), ticktext = list(), title = ""),
        zaxis = list(showgrid = FALSE, zeroline = FALSE, showline = FALSE, tickvals = list(), ticktext = list(), title = "")
      )
    )
  
  # Add a separate trace for each unique element to create a proper legend
  unique_elements <- unique(element_symbols)
  for (element in unique_elements) {
    element_indices <- which(element_symbols == element)
    plot <- plot %>% add_trace(
      x = x[element_indices],
      y = y[element_indices],
      z = z[element_indices],
      type = 'scatter3d',
      mode = 'markers',
      marker = list(size = 8, color = element_colors[[element]]),
      name = element_names[[element]],
      showlegend = TRUE
    )
  }
  
  plot
}

# Function to visualize a specific molecule by index
visualize_molecule <- function(index) {
  if (index > 0 && index <= length(sdfset_3d)) {
    plot_3d_molecule(sdfset_3d[[index]], "Sulphorphane")
  } else {
    cat("Invalid index. Please choose a number between 1 and", length(sdfset_3d), "\n")
  }
}