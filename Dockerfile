FROM ruby:3.2.0
WORKDIR /opt/app/mass_info
COPY . .
RUN set -eux; \
  apt update; \
  apt install -y libapr1-dev libxml2-dev  libxslt1-dev \
    default-libmysqlclient-dev \
    libcurl4-openssl-dev \
    git curl build-essential libssl-dev libreadline-dev libssl-dev libreadline-dev \
    ruby-dev zlib1g-dev liblzma-dev ruby-all-dev  libyaml-dev libncurses5-dev libffi-dev libgdbm-dev libdb-dev vim \
    python3 pip python3-venv python3-pip \
    nmap wafw00f dnsutils; \
  apt clean; \
  wget https://github.com/pypa/pipx/releases/latest/download/pipx.pyz; \
  chmod +x pipx.pyz; \
  mv pipx.pyz /usr/bin/pipx; \
  /usr/bin/pipx install poetry; \
  wget https://github.com/Becivells/iconhash/releases/download/v0.4.3/iconhash_0.4.3_linux_amd64.deb; \
  dpkg -i iconhash_0.4.3_linux_amd64.deb; \
  rm iconhash_0.4.3_linux_amd64.deb; \
  rm -rf /var/lib/apt/lists/*

#  pip install favihunter; \

RUN gem install bundler -v 2.6.9  && \
  cd /opt/app/mass_info && bundle install --verbose && \
  gem install wpscan && wpscan --update

RUN pip3 install favihunter; \
  cd /opt/app && git clone https://github.com/urbanadventurer/WhatWeb.git && \
  cd /opt/app/WhatWeb && bundle install

CMD ["tail", "-f", "/dev/null"]
