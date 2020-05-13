FROM swift
WORKDIR /app
ADD . ./

RUN apt-get update
RUN apt-get install libssl-dev
RUN apt-get install libz-dev
RUN apt-get install libsqlite3-dev

RUN swift package clean
RUN swift build -c release
RUN mkdir /app/bin
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/Run serve -e prod -b 0.0.0.0
