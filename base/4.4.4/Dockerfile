FROM debian:buster-20190812

ENV RT_ROOT /opt
ENV RT_SRC_ROOT $RT_ROOT/src
ENV RT_VERSION 4.4.4
ENV RT_TAG rt-$RT_VERSION
ENV RT_HOME $RT_ROOT/rt4
ENV RT_SRC_ARCHIVE $RT_SRC_ROOT/$RT_TAG.tar.gz
ENV RT_SRC_HOME $RT_SRC_ROOT/rt-$RT_TAG
ENV PERL5LIB $RT_HOME/lib
ENV RT_FIX_DEPS_CMD /usr/bin/cpanm

RUN     apt-get update --yes

# Install Perl dependencies:
RUN     apt-get install --yes \
        build-essential \
        autoconf \
        cpanminus

# Install SQLITE dependencies:
RUN     apt-get install --yes \
        sqlite3 \
        libdbd-sqlite3-perl

# Install FASTCGI dependencies:
RUN     apt-get install --yes \
        libfcgi-perl

# Install CLI dependencies:
RUN     apt-get install --yes \
        libterm-readline-gnu-perl \
        libterm-readline-perl-perl \
        libterm-readkey-perl

# Install MAILGATE dependencies:
RUN /usr/bin/cpanm Mozilla::CA@20180117

# Install CORE dependencies
RUN     apt-get install --yes \
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

# Install GRAPHVIZ dependencies:
RUN     apt-get install --yes \
        libgraphviz-perl

# Install GD dependencies:
RUN     apt-get install --yes \
        libgd-perl \
        libgd-text-perl \
        libgd-graph-perl

# Install EXTERNALAUTH dependencies:
RUN     apt-get install --yes \
        libnet-ldap-perl

## TODO: Install GnuPG::Interface-compatible version of GnuPG
## Install GPG dependencies:
#RUN     apt-get install --yes \
#        gnupg1 \
#        libgnupg-interface-perl \
#        libperlio-eol-perl

RUN mkdir --parents $RT_SRC_ROOT

ADD https://github.com/bestpractical/rt/archive/$RT_TAG.tar.gz $RT_SRC_ARCHIVE

COPY checksums/$RT_TAG/SHA512SUMS $RT_SRC_ROOT/SHA512SUMS

RUN /usr/bin/sha512sum --check $RT_SRC_ROOT/SHA512SUMS

# Unarchives to rt-$RT_TAG ($RT_SRC_ARCHIVE)
RUN tar --directory=$RT_SRC_ROOT --file=$RT_SRC_ARCHIVE --extract --verbose
