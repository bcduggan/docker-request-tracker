ARG PATCH=4

FROM bcduggan/request-tracker:4.4.${PATCH}-base_developer

ARG PATCH

RUN apt-get update --yes && apt-get install --yes build-essential

RUN /rt4/sbin/rt-setup-database --action create

WORKDIR /usr/local/src/rt-4.4.${PATCH}

CMD [ "make", "test-parallel" ]
