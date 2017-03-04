create_EIA_tree = function(node, key) {
  result = list(node = node, key = key)
  result
}

#' Create the start of an EIA query tree
#' 
#' @param key Your EIA API key
#' 
#' @export
trunk = function(key)
  getCatEIA(key = key) %>% 
  create_EIA_tree(., key)

#' Move through a series of branches (subcategories) in your EIA tree (category)
#' 
#' Find possible branches with \code{\link{branches}}
#' 
#' @param tree An EIA tree (category)
#' @param branch_names A list of branch (subcategory) names
#' 
#' @export
branch = function(tree, branch_names)
  if ( length(branch_names) > 0 )
    branch( single_branch(tree, branch_names[[1]] ), branch_names[-1] ) else
      tree
  
single_branch = function(tree, branch_name) {
  key = tree$key
  
  branches = tree$node$Sub_Categories
  
  if (length(branches) == 0) stop("No branches")
  
  cat = 
    branches %>%
    with(., stats::setNames(category_id, name) ) %>%
    .[branch_name] %>%
    as.character
  
  if (is.na(cat) ) stop("Branch doesn't exist") else {
    getCatEIA(key = key, cat = cat) %>%
    create_EIA_tree(., key)
  }
}

#' Find the ID number of a branch (subcategory)
#' 
#' @param tree An EIA tree
#' 
#' @export
branch_ID = function(tree) 
  tree$node$Parent_Category$text %>% 
  as.character %>% as.numeric

#' Open a leaf (dataset) in your EIA tree (category)
#' 
#' Find possible leaves (datasets) with \code{\link{leaves}}
#' 
#' @param tree An EIA tree  (category)
#' @param leaf_name The name of the leaf (dataset) to extract
#' 
#' @export
leaf = function(tree, leaf_name) {
  key = tree$key
  
  series_ids = tree$node$Series_IDs
  
  if (length(series_ids) == 0) stop("No leaves")
  
  ID = 
    series_ids %>%
    with(., stats::setNames(series_id, name) ) %>%
    .[leaf_name] %>%
    as.character
  
  if (is.na(ID) ) stop("Leaf doesn't exist")
  
  getEIA(key = key, ID = ID) %>%
    stats::setNames(leaf_name)
}

#' Find available branches (subcategories) in your EIA tree (category)
#' 
#' @param tree An EIA tree  (category)
#' 
#' @export
branches = function(tree)
  tree$node$Sub_Categories$name %>% as.character

#' Find available leaves (datasets) in your EIA tree (category)
#' 
#' @param tree An EIA tree (category)
#' 
#' @export
leaves = function(tree) tree$node$Series_IDs$name %>% as.character

frequency_name = function(letter)
  switch(letter, 
         "A" = "Annual", 
         "Q" = "Quarterly",
         "M" = "Monthly", 
         "D" = "Daily",
         "H" = "Hourly")

#' Find extra information about a leaf (dataset) in your tree (category)
#' 
#' @param tree An EIA tree (category)
#' @param leaf_name A leaf (dataset) in your tree (category)
#' 
#' @export
leaf_info = function(tree, leaf_name) {

  all_info = 
    tree$node$Series_IDs %>%
    dplyr::filter(name == leaf_name)
  
  if (length( dplyr::row_number(all_info) ) == 0) stop("Leaf doesn't exist")
  
  all_info %>%
    dplyr::select(-name) %>%
    dplyr::rename(frequency = f) %>%
    dplyr::mutate(series_id = series_id %>% as.numeric,
                  frequency = frequency %>% as.character %>% frequency_name,
                  units = units %>% as.character,
                  updated = lubridate::dmy_hms(updated) )
}
