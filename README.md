# PENENV

> Kali Linux Docker Environment

## Download / Build

```
# Download from DockerHub
docker pull christoss/penenv:latest

# Build Locally
./build.sh
```

## Usage

I suggest adding the following functions to your zshrc/bashrc file:

```bash
function checkContainerRunning() {
    docker container ls -q -f name="$1"
}

function penenv() {
    if [ $(checkContainerRunning "penenv") ]; then
        docker exec -it penenv bash
    else
        docker run --net=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it --rm --name penenv -v "$(pwd)":/root/data penenv bash
    fi
}
```

This starts up the container if it is not running or executes bash if it is.
