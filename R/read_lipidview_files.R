# read_lipidview_files----------------------------------------------------------
#' Read, merge and clean txt.files, which are generated by LipidView
#'
#' @param path string. Path to your textfiles
#' @param format string
#' * "long": Default. Prints the tibble in long-format (all samples in one col)
#' * "wide": Prints the tibble in wide-format (one sample, one col)
#'
#' @return tibble. Merged textfiles into one tibble
#' @export
#'
#' @examples
#' read_lipidview_files(system.file("extdata", package = "lipidcountr"))
read_lipidview_files <- function(path, format = "long"){

  data <- path %>%
    list_txt_files() %>%
    read_txt_files() %>%
    clean_txt_files()

  if(format == "long"){
    data %>%
      tidyr::pivot_longer(
        cols = c(-species, -class, -scan_name, -mz),
        names_to = "sample",
        values_to = "intensity")
  } else if(format == "wide"){
    data
  }

}

# list_txt_files----------------------------------------------------------------
#' List files with '.txt'-pattern from given path and set names of each object
#'
#' @param path string. Path to your textfiles
#'
#' @return character vector
#' @export
#'
#' @examples
#' list_txt_files(system.file("extdata", package = "lipidcountr"))
list_txt_files <- function(path){

  list.files(path, pattern = ".txt", full.names = TRUE) %>%
    purrr::map(name_lipid_file) %>%
    unlist()
}

# name_lipid_file---------------------------------------------------------------
#' Helper function: Name a single txt.file
#'
#' @param file character. Name/path of textfile
#' @param names character vector. Vector of lipidclasses to parse out of your files
#'
#' @return character. Named version of name/path of your textfile
name_lipid_file <- function(file, names = lipid_classes){

  stringr::str_extract(file, paste0("_", names, ".txt")) %>%
    .[!is.na(.)] %>%
    stringr::str_remove("_") %>%
    stringr::str_remove(".txt")-> names(file)

  # Errormessage, if name of file is NA.
  if(is.na(names(file))){
    rlang::abort(paste0("Check filename -> ",
                        file,
                        ". Couldn't parse valid lipidname. Valid names: ",
                        paste(lipidcountr::lipid_classes, collapse = ', '),
                        ". Is your lipid class not in the list? Try 'lipid_classes <- add_lipid_class('YourLipidClass')'"
                        )
                 )
  }

  file
}

# read_txt_files----------------------------------------------------------------
#' Read (and merge) named txt.files, generated by LV
#'
#' @param files character vector. Vector of path/name from textfiles
#'
#' @return tibble
#' @export
#'
#' @examples
#' read_txt_files(system.file("extdata",
#'                             "yymmdd_XtrIL_ExampleData_SM.txt",
#'                             package = "lipidcountr"))
read_txt_files <- function(files){

  suppressWarnings(

    purrr::map_df(files,
                  readr::read_tsv,
                  col_types = readr::cols(),
                  skip = 1,
                  .id = "class")

  )

}

# clean_txt_files---------------------------------------------------------------
#' Clean up of LipidView txt.files
#'
#' @param files tibble
#'
#' @return tibble
#' @export
#'
clean_txt_files <- function(files){

  # General clean up of the LipidView dataframe:
  ## Get rid off unnecessary columns and strings, rename columns
  data <- files %>% janitor::clean_names()

  data %>%
    dplyr::filter(!stringr::str_detect(sample_name, "Sample ID")) %>%
    dplyr::select(-x2, -x3, -x4) %>%
    dplyr::rename("species" = x5,
                  "scan_name" = x6,
                  "mz" = sample_name) %>%
    dplyr::mutate(species = stringr::str_remove_all(species, "\\+NH4"),
                  species = ifelse(
                    class != species,
                    stringr::str_remove_all(species, paste0(class, " ")),
                    species
                  ),
                  scan_name = stringr::str_remove(scan_name, "\\(-FA "),
                  scan_name = stringr::str_remove(scan_name, "\\)"),
                  scan_name = stringr::str_remove(scan_name, "\\("))

}
