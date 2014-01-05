# ffmbc, chromedriver with google chrome, ruby, ubuntu, node.js, xvfb, redis, mongodb
FROM keyvanfatehi/chrome-xvfb

MAINTAINER Keyvan Fatehi <keyvanfatehi@gmail.com>

# Add multiverse repo (for libx264)
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse" >> /etc/apt/sources.list

# Add MongoDB official repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

# Install Redis, Mongo, MediaInfo, and other dependencies by apt
RUN apt-get -y update
RUN apt-get -y -q install redis-server mongodb-10gen mediainfo curl build-essential yasm git libssl-dev bzip2 libx264-dev libreadline6 libreadline6-dev

# Install Ruby with readline & ssl support by compilation
RUN curl -O http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz && tar -zxvf ruby-2.1.0.tar.gz && rm ruby-2.1.0.tar.gz
RUN cd ruby-2.1.0 && ./configure --with-readline --with-readline-dir=/usr --disable-install-doc --with-openssl-dir=/usr/bin && make && make install

# Install Bundler by gem install
ADD http://rubygems.org/downloads/bundler-1.5.1.gem /ruby/gems/bundler-1.5.1.gem
RUN gem install --local /ruby/gems/bundler-1.5.1.gem --no-document

# Install FFMBC by compilation
RUN curl -O https://ffmbc.googlecode.com/files/FFmbc-0.7-rc8.tar.bz2 && tar -jxvf FFmbc-0.7-rc8.tar.bz2 && rm FFmbc-0.7-rc8.tar.bz2
RUN cd FFmbc-0.7-rc8 && ./configure --enable-gpl --enable-libx264 --enable-nonfree && make && make install

# Install Node.js from binary
RUN curl -o ~/node.tar.gz http://nodejs.org/dist/v0.10.24/node-v0.10.24-linux-x64.tar.gz
RUN cd /usr/local && tar --strip-components 1 -xzf ~/node.tar.gz && rm ~/node.tar.gz

# Add MongoDB Data Dir
RUN mkdir -p /data/db
