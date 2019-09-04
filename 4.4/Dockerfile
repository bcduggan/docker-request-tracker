FROM debian:buster-20190812-slim

ARG PATCH
ARG DB_TYPE
ARG GRAPHVIZ
ARG GD
ARG EXTERNALAUTH
ARG SMIME
ARG GPG

# RT sets its $DatabaseType to the env var $RT_DB_TYPE. But when
# $RT_DB_TYPE is set to empty string, this causes a 'DBIx::SearchBuilder::Handle::'
# module not found error.
#
# $RT_HOME/etc/RT_SiteConfig.d/RT_DatabaseConfig.pm defines
# DatabaseType.
ENV DB_TYPE ${DBTYPE}
ENV RT_PATCH ${PATCH}
ENV RT_GRAPHVIZ ${GRAPHVIZ:-enable}
ENV RT_GD ${GD:-enable}
ENV RT_EXTERNALAUTH ${EXTERNALAUTH:-enable}
ENV RT_SMIME ${SMIME:-enable}
ENV RT_GPG ${GPG:-disable}

ENV RT_HOME=/rt4
ENV RT_SRC_ROOT /usr/local/src/rt4
ENV RT_VERSION 4.4.$RT_PATCH
ENV RT_TAG rt-$RT_VERSION

# TODO: Migrate critical configuration to env vars. See
#       files/RT_SRC_ROOT/4.4./files/RT_HOME/etc/RT_SiteConfig.d/*.pm
ENV NAME=example.com
#ENV ORGANIZATION="Example Organization"
#ENV WEB_DOMAIN=example.com

# Install build dependencies:
RUN     apt-get update --yes && \
        apt-get install --yes \
        build-essential \
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

# By default, this Dockerfile installs all optional dependencies.  You
# can customize this image to include only the dependencies that your
# RT uses.

# Install database dependencies:
RUN set -eux; \
        if [ "${DB_TYPE:-nil}" = "SQLite" -o "${DB_TYPE:-nil}" = "nil" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            sqlite3 \
            libdbd-sqlite3-perl; \
        elif [ "${DB_TYPE:-nil}" = "Pg"  -o "${DB_TYPE:-nil}" = "nil" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libdbd-pg-perl; \
        elif [ "${DB_TYPE:-nil}" = "mysql"  -o "${DB_TYPE:-nil}" = "nil" ]; then \
            apt-get update --yes && \
            apt-get install --yes \
            libdbd-mysql-perl; \
        else \
            echo "Valid values for DB_TYPE are 'SQLite', 'Pg', and 'mysql'"; \
            exit 1; \
        fi

# Install GRAPHVIZ dependencies:
RUN if [ "${RT_GRAPHVIZ:-nil}" = "enable" ]; \
    then \
        apt-get update --yes && \
        apt-get install --yes \
        libgraphviz-perl; \
    fi

# Install GD dependencies:
RUN if [ "${RT_GD:-nil}" = "enable" ]; \
    then \
        apt-get update --yes && \
        apt-get install --yes \
        libgd-perl \
        libgd-text-perl \
        libgd-graph-perl; \
    fi

# Install EXTERNALAUTH dependencies:
RUN if [ "${RT_EXTERNALAUTH:-nil}" = "enable" ]; \
    then \
        apt-get update --yes && \
        apt-get install --yes \
        libnet-ldap-perl; \
    fi

# TODO: Install GnuPG::Interface-compatible version of GnuPG
# Install GPG dependencies:
RUN if [ "${RT_GPG:-nil}" = "enable" ]; \
    then \
        apt-get update --yes && \
        apt-get install --yes \
        libgnupg-interface-perl \
        libperlio-eol-perl; \
    fi

# Install SMIME dependencies:
RUN if [ "${RT_SMIME:-nil}" = "enable" ]; \
    then \
        apt-get update --yes && \
        apt-get install --yes \
        libstring-shellquote-perl \
        libcrypt-x509-perl; \
    fi

WORKDIR $RT_SRC_ROOT

ADD https://download.bestpractical.com/pub/rt/release/$RT_TAG.tar.gz ./

COPY files/RT_SRC_ROOT/4.4.$RT_PATCH/SHA512SUMS ./

RUN /usr/bin/sha512sum --check SHA512SUMS && \
        tar --file=$RT_TAG.tar.gz --extract --verbose

WORKDIR $RT_SRC_ROOT/$RT_TAG

RUN ./configure \
        --prefix=$RT_HOME \
        --with-db-type=${DB_TYPE:-SQLite} \
        --$RT_GRAPHVIZ-graphviz \
        --$RT_GD-gd \
        --$RT_EXTERNALAUTH-externalauth \
        --$RT_GPG-gpg \
        --$RT_SMIME-smime

RUN make testdeps && make install

WORKDIR $RT_HOME

RUN mkdir --parents var/data/smime

# TODO: Migrate critical configs to env vars
COPY files/RT_HOME/etc/RT_SiteConfig.d/*.pm ./etc/RT_SiteConfig.d/

# Mount $RT_HOME/var with persistent storage to initialize persistent
# SQLite database.
#
# TODO: Determine appropriate datbase initialization (first run) and
#       upgrade processes with Docker
RUN ./sbin/rt-setup-database --action init

# Remove build dependencies artifacts:
RUN     rm --recursive --force $RT_SRC_ROOT && \
        rm -rf /root/.cpanm && \
        apt-get purge --yes --autoremove \
        build-essential \
        cpanminus && \
        apt-get clean --yes

ENTRYPOINT [ "./sbin/rt-server" ]
CMD [ "--port", "80" ]
