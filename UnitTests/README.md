## Unit Tests

Am using:

- `functions_test.R` to test functions in `functions.R`
- Docker container to test __pandas-profiling__ (Python 3.11.x is currently unsupported)
    - all req packages should be listed in `requirements.txt`

## Requirements (for testing pandas-profiling)

- Docker
- VS Code
    - [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## To use

1. open Docker
1. open UnitTests folder inside container
1. disable Code Runner telemetry (optional)

everything should be ready to go for running either `pd_profile.ipynb` or `pd_profile.py`
