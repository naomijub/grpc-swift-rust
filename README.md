# grpc-swift-rust

## Usage

1. Set environment variable `OUT_DIR`  to folder `out/`, if necessary.
2. `cargo build`
3. Get grpc:
```
$ curl -LOk https://github.com/protocolbuffers/protobuf/releases/download/v<LATEST_VERSION>/protoc-<LATEST_VERSION>-osx-x86_64.zip
$ unzip protoc-<LATEST_VERSION>-osx-x86_64.zip -d proto_buffer && cd proto_buffer
$ sudo cp bin/protoc /usr/local/bin
$ sudo cp -R include/google/protobuf/ /usr/local/include/google/protobuf
$ protoc --version
``` 
4. Install swift grpc plugins:
```
$ git clone https://github.com/grpc/grpc-swift.git
$ cd grpc-swift
$ make
$ make plugins
$ sudo cp protoc-gen-swift protoc-gen-grpc-swift /usr/local/bin
```
5. Build swift protos `protoc protos/notes.proto --grpc-swift_opt=Client=true,Server=false --grpc-swift_out=.`
6. Install `grpc-swift` dependencies in xcode.
7. In `server/` run `cargo run`
8. Build your swift app and play!