%% filename: amsplain-ey.bst
%% date: 2024/01/17
%%
%% Version of amsplain.bst modified on 2013/08/21 by V. Kozyakin
%%
%% 1. added support for electronic resource and hyperreferencing
%%
%% 2. added support to strip unnecessary records from MR references
%%
%% 3. URL is printed only if both DOI and EPRINT fields,
%%    for a reference, are absent or empty
%%
%% 4. Sorting is made according year-names with indication of
%% year as a non-numbered item
%%
%% 5. On 2022/09/13 command format.note disjointed into two commands:
%%    format.url & format.note with rearranging all format... output
%%    commands
%%
%% 6. On 2022/09/15 comma before and after note replaced by period
%%
%% 7. On 2023/07/04 added support for hal_id/hal_version processing
%%
%% 8. On 2024/01/17 removed doi duplicating destination of ArXivID
%%
%% ====================================================================
%% filename: amsplain.bst
%% version: 2.0
%% date: 2000/03/27
%%
%% American Mathematical Society
%% Technical Support
%% Publications Technical Group
%% 201 Charles Street
%% Providence, RI 02904
%% USA
%% tel: (401) 455-4080
%%      (800) 321-4267 (USA and Canada only)
%% fax: (401) 331-3842
%% email: tech-support@ams.org
%%
%% Copyright 1995, 2000, 2010 American Mathematical Society.
%%
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%%
%% This work has the LPPL maintenance status `maintained'.
%%
%% The Current Maintainer of this work is the American Mathematical
%% Society.
%%
%% ====================================================================

% See the file btxbst.doc for extra documentation other than
% what is included here.  And see btxhak.tex for a description
% of the BibTeX language and how to use it.

% This defines the types of fields that can occur in a database entry
% for this particular bibliography style.  Except for `language',
% this is the standard list from plain.bst.

%% Types of entries currently allowed in a BibTeX file:
%%
%% ARTICLE -- An article from a journal or magazine.
%%
%% BOOK -- A book with an explicit publisher.
%%
%% BOOKLET -- A work that is printed and bound,
%% but without a named publisher or sponsoring institution.
%%
%% CONFERENCE -- The same as INPROCEEDINGS,
%% included for Scribe compatibility.
%%
%% INBOOK -- A part of a book,
%% which may be a chapter (or section or whatever) and/or a range of pages.
%%
%% INCOLLECTION -- A part of a book having its own title.
%%
%% INPROCEEDINGS -- An article in a conference proceedings.
%%
%% MANUAL -- Technical documentation.
%%
%% MASTERSTHESIS -- A Master's thesis.
%%
%% MISC -- Use this type when nothing else fits.
%%
%% PHDTHESIS -- A PhD thesis.
%%
%% PROCEEDINGS -- The proceedings of a conference.
%%
%% TECHREPORT -- A report published by a school or other institution,
%% usually numbered within a series.
%%
%% UNPUBLISHED -- A document having an author and title, but not formally
%% published.

ENTRY
  { address
    annote
    author
    booktitle
    chapter
    doi
    edition
    editor
    eid
    eprint
    hal_id
    hal_version
    howpublished
    institution
    journal
    key
    keywords
    language
    month
    mrnumber
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    url
    volume
    year
    zblnumber
  }
  {}
  { label bysame }

% Removed after.sentence, after.block---not needed.
STRINGS { urlintro eprinturl eprintprefix doiprefix doiurl yeartemp} % urlbst...
STRINGS { halurl halprefix } % kozyakin for supporting hal...
INTEGERS { hrefform inlinelinks }
FUNCTION {init.urlbst.variables}
{
  "Available from: " 'urlintro := % prefix before URL
  "https://arxiv.org/abs/" 'eprinturl := % prefix to make URL from eprint ref
  "arXiv:" 'eprintprefix := % text prefix printed before eprint ref
  "https://hal.science/" 'halurl := % prefix to make URL from hal ref
  "HAL:" 'halprefix := % text prefix printed before hal ref
  "https://doi.org/" 'doiurl := % prefix to make URL from DOI
  "doi:" 'doiprefix :=      % text prefix printed before DOI ref
  "0" 'yeartemp :=          % label of used years
  #2 'hrefform :=           % 0=no crossrefs; 1=hypertex xrefs; 2=hyperref refs
  #1 'inlinelinks :=        % 0=URLs explicit; 1=URLs attached to titles
}

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

