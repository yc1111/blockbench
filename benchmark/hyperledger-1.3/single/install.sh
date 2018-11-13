. env.sh

if ! [ -d "$HL_DATA" ]; then
  mkdir -p $HL_DATA
fi
cd $HL_DATA

GOTAR="go1.10.5.linux-amd64.tar.gz"
if [ ! -f "$GOTAR" ]; then
  wget https://storage.googleapis.com/golang/$GOTAR
  tar -zxvf $GOTAR
  export GOROOT=`pwd`/go
  export PATH=`pwd`/go/bin:$PATH
  export GOPATH=`pwd`/go/workspace
fi
cd $HL_DATA/go

mkdir -p src/github.com/hyperledger1.3
cd src/github.com/hyperledger1.3
if [ ! -d "fabric-samples" ]; then
  curl -sSL http://bit.ly/2ysbOFE | bash -s 1.3.0
fi
