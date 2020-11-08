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
make4ht -sc myconfig.cfg JSRbib.tex "html,0,mathjax,p-indent,charset=utf-8" " -cunihtf -utf8"
```

(пробел в последней паре кавычек **НЕ УДАЛЯТЬ!**)

5. Для "вложения" сгенерированного файла .css в .html, запустить дополнительно один или два раза команду

```
htlatex JSRbib.tex "myconfig,html,0,mathjax,p-indent,charset=utf-8,css-in" " -cunihtf -utf8"
```

или команду

```
make4ht -sc myconfig.cfg -m draft JSRbib.tex "0,mathjax,p-indent,charset=utf-8,css-in" " -cunihtf -utf8"
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
Процедуры из пунктов 5, 6 можно выполнить, запустив последовательно два bat-файла (при этом в системе должен быть установлен и находиться в переменной **PATH** компилятор **Perl**):

```
my_make4ht.bat JSRbib.tex
my_make4ht+include_css+more_selective_cleaning.bat JSRbib.tex
```
