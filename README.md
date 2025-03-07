# srtrelay v1.3.0 ![CI](https://github.com/voc/srtrelay/workflows/CI/badge.svg)
Streaming-Relay for the SRT-protocol

Use at your own risk.

## Quick start
Run with docker (**Note:** nightly image not recommended for production)
```bash
docker run makishimuakuma/srtrelay

# start publisher
ffmpeg -i test.mp4 -c copy -f mpegts srt://localhost:1337?streamid=publish/test

# start subscriber
ffplay -fflags nobuffer srt://localhost:1337?streamid=play/test
```

Start docker with custom config. See [config.toml.example](https://github.com/voc/srtrelay/blob/master/config.toml.example)
```bash
# provide your own config from the local directory
docker run -v $(pwd)/config.toml:/home/srtrelay/config.toml makishimuakuma/srtrelay
```

## Run with docker-compose

In your `docker-compose.yml`:

```yaml
   srtrelay:
     image: makishimuakuma/srtrelay
     restart: always
     container_name: srtrelay
     volumes:
       - ./srtrelay-config.toml:/home/srtrelay/config.toml
     ports:
       - "44560:1337/udp"
```

This will forward port `44560` to internal port `1337` in the container. Importantly, forwarding UDP is required.
It will also copy a `srtrelay-config.toml` file in the same directory into the container to use as config.toml

Start the server with the usual

```bash
docker-compose up -d
```

### Configuration
Please take a look at [config.toml.example](https://github.com/voc/srtrelay/blob/master/config.toml.example) to learn more about configuring srtrelay.

The configuration file can be placed under *config.toml* in the current working directory, at */etc/srtrelay/config.toml* or at a custom location specified via the *-config* flag.

### API
See [docs/API.md](https://github.com/voc/srtrelay/blob/master/docs/API.md) for more information about the API.

## Contributing
See [docs/Contributing.md](https://github.com/voc/srtrelay/blob/master/docs/Contributing.md)

## Credits
Thanks go to
  - Haivision for [srt](https://github.com/Haivision/srt) and [srtgo](https://github.com/Haivision/srtgo)
  - Edward Wu for [srt-live-server](https://github.com/Edward-Wu/srt-live-server)
  - Quentin Renard for [go-astits](https://github.com/asticode/go-astits)
