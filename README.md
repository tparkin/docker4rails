Docker4Rails
============

## tl;dr

If you want to jump right in and get started, follow these simple steps:

 1. Fork this Repository
 1. Update the 'nginx.conf' file to include the *actual* server name (or IP Address)
   - Replace 'XXX.XXX.XXX.XX' in the file
 1. From a Docker-enabled host (I recommend a [Digital Ocean Droplet](https://www.digitalocean.com/?refcode=ad30861cee8b)) issue this command `docker build -t rails_passenger_nginx <YOUR FORK OF THIS REPOSITORY>`

It will take a while to build the container.

Then you can perform a quick "smoke test" with `docker run -dtp 80:80 rails_passenger_nginx` and point a browser to your server (the name or IP address you entered in the 'nginx.conf' file earlier).

If you do not get a proper response, check the Docker container is running with `docker ps`.

===

More to follow after I complete the article for RubySource on this.
