#' Check if Singularity is Available and Return Its Path
#'
#' The `has_singularity` function checks if the Singularity executable is
#' available  in the system's `PATH`. It returns a list with a boolean
#' indicating if Singularity is found, and the path to the Singularity
#' executable if it is available.
#'
#' @return
#' A list with two elements:
#' \item{found}{A logical value: `TRUE` if Singularity is available in the
#' system's `PATH`, `FALSE` otherwise.}
#' \item{path}{A character string containing the full path to the Singularity
#' executable if found, or an empty string if not found.}
#'
#' @examples
#' result <- has_singularity()
#' if (result$found) {
#'   cat("Singularity is available at:", result$path, "\n")
#' } else {
#'   cat("Singularity is not available.\n")
#' }
#'
#' @export
has_singularity <- function() {
  path <- Sys.which("singularity")
  return(list(found = nzchar(path), path = path, fn = run_in_singularity))
}

#' Check if the script is running in a container.
#'
#' @returns A truthy value indicating the state.
#' @export
is_running_in_singularity <- function() {
  cgroup_exists <- file.exists("/proc/1/cgroup")
  in_container_runtime <- FALSE
  if (cgroup_exists) {
    in_container_runtime <- any(
      grepl("singularity", readLines("/proc/1/cgroup", warn = FALSE))
    )
  }
  return(in_container_runtime)
}

#' Run a singularity container.
#'
#' @param image_name The singularity image you want to run.
#' @param volumes The list of volumes to mount to the container.
#' @param additional_arguments Vector of arguments to pass to the container.
#'
#' @export
run_in_singularity <- function(image_name,
                               volumes = list(),
                               additional_arguments = c()) {
}
