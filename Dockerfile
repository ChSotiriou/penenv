FROM kalilinux/kali-rolling

# Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive

# Working Directory
WORKDIR /root

# Install Toolkit
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends kali-linux-everything

WORKDIR /root
CMD [ "bash" ]
