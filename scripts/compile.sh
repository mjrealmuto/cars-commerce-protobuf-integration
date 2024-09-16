#!/bin/bash

flag_d=false
value_d=""

# Function to display usage
usage() {
    echo "Usage: $0 [-d DirectoryToCompile] "
    exit 1
}

if ! command -v protoc &> /dev/null
then
  echo "'protoc' does not seem to be installed on this device."
  exit 1
fi

echo "'protoc' is installed, continuing...";

currentDir=$(pwd)
echo $currentDir


while getopts "d:" opt; do
    case ${opt} in
        d )
            flag_d=true
            value_d=$OPTARG
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" >&2
            usage
            ;;
    esac
    shift
done

if ! $flag_d; then
  echo "No directory was passed. Exiting"
  exit 1
fi

compiledDirectory=$(printf "./src/%s/classes" "$value_d")
protoDirectory=$(printf "./src/%s/protos" "$value_d")

if [ ! -d "$protoDirectory" ]; then
  printf "%s is not a directory. Can not compile .proto files. Please try again" "$protoDirectory"
  exit 1
fi

if [ ! -d "$compiledDirectory" ]; then
  printf "There is no 'classes' directory in %s. Creating directory..." "$value_d"
  mkdir -p $(printf "./src/%s/classes", "$value_d")
fi

for file in "$protoDirectory"/*.proto; do
  protoc --php_out=$(printf "%s/src/%s/classes" "$currentDir" "$value_d") $file
done




