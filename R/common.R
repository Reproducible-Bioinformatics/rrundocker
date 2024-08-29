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
  source("docker.R")
  source("singularity.R")

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
