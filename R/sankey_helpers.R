#' Extract nodes/links from a  Sankey diagram
#'
#'
#' - `get_nodes()` returns the ordered named nodes of the Sankey diagram
#'
#' - `get_links()`returns the ordered named links of the Sankey diagram.
#' @param p sankey diagram object
#'
#' @export
#'
get_nodes <- function(p){
  p$x$nodes$name
}

#' @rdname get_nodes
#' @export
get_links <- function(p){
  nodes = p |> get_nodes()
  paste0('(',nodes[p$x$links$source+1], ') -> (', nodes[p$x$links$target+1],')')
}


#' Convert a sankey diagram to a data frame
#'
#' @details
#' this function takes a sankey diagram (sankeyNetwork object) and converts the underlying data into a data frame (or list of data frames).
#'
#' @param p sankey diagram object
#' @param simple  Flag (TRUE/FALSE) for whether you want simplified information (a single data frame with source target and number of students) or original data (two data frames one for links one for nodes)
#'
#' @export
#'
sankey_to_data_frame <- function(p, simple = T){
  links = p$x$links
  nodes = p$x$nodes
  links$source = nodes$name[links$source+1]
  links$target = nodes$name[links$target+1]
  if(simple){
    links = links[,1:3]
    names(links) = c('Source', 'Target', 'Number of Students')
    return(links)
  }
 return(list(nodes = nodes, links = links))
}


