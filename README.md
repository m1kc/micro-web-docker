# micro-web-docker

This image runs the `micro web` utility from
the [micro](https://github.com/micro/micro) framework. Unlike the vanilla version,
it's patched to support both HTTP and NATS transports.

To build, cd into the repo dir and run:

    docker build -t m1kc/microweb .

Run the image with `docker run`, as usual. You'll need to pass registry address
in any case, and NATS address if you plan to use it. Something like this:

    docker run \
    -ti \
    --rm \
    -e "MICRO_REGISTRY_ADDRESS=consul.mydomain.local:8500" \
    -e 'MICRO_TRANSPORT=nats' \
    -e 'MICRO_TRANSPORT_ADDRESS=nats.mydomain.local:4222' \
    --publish-all \
    m1kc/microweb

