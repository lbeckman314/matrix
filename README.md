![matrix](matrix.png)

This program adds, multiplies, transposes, and averages matrices! See it in action [here](https://asciinema.org/a/zjRyykwFxzX8SYoXAMemrWPk8).

<br />
<hr />

# Installation

For an example of installation, see [here](https://asciinema.org/a/4R4KJhtmdGImK1UHn9x6hIULx).

<h2 class="code">0. Prerequisites</h2>

[`bash`](https://www.gnu.org/software/bash/) :: for running the script.

[`git`](https://git-scm.com/) :: for a quick git clone.

If you are running Windows, the above utilities will be packaged in any of the following: [babun](https://babun.github.io/), [cmder](http://cmder.net/), or [Linux Subsytem for Windows](https://docs.microsoft.com/en-us/windows/wsl/install-win10). Take your pick! : )

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
<hr />

# Uninstallation


<h2 class="code">0. Delete the directory/folder.</h2>

```shell
rm -rfI matrix
```

<br />
<hr />

# Documentation

(Run `man -l matrix.man` while in the directory for a basic man page for `matrix`.)

`matrix` takes four arguments: **add**, **average**, **multiply**, and **transpose**. Matrix input (either with files or standard input) must be integers, either positive or negative, seperated by white space. Non-numeric characters (including blank elements) will throw an error.


**add**
    takes two matrices of dimensions (Y by Z) and (Y by Z) and produces a sum matrix of dimesions (Y by Z). To add two matrices, run `./matrix add m1 m2` where `m1` and `m2` are matrix files.

**average**
    takes one matrix of dimension (Y by X) and averages each of it's columns. Produces an average matrix of dimensions (1 by X). To add two matrices, run `./matrix transpose m1 ` where `m1` is a matrix file.

**multiply**
    takes two matrices of dimensions (Y1 by X1) and (Y2 by X2) and produces a sum matrix of dimesions (X1 by Y2). X1 must be eqaul to Y2. To add two matrices, run `./matrix multiply m1 m2` where `m1` and `m2` are matrix files.

**transpose**
    takes one matrix and moves element at position (Y by X) to position (X by Y). To add two matrices, run `./matrix transpose m1` where `m1` is a matrix file.

<hr />
<br />

Examples of **valid** matrix input include:

```
1   2   3
4   5   6
7   8   9
10  11  12
```
<br />

```
1   2   3   4
5   6   7   8
```
<br />

```
1   2   3
```
<br />

Examples of **invalid** matrix input include:

Non-numeric charcter at position (1, 3).
```
1   2   a
4   5   6
7   8   9
10  11  12
```
<br />

Blank character at position (1, 2)
```
1       3   4
5   6   7   8
```
<br />

Trailing tab in first row
```
1t2\t3\t
```

