FROM node:14

WORKDIR /build
COPY . .
RUN make build
RUN make test
EXPOSE 4200
WORKDIR /build/cognataTestApp
CMD [ "ng", "serve", "--host=0.0.0.0" ]