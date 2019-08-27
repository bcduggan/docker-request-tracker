FROM debian:buster-20190812

ARG DB
ARG GRAPHVIZ
ARG GD
ARG EXTERNALAUTH
ARG GPG
ARG SMIME

ENV BUILD_RT_DB ${DB:-SQLite}
ENV BUILD_RT_GRAPHVIZ ${GRAPHVIZ:-1}
ENV BUILD_RT_GD ${GD:-1}
ENV BUILD_RT_EXTERNALAUTH ${EXTERNALAUTH:-0}
ENV BUILD_RT_GPG ${GPG:-0}
ENV BUILD_RT_SMIME ${SMIME:-0}

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
        libmime-tools-perl

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

# Install GRAPHVIZ dependencies:
RUN     [ $BUILD_RT_GRAPHVIZ -eq 1 ] && \
        apt-get update --yes && \
        apt-get install --yes \
        libgraphviz-perl

# Install GD dependencies:
RUN     [ $BUILD_RT_GD -eq 1 ] && \
        apt-get update --yes && \
        apt-get install --yes \
        libgd-perl \
        libgd-text-perl \
        libgd-graph-perl

# Install EXTERNALAUTH dependencies:
RUN set -eux; \
        if [ $BUILD_RT_EXTERNALAUTH -eq 1 ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libnet-ldap-perl; \
        fi

# TODO: Install GnuPG::Interface-compatible version of GnuPG
# Install GPG dependencies:
RUN set -eux; \
        if [ $BUILD_RT_GPG -eq 1 ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libgnupg-interface-perl \
            libperlio-eol-perl; \
        fi


# Install database dependencies:
RUN set -eux; \
        if [ "$BUILD_RT_DB" = "SQLite" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            sqlite3 \
            libdbd-sqlite3-perl; \
        elif [ "$BUILD_RT_DB" = "Pg" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libdbd-pg-perl; \
        elif [ "$BUILD_RT_DB" = "mysql" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libdbd-mysql-perl; \
        else \
            exit 1; \
        fi

ENV RT_ROOT /opt
ENV RT_SRC_ROOT $RT_ROOT/src
ENV RT_HOME $RT_ROOT/rt4
ENV PERL5LIB $RT_HOME/lib
ENV RT_FIX_DEPS_CMD /usr/bin/cpanm

ENV RT_VERSION 4.4.4

ENV RT_TAG rt-$RT_VERSION
ENV RT_SRC_ARCHIVE $RT_SRC_ROOT/$RT_TAG.tar.gz
ENV RT_SRC_HOME $RT_SRC_ROOT/$RT_TAG

RUN mkdir --parents $RT_SRC_ROOT

ADD https://github.com/bestpractical/rt/archive/$RT_TAG.tar.gz $RT_SRC_ARCHIVE

COPY checksums/$RT_TAG/SHA512SUMS $RT_SRC_ROOT/SHA512SUMS

RUN /usr/bin/sha512sum --check $RT_SRC_ROOT/SHA512SUMS

# Unarchives to rt-$RT_TAG
RUN tar --directory=$RT_SRC_ROOT --file=$RT_SRC_ARCHIVE --extract --verbose
RUN mv $RT_SRC_ROOT/rt-$RT_TAG $RT_SRC_HOME
