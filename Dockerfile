FROM golang
MAINTAINER m1kc <m1kc@yandex.ru>

EXPOSE 8082
CMD ["/go/src/github.com/micro/micro/micro", "web"]

RUN go get -v github.com/micro/go-micro
RUN go get -v github.com/micro/go-plugins/transport/nats
RUN go get -v github.com/micro/micro

RUN rm -v /go/bin/micro

# Remove cyclic dep
RUN sed -i 's|"github.com/micro/go-micro/cmd"||g' /go/src/github.com/micro/go-plugins/transport/nats/nats.go
RUN sed -i 's|cmd.DefaultTransports\["nats"\] = NewTransport||g' /go/src/github.com/micro/go-plugins/transport/nats/nats.go

# Manually register NATS transport
RUN sed -i 's|thttp "github.com/micro/go-micro/transport/http"|thttp "github.com/micro/go-micro/transport/http"\n\ttnats "github.com/micro/go-plugins/transport/nats"|g' /go/src/github.com/micro/go-micro/cmd/cmd.go
RUN sed -i 's|"http": thttp.NewTransport,|"http": thttp.NewTransport,\n\t\t"nats": tnats.NewTransport,|g' /go/src/github.com/micro/go-micro/cmd/cmd.go

RUN cd /go/src/github.com/micro/micro && go build -v
