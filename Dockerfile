FROM ubuntu:14.10
MAINTAINER Thom Parkin, Thom.Parkin@Websembly.com

# Rails with Nginx and Passenger - Read the article on RubySource.com

# Update local OS
RUN apt-get update
RUN apt-get upgrade -y

# Install dependencies
RUN apt-get install -y git-core wget curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties

## Install Ruby 2.1.3
RUN mkdir ~/ruby
WORKDIR ~/ruby
RUN wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz
RUN tar -xzvf ruby-2.1.3.tar.gz
WORKDIR ruby-2.1.3
RUN ./configure
RUN make
RUN make install
RUN rm -rf ~/ruby && ruby -v
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler rails --no-ri --no-rdoc
WORKDIR ~/

# Add a default Rails application to use for "smoke test"
ADD ./ /opt/
WORKDIR /opt/dockerapp
RUN bundle install

# Install Phusion's PGP key to verify packages
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN gpg --armor --export 561F9B9CAC40B2F7 | sudo apt-key add -

# Add HTTPS support to APT
RUN apt-get install apt-transport-https

# Add the passenger repository
RUN sh -c "echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' >> /etc/apt/sources.list.d/passenger.list"
RUN chown root: /etc/apt/sources.list.d/passenger.list
RUN chmod 600 /etc/apt/sources.list.d/passenger.list
RUN apt-get update

# Install nginx and passenger
RUN apt-get install -y nginx-full passenger
RUN service nginx start

RUN sed -i 's/# passenger_root /passenger_root /' /etc/nginx/nginx.conf
RUN sed -i 's/# passenger_ruby.*;/passenger_ruby \/usr\/local\/bin\/ruby;/' /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# nginx configuration
ADD nginx.conf /etc/nginx/sites-enabled/default

# Restart nginx service
CMD sudo service nginx restart

EXPOSE 80
