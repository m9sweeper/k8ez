# Ansible Images

When running CICD Pipelines or running Ansible on your local machine, building and running a container image is the
easiest way to get consistent results. This ensures the same version of ansible, python, and whatever other
dependencies you require are installed every time. 

## Dependencies

The only dependency for running ansible through a Docker image is to have Docker itself installed locally. Instructions
for installation can be found [on the Docker website](https://docs.docker.com/get-started/get-docker/).

## To build

Once Docker is installed, you can build the CLI tools locally by navigating to this directory using one of the
following commands on the command line, depending on which architecture you are expecting to work with.

`docker build . -f Dockerfile-oci -t ansible-oci-container:latest`

`docker build . -f Dockerfile-Azure -t ansible-azure-container:latest`

The Docker build will display the build steps as it runs, and once it finishes it will save the built image locally.

## To Run

To run ansible commands locally, you will need to create a docker container and attach a shell to it. This can be
accomplished with the following command:

`docker run --rm -it -v $PWD:/playbooks -v ~/.ssh:/root/.ssh ansible-oci-container:latest /bin/bash`

Here's a quick breakdown of what the above command is doing:

- `docker run`: this tells Docker to create a new container using an image specified later
- `--rm`: Delete the container after exiting. This prevents a large number of unused containers from building up on disk over time
- `-it`: Run in interactive mode. This places you on the command line of the newly created container, and is how you will run ansible commands
- `-v $PWD:/playbooks`: Mount a volume onto the container. This gives the Docker container access
to specified files on the filesystem. In this case, it mounts the current working directory onto the /playbooks
directory of the container.
- `-v ~/.ssh:/root/.ssh`: Mount the user's SSH directory onto the Docker container. Placing SSH keys and configs into
the container's /root/.ssh directory allows ansible to use SSH configurations from your host machine to connect to target machines
- `ansible-oci-container:latest`: Create a container using the "ansible-oci-container" image, with the "latest" tag
- `/bin/bash`: Use the bash shell within the container

Once run, you will be placed on the command line of a newly created container, and from there can navigate as normal.

Note: the docker run command can be assigned to an alias within a .bashrc file or similar, minimize the need to type it out.

## Running Ansible

In order to run ansible within the container, all you need to do is run the command `ansible-playbook playbook.yml`.
The Docker image has ansible and all prerequisites preinstalled on it, and can run playbooks with no additional setup.

The tests directory contains an example playbook, which can be run using `ansible-playbook playbooks/ansible-hello-world.yml`.
This will run a short playbook that prints a message to the screen and displays the ansible version.
