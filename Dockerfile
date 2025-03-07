FROM golang:latest AS build

ARG TARGETARCH

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install --no-install-recommends -y git tclsh pkg-config cmake libssl-dev build-essential ninja-build

RUN git clone --depth 1 --branch v1.5.4 https://github.com/Haivision/srt.git libsrt && \
    cmake -S libsrt -B libsrt-build -G Ninja && \
    ninja -C libsrt-build && \
    ninja -C libsrt-build install

RUN git clone --depth 1 --branch v1.3.0 https://github.com/voc/srtrelay.git /build

RUN rm -rf libsrt libsrt-build && \
    apt-get purge -y git tclsh pkg-config cmake libssl-dev build-essential ninja-build && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN GOOS=linux GOARCH=$TARGETARCH go build -ldflags="-w -s" -v -o srtrelay .

FROM debian:stable-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y libssl3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /srtrelay

COPY --from=build /build/config.toml.example ./config.toml
COPY --from=build /build/srtrelay ./
COPY --from=build /usr/local/lib/libsrt* /usr/lib/

CMD [ "./srtrelay" ]
