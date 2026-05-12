#!/bin/bash

DIR=$(dirname $(readlink -f $0))
VERSION=$(cat $DIR/info.json | jq -r '.version')
NAME=$(cat $DIR/info.json | jq -r '.name')

echo "Cleaning old builds..."
if [ -f $DIR/Build/$NAME\_$VERSION ]; then
    rm $DIR/Build/$NAME\_$VERSION
fi

if [ -f $DIR/Build/$NAME\_*.zip ]; then
    rm $DIR/Build/$NAME\_*.zip
fi

if [ -f $HOME/.factorio/mods/$NAME\_* ]; then
    rm $HOME/.factorio/mods/$NAME\_*.zip
fi

echo "Packaging $NAME $VERSION..."
mkdir -p $DIR/Build/$NAME\_$VERSION
for file in $DIR/*; do
    if [[ $file != *package.sh* && $file != $DIR/Build* && $file != *README.md* ]]; then
        cp -R $file $DIR/Build/$NAME\_$VERSION/

    fi
done

(cd $DIR/Build && zip -rq $DIR/Build/$NAME\_$VERSION.zip ./$NAME\_$VERSION)

echo "Copying to Factorio mods folder..."
cp $DIR/Build/$NAME\_$VERSION.zip $HOME/.factorio/mods/$NAME\_$VERSION.zip
