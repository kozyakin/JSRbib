# JSRbib

Здесь представлено все необходимое для создания файлов **JSRbib.pdf** и **JSRbib.html**,  содержащих *An annotated bibliography on convergence of matrix products and the theory of joint/generalized spectral radius* *(Аннотированную библиографию по сходимости матричных произведений и теории совместного/обобщенного спектрального радиуса)*

## Пререквизиты и подготовка

* **TexLive** или **MikTex** (или любая другая система **TeX**)
* **Perl**, доступный для всех пользователей (т.е. добавленный в системный **PATH**)
* **HTML tidy** (программа чистки HTML кода), доступная для всех пользователей (т.е. установленная и добавленная в системный **PATH**); может быть загружена с сайта [HTML Tidy](https://www.html-tidy.org/) или [htacg/tidy-html5](https://github.com/htacg/tidy-html5)
* **Node.js** (среда выполнения **JavaScript**) с дополнительно установлеными модулями **purifycss** и **cleancss**

Для добавления новых записей в **JSRbib.pdf** необходимо:

* добавить подходящие записи **BiBTex** в файл **JSR+matprod.bib**
* добавить цитирование новых записей в файл **JSRbib.tex**
* откомпилировать **JSRbib.tex** для создания **JSRbib.pdf**
* обработать файл **JSRbib.tex** с помощью программы **make4ht** для создания **JSRbib.html**

## Предварительные шаги

Внимательно прочитайте [html/README.md](html/README.md) и при необходимости сделайте описанные там предварительные шаги.

## Создание JSRbib.pdf

Напомним еще раз: в системе должен быть установлен **Perl** с прописанным путем к нему в **PATH** &mdash; для этого проще всего скачать в интернете и установить **Strawberry Perl** &mdash; после установки он сразу настроится на выполнение и никаких дополнительных действий не потребуется.

В случае, если в системе установлен **TexLive**, выполнение полного цикла трансляции состоит из следующих команд:

```sh
pdflatex --shell-escape JSRbib.tex
bibtex JSRbib
pdflatex --shell-escape JSRbib.tex
pdflatex --shell-escape JSRbib.tex
```

В случае, если в системе установлен **MikTeX**, выполнение полного цикла трансляции состоит из следующих команд:

```sh
pdflatex --enable-write18 JSRbib.tex
bibtex JSRbib
pdflatex --enable-write18 JSRbib.tex
pdflatex --enable-write18 JSRbib.tex
```

Ключевым моментом здесь является наличие параметров **--shell-escape** и **--enable-write18**, которые позволяют программе **pdflatex** запускать внешние программы &mdash; в данном случае **Perl**, который в свою очередь исполнит скрип **authorindex-mod.pl**, с помощью которого будет создан требуемый авторский индекс.

Указанные команды могут быть выполнены как в командной строке, так и в подходящем редакторе, но последняя возможность, конечно, зависит от используемого редактора и его возможностей &mdash; обычно инструкции по необходимой конфигурации наиболее распространенных редакторов могут быть найдены в интернете.

## Создание JSRbib.html

1. Создайте временную папку и скопируйте туда все файлы (исключая папку **html** !) из папки **JSRbib**

2. Скопируйте туда же содержимое папки **JSRbib/html**

3. Создайте в этой временной папке файл **JSRbib.pdf**, как описано в разделе *Создание JSRbib.pdf*. **Не удаляйте созданные при этом временные и рабочие файлы!**

4. Выполните в этой временной папке (в командной строке) одну из команд

    ```sh
    make4ht+inject_css_js+cleaning.cmd
    make4ht+inject_css_pl+cleaning.cmd
    ```

5. Через некоторое время Вы получите файл **JSRbib.html**

---

This is a set of files to create **JSRbib.pdf** and **JSRbib.html** containing *An annotated bibliography on convergence of matrix products and the theory of joint/generalized spectral radius*

## Prerequisites and Preparation

* **TexLive** or **MikTex** (or any other **TeX** system)
* **Perl**, available to all users (i.e. added to the system **PATH**)
* **HTML tidy** (HTML cleaner), available to all users (i.e. installed and added to the system **PATH**); can be downloaded from [HTML Tidy](https://www.html-tidy.org/) or [htacg/tidy-html5](https://github.com/htacg/tidy-html5)
* **Node.js** (JavaScript runtime) with the **purifycss** and **cleancss** modules additionally installed

To add new record to the **JSRbib.pdf** it is needed

* Add appropriate **BiBTex** record to **JSR+matprod.bib**
* Add reference to new record in **JSRbib.tex**
* Compile **JSRbib.tex** to generate **JSRbib.pdf**
* Process **JSRbib.tex** with **make4ht** to generate **JSRbib.html**

## Pleliminary step

Read carefully [html/README.md](html/README.md) and make appropriate preliminary steps if necessary.

## Generating JSRbib.pdf

Let us remind once again: **Perl** must be installed with the registered path to it in **PATH** &mdash; the easiest way is to download and install **Strawberry Perl** on the Internet &mdash; after installation it will immediately be configured for execution &mdash; no additional actions are required.

In the case of installed **TexLive**, it is necessary to execute the following commands

```sh
pdflatex --shell-escape JSRbib.tex
bibtex JSRbib
pdflatex --shell-escape JSRbib.tex
pdflatex --shell-escape JSRbib.tex
```

In the case of **MikTeX** installed, the execution of a full processing cycle consists of the following commands

```sh
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

4. Run one of the following commands:

    ```sh
    make4ht+inject_css_js+cleaning.cmd
    make4ht+inject_css_pl+cleaning.cmd
    ```

5. After a while you should get **JSRbib.html**
