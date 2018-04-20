![matrix](matrix.png)

This program adds, multiplies, tranposes, and averages matrices!


# Installation

<h2 class="code">1. Download</h2>

```shell
wget http://www.liambeckman.com/code/matrix/matrix.tar.gz
# or for a quick git clone...
# git clone https://github.com/lbeckman314/matrix
```

<h2 class="code">Optional (but recommended): verify file integrity</h2>

```shell
#-------------------------------#
# RECIEVE GPG KEYS
#-------------------------------#

gpg --keyserver pgp.mit.edu --recv-keys AC1CC079

#-------------------------------#
# RECIEVE SHA256SUMS
#-------------------------------#

wget http://www.liambeckman.com/code/matrix/sha256sums.txt{,.sig}
# or if you prefer curl:
# curl http://www.liambeckman.com/code/matrix/sha256sums.txt{,.sig} -o sha256sums.txt -o sha256sums.txt.sig

#-------------------------------#
# VERIFY SHA256SUMS
#-------------------------------#

gpg --verify sha256sums.txt.sig

# gpg: Signature made Tue Oct 31 11:11:11 2017 PDT using RSA key ID AC1CC079
# gpg: Good signature from "liam beckman ("I only want to live in peace,
#        plant potatoes, and dream!" -Tove Jansson) <lbeckman314@gmail.com>" [unknown]

#-------------------------------#
# VERIFY FILE INTEGRITY
#-------------------------------#

sha256sum -c sha256sums.txt

# matrix.tar.gz: OK
# matrix.zip: OK

#-------------------------------#
# OPTIONALLY REMOVE PUBLIC KEY
#-------------------------------#

# to remove my public key from your public key ring, simply
gpg --delete-key AC1CC079
```


<h2 class="code">2. Extract</h2>

```shell
tar -zxvf matrix.tar.gz
# or if you downloaded the zip file
# unzip matrix.zip
```


<h2 class="code">3. Compile and run</h2>

```shell
g++ matrix/src/matrix.cpp -o matrix/src/matrix
./matrix/src/matrix
```


# Uninstallation

<h2 class="code">1. Delete the directory/folder.</h2>

```shell
rm -rfI matrix
```
