# ODC Data Quality App

[![Build container](https://github.com/kenf1/dqa/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/kenf1/dqa/actions/workflows/build.yml) [![Render vignette](https://github.com/kenf1/dqa/actions/workflows/render.yml/badge.svg?branch=main)](https://github.com/kenf1/dqa/actions/workflows/render.yml)

__Ready to deploy containerized Data Quality App__

Folder structure: (alphabetical order)

- `Dev`: for development/fixing issues
- `HistoricalCheck`: applying checks on previously uploaded public odc datasets
- `src`: all files for container
- `UnitTest`: unit testing
- `VignetteFiles`: documentation

By default, all files in `src` folder will be included in Docker container. To exclude certain files, add filename to `.dockerignore`.

### Create Docker container:

Run in terminal:

`cd` to folder, then run:

```{shell}
docker container create CONTAINER_NAME .
```

```{shell}
docker run CONTAINER_NAME 3838:3838
```

There will be a localhost or 0.0.0.0 link in terminal output. Navigate to that webpage.

> By default it will be:
> 
> http://localhost:3838 or http://0.0.0.0:3838

To change port number, change the first set of numbers (before `:`).

> Example:
>
> 404:3838 will allow you to access the app via http://localhost:404 or http://0.0.0.0:404

Alternatively:

1. Install Docker & Dev Containers extensions in VS Code
1. Select "Open Folder in Container" in command palate
