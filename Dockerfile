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

# Fix Kali Stuff
RUN sed "s/PROMPT_ALTERNATIVE=twoline/PROMPT_ALTERNATIVE=oneline/" .bashrc --in-place && \
    sed "s/NEWLINE_BEFORE_PROMPT=yes/NEWLINE_BEFORE_PROMPT=no/" .bashrc --in-place && \
    gzip -d /usr/share/wordlists/rockyou.txt.gz

# Install stuff not included with kali
RUN apt-get install -y iputils-ping sshpass

# Install Other Tools
RUN mkdir tools
# tplmap
RUN cd tools && \
    git clone https://github.com/epinna/tplmap && \
    ln -s /root/tools/tplmap/tplmap.py /usr/bin/tplmap && \
    chmod +x /usr/bin/tplmap

# jwt_tools
RUN cd tools && \
    git clone https://github.com/ticarpi/jwt_tool && \
    ln -s /root/tools/jwt_tool/jwt_tool.py /usr/bin/jwt_tool && \
    chmod +x /usr/bin/jwt_tool && jwt_tool || exit 0

WORKDIR /root
CMD [ "bash" ]
