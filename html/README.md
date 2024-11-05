# JSRBib.tex to JSRBib.html

1. Если в файле **JSRbib.tex** имеется строка

    ```latex
    \usepackage[a-1b,mathxmp]{pdfx}
    ```

    то ее следует удалить и заменить строками

    ```latex
    \ifdefined\HCode\relax
    \else
    \usepackage[a-1b,mathxmp]{pdfx}
    \fi
    ```

2. При необходимости выполнить сортировку и сжатие цитат ПРИ СОВМЕСТНОМ ИСПОЛЬЗОВАНИИ **authorindex**, вставить следующие команды

    ```latex
    \usepackage[numbers,sort,compress]{natbib}
    \let\cite=\citep
    \makeatletter
    %%%%%%%%%%%%% natbib.cfg
    \AtBeginDocument{%
    \@ifpackageloaded{authorindex}{%
    \ifNAT@numbers
    \let\org@@citex\NAT@citexnum
    \else
    \let\org@@citex\NAT@citex
    \fi
    \def\@citex[#1][#2]#3{%
    \typeout{indexing: [#1][#2]{#3}}%
    \org@@citex[#1][#2]{#3}%
    \@aicitey{#3}}%
    \renewcommand\NAT@wrout[5]{%
    \if@filesw{%
    \let\protect\noexpand\let~\relax
    \immediate\write\@auxout{\string\aibibcite{#5}{#1}}%
    \immediate\write\@auxout{\string\bibcite{#5}{{#1}{#2}{{#3}}{{#4}}}}}%
    \fi}}{}}
    %%%%%%%%%%%%%
    \makeatother
    ```

    или поместить в корень директории с файлом **JSRbib.tex** файл конфигурации **natbib.cfg**

3. Оттранслировать обычным образом файл **JSRbib.tex**

4. Выполнить команду

    ```sh
    make4ht -s JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

    (пробел в последней паре кавычек **НЕ УДАЛЯТЬ!**) А затем для "вложения" сгенерированного файла .css в .html, запустить дополнительно команду

    ```sh
    make4ht -sm draft JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

5. К сожалению по непонятным причинам команды из п4 перестали работать в **batch**-файлах в последних выпусках **TeXLive** . Поэтому они могут быть заменены на две одинаковые команды:

    ```sh
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

6. Сделать в полученном .html файле замены

    ```html
    <\/a>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<a -> <\/a>, <a
    ,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<\/span> -> , <\/span>
    .figure \&gt; p -> .figure \> p
    ```

    После этого вместо `&#x00A0;` в utf-8 кодировке в соответствующих местах будет стоять символ `No-Breake-Space`

## Замечание

Процедуры из пунктов 5, 6 можно выполнить, запустив следующий cmd-файл (при этом в системе должен быть установлен и находиться в переменной **PATH** компилятор **Perl**, а также платформа для работы с языком JavaScript **Node. js** (Node)):

```sh
make4ht+include_css+cleaning.cmd 
```

---

1. If file **JSRbib.tex** contains the string

    ```latex
    \usepackage[a-1b,mathxmp]{pdfx}
    ```

    then this string must be replaced by

    ```latex
    \ifdefined\HCode\relax
    \else
    \usepackage[a-1b,mathxmp]{pdfx}
    \fi
    ```

2. If necessary to sort and compress cites WHEN USING **authorindex**, then insert the following commands

    ```latex
    \usepackage[numbers,sort,compress]{natbib}
    \let\cite=\citep
    \makeatletter
    %%%%%%%%%%%%% natbib.cfg
    \AtBeginDocument{%
    \@ifpackageloaded{authorindex}{%
    \ifNAT@numbers
    \let\org@@citex\NAT@citexnum
    \else
    \let\org@@citex\NAT@citex
    \fi
    \def\@citex[#1][#2]#3{%
    \typeout{indexing: [#1][#2]{#3}}%
    \org@@citex[#1][#2]{#3}%
    \@aicitey{#3}}%
    \renewcommand\NAT@wrout[5]{%
    \if@filesw{%
    \let\protect\noexpand\let~\relax
    \immediate\write\@auxout{\string\aibibcite{#5}{#1}}%
    \immediate\write\@auxout{\string\bibcite{#5}{{#1}{#2}{{#3}}{{#4}}}}}%
    \fi}}{}}
    %%%%%%%%%%%%%
    \makeatother
    ```

    or put the configuration file **natbib.cfg** in the root directory (directory containing file **JSRbib.tex**)

3. Compile, as usual, the file **JSRbib.tex** to produce **JSRbib.pdf**

4. Run the command

    ```sh
    make4ht -s JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

    (**DO NOT DELETE** space in the last pair of quotes !) And then to "embed" the created by the last command .css file in .html, run additionally the following command

    ```sh
    make4ht -sm draft JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

5. Unfortunately, for unknown reasons, the commands from point 4 stopped working in **batch** files in recent releases of **TeXLive** . Therefore, they can be replaced with commands:

    ```sh
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

6. Make the following replacements in the resulting .html file

    ```html
    <\/a>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<a -> <\/a>, <a
    ,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<\/span> -> , <\/span>
    .figure \&gt; p -> .figure \> p
    ```

    After that, in utf-8 encoding, instead of `&#x00A0;` the symbol `No-Breake-Space` will appear in the appropriate places.

## Remark

The procedures from points 5, 6 can be performed by running the following cmd-file (the **Perl** compiler must be installed in the system and in the **PATH** variable, as well as the **Node. js** (Node) platform for working with the JavaScript language):

```latex
make4ht+include_css+cleaning.cmd 
```
