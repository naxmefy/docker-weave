#!/bin/bash

# prepare
if ! command -v deno $> /dev/null
then
    echo "deno could not be found"
    exit 1
fi

if ! command -v docker $> /dev/null
then
    echo "docker could not be found"
    exit 1
fi

function getLatestVersion() {
    local LATEST_URL="https://github.com/$1/releases/latest"
    local LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' $LATEST_URL)
    local LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
    echo "$LATEST_VERSION"
}



PROJECT=jsdw/weave
PROJECT_VERSION="$(getLatestVersion $PROJECT)"
echo "PROJECT_VERSION $PROJECT_VERSION"

if test -z "$PROJECT_VERSION"
then
    echo "no project version available for $PROJECT"
    exit 0
fi

REPO=naxmefy/docker-weave
REPO_VERSION="$(getLatestVersion $REPO)"
REPO_VERSION="v0.4.1"
echo "REPO_VERSION $REPO_VERSION"

if ! test -z "$REPO_VERSION"
then
    # https://www.npmjs.com/package/semver-compare-cli
    if ! deno run https://cdn.deno.land/semver_compare_cli/versions/v2.0.0/raw/semver-compare.js $PROJECT_VERSION gt $REPO_VERSION;
    then
        echo "no build required"
        exit 0
    fi
fi

echo "create build $PROJECT_VERSION for repo $REPO"

ARTIFACT_NAME="weave-$PROJECT_VERSION-x86_64-unknown-linux-musl.tar.gz"
ARTIFACT_URL="https://github.com/$PROJECT/releases/download/$PROJECT_VERSION/$ARTIFACT_NAME"

echo "Download from $ARTIFACT_NAME"

curl -L $ARTIFACT_URL | tar -xz

docker build \
    --build-arg http_proxy=$HTTP_PROXY \
    --build-arg HTTP_PROXY=$HTTP_PROXY \
    --build-arg https_proxy=$HTTPS_PROXY \
    --build-arg HTTPS_PROXY=$HTTPS_PROXY \
    --build-arg no_proxy=$NO_PROXY \
    --build-arg NO_PROXY=$NO_PROXY \
    -q=false \
    -t naxmefy/weave \
    .
