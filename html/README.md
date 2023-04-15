1. If file **JSRbib.tex** contains the string

    ```
    \usepackage[a-1b,mathxmp]{pdfx}
    ```

    then this string must be replaced by

    ```
    \ifdefined\HCode\relax
    \else
    \usepackage[a-1b,mathxmp]{pdfx}
    \fi
    ```

2. If necessary to sort and compress cites WHEN USING **authorindex**, then insert the following commands

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

    or put the configuration file **natbib.cfg** in the root directory (directory containing file **JSRbib.tex**)

3. Compile, as usual, the file **JSRbib.tex** to produce **JSRbib.pdf**

4. Run the command

    ```
    make4ht -s JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```

    (**DO NOT DELETE** space in the last pair of quotes !) And then to "embed" the created by the last command .css file in .html, run additionally the following command

    ```
    make4ht -sm draft JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```
    
5. Unfortunately, for unknown reasons, the commands from point 4 stopped working in **batch** files in recent releases of **TeXLive** . Therefore, they can be replaced with commands:
    ```
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    htlatex JSRbib.tex "myconfig" " -cunihtf -utf8"
    ```
    
6. Make the following replacements in the resulting .html file

    ```
    <\/a>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<a -> <\/a>, <a
    ,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<\/span> -> , <\/span>
    .figure \&gt; p -> .figure \> p
    ```

    After that, in utf-8 encoding, instead of `&#x00A0;` the symbol `No-Breake-Space` will appear in the appropriate places. 

---

#### Remark
The procedures from points 5, 6 can be performed by running one of the following two cmd-files sequentially (in this case, the compiler **Perl** must be installed and be in the **PATH** variable on the system):

```
htlatex+include_css+cleaning.cmd 
make4ht+include_css+cleaning.cmd 
```
