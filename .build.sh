#!/bin/bash
set +x

project=matriz
pkgs=/var/www/pkgs/$project
demo=/var/www/demo/programs
src=/var/www/pkgs/$project/src
obj=matriz.sh

git pull origin master

echo "compress"
git archive --format=tar -o $project.tar.gz HEAD
git archive --format=zip -o $project.zip HEAD

echo "sign"
sha256sum *.tar.gz *.zip > sha256sums.txt
gpg --pinentry-mode loopback --passphrase $gpgpass --batch --yes --detach-sign -a sha256sums.txt

echo "copy"
mv $project.tar.gz $project.zip sha256sums.txt* $pkgs
cp $obj $demo