#' Write sankey to xlsx
#'
#'@details
#' This function writes the sankey diagram information (flows) to an .xlsx file with title (`title`) and subtitle (`source`) ready for SDC checks / outputting.
#'
#'
#'
#' @param p sankey diagram object
#' @param title title for excel spreadsheet
#' @param source sources used for sankey diagram (e.g. Source: National Pupil Database)
#' @param filepath the file path to save the .xlsx file to.
#'
#' @export
#'
sankey_export_xlsx <- function(p,
                               title = 'Sankey Information',
                               source = '',
                               filepath = paste0(getwd(), '/sankey_info.xlsx')){
  # xlsx format values
  main_title = openxlsx::createStyle(fontSize = 14, textDecoration = "bold", halign = "left")
  second_title = openxlsx::createStyle(fontSize = 10, textDecoration = "italic", halign = "left")
  student_count = openxlsx::createStyle(numFmt = "#,##0")

  sankey_type = 'filtered'
  sankey_info = p |> sankey_to_data_frame(simple = FALSE)
  if('group' %in% names(sankey_info$links)){
    if('type_a' %in% sankey_info$links$group){
      sankey_type = 'traced'

    }else{
      sankey_type = 'grouped'
    }
  }


  # Create and export .xlsx file with underlying information for a filtered sankey diagram.
  if(sankey_type == 'filtered'){
    df = p |> sankey_to_data_frame(simple = T)
    df$`Number of Students` = as.numeric(df$`Number of Students`)

    # Create and save the excel file
    wb <- openxlsx::createWorkbook()
    openxlsx::addWorksheet(wb, "Data")
    openxlsx::writeData(wb, 1, x = title, startRow = 1, startCol = 1)
    openxlsx::writeData(wb, 1, x = source, startRow = 2, startCol = 1)
    openxlsx::writeDataTable(wb,
                             sheet = "Data",
                             x = df,
                             startRow = 4,
                             rowNames = FALSE,
                             withFilter = TRUE)

    openxlsx::addStyle(wb = wb, sheet = 1, rows = 1, cols = 1, style = main_title)
    openxlsx::addStyle(wb = wb, sheet = 1, rows = 2, cols = 1, style = second_title)
    openxlsx::addStyle(wb = wb, sheet = 1, rows = 4:(nrow(df)+4), cols = 3, style = student_count)
    openxlsx::setColWidths(wb, sheet=1, cols = 1:3, widths = 'auto')

    # Save workbook
    openxlsx::saveWorkbook(wb,  file = filepath, overwrite = TRUE)
  }

  # Create and export .xlsx file with underlying information for a traced sankey diagram.
  if(sankey_type == 'traced'){
    sankey_info = p |> sankey_to_data_frame(simple = FALSE)
    group_info = sankey_info$links$name[1] |>
      stringr::str_split(pattern = '\\.\n') |> unlist()
    group_info = group_info[1] |>
      stringr::str_split(pattern = 'in: ') |> unlist()
    group_info = group_info[2]

    df = sankey_info$links[,c(4,1,2,3)]
    df$group[df$group == 'type_a'] = 'Yes'
    df$group[df$group == 'type_b'] = 'No'
    df$value = as.numeric(df$value)
    names(df) = c(paste0('In (', group_info, ')?'), 'Source', 'Target', 'Number of Students')

    # Create and save the excel file
    wb <- openxlsx::createWorkbook()
    openxlsx::addWorksheet(wb, "Data")
    openxlsx::writeData(wb, 1, x = title, startRow = 1, startCol = 1)
    openxlsx::writeData(wb, 1, x = source, startRow = 2, startCol = 1)
    openxlsx::writeDataTable(wb,
                             sheet = "Data",
                             x = df,
                             startRow = 4,
                             rowNames = FALSE,
                             withFilter = TRUE)

    openxlsx::addStyle(wb = wb, sheet = 1, rows = 1, cols = 1, style = main_title)
    openxlsx::addStyle(wb = wb, sheet = 1, rows = 2, cols = 1, style = second_title)
    openxlsx::addStyle(wb = wb, sheet = 1, rows = 4:(nrow(df)+4), cols = 4, style = student_count)
    openxlsx::setColWidths(wb, sheet=1, cols = 2:4, widths = 'auto')
    openxlsx::setColWidths(wb, sheet=1, cols = 1, widths = 15)
    # Save workbook
    openxlsx::saveWorkbook(wb,  file = filepath, overwrite = TRUE)
  }

  # Create and export .xlsx file with underlying information for a multi-traced (by group) sankey diagram.
  if(sankey_type == 'grouped'){
    sankey_info = p |> sankey_to_data_frame(simple = FALSE)
    group_info = lapply(sankey_info$links$name, function(x){
     split =  x |> stringr::str_split(pattern = '\n\n') |>
        unlist()
     split[1] |> stringr::str_trim()
    })  |> unlist()
   column = (group_info[1] |> stringr::str_split(pattern = ' = ') |> unlist())[1]
   group_info = group_info |> stringr::str_remove(pattern = paste0(column, ' = '))

    df = sankey_info$links[,c(1,2,3)]
    df$value = as.numeric(df$value)
    df = data.frame(group = group_info, df)
    names(df) = c(column, 'Source', 'Target', 'Number of Students')

    # Create and save the excel file
    wb <- openxlsx::createWorkbook()
    openxlsx::addWorksheet(wb, "Data")
    openxlsx::writeData(wb, 1, x = title, startRow = 1, startCol = 1)
    openxlsx::writeData(wb, 1, x = source, startRow = 2, startCol = 1)
    openxlsx::writeDataTable(wb,
                             sheet = "Data",
                             x = df,
                             startRow = 4,
                             rowNames = FALSE,
                             withFilter = TRUE)

    openxlsx::addStyle(wb = wb, sheet = 1, rows = 1, cols = 1, style = main_title)
    openxlsx::addStyle(wb = wb, sheet = 1, rows = 2, cols = 1, style = second_title)
    openxlsx::addStyle(wb = wb, sheet = 1, rows = 4:(nrow(df)+4), cols = 4, style = student_count)
    openxlsx::setColWidths(wb, sheet=1, cols = 2:4, widths = 'auto')
    openxlsx::setColWidths(wb, sheet=1, cols = 1, widths = 15)
    # Save workbook
    openxlsx::saveWorkbook(wb,  file = filepath, overwrite = TRUE)
  }
}
