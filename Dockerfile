FROM kalilinux/kali-rolling

# Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive

# Working Directory
WORKDIR /root

# Install Kali Toolkit
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends kali-linux-everything

# Install Other Tools
# tplmap
RUN mkdir tools && cd tools && \
    git clone https://github.com/epinna/tplmap && \
    ln -s /root/tools/tplmap/tplmap.py /usr/bin/tplmap && \
    chmod +x /usr/bin/tplmap

WORKDIR /root
CMD [ "bash" ]
