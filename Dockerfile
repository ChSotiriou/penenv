FROM ubuntu:20.04

# Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive

# Working Directory
WORKDIR /root
RUN mkdir ${HOME}/toolkit && \
    mkdir ${HOME}/wordlists

# General Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    tmux \
    gcc \
    iputils-ping\
    git \
    vim \
    wget \
    awscli \
    tzdata \
    curl \
    make \
    nmap \
    whois \
    python3 \
    python3-pip \
    perl \
    nikto \
    dnsutils \
    net-tools \
    zsh\
    nano\
    && rm -rf /var/lib/apt/lists/*

# Specific tools / dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # sqlmap
    sqlmap \
    # dirb
    dirb \
    # dnsenum
    cpanminus \
    # wfuzz
    python-pycurl \
    # knock
    python-dnspython \
    # massdns
    libldns-dev \
    # wpcscan
    libcurl4-openssl-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    ruby-dev \
    libgmp-dev \
    zlib1g-dev \
    # masscan
    libpcap-dev \
    # joomscan
    libwww-perl \
    # hydra
    hydra \
    # dnsrecon
    dnsrecon \
    # zsh
    powerline\
    # zsh
    fonts-powerline\
    # metasploit
    gnupg\
    gnupg2\
    gnupg1\
    && rm -rf /var/lib/apt/lists/*

# configure python(s)
RUN python3 -m pip install --upgrade setuptools

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# metasploit
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall

# dnsenum
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/fwaeytens/dnsenum.git && \
    cd dnsenum/ && \
    chmod +x dnsenum.pl && \
    ln -s ${HOME}/toolkit/dnsenum/dnsenum.pl /usr/bin/dnsenum && \
    cpanm String::Random && \
    cpanm Net::IP && \
    cpanm Net::DNS && \
    cpanm Net::Netmask && \
    cpanm XML::Writer

# Sublist3r
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/aboul3la/Sublist3r.git && \
    cd Sublist3r/ && \
    pip install -r requirements.txt && \
    ln -s ${HOME}/toolkit/Sublist3r/sublist3r.py /usr/local/bin/sublist3r

# knock
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/guelfoweb/knock.git && \
    cd knock && \
    chmod +x setup.py && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.7 -y && \
    python3.7 setup.py install

# massdns
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/blechschmidt/massdns.git && \
    cd massdns/ && \
    make && \
    ln -sf ${HOME}/toolkit/massdns/bin/massdns /usr/local/bin/massdns

# wafw00f
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/enablesecurity/wafw00f.git && \
    cd wafw00f && \
    chmod +x setup.py && \
    python3 setup.py install

# wpscan
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/wpscanteam/wpscan.git && \
    cd wpscan/ && \
    gem install bundler && bundle install --without test && \
    gem install wpscan

# commix
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/commixproject/commix.git && \
    cd commix && \
    chmod +x commix.py && \
    ln -sf ${HOME}/toolkit/commix/commix.py /usr/local/bin/commix

# masscan
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/robertdavidgraham/masscan.git && \
    cd masscan && \
    make && \
    ln -sf ${HOME}/toolkit/masscan/bin/masscan /usr/local/bin/masscan

# altdns
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/infosec-au/altdns.git && \
    cd altdns && \
    pip install -r requirements.txt && \
    chmod +x setup.py && \
    python3 setup.py install

# teh_s3_bucketeers
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/tomdev/teh_s3_bucketeers.git && \
    cd teh_s3_bucketeers && \
    chmod +x bucketeer.sh && \
    ln -sf ${HOME}/toolkit/teh_s3_bucketeers/bucketeer.sh /usr/local/bin/bucketeer

# Recon-ng
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/lanmaster53/recon-ng.git && \
    cd recon-ng && \
    pip3 install -r REQUIREMENTS && \
    chmod +x recon-ng && \
    ln -sf ${HOME}/toolkit/recon-ng/recon-ng /usr/local/bin/recon-ng

# XSStrike
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/s0md3v/XSStrike.git && \
    cd XSStrike && \
    pip3 install -r requirements.txt && \
    chmod +x xsstrike.py && \
    ln -sf ${HOME}/toolkit/XSStrike/xsstrike.py /usr/local/bin/xsstrike

# CloudFlair
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/christophetd/CloudFlair.git && \
    cd CloudFlair && \
    pip install -r requirements.txt && \
    chmod +x cloudflair.py && \
    ln -sf ${HOME}/toolkit/CloudFlair/cloudflair.py /usr/local/bin/cloudflair

# joomscan
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/rezasp/joomscan.git && \
    cd joomscan/ && \
    chmod +x joomscan.pl && \
    # Pulling from BugBountyToolkit
    wget -O /opt/joomscan.sh https://raw.githubusercontent.com/AlexisAhmed/BugBountyToolkit/ed7f1470aaa66c1e57010cba3b7b57a748eaf79b/joomscan.sh && \
    chmod +x /opt/joomscan.sh && \
    ln -sf /opt/joomscan.sh /usr/local/bin/joomscan

# go
RUN cd /opt && \
    wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz && \
    tar -xvf go1.16.4.linux-amd64.tar.gz && \
    rm -rf /opt/go1.16.4.linux-amd64.tar.gz && \
    mv go /usr/local
ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}

# gobuster
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/OJ/gobuster.git && \
    cd gobuster && \
    go get && go install

# virtual-host-discovery
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/AlexisAhmed/virtual-host-discovery.git && \
    cd virtual-host-discovery && \
    chmod +x scan.rb && \
    ln -sf ${HOME}/toolkit/virtual-host-discovery/scan.rb /usr/local/bin/virtual-host-discovery

# bucket_finder
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/AlexisAhmed/bucket_finder.git && \
    cd bucket_finder && \
    chmod +x bucket_finder.rb && \
    ln -sf ${HOME}/toolkit/bucket_finder/bucket_finder.rb /usr/local/bin/bucket_finder

# dirsearch
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/AlexisAhmed/dirsearch.git && \
    cd dirsearch && \
    chmod +x dirsearch.py && \
    ln -sf ${HOME}/toolkit/dirsearch/dirsearch.py /usr/local/bin/dirsearch

# s3recon
RUN pip3 install --upgrade setuptools && \
    pip3 install pyyaml pymongo requests s3recon

# subfinder
RUN GO111MODULE=on go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder

# install rust apps
ENV PATH ${HOME}/.cargo/bin:${PATH}
RUN cargo install rustscan

# zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&\
    chsh -s /bin/zsh && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1 && \
    echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

# Cleanup
RUN rm /root/msfinstall

WORKDIR /root
CMD [ "zsh" ]