% Scratch variables:

STRINGS { s t }

% Utility functions

FUNCTION {shows}
{ duplicate$ "::::  `" swap$ * "'" * top$
}

FUNCTION {showstack}
{"STACK====================================================================="
top$
stack$
"ENDSTACK=================================================================="
top$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

INTEGERS{ l }
FUNCTION{ string.length }
{
  #1 'l :=
  {duplicate$ duplicate$ #1 l substring$ = not}
    { l #1 + 'l :=}
  while$
  pop$ l
}

INTEGERS {find.length search.start search.end done}
STRINGS {find.string find.pattern}
FUNCTION {contains}
{
  'find.pattern :=
  'find.string :=
  find.pattern string.length 'find.length :=
  #1 'search.start :=
  find.string string.length find.length - #2 + 'search.end :=
  #0 'done :=
  { search.start search.end < }
  {
    find.string search.start find.length substring$ find.pattern =
      { 
        #1 'done :=
        search.end 'search.start :=%% stop searching
      }
      { #1 search.start + 'search.start := }
    if$
  }
  while$
  done
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\emph{" swap$ * "}" * }
  if$
}

% n.dashify is used to make sure page ranges get the TeX code
% (two hyphens) for en-dashes.

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

% tie.or.space.connect connects two items with a ~ if the
% second item is less than 3 letters long, otherwise it just puts an
% ordinary space.

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {add.space.if.necessary}
{ duplicate$ "" =
    'skip$
    { " " * }
  if$
}

% either.or.check gives a warning if two mutually exclusive fields
% were used in the database.

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

% output.nonnull is called by output.

FUNCTION {output.nonnull}
% remove the top item from the stack because it's in the way.
{ 's :=
  output.state mid.sentence =
% If we're in mid-sentence, add a comma to the new top item and write it
    { ", " * write$ }
    { output.state after.block =
% If we're in block, add a period to the new top item and write it
        { ". " * write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
% Put the top item back on the stack that we removed earlier.
  s
}

% Output checks to see if the stack top is empty; if not, it
% calls output.nonnull to write it out.

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

% Standard warning message for a missing or empty field. For the user
% we call any such field `missing' without respect to the distinction
% made by BibTeX between missing and empty.

FUNCTION {missing.warning}
{ "missing " swap$ * " in " * cite$ * warning$ }

% Output.check is like output except that it gives a warning on-screen
% if the given field in the database entry is empty.  t is the field
% name.

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ t missing.warning }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  year yeartemp =
    {}
    { year 'yeartemp :=
      "\pagebreak[3]\item[{\large\textbf{" write$ year write$ "}}]" write$
      newline$}
  if$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
% This empty string is the first thing that will be written
% the next time write$ is called.  Done this way because each
% item is saved on the stack until we find out what punctuation
% should be added after it.  Therefore we need an empty first item.
  ""
  before.all 'output.state :=
}

FUNCTION {output.nonempty.mrnumber}
{ duplicate$ missing$
    { pop$ "" }
    'skip$
  if$
  duplicate$ empty$
    'pop$
    { " XX" *
% Extract only the first part of the field mrnumber of the form {####### something}
      purify$
      #1 "{ff{, }}" format.name$
      #1 "{ll}" format.name$
      duplicate$
      #1 #2 substring$ "MR" =
        {#3 #10 substring$}
        'skip$
      if$
% end of extraction  of #######
      " \mrref{" swap$ * "}" * add.period$ write$ }
  if$
}

FUNCTION {format.zblnumber}
{  zblnumber duplicate$ empty$
    { pop$ "" }
    { " \zblref{" swap$ * "}" * add.period$}
  if$
}

FUNCTION {fin.entry}
{ add.period$
  write$
  mrnumber output.nonempty.mrnumber
  format.zblnumber write$
  newline$
  keywords missing$
    'skip$
    { "\KeyWords{" write$ keywords write$ "}" write$
      newline$}
  if$
  annote missing$
    'skip$
    { "\BibAnnote{" write$ annote write$ "}" write$
      newline$}
  if$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence.orig}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {new.sentence}
{
  new.block
%  new.sentence.orig
}

% Moved some real basic functions like `and' and 'or'
% earlier in the file.

INTEGERS { nameptr namesleft numnames }

% The extra section to write out a language field was added
% for AMSPLAIN.BST.  Not present in plain.bst.

FUNCTION {format.language}
{ language empty$
    { "" }
    { " (" language * ")" * }
  if$
}

% This version of format.names puts names in the format
%
% First von Last, Jr.
%
% (i.e., first name first, no abbreviating to initials).

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { " (eds.)" * }
        { " (ed.)" * }
      if$
    }
  if$
}

FUNCTION {format.nonauthor.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { ", eds." * }
        { ", ed." * }
      if$
    }
  if$
}
FUNCTION {bibinfo.check}
{ swap$
  duplicate$ missing$
    {
      pop$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ pop$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}

FUNCTION {make.href.null}
{
  pop$
}
FUNCTION {make.href.hypertex}
{
  "\special {html:<a href=" quote$ *
  swap$ * quote$ * "> }" * swap$ *
  "\special {html:</a>}" *
}
FUNCTION {make.href.hyperref}
{
  "\href{" swap$ * "} {\path{" * swap$ * "}}" *
}
FUNCTION {make.href}
{ hrefform #2 =
    'make.href.hyperref      % hrefform = 2
    { hrefform #1 =
        'make.href.hypertex  % hrefform = 1
        'make.href.null      % hrefform = 0 (or anything else)
      if$
    }
  if$
}

FUNCTION {format.eprint}
{ eprint empty$
    { "" }
    { eprintprefix eprint * eprinturl eprint * make.href }
  if$
}

FUNCTION {format.hal}
{ hal_id empty$
    { "" }
    { hal_version empty$
        { halprefix hal_id * halurl hal_id * make.href }
	{ halprefix hal_id * hal_version * halurl hal_id * hal_version * make.href }
	  if$
	}
  if$
}

FUNCTION {format.doi}
{ doi empty$
    { "" }
    { doiprefix doi * doiurl doi * make.href }
  if$
}

FUNCTION {format.doi.eprint.output}
{ doi empty$
  { format.eprint output }
  { eprint empty$
      { format.doi output }
      { doi eprint contains
          { format.eprint output }
          { format.doi output
            format.eprint output
          }
        if$
       }
    if$  
  }
  if$
}

FUNCTION {format.url}
{ doi empty$
    { eprint empty$
        { hal_id empty$
            { url empty$
                { "" }
                { "\urlprefix\url{" url * "}" * }
              if$
            }
            { "" }
		  if$
        }
        { "" }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.note}
{
  note empty$
    { "" }
    { note #1 #1 substring$
      duplicate$ "{" =
        'skip$
        { output.state mid.sentence =
            { "l" }
            { "u" }
          if$
          change.case$
        }
      if$
      note #2 global.max$ substring$ * "note" bibinfo.check
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ emphasize }
  if$
}

FUNCTION {format.journal.vol.year}
{ journal empty$
    { "journal name" missing.warning ""}
    { journal }
  if$
  volume empty$
    'skip$
    { " \textbf{" * volume * "}" * }
  if$
  year empty$
    { "year" missing.warning }
    { " (" * year * ")" * }
  if$
}

% For formatting the issue number for a journal article.

FUNCTION {format.number}
{ number empty$
    { "" }
    { "no.~" number * }
  if$
}

% For formatting miscellaneous dates

FUNCTION {format.date}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$
        'year
        { month " " * year * }
      if$
    }
  if$
}

%%      The volume, series and number information is sort of tricky.
%%      This code handles it as follows:
%%      If the series is present, and the volume, but not the number,
%%        then we do "\emph{Book title}, Series Name, vol. 000"
%%      If the series is present, and the number, but not the volume,
%%        then we do "\emph{Book title}, Series Name, no. 000"
%%      If the series is present, and both number and volume,
%%        then we do "\emph{Book title}, vol. XX, Series Name, no. 000"
%%      Finally, if the series is absent,
%%        then we do "\emph{Book title}, vol. XX"
%%        or         "\emph{Book title}, no. 000"
%%        and if both volume and number are present, give a warning message.

FUNCTION {format.bookvolume.series.number}
{ volume empty$
    { "" % Push the empty string as a placeholder in case everything else
         % is empty too.
      series empty$
        'skip$
        { pop$ series } % if series is not empty put in stack
      if$
      number empty$
        'skip$
        { duplicate$ empty$ % if no preceding material,
            'skip$          % do nothing, otherwise
            { ", " * }      % add a comma and space to separate.
          if$
          "no." number tie.or.space.connect * % add the number information
        }
      if$
    }
%% If the volume is NOT EMPTY:
    { "vol." volume tie.or.space.connect % vol. XX
      number empty$
        { series empty$
            'skip$
            { series ", " * swap$ *}    % Series Name, vol. XX
          if$
        }
        { series empty$
            { "can't use both volume and number if series info is missing"
              warning$
              "in BibTeX entry type `" type$ * "'" * top$
            }
            { ", " * series * ", no." * number tie.or.space.connect }
          if$
        }
      if$
    }
  if$

}  % end of format.bookvolume.series.number

%% format.inproc.title.where.editors is used by inproceedings entry types

%%      No case changing or emphasizing for the title.  We want initial
%%      caps, roman.
%%      We add parentheses around the address (place where conference
%%      was held).
%%      Likewise we add parentheses around the editors' names.

FUNCTION {format.inproc.title.address.editors}
{ booktitle empty$
    { "" }
    { booktitle
      address empty$
        'skip$
        { add.space.if.necessary "(" * address * ")" * }
      if$
      editor empty$
        'skip$
        { add.space.if.necessary "(" * format.nonauthor.editors * ")" * }
      if$
    }
  if$
}

%% format.incoll.title.editors is similar to format.inproc... but
%% omits the address. For collections that are not proceedings volumes.

FUNCTION {format.incoll.title.editors}
{ booktitle empty$
    { "" }
    { editor empty$
        { booktitle }
        { booktitle
          add.space.if.necessary "(" * format.nonauthor.editors * ")" *
        }
      if$
    }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { edition "l" change.case$ " ed." * }
        { edition "t" change.case$ " ed." * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages n.dashify }
  if$
}

FUNCTION {format.book.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { "pp.~" pages n.dashify * }
        { "p.~" pages * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.book.pages
    { type empty$
        { "ch.~" }
        { type "l" change.case$ " " * }
      if$
      chapter *
      pages empty$
        'skip$
        { ", " * format.book.pages * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Tech. Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

% The format.crossref functions haven't been paid much attention
% at the present time (June 1990) and could probably use some
% work.  MJD

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "in " journal * }
      if$
    }
    { "in " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " and " * editor #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "in "
    }
    { "vol." volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { series * }
          if$
        }
        { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "in \emph{" booktitle * "}" * }
          if$
        }
        { "in " key * }
      if$
    }
    { "in " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The main functions for each entry type.

% journal, vol and year are formatted together because they are
% not separated by commas.

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  crossref missing$
    { format.journal.vol.year output
      format.number output
      format.pages "pages" output.check
    }
    { format.article.crossref output.nonnull
      format.pages "pages" output.check
    }
  if$
%  format.language *
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.title "title" output.check
  format.edition output
  crossref missing$
    { format.bookvolume.series.number output
      publisher "publisher" output.check
      address output
    }
    { format.book.crossref output.nonnull
    }
  if$
  format.date "year" output.check
%  format.language *
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  format.title "title" output.check
  howpublished output
  address output
  format.date output
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.title "title" output.check
  format.edition output
  crossref missing$
    { format.bookvolume.series.number output
      format.chapter.pages "chapter and pages" output.check
      publisher "publisher" output.check
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      format.book.crossref output.nonnull
    }
  if$
  format.date "year" output.check
%  format.language *
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  crossref missing$
    { format.incoll.title.editors "booktitle" output.check
      format.bookvolume.series.number output
      publisher "publisher" output.check
      address output
      format.edition output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
    }
  if$
  format.book.pages output
%  format.language *
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  crossref missing$
    { format.inproc.title.address.editors "booktitle" output.check
      format.bookvolume.series.number output
      organization output
      publisher output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
    }
  if$
  format.book.pages output
%  format.language *
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization output.nonnull
          address output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  format.title "title" output.check
  author empty$
    { organization empty$
        { address output }
        'skip$
      if$
    }
    { organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  format.book.pages output
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  format.title output
  howpublished output
  format.date output
  format.book.pages output
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.url output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  "Ph.D. thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  format.book.pages output
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  format.title "title" output.check
  format.bookvolume.series.number output
  address empty$
    { editor empty$
        'skip$
        { organization output }
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      editor empty$
        'skip$
        { organization output }
      if$
      publisher output
      format.date "year" output.check
    }
  if$
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  format.date output
  new.block
  format.note output
  new.block
  format.doi.eprint.output
  format.hal output
  format.url output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}"
      format.name$ 't :=
      nameptr #1 >
        {
          nameptr #3
          #1 + =
            numnames #3
            > and
              { "others" 't :=
                #1 'namesleft := }
              'skip$
            if$
            "   "  *
            namesleft #1 = t "others" = and
              { "zzzzz" * }
              { t sortify * }
            if$
        }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {year.sort}
{ year empty$
    { key empty$
        { "to sort, need year or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { year sort.format.names }
  if$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ year.sort
  "    "
  *
  author field.or.null
  sort.format.names
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label prev.author this.author }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
  "abcxyz" 'prev.author :=
  "" 'this.author :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}
EXECUTE {init.urlbst.variables}

ITERATE {longest.label.pass}

FUNCTION {write.lines}
{   { duplicate$ "." = NOT }
    { write$ newline$ }
  while$
  pop$
}

FUNCTION {begin.bib}
{ "\providecommand{\BibAnnote}[1]{#1}"
    write$ newline$
  "\providecommand{\KeyWords}[1]{#1}"
    write$ newline$
  "\begin{thebibliography}{"  longest.label  * "}" *
    write$ newline$
  "\def\mrref#1{\href{https://www.ams.org/mathscinet-getitem?mr=#1}{MR~#1}}"
    write$ newline$
  "\def\zblref#1{\href{https://zbmath.org/?q=an:#1}{Zbl~#1}}"
    write$ newline$
  "\expandafter\ifx\csname url\endcsname\relax"
  write$ newline$
  "  \def\url#1{\texttt{#1}}\fi"
  write$ newline$
  "\expandafter\ifx\csname urlprefix\endcsname\relax\def\urlprefix{URL }\fi"
  write$ newline$
  "\expandafter\ifx\csname href\endcsname\relax"
  write$ newline$
  "  \def\href#1#2{#2} \def\path#1{#1}\fi"
  write$ newline$
  preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
