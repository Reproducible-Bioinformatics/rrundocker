#' Run a docker container.
#'
#' @param image_name The docker image you want to run.
#' @param volumes The list of volumes to mount to the container.
#' @additional_arguments Vector of arguments to pass to the container.
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
  system2("docker", args = base_command, stdout = TRUE, stderr = TRUE)
}
