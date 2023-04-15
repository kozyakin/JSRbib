1. Если в файле **JSRbib.tex** имеется строка

    ```
    \usepackage[a-1b,mathxmp]{pdfx}
    ```

    то ее следует удалить и заменить строками

    ```
    \ifdefined\HCode\relax
    \else
    \usepackage[a-1b,mathxmp]{pdfx}
    \fi
    ```

2. При необходимости выполнить сортировку и сжатие цитат ПРИ СОВМЕСТНОМ ИСПОЛЬЗОВАНИИ **authorindex**, вставить следующие команды

    ```
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

    ```
    make4ht -s JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

    (пробел в последней паре кавычек **НЕ УДАЛЯТЬ!**) А затем для "вложения" сгенерированного файла .css в .html, запустить дополнительно команду

    ```
    make4ht -sm draft JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```
    
5. К сожалению по непонятным причинам команды из п4 перестали работать в **batch**-файлах в последних выпусках **TeXLive** . Поэтому они могут быть заменены на две одинаковые команды:
    ```
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```
    
6. Сделать в полученном .html файле замены

    ```
    <\/a>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<a -> <\/a>, <a
    ,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<\/span> -> , <\/span>
    .figure \&gt; p -> .figure \> p
    ```

    После этого вместо `&#x00A0;` в utf-8 кодировке в соответствующих местах будет стоять символ `No-Breake-Space` 

---

#### Замечание
Процедуры из пунктов 5, 6 можно выполнить, запустив один из двух cmd-файлов (при этом в системе должен быть установлен и находиться в переменной **PATH** компилятор **Perl**):

```
htlatex+include_css+cleaning.cmd 
make4ht+include_css+cleaning.cmd 
```
