FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
                    build-essential ca-certificates file g++-mingw-w64 \
                    gcc-mingw-w64 gcc-mingw-w64-x86-64 gdb-mingw-w64 \
                    gdb-mingw-w64-target git libarchive-tools make \
                    mingw-w64 mingw-w64-common mingw-w64-tools \
                    mingw-w64-x86-64-dev msitools pkg-config \
                    protobuf-compiler upx wget wine64 wine64-development \
                    wine64-development-preloader wixl xz-utils zstd

RUN apt-get clean -y && \
    rm -rf /var/lib/apt/lists

RUN cd /tmp/ && \
    wget --no-check-certificate https://www.sqlite.org/2021/sqlite-autoconf-3350400.tar.gz && \
    tar xzvf sqlite-autoconf-3350400.tar.gz && \
    cd sqlite-autoconf-3350400/ && \
    ./configure --host=x86_64-w64-mingw32 && \
    make && make install && \
    rm -rf sqlite-autoconf-3350400.tar.gz sqlite-autoconf-3350400/

RUN wget -P /tmp -q https://dl.google.com/go/go1.16.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go1.16.3.linux-amd64.tar.gz && \
    mkdir -p /go

ENV CC=x86_64-w64-mingw32-gcc
ENV CGO_ENABLED=1
ENV CXX=x86_64-w64-mingw32-g++
ENV GOARCH=amd64
ENV GOOS=windows
ENV GOPATH=/go
ENV MSYS2_ARCH=x86_64
ENV PATH="/go/bin:/usr/local/go/bin:${PATH}"

RUN mkdir -p /work
WORKDIR /work

CMD [ "go", "build" ]
