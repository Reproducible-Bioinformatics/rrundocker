# rrundocker

Execute in docker containers.

---

Get the latest [release](https://github.com/Reproducible-Bioinformatics/rrundocker/releases/latest).

Usage example:

```R
run_in_docker(
  image_name = "docker.io/repbioinfo/r332.2017.01:latest",
  volumes = list(
    c(result_dir_path, "/data"),
    c(parent_folder, "/scratch")
  ),
  additional_arguments = c(
    "Rscript /home/main.R",
    matrix_name,
    format,
    paste0('"', separator, '"')
  )
)
```
