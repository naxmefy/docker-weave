# docker-weave

![docker stars](https://img.shields.io/docker/stars/naxmefy/weave.svg)

![docker pulls](https://img.shields.io/docker/pulls/naxmefy/weave.svg)

docker image for [weave](https://github.com/jsdw/weave)

> A simple CLI router for wiring together several sources behind a single HTTP endpoint

## usage

```bash
docker run \
    --rm \
    -v "/path/to/dir:/path/in/container" \
    -p 8080:8080 \
    naxmefy/weave \
    weave \
    0.0.0.0:8080 to /path/in/container \
    0.0.0.0:8080/google to https://google.com \
    0.0.0.0:8080/my-react-app to host.docker.internal:3000
```

More examples can be found inside [weave](https://github.com/jsdw/weave) documentation. 
