#' Filter manager modal
#'
#' Opens modal containing the filter manager UI.
#'
#' @name module_filter_manager_modal
#' @inheritParams filter_manager_srv
#' @examples
#' fd1 <- teal.slice::init_filtered_data(list(iris = list(dataset = iris)))
#' fd2 <- teal.slice::init_filtered_data(
#'   list(iris = list(dataset = iris), mtcars = list(dataset = mtcars))
#' )
#' fd3 <- teal.slice::init_filtered_data(
#'   list(iris = list(dataset = iris), women = list(dataset = women))
#' )
#' filter <- teal_slices(
#'   teal.slice::teal_slice(dataname = "iris", varname = "Sepal.Length"),
#'   teal.slice::teal_slice(dataname = "iris", varname = "Species"),
#'   teal.slice::teal_slice(dataname = "mtcars", varname = "mpg"),
#'   teal.slice::teal_slice(dataname = "women", varname = "height"),
#'   mapping = list(
#'     module2 = c("mtcars mpg"),
#'     module3 = c("women height"),
#'     global_filters = "iris Species"
#'   )
#' )
#'
#' app <- shinyApp(
#'   ui = fluidPage(
#'     teal:::filter_manager_modal_ui("manager")
#'   ),
#'   server = function(input, output, session) {
#'     teal:::filter_manager_modal_srv(
#'       "manager",
#'       filtered_data_list = list(module1 = fd1, module2 = fd2, module3 = fd3),
#'       filter = filter
#'     )
#'   }
#' )
#' if (interactive()) {
#'   runApp(app)
#' }
#'
#' @keywords internal
#'
NULL

#' @rdname module_filter_manager_modal
filter_manager_modal_ui <- function(id) {
  ns <- NS(id)
  tags$button(
    id = ns("show"),
    class = "btn action-button filter_manager_button",
    title = "Show filters manager modal",
    icon("gear")
  )
}

#' @rdname module_filter_manager_modal
filter_manager_modal_srv <- function(id, filtered_data_list, filter) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$show, {
      logger::log_trace("filter_manager_modal_srv@1 show button has been clicked.")
      showModal(
        modalDialog(
          filter_manager_ui(session$ns("filter_manager")),
          size = "l",
          footer = NULL,
          easyClose = TRUE
        )
      )
    })

    filter_manager_srv("filter_manager", filtered_data_list, filter)
  })
}

#' @rdname module_filter_manager
filter_manager_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "filter_manager_content",
    tableOutput(ns("slices_table")),
    snapshot_manager_ui(ns("snapshot_manager"))
  )
}

