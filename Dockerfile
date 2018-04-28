FROM debian:8
MAINTAINER pihizi@msn.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl libexpat1 libmysqlclient18 libpq5 libodbc1 locales locales && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen && \
    sed -i 's/# zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen && \
    locale-gen && \
    /usr/sbin/update-locale LANG="en_US.UTF-8" LANGUAGE="en_US:en" && \
    curl -sLo /tmp/sphinxsearch.deb http://sphinxsearch.com/files/sphinxsearch_2.3.2-beta-1_jessie_amd64 && \
    dpkg -i /tmp/sphinxsearch.deb && \
    rm /tmp/sphinxsearch.deb && \
    mkdir -p /etc/sphinxsearch/conf.d

RUN apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean

VOLUME ["/var/lib/sphinxsearch"]

# 9312 Sphinx Plain Port
# 9306 SphinxQL Port
EXPOSE 9312 9306

CMD ["/usr/bin/searchd", "--nodetach", "--config", "/etc/sphinxsearch/sphinx.conf.sh"]
