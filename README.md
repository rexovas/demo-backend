
# Crossix Assignment Back-End
## Author: David Lovas

This project is a basic Flask application enabling users to retrieve data provided by the National Center for Health Statistics concerning death rates for the top 10 causes of death in the United States.

This project is paired with a React web application, enabling users to browse the data in a responsive webpage.

## Python Configuration

To run this project it is recommended to create a new Conda environment (or virtualenv) and install the dependencies listed in `requirements.txt`

### Example:

create a new environment

### `conda create -n <envname> pip`

activate the new environment

### `conda activate <envname>`

Install project dependencies using requirements.txt file

### `pip install -r requirements.txt`

Note: it is not recommended to use `conda install` when installing requirements for this project as it has been known to cause problems

## Running the  app

Before running, ensure that the `FLASK_DEBUG` environment variable has been set to either `1` for on or `0` for off

#### Windows
In cmd.exe `set FLASK_DEBUG=0`

#### Bash
`FLASK_DEBUG=0`

In the project/src directory, you can run:

### `python -m flask run -h 0.0.0.0`

Runs the app in the development mode.<br />
Accessible at [http://localhost:5000](http://localhost:5000).

`-h 0.0.0.0` makes the service available to other computers on the same network through the host machines IP address
this is useful for testing with mobile devices or multiple devices simultaneously.

## Troubleshooting

If you have trouble running the application, it may be due to how some of the dependencies were installed.
Ensure you have installed the versions specified in the requirements.txt file, and avoid installing via `conda install` as it seems to cause issues that `pip install` does not. 