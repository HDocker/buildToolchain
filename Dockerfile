FROM buildpack-deps:jessie-scm

# gcc for cgo
MAINTAINER justin.h <justin@5nas.cc>
  
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.8
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 53ab94104ee3923e228a2cb2116e5e462ad3ebaeea06ff04463479d7f12d27ca

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

# CMAKE install
  RUN apk add --no-cache curl build-base \
      && curl -O https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz \
      && mv cmake-3.7.2.tar.gz /tmp/ && cd /tmp \
      && tar -xzf cmake-3.7.2.tar.gz \
      && cd cmake-3.7.2 \
      && sh bootstrap \
      && make \
      && make install \
      && cd / && rm -r /tmp/cmake-3.7.2
