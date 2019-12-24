FROM ruby:2.6.4

RUN apt-get update && apt-get install -y postgresql-client

ADD . /var/www/dog-walking-api

WORKDIR /var/www/dog-walking-api

RUN bundle install --jobs=4

EXPOSE 3000

CMD bash bin/start
