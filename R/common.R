#' Check and Identify the Container Runtime
#'
#' The `detect_container_runtime` function checks if the current R process
#' is running  inside a Docker or Singularity container. It returns the name
#' of the container runtime (either "Docker", "Singularity", or "None") along
#' with a boolean indicating whether it is running inside any of these
#' containers.
#'
#' @return
#' A list with two elements:
#' \item{name}{A character string indicating the container runtime: "Docker",
#' "Singularity", or "None".}
#' \item{is_running}{A logical value: `TRUE` if the process is running inside
#' a recognized container runtime, `FALSE` otherwise.}
#'
#' @examples
#' result <- detect_container_runtime()
#' cat("Container runtime:", result$name, "\n")
#' cat("Is running in container:", result$is_running, "\n")
#'
#' @export
detect_container_runtime <- function() {
  detection_map <- list(
    Docker = is_running_in_docker,
    Singularity = is_running_in_singularity
  )
  for (runtime in names(detection_map)) {
    if (detection_map[[runtime]]()) {
      return(list(name = runtime, is_running = TRUE))
    }
  }
  return(list(name = "None", is_running = FALSE))
}

#' Run a container.
#'
#' @param image_name The image you want to run.
#' @param volumes The list of volumes to mount to the container.
#' @param additional_arguments Vector of arguments to pass to the container.
#'
#' @export
run_in_container <- function(image_name,
                             volumes = list(),
                             additional_arguments = c()) {
  detection_map <- list(
    Docker = has_docker(),
    Singularity = has_singularity()
  )

  filtered_providers <- Filter(function(x) x$found, detection_map)
  if (length(filtered_providers) < 1) {
    return
  }
  first_found_name <- names(filtered_providers)[1]
  first_found_fn <- filtered_providers[[first_found_name]]$fn

  first_found_fn(image_name, volumes, additional_arguments)
}
