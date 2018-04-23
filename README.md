![matrix](matrix.png)

This program adds, multiplies, transposes, and averages matrices!  in action [here](https://asciinema.org/a/zjRyykwFxzX8SYoXAMemrWPk8).

<br />
<hr />

# Installation

For an example of installation, see [here](https://asciinema.org/a/4R4KJhtmdGImK1UHn9x6hIULx).

<h2 class="code">0. Prerequisites</h2>

[`bash`](https://www.gnu.org/software/bash/) :: for running the script.

[`git`](https://git-scm.com/) :: for a quick git clone.

If you have a propensity against git, check out [the alternative installation](./#alternative-installation). In which case [`wget`](https://www.gnu.org/software/wget/) or [`curl`](https://curl.haxx.se/) can be helpful for downloading the necessary files. [`gpg`](https://gnupg.org/) and [`sha256sum`](https://linux.die.net/man/1/sha256sum) can be used to verify the integrity of the files.

If you are running Windows, the above utilities will be packaged in any of the following: [babun](https://babun.github.io/), [cmder](http://cmder.net/), or [Linux Subsystem for Windows](https://docs.microsoft.com/en-us/windows/wsl/install-win10). Take your pick! : )

The above utilities should be installed (or readily available) if you are running a Unix derivative (such as Linux, macOS, or any of the BSD's).

<h2 class="code">1. Quickstart</h2>

```shell
# clone the git repo
git clone https://git.liambeckman.com/cgit/matrix

# enter directory
cd matrix

# allow the script to execute
chmod u+x matrix

# run the script
./matrix add m1 m1
```

<br />

# Uninstallation


<h2 class="code">0. Delete the directory/folder.</h2>

```shell
rm -rfI matrix
```

<br />
<hr />

# Documentation

(Run `man -l matrix.man` while in the directory for a basic man page for `matrix`.)

`matrix` takes four arguments: **add**, **average**, **multiply**, and **transpose**. Matrix input (either with files or standard input) must be integers, either positive or negative, separated by white space. Non-numeric characters (including blank elements) will throw an error. Output will be tab-delimited elements.

<br />
<br />

**add**
    takes two matrices of dimensions `row × col` and `row × col` and produces a sum matrix of dimesions `row × col`. To add two matrices, run `./matrix add m1 m2` where `m1` and `m2` are matrix files.


```sh
$ cat mI1
1   2   3   4
5   6   7   8

$ ./matrix add m1 m1
2	4	6	8
10	12	14	16
```

<br />
<br />

**mean**
    takes one matrix of dimension `row × col` and averages each of it's columns. Produces an average matrix of dimensions `1 × col`. To add two matrices, run `./matrix transpose m1 ` where `m1` is a matrix file.

```sh
$ cat m1
1   2   3   4
5   6   7   8

$ ./matrix mean m1
3	4	5	6
```

<br />
<br />

**multiply**
    takes two matrices of dimensions `row₁ × col₁` and `row₂ × col₂` and produces a sum matrix of dimesions `row₁ × col₂`. col₁ must be eqaul to row₂. To add two matrices, run `./matrix multiply m1 m2` where `m1` and `m2` are matrix files.

```sh
$ cat m1
1   2   3   4
5   6   7   8

$ cat m2
1	5
2	6
3	7
4	8

$ ./matrix multiply m1 m2
30	70
70	174
```

<br />
<br />

**transpose**
    takes one matrix and moves element at position `row × col` to position `col × row`. To add two matrices, run `./matrix transpose m1` where `m1` is a matrix file.

```sh
$ cat m1
1   2   3   4
5   6   7   8

$ ./matrix transpose m1
1	5
2	6
3	7
4	8
```

<br />
<hr />
<br />

# Examples of valid and invalid matrices:

m4 is a **valid** matrix
```
$ cat m4

1   2   3
4   5   6
7   8   9
10  11  12
```
<br />

m5 is an **invalid** matrix: non-numeric character at position (1, 3).
```
$ cat m5

1   2   A
4   5   6
7   8   9
10  11  12
```

<br />
<hr />
<br />

m6 is a **valid** matrix
```
$ cat m6

1   2
2   3
3   4
4   5
```

<br />

m7 is an **invalid** matrix: blank character at position (2, 1)
```
$ cat m7

1   2
    3
3   4
4   5
```

<br />
<hr />
<br />

m8 is a **valid** matrix
```
$ cat -A m8

1   2   3$
```

<br />

m9 is an **invalid** matrix: trailing tab in first row
```
$ cat m9

1   2   3    $
```

<br />
<hr />
<br />

# Alternative Installation

<h2 class="code">0. Download</h2>

Click the tar.gz or zip buttons at the top of the page to download a tar.gz or .zip compressed directory.

Or copy and paste the following command into the terminal to have it download it for you!

```shell
wget http://www.liambeckman.com/pkgs/matrix/matrix.tar.gz

# or if you prefer curl:
# curl http://www.liambeckman.com/pkgs/matrix/matrix.tar.gz -o matrix.tar.gz
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

wget http://www.liambeckman.com/pkgs/matrix/sha256sums.txt{,.asc}
# or if you prefer curl:
# curl http://www.liambeckman.com/pkgs/matrix/sha256sums.txt{,.asc} -o sha256sums.txt -o sha256sums.txt.asc

#-------------------------------#
# VERIFY SHA256SUMS
#-------------------------------#

gpg --verify sha256sums.txt.asc

# gpg: Signature made Tue Oct 31 11:11:11 2017 PDT using RSA key ID AC1CC079
# gpg: Good signature from "liam beckman ("I only want to live in peace, plant potatoes, and dream!" -Tove Jansson) <lbeckman314@gmail.com>" [unknown]

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


<h2 class="code">1. Extract</h2>


```shell
tar -zxvf matrix.tar.gz
# or if you downloaded the zip file
# unzip matrix.zip
```


<h2 class="code">2. Compile and run</h2>


```shell
cd matrix

chmod u+x matrix
./matrix add m1 m1
```

<br />

# Uninstallation


<h2 class="code">0. Delete the directory/folder.</h2>

```shell
rm -rfI matrix
```
