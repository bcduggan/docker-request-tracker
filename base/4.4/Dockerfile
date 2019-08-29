FROM debian:buster-20190812-slim

ARG DB_TYPE=SQLite
ARG GRAPHVIZ=enable
ARG GD=enable
ARG EXTERNALAUTH
ARG GPG
ARG SMIME
ARG DEVELOPER
ARG PATCH=4

ENV BUILD_DB_TYPE ${DB_TYPE:-SQLite}

# Install database dependencies:
RUN set -eux; \
        if [ "${BUILD_DB_TYPE}" = "SQLite" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            sqlite3 \
            libdbd-sqlite3-perl; \
        elif [ "${BUILD_DB_TYPE}" = "Pg" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libdbd-pg-perl; \
        elif [ "${BUILD_DB_TYPE}" = "mysql" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libdbd-mysql-perl; \
        else \
            exit 1; \
        fi

# Install Perl dependencies:
RUN     apt-get update --yes && \
        apt-get install --yes \
        build-essential \
        autoconf \
        cpanminus

# Install CORE dependencies
RUN     apt-get update --yes && \
        apt-get install --yes \
        starlet \
        liblocale-maketext-fuzzy-perl \
        libhtml-mason-psgihandler-perl \
        libscope-upper-perl \
        libdata-guid-perl \
        libbusiness-hours-perl \
        libnet-ip-perl \
        libregexp-ipv6-perl \
        libsymbol-global-name-perl \
        libdate-manip-perl \
        libmodule-refresh-perl \
        libcgi-emulate-psgi-perl \
        libmime-types-perl \
        libdbix-searchbuilder-perl \
        liblocale-maketext-lexicon-perl \
        libjavascript-minifier-xs-perl \
        librole-basic-perl \
        libhtml-scrubber-perl \
        libipc-run3-perl \
        libcss-squish-perl \
        libxml-rss-perl \
        libregexp-common-net-cidr-perl \
        libplack-perl \
        libconvert-color-perl \
        libmodule-versions-report-perl \
        libtree-simple-perl \
        libdata-page-pageset-perl \
        libhtml-formattext-withlinks-perl \
        libtext-password-pronounceable-perl \
        libtime-parsedate-perl \
        libtext-wikiformat-perl \
        libapache-session-perl \
        libhtml-quoted-perl \
        libjson-perl \
        libdatetime-format-natural-perl \
        libtext-wrapper-perl \
        libuniversal-require-perl \
        libdate-extract-perl \
        libparallel-prefork-perl \
        libserver-starter-perl \
        libmodule-install-perl \
        libcss-minifier-xs-perl \
        libcrypt-eksblowfish-perl \
        libtext-quoted-perl \
        libdata-ical-perl \
        libhtml-rewriteattributes-perl \
        libnet-cidr-perl \
        libhtml-formattext-withlinks-andtables-perl \
        libmime-tools-perl \
        libtext-template-perl

# RT requires later versions of Email::Address and
# Email::Address::List than are in apt
RUN /usr/bin/cpanm Email::Address@1.912
RUN /usr/bin/cpanm Email::Address::List@0.06

# Install FASTCGI dependencies:
RUN     apt-get update --yes && \
        apt-get install --yes \
        libfcgi-perl

# Install CLI dependencies:
RUN     apt-get update --yes && \
        apt-get install --yes \
        libterm-readline-gnu-perl \
        libterm-readline-perl-perl \
        libterm-readkey-perl

# Install MAILGATE dependencies:
RUN /usr/bin/cpanm Mozilla::CA@20180117

ENV BUILD_GRAPHVIZ ${GRAPHVIZ:-enable}
ENV BUILD_GD ${GD:-enable}
ENV BUILD_EXTERNALAUTH ${EXTERNALAUTH:-disable}
ENV BUILD_GPG ${GPG:-disable}
ENV BUILD_SMIME ${SMIME:-disable}
ENV BUILD_DEVELOPER ${DEVELOPER:-disable}

# Install GRAPHVIZ dependencies:
RUN     [ "${BUILD_GRAPHVIZ}" = "enable" ] && \
        apt-get update --yes && \
        apt-get install --yes \
        libgraphviz-perl

# Install GD dependencies:
RUN     [ "${BUILD_GD}" = "enable" ] && \
        apt-get update --yes && \
        apt-get install --yes \
        libgd-perl \
        libgd-text-perl \
        libgd-graph-perl

# Install EXTERNALAUTH dependencies:
RUN set -eux; \
        if [ "${BUILD_EXTERNALAUTH}" = "enable" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libnet-ldap-perl; \
        fi

# TODO: Install GnuPG::Interface-compatible version of GnuPG
# Install GPG dependencies:
RUN set -eux; \
        if [ "${BUILD_GPG}" = "enable" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libgnupg-interface-perl \
            libperlio-eol-perl; \
        fi

# Install DEVELOPER dependencies:
RUN set -eux; \
        if [ "${BUILD_DEVELOPER}" = "enable" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libtest-nowarnings-perl \
            libtest-warn-perl \
            liblog-dispatch-perl-perl \
            libtest-mocktime-perl \
            libset-tiny-perl \
            libtest-email-perl \
            libcrypt-x509-perl \
            libemail-abstract-perl \
            libencode-hanextra-perl \
            libtest-pod-perl \
            libtest-longstring-perl \
            libtest-www-mechanize-psgi-perl \
            libtest-deep-perl \
            liblocale-po-perl \
            libtest-expect-perl \
            libxml-simple-perl \
            libplack-middleware-test-stashwarnings-perl \
            libmojo-server-fastcgi-perl \
            libnet-ldap-server-test-perl; \
        fi

ENV RT_HOME=/rt4
ENV RT_SRC_ROOT /usr/local/src
ENV RT_VERSION 4.4.${PATCH}
ENV RT_TAG rt-${RT_VERSION}

WORKDIR $RT_SRC_ROOT

ADD https://github.com/bestpractical/rt/archive/$RT_TAG.tar.gz ./

COPY checksums/$RT_VERSION/SHA512SUMS ./

RUN     /usr/bin/sha512sum --check SHA512SUMS && \
        tar --file=$RT_TAG.tar.gz --extract --verbose && \
        mv rt-$RT_TAG $RT_TAG

WORKDIR $RT_SRC_ROOT/$RT_TAG

RUN     ./configure.ac \
        --prefix=${RT_HOME} \
        --with-db-type=${BUILD_DB_TYPE} \
        --${BUILD_GRAPHVIZ}-graphviz \
        --${BUILD_GD}-gd \
        --${BUILD_EXTERNALAUTH}-externalauth \
        --${BUILD_GPG}-gpg \
        --${BUILD_SMIME}-smime \
        --${BUILD_DEVELOPER}-developer && \
        make testdeps && \
        make install && \
        rm -rf /root/.cpanm && \
        apt-get purge --yes --autoremove \
        build-essential \
        autoconf \
        cpanminus && \
        apt-get clean --yes

WORKDIR $RT_HOME
