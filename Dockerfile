FROM ruby:2.7.3

ENV LANG C.UTF-8
ENV DEBCONF_NOWARNINGS yes
ENV NODE_VERSION 14.18.2
ENV APP_ROOT /pai-auth
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE yes

EXPOSE 3000

RUN apt-get update -qq && apt-get install -y build-essential postgresql-client libpq-dev && \
rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
&& case "${dpkgArch##*-}" in \
amd64) ARCH='x64';; \
ppc64el) ARCH='ppc64le';; \
s390x) ARCH='s390x';; \
arm64) ARCH='arm64';; \
armhf) ARCH='armv7l';; \
i386) ARCH='x86';; \
*) echo "unsupported architecture"; exit 1 ;; \
esac \
&& set -ex \
&& curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
&& tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
&& rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
&& ln -s /usr/local/bin/node /usr/local/bin/nodejs \
&& node --version \
&& npm --version


RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install
COPY . $APP_ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
