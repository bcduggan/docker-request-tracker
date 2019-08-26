FROM debian:buster-20190812

ENV RT_ROOT /opt
ENV RT_SRC_ROOT $RT_ROOT/src
ENV RT_VERSION 4.4.4
ENV RT_TAG rt-$RT_VERSION
ENV RT_HOME $RT_ROOT/rt4
ENV PERL5LIB $RT_HOME/lib

ADD https://github.com/bestpractical/rt/archive/$RT_TAG.tar.gz $RT_SRC_ROOT/$RT_TAG.tar.gz

COPY checksums/$RT_TAG/SHA512SUMS $RT_SRC_ROOT

RUN sha512sum --check $RT_SRC_ROOT/SHA512SUMS

# Unarchives to rt-$RT_TAG.tar.gz
RUN tar --directory $RT_SRC_ROOT --extract --file $RT_TAG.tar.gz --verbose