#' Manage multiple `FilteredData` objects
#'
#' Oversee filter states in the whole application.
#'
#' @rdname module_filter_manager
#' @details
#' This module observes the changes of the filters in each `FilteredData` object
#' and keeps track of all filters used. A mapping of filters to modules
#' is kept in the `mapping_matrix` object (which is actually a `data.frame`)
#' that tracks which filters (rows) are active in which modules (columns).
#'
#' @param id (`character(1)`)\cr
#'  `shiny` module id.
#' @param filtered_data_list (`named list`)\cr
#'  A list, possibly nested, of `FilteredData` objects.
#'  Each `FilteredData` will be served to one module in the `teal` application.
#'  The structure of the list must reflect the nesting of modules in tabs
#'  and names of the list must be the same as labels of their respective modules.
#' @inheritParams init
#' @return A list of `reactive`s, each holding a `teal_slices`, as returned by `filter_manager_module_srv`.
#' @keywords internal
#'
filter_manager_srv <- function(id, filtered_data_list, filter) {
  moduleServer(id, function(input, output, session) {
    logger::log_trace("filter_manager_srv initializing for: { paste(names(filtered_data_list), collapse = ', ')}.")

    is_module_specific <- isTRUE(attr(filter, "module_specific"))

    # Create global list of slices.
    # Contains all available teal_slice objects available to all modules.
    # Passed whole to instances of FilteredData used for individual modules.
    # Down there a subset that pertains to the data sets used in that module is applied and displayed.
    slices_global <- reactiveVal(filter)

    filtered_data_list <-
      if (!is_module_specific) {
        # Retrieve the first FilteredData from potentially nested list.
        # List of length one is named "global_filters" because that name is forbidden for a module label.
        list(global_filters = unlist(filtered_data_list)[[1]])
      } else {
        # Flatten potentially nested list of FilteredData objects while maintaining useful names.
        # Simply using `unlist` would result in concatenated names.
        flatten_nested <- function(x, name = NULL) {
          if (inherits(x, "FilteredData")) {
            setNames(list(x), name)
          } else {
            unlist(lapply(names(x), function(name) flatten_nested(x[[name]], name)))
          }
        }
        flatten_nested(filtered_data_list)
      }

    # Create mapping fo filters to modules in matrix form (presented as data.frame).
    mapping_matrix <- reactive({
      module_states <- lapply(filtered_data_list, function(x) x$get_filter_state())
      mapping_ragged <- lapply(module_states, function(x) vapply(x, `[[`, character(1L), "id"))
      all_names <- vapply(slices_global(), `[[`, character(1L), "id")
      mapping_smooth <- lapply(mapping_ragged, is.element, el = all_names)
      as.data.frame(mapping_smooth, row.names = all_names, check.names = FALSE)
    })

    output$slices_table <- renderTable(
      expr = {
        # Display logical values as UTF characters.
        mm <- mapping_matrix()
        mm[] <- lapply(mm, ifelse, yes = intToUtf8(9989), no = intToUtf8(10060))
        if (!is_module_specific) colnames(mm) <- "Global Filters"
        mm
      },
      rownames = TRUE
    )

    # Create list of module calls.
    modules_out <- lapply(names(filtered_data_list), function(module_name) {
      filter_manager_module_srv(
        id = module_name,
        module_fd = filtered_data_list[[module_name]],
        slices_global = slices_global
      )
    })

    # Call snapshot manager.
    snapshot_manager_srv("snapshot_manager", slices_global, mapping_matrix, filtered_data_list)

    modules_out # returned for testing purpose
  })
}

#' Module specific filter manager
#'
#' Track filter states in single module.
#'
#' This module tracks the state of a single `FilteredData` object and global `teal_slices`
#' and updates both objects as necessary. Filter states added in different modules
#' Filter states added any individual module are added to global `teal_slices`
#' and from there become available in other modules
#' by setting `private$available_teal_slices` in each `FilteredData`.
#'
#' @param id (`character(1)`)\cr
#'  `shiny` module id.
#' @param module_fd (`FilteredData`)\cr
#'   object to filter data in the teal-module
#' @param slices_global (`reactiveVal`)\cr
#'   stores `teal_slices` with all available filters; allows the following actions:
#'   - to disable/enable a specific filter in a module
#'   - to restore saved filter settings
#'   - to save current filter panel settings
#' @return A `reactive` expression containing the slices active in this module.
#' @keywords internal
#'
filter_manager_module_srv <- function(id, module_fd, slices_global) {
  moduleServer(id, function(input, output, session) {
    # Only operate on slices that refer to data sets present in this module.
    available_slices <- reactive({
      Filter(function(slice) slice$dataname %in% module_fd$datanames(), slices_global())
    })
    module_fd$set_available_teal_slices(available_slices)

    # Track filter state of this module.
    slices_module <- reactive(module_fd$get_filter_state())

    # Reactive values for comparing states.
    previous_slices <- reactiveVal(isolate(slices_module()))
    slices_added <- reactiveVal(NULL)

    # Observe changes in module filter state and trigger appropriate actions.
    observeEvent(slices_module(), ignoreNULL = FALSE, {
      logger::log_trace("filter_manager_srv@1 detecting states deltas in module: { id }.")
      added <- setdiff_teal_slices(slices_module(), slices_global())
      if (length(added)) slices_added(added)
      previous_slices(slices_module())
    })

    observeEvent(slices_added(), ignoreNULL = TRUE, {
      logger::log_trace("filter_manager_srv@2 added filter in module: { id }.")
      # In case the new state has the same id as an existing state, add a suffix to it.
      global_ids <- vapply(slices_global(), `[[`, character(1L), "id")
      lapply(
        slices_added(),
        function(slice) {
          if (slice$id %in% global_ids) {
            slice$id <- utils::tail(make.unique(c(global_ids, slice$id), sep = "_"), 1)
          }
        }
      )
      slices_global_new <- c(slices_global(), slices_added())
      slices_global(slices_global_new)
      slices_added(NULL)
    })

    slices_module # returned for testing purpose
  })
}
