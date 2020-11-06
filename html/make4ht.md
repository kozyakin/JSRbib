1. If file **JSRbib.tex** contains the string

```
\usepackage[a-1b,mathxmp]{pdfx}
```

then it should be replaced by the strings

```
\ifdefined\HCode\relax
\else
\usepackage[a-1b,mathxmp]{pdfx}
\fi
```

2. If necessary to sort and compress cites WHEN USING **authorindex**, insert the following commands

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

or put in the root directory containing file **JSRbib.tex** the configuration file **natbib.cfg** 

3. Compile as usual the file **JSRbib.tex**

4. Run the command

```
make4ht -sc myconfig.cfg JSRbib.tex "html,0,mathjax,p-indent,charset=utf-8" " -cunihtf -utf8"
```

(space in the last pair of quotes **DO NOT DELETE!**)

5. To "embed" the generated .css file in .html, run additionally the following command once or twice

```
htlatex JSRbib.tex "myconfig,html,0,mathjax,p-indent,charset=utf-8,css-in" " -cunihtf -utf8"
```

or run the command

```
make4ht -sc myconfig.cfg -m draft JSRbib.tex "0,mathjax,p-indent,charset=utf-8,css-in" " -cunihtf -utf8"
```

6. Make the following replacements in the resulting .html file

```
<\/a>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<a -> <\/a>, <a
,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<\/span> -> , <\/span>
.figure \&gt; p -> .figure \> p
```

After that, instead of `& # x00A0;` in utf-8 encoding, the symbol `No-Breake-Space` will appear in the appropriate places 

---

#### Remark
The procedures from points 5, 6 can be performed by running the following two bat-files sequentially (in this case, the compiler **Perl** must be installed and in the **PATH** variable on the system):

```
my_make4ht.bat JSRbib.tex
my_make4ht+include_css+more_selective_cleaning.bat JSRbib.tex
```
