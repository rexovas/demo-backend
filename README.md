
# Demo Project Back-End
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

## Installing Redis

This project uses Redis for caching and requires `redis-server` to be installed on the host machine

To install on Ubuntu/Linux:
`sudo apt update && sudo apt install redis-server`

To install on Mac:
`brew install redis`

Windows requires a port of redis which can be downloaded from [here](https://github.com/dmajkic/redis/downloads) (these binaries have also been included in this repository for convenience)

[Detailed instructions available here](https://redislabs.com/ebook/appendix-a/a-3-installing-on-windows/a-3-2-installing-redis-on-window/)

once Redis has been installed, you can simply run `redis-server` to start the process in the background

## Running the  app

Start Redis by typing
### `redis-server`

or launching the redis-server executable on Windows.

In the **project/src** directory, you can run:

### `python -m flask run -h 0.0.0.0`

Runs the app in the development mode.<br />
Accessible at [http://localhost:5000](http://localhost:5000).

`-h 0.0.0.0` makes the service available to other computers on the same network through the host machines IP address
this is useful for testing with mobile devices or multiple devices simultaneously.

## Troubleshooting

If you have trouble running the application, it may be due to how some of the dependencies were installed.
Ensure you have installed the versions specified in the requirements.txt file, and avoid installing via `conda install` as it seems to cause issues that `pip install` does not. 