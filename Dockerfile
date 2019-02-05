FROM alpine:latest
MAINTAINER Mike 'Fuzzy' Partin

RUN apk update
RUN apk add openssh openjdk7-jre-base git go
RUN apk add gcc musl musl-dev musl-utils g++
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key

RUN adduser -D -h /org -s /bin/sh org
RUN echo org:6701efd19336759d3834a1187c996ed5 | chpasswd

RUN mkdir /tmp/path ; env GOPATH=/tmp/path go get -v -u -d github.com/fuzzy/goorgeous-george
RUN cd /tmp/path/src/github.com/fuzzy/goorgeous-george ; env GOPATH=/tmp/path go build -v
RUN mv /tmp/path/src/github.com/fuzzy/goorgeous-george/goorgeous-george /
RUN mkdir /config ; mv /tmp/path/src/github.com/fuzzy/goorgeous-george/george.yml /config/
RUN mkdir /data
COPY . /data/
RUN chmod +x /data/run.sh

EXPOSE 22 8080
#CMD ["/bin/sh", "-l"]
CMD ["/data/run.sh"]

