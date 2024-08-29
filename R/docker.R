#' Check if Docker is Available and Return Its Path
#'
#' The `has_docker` function checks if the Docker executable is available
#' in the system's `PATH`. It returns a list with a boolean indicating if Docker
#' is found, and the path to the Docker executable if it is available.
#'
#' @return
#' A list with two elements:
#' \item{found}{A logical value: `TRUE` if Docker is available in the system's
#' `PATH`, `FALSE` otherwise.}
#' \item{path}{A character string containing the full path to the Docker
#' executable if found,  or an empty string if not found.}
#'
#' @examples
#' result <- has_docker()
#' if (result$found) {
#'   cat("Docker is available at:", result$path, "\n")
#' } else {
#'   cat("Docker is not available.\n")
#' }
has_docker <- function() {
  path <- Sys.which("docker")
  return(list(found = nzchar(path), path = path, fn = run_in_docker))
}

#' Check if the script is running in Docker.
#'
#' @returns A truthy value indicating the state.
#' @export
is_running_in_docker <- function() {
  dockerenv_exists <- file.exists("/.dockerenv")
  cgroup_exists <- file.exists("/proc/1/cgroup")
  in_container_runtime <- FALSE
  if (cgroup_exists) {
    in_container_runtime <- any(
      grepl("docker", readLines("/proc/1/cgroup", warn = FALSE))
    )
  }
  return(dockerenv_exists || in_container_runtime)
}


#' Run a docker container.
#'
#' @param image_name The docker image you want to run.
#' @param volumes The list of volumes to mount to the container.
#' @param additional_arguments Vector of arguments to pass to the container.
#'
#' @export
run_in_docker <- function(image_name,
                          volumes = list(),
                          additional_arguments = c()) {
  base_command <- "run --privileged=true --platform linux/amd64 --rm"
  for (volume in volumes) {
    volume[1] <- normalizepath::normalize_path(volume[1],
      path_mappers = c(normalizepath::docker_mount_mapper)
    )
    base_command <- paste(base_command, "-v", paste(
      volume[1],
      volume[2],
      sep = ":"
    ))
  }
  base_command <- paste(base_command, image_name)
  for (argument in additional_arguments) {
    base_command <- paste(base_command, argument)
  }
  # Using an empty string to output to R's console according to documentation.
  system2("docker", args = base_command, stdout = "", stderr = "")
}
