% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Customise_interactive_sankey_plots_networkD3.R
\name{add_column_names}
\alias{add_column_names}
\alias{add_node_hover_text}
\alias{add_link_hover_text}
\alias{update_node_labels}
\alias{update_sankey_colour}
\title{Functions to customise the styling of the sankey diagrams}
\usage{
add_column_names(
  p,
  titles,
  fontSize = p$x$options$fontSize,
  fontFamily = p$x$options$fontFamily
)

add_node_hover_text(p, hovertext)

add_link_hover_text(p, hovertext)

update_node_labels(p, labels = NULL)

update_sankey_colour(
  p,
  colors_node = NULL,
  colors_link = NULL,
  type = "target",
  link_alpha = 1
)
}
\arguments{
\item{p}{html widget of a sankey diagram}

\item{titles}{a character vector of the same length as the number of stages in the sankey diagram specifying the title to but above each stage.}

\item{fontSize}{numeric font size in pixels for the node text labels.}

\item{fontFamily}{font family for the node text labels.}

\item{hovertext}{a character vector of either the same length as nodes or links (depending on the function) to overwrite the hover information in the sankey diagram.}

\item{labels}{a character vector of the same length as the number of nodes in the sankey diagram specifying the new label for each node.}

\item{colors_node}{a character vector of length the number of nodes in the sankey (`p |> get_nodes() |> length()`) specifying the desired colour for the nodes.}

\item{colors_link}{a character vector of length the number of links in the sankey (`p |> get_links() |> length()`) specifying the desired colour for the links}

\item{type}{special colour systems where the links are the same colour as the nodes they come from (`type = "source"`) or the colour of the nodes they go towards (`type = "target"`)}

\item{link_alpha}{numeric between 0 and 1 specifying the transparency to apply to link colours (closer to zero the larger the transparency)}
}
\description{
Functions to customise the styling of the sankey diagrams
}
\details{
- `add_column_names()` this function can be used to add names above stages (columns) in the the sankey diagram.

- `add_node_hover_text()` this can be used to change the hover information over nodes.

- `add_link_hover_text()` this can be used to changed the hover information of links.

- `update_node_title()` this can be used to change the displayed node label in the sankey diagram

- `update_sankey_colour()` this can be used to change the node/link colouring of the sankey diagram (sankey_filtered, or any sankey diagram created using the networkD3 package). You can omit the link colours and provide a type for link colouring dependent on source or target nodes (using `type`).
}
