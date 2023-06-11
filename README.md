# JSRbib

This is a set of files to create **JSRbib.pdf** and **JSRbib.html** containing *An annotated bibliography on convergence of matrix products and the theory of joint/generalized spectral radius*

## Prerequisites and updating

* **TexLive** or **MikTex** (or other **TeX** system)
* **Perl** globally accessible (e.g., added to system **PATH**)

To add new record to the **JSRbib.pdf** it is needed

* Add appropriate **BiBTex** record to **JSR+matprod.bib**
* Add reference to new record in **JSRbib.tex**
* Compile **JSRbib.tex** to generate **JSRbib.pd**f
* Process **JSRbib.tex** with **make4ht** to generate **JSRbib.html**

## Pleliminary step

Read carefully [html/README.md](html/README.md) and make appropriate preliminary steps if necessary.

## Generating JSRbib.pdf

Let us remind once again: **Perl** must be installed with the registered path to it in **PATH** &mdash; the easiest way is to download and install **Strawberry Perl** on the Internet &mdash; after installation it will immediately be configured for execution &mdash; no additional actions are required.

In the case of installed **TexLive**, it is necessary to execute the following commands

```shell
pdflatex --shell-escape JSRbib.tex
bibtex JSRbib
pdflatex --shell-escape JSRbib.tex
pdflatex --shell-escape JSRbib.tex
```

In the case of **MikTeX** installed, the execution of a full processing cycle consists of the following commands

```shell
pdflatex --enable-write18 JSRbib.tex
bibtex JSRbib
pdflatex --enable-write18 JSRbib.tex
pdflatex --enable-write18 JSRbib.tex
```

The key point here is the presence of the **--shell-escape** and **--enable-write18** parameters, which allow **pdflatex** to run external programs &mdash; in this case **Perl**, which in its turn calls the script **authorindex-mod.pl**, and it already creates the required author index.

You can execute these commands either on the command line or by setting up the appropriate editor, but this already depends on the editor &mdash; usually there are instructions for all of them on the Internet.

## Generating JSRbib.html

1. Create a temporary directory and put there all the files (not the directory **html** !) from directory **JSRbib**

2. Put also in this temporary directory all the files from **JSRbib/html**

3. Generate in the temporary directory file **JSRbib.pdf** as instructed in Section *Generating JSRbib.pdf*. **Do not remove auxiliary and working files!**

4. Run the command

    ```shell
    make4ht+include_css+cleaning.cmd
    ```

5. After a while you should get **JSRbib.html**
