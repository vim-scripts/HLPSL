" hlpsl.vim
" @Author:      xingchao <xingchao19811209@gmail.com>
" @Website:     
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:    25/03/2013 18:12:22 Monday  
" @Last Change:   
" @Revision:    0.1

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let g:HLPSL_PATH = ''
let g:HLPSL_PdfLatex = ''
let s:hlpsl_template             = { 'default' : {} }
let s:HLPSL_ActualStyle					= 'default'
let s:HLPSL_GlobalTemplateDir	= ''

let s:Attribute                = { 'below':'', 'above':'', 'start':'', 'append':'', 'insert':'' }
let s:HLPSL_Attribute           = {}
let s:HLPSL_Macro                = {'|AUTHOR|'         : 'first name surname',
      \						 '|AUTHORREF|'      : '',
      \						 '|EMAIL|'          : '',
      \						 '|COMPANY|'        : '',
      \						 '|PROJECT|'        : '',
      \						 '|COPYRIGHTHOLDER|': '',
      \		 				 '|STYLE|'          : ''
      \						}

let s:installation						= 'local'
let s:vimfiles								= $VIM
let s:HLPSL_MacroNameRegex        = '\([a-zA-Z][a-zA-Z0-9_]*\)'
let s:HLPSL_MacroCommentRegex		 = '^§'
let s:HLPSL_MacroLineRegex				 = '^\s*|'.s:HLPSL_MacroNameRegex.'|\s*=\s*\(.*\)'

let s:HLPSL_ExpansionRegex				 = '|?'.s:HLPSL_MacroNameRegex.'\(:\a\)\?|'
let s:HLPSL_NonExpansionRegex		 = '|'.s:HLPSL_MacroNameRegex.'\(:\a\)\?|'
let s:HLPSL_TemplateNameDelimiter = '-+_,\. '
let s:HLPSL_TemplateLineRegex		 = '^==\s*\([a-zA-Z][0-9a-zA-Z'.s:HLPSL_TemplateNameDelimiter
let s:HLPSL_TemplateLineRegex		.= ']\+\)\s*==\s*\([a-z]\+\s*==\)\?'
let s:HLPSL_TemplateIf						 = '^==\s*IF\s\+|STYLE|\s\+IS\s\+'.s:HLPSL_MacroNameRegex.'\s*=='
let s:HLPSL_TemplateEndif				 = '^==\s*ENDIF\s*=='


let s:HLPSL_Ctrl_j								= 'on'
let s:HLPSL_TJT									= '[ 0-9a-zA-Z_]*'
let s:HLPSL_TemplateJumpTarget1  = '<+'.s:HLPSL_TJT.'+>\|{+'.s:HLPSL_TJT.'+}'
let s:HLPSL_TemplateJumpTarget2  = '<-'.s:HLPSL_TJT.'->\|{-'.s:HLPSL_TJT.'-}'
let s:HLPSL_TemplateOverwrittenMsg = 'yes' 


let s:HLPSL_LineEndCommColDefault = 149
let s:HLPSL_LoadMenus      				= 'yes'
" let s:HLPSL_OutputGvim            = 'vim'
let s:HLPSL_Printheader           = "%<%f%h%m%<  %=%{strftime('%x %X')}     Page %N"
let s:HLPSL_Root  	       				= '&HLPSL.'           " the name of the root menu of this plugin
let s:HLPSL_TypeOfH               = 'hlpsl'
let s:HLPSL_FormatDate						= '%x'
let s:HLPSL_FormatTime						= '%X'
let s:HLPSL_FormatYear						= '%Y'
let s:HLPSL_SourceCodeExtensions  = 'hlpsl'



let	s:MSWIN =		has("win16") || has("win32") || has("win64") || has("win95")
"
if	s:MSWIN
  if match(resolve( expand("<sfile>")), $VIM ) >= 0
    " if match( s:sourced_script_file, escape( s:vimfiles, ' \' ) ) == 0
    " system wide installation
    let s:installation						= 'system'
    let s:plugin_dir							= $VIM.'\vimfiles\'
  else
    " user installation assumed
    let s:plugin_dir  						= $VIM.'\vimfiles\'
  endif
  "
  "------------------------------------------------------------------------------
  "
  "  g:HLPSL_Dictionary_File  must be global
  "
  if !exists("g:HLPSL_Dictionary_File")
    let g:HLPSL_Dictionary_File     = s:plugin_dir.'hlpsl-support\wordlists\hlpsl.list'
  endif
  "

  let g:HLPSL_PATH = 'c:\hlpsl'
  "pdflatex is already in PATH
  " let g:HLPSL_PdfLatexDir = 'C:\Program Files (x86)\ProTeXt\MiKTex\miktex\bin\x64\'
  let s:HLPSL_GlobalTemplateDir	= s:plugin_dir.'hlpsl-support\templates'
  let s:HLPSL_GlobalTemplateFile = s:HLPSL_GlobalTemplateDir.'\Templates'
  let s:HLPSL_LocalTemplateFile    = s:plugin_dir.'\hlpsl-support\templates\Templates'
  let s:HLPSL_LocalTemplateDir     = fnamemodify( s:HLPSL_LocalTemplateFile, ":p:h" ).'\'
  let s:HLPSL_CodeSnippets 				= s:plugin_dir.'\hlpsl-support\codesnippets\'
  let s:HLPSL_OutputGvim						= 'xterm'

else "linux
  if match( expand("<sfile>"), $VIM ) >= 0
    " if match( s:sourced_script_file, escape( s:vimfiles, ' \' ) ) == 0
    " system wide installation
    let s:installation						= 'system'
    let s:plugin_dir							= $VIM.'/.vim/'
  else
    " user installation assumed
    let s:plugin_dir  						= $HOME.'/.vim/'
  endif
  "
  "------------------------------------------------------------------------------
  "
  "  g:HLPSL_Dictionary_File  must be global
  "
  if !exists("g:HLPSL_Dictionary_File")
    let g:HLPSL_Dictionary_File     = s:plugin_dir.'hlpsl-support/wordlists/hlpsl.list'
  endif
  "

  let g:HLPSL_PATH = '/opt/avispa-1.1/'
  let s:HLPSL_GlobalTemplateDir	= s:plugin_dir.'hlpsl-support/templates'
  let s:HLPSL_GlobalTemplateFile = s:HLPSL_GlobalTemplateDir.'/Templates'
  let s:HLPSL_LocalTemplateFile    = s:plugin_dir.'/hlpsl-support/templates/Templates'
  let s:HLPSL_LocalTemplateDir     = fnamemodify( s:HLPSL_LocalTemplateFile, ":p:h" ).'/'
  let s:HLPSL_CodeSnippets 				= s:plugin_dir.'/hlpsl-support/codesnippets/'
  let s:HLPSL_OutputGvim						= 'xterm'
endif

"
" ---------- HLPSL dictionary -----------------------------------
"
" This will enable keyword completion for hlpsl
if exists("g:HLPSL_Dictionary_File")
  let save=&dictionary
  silent! exe 'setlocal dictionary='.g:HLPSL_Dictionary_File
  silent! exe 'setlocal dictionary+='.save
endif    


"
"  Look for global variables (if any), to override the defaults.
"
function! HLPSL_CheckGlobal ( name )
  if exists('g:'.a:name)
    exe 'let s:'.a:name.'  = g:'.a:name
  endif
endfunction    " ----------  end of function HLPSL_CheckGlobal ----------

call HLPSL_CheckGlobal('HLPSL_LineEndCommColDefault')
call HLPSL_CheckGlobal('HLPSL_LoadMenus')
call HLPSL_CheckGlobal('HLPSL_OutputGvim')
call HLPSL_CheckGlobal('HLPSL_Printheader')
call HLPSL_CheckGlobal('HLPSL_Root')
call HLPSL_CheckGlobal('HLPSL_TypeOfH')
call HLPSL_CheckGlobal('HLPSL_FormatDate')
call HLPSL_CheckGlobal('HLPSL_FormatTime')
call HLPSL_CheckGlobal('HLPSL_FormatYear')
call HLPSL_CheckGlobal('HLPSL_SourceCodeExtensions')
call HLPSL_CheckGlobal('installation')
call HLPSL_CheckGlobal('plugin_dir')
call HLPSL_CheckGlobal('HLPSL_GlobalTemplateDir')
call HLPSL_CheckGlobal('HLPSL_GlobalTemplateFile')
call HLPSL_CheckGlobal('HLPSL_CodeSnippets')
call HLPSL_CheckGlobal('HLPSL_PATH')
call HLPSL_CheckGlobal('hlpsl_template             ')
call HLPSL_CheckGlobal('HLPSL_ActualStyle					')
call HLPSL_CheckGlobal('HLPSL_GlobalTemplateDir	')
call HLPSL_CheckGlobal('HLPSL_Attribute           ')
call HLPSL_CheckGlobal('HLPSL_Macro                ')
call HLPSL_CheckGlobal('installation						')
call HLPSL_CheckGlobal('vimfiles')
call HLPSL_CheckGlobal('HLPSL_MacroCommentRegex		 ')
call HLPSL_CheckGlobal('HLPSL_MacroLineRegex				 ')
call HLPSL_CheckGlobal('HLPSL_TemplateLineRegex		 ')
call HLPSL_CheckGlobal('HLPSL_TemplateIf						 ')
call HLPSL_CheckGlobal('HLPSL_TemplateEndif				 ')
call HLPSL_CheckGlobal('HLPSL_MacroNameRegex        ')
call HLPSL_CheckGlobal('HLPSL_TemplateNameDelimiter ')
call HLPSL_CheckGlobal('HLPSL_ExpansionRegex ')
call HLPSL_CheckGlobal('HLPSL_NonExpansionRegex ')
call HLPSL_CheckGlobal('HLPSL_Ctrl_j								')
call HLPSL_CheckGlobal('HLPSL_TJT')
call HLPSL_CheckGlobal('HLPSL_TemplateJumpTarget1')
call HLPSL_CheckGlobal('HLPSL_TemplateJumpTarget2')
call HLPSL_CheckGlobal('HLPSL_TemplateOverwrittenMsg')


let s:HLPSL_avispaExist = 1
" if executable(s:HLPSL_avispa)
" let s:HLPSL_avispaExist = 1
" endif

let s:HLPSL_hlpsl2latexexist = 1
" if executable(s:HLPSL_tlc)
" let s:HLPSL_hlpsl2latexexist = 1
" endif

"------------------------------------------------------------------------------
"  HLPSL : HLPSL_InitMenus                              {{{1
"  Initialization of HLPSL support menus
"------------------------------------------------------------------------------
"
" the menu names
"
let s:Operator     = s:HLPSL_Root.'&Operator'
let s:Constructs   = s:HLPSL_Root.'&Constructs'
let s:snippets          = s:HLPSL_Root.'&snippets'
let s:Comments          = s:HLPSL_Root.'&Comments'
let s:Run          = s:HLPSL_Root.'&Run'
"
function! HLPSL_InitMenus ()
  "
  "===============================================================================================
  "----- Menu : HLPSL-Operator --------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  "----- Submenu : HLPSL-Operator : Operator defined in the standard modules  ---------------------
  "
  "
  "----- SubSubmenu : HLPSL-Operator : Operator defined in the standard modules Naturals Integers Reals ---------------------
  "
  " exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.+        :call HLPSL_InsertTemplate("operator.plus")<CR>'

  "===============================================================================================
  "----- Menu : HLPSL-Constructs-------------------------------------------------   {{{2
  "===============================================================================================

  "
  "===============================================================================================
  "----- Menu : snippets  ----- --------------------------------------------------   {{{2
  "===============================================================================================
  "


  "
  "===============================================================================================
  "----- Menu : run  ----- --------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  "
    exe "amenu  <silent>  ".s:Run.'.avispa<Tab>\F11                               :call HLPSL_avispa()<CR>'
    exe "imenu  <silent>  ".s:Run.'.avispa<Tab>\F11                          <C-C>:call HLPSL_avispa()<CR>'
    exe "amenu  <silent>  ".s:Run.'.cmd\.\ line\ arg\.\ for\ avispa<Tab>\F12      :call HLPSL_avispaArguments()<CR>'
    exe "imenu  <silent>  ".s:Run.'.cmd\.\ line\ arg\.\ for\ avispa<Tab>\F12 <C-C>:call HLPSL_avispaArguments()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP1-                          :'
  "

  if s:MSWIN 
    let s:non = 0
  else
    exe "amenu  <silent>  ".s:Run.'.&hlpsl2latex<Tab>\F9                                    :call HLPSL_hlpsl2latex()<CR>'
    exe "imenu  <silent>  ".s:Run.'.&hlpsl2latex<Tab>\F9                               <C-C>:call HLPSL_hlpsl2latex()<CR>'
    exe "amenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ hlpsl2latex<Tab>\F10           :call HLPSL_hlpsl2latexArguments()<CR>'
    exe "imenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ hlpsl2latex<Tab>\F10      <C-C>:call HLPSL_hlpsl2latexArguments()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP2-                          :'
  endif

    exe "amenu  <silent>  ".s:Run.'.&hlpsl2html<Tab>\F7                                    :call HLPSL_hlpsl2html()<CR>'
    exe "imenu  <silent>  ".s:Run.'.&hlpsl2html<Tab>\F7                               <C-C>:call HLPSL_hlpsl2html()<CR>'
    exe "amenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ hlpsl2html<Tab>\F8           :call HLPSL_hlpsl2htmlArguments()<CR>'
    exe "imenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ hlpsl2html<Tab>\F8      <C-C>:call HLPSL_hlpsl2htmlArguments()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP3-                          :'

    exe "amenu  <silent>  ".s:Run.'.&hlpsl2clean<Tab>\F5                               <C-C>:call HLPSL_hlpsl2clean()<CR>'
    exe "imenu  <silent>  ".s:Run.'.&hlpsl2clean<Tab>\F5                               <C-C>:call HLPSL_hlpsl2clean()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP4-                          :'



  "
  "===============================================================================================
  "----- Menu : Comments----- --------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  "
  "
  if s:HLPSL_avispaExist ==1
    exe "amenu  <silent>  ".s:Comments.'.line\ comment<Tab>\;cc                               :s=^\(//\)*=\%=g<cr>:noh<cr>'
    exe "amenu  <silent>  ".s:Comments.'.cancel\ line\ comment<Tab>\;cu                          <C-C>:s=^\(%\)*==g<cr>:noh<cr>'
    exe "amenu  <silent>  ".s:Comments.'.end\ line\ comment<Tab>\;qe  A    %%%'
    exe "amenu  <silent>  ".s:Comments.'.-SEP1-                          :'
  endif

  "


  "
  "===============================================================================================
  "----- Menu : help  -------------------------------------------------------   {{{2
  "===============================================================================================
  "
  if s:HLPSL_Root != ""
    exe " menu  <silent>  ".s:HLPSL_Root.'&help\ (HLPSL-Support)<Tab>\\hp        :call HLPSL_HelpHLPSLsupport()<CR>'
    exe "imenu  <silent>  ".s:HLPSL_Root.'&help\ (HLPSL-Support)<Tab>\\hp   <C-C>:call HLPSL_HelpHLPSLsupport()<CR>'
  endif

endfunction    " ----------  end of function  HLPSL_InitMenus  ----------

"
" ---------- hot keys ------------------------------------------
"
" ---------- statement menu ----------------------------------------------------
"
noremap  <buffer>  <silent>  <Leader>gi           :call HLPSL_InsertTemplate("statements.IF-THEN-ELSE")<CR>
noremap  <buffer>  <silent>  <Leader>ga          :call HLPSL_InsertTemplate("statements.CASE")<CR>
noremap  <buffer>  <silent>  <Leader>go           :call HLPSL_InsertTemplate("statements.CASE-OTHER")<CR>
noremap  <buffer>  <silent>  <Leader>glc          :call HLPSL_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>
noremap  <buffer>  <silent>  <Leader>gld           :call HLPSL_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>

inoremap  <buffer>  <silent>  <Leader>gi           :call HLPSL_InsertTemplate("statements.IF-THEN-ELSE")<CR>
inoremap  <buffer>  <silent>  <Leader>ga          :call HLPSL_InsertTemplate("statements.CASE")<CR>
inoremap  <buffer>  <silent>  <Leader>go           :call HLPSL_InsertTemplate("statements.CASE-OTHER")<CR>
inoremap  <buffer>  <silent>  <Leader>glc          :call HLPSL_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>
inoremap  <buffer>  <silent>  <Leader>gld           :call HLPSL_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>


vnoremap  <buffer>  <silent>  <Leader>gi           :call HLPSL_InsertTemplate("statements.IF-THEN-ELSE")<CR>
vnoremap  <buffer>  <silent>  <Leader>ga          :call HLPSL_InsertTemplate("statements.CASE")<CR>
vnoremap  <buffer>  <silent>  <Leader>go           :call HLPSL_InsertTemplate("statements.CASE-OTHER")<CR>
vnoremap  <buffer>  <silent>  <Leader>glc          :call HLPSL_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>
vnoremap  <buffer>  <silent>  <Leader>gld           :call HLPSL_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>

"
" ---------- snippets  menu ----------------------------------------------------
"
noremap  <buffer>  <silent>  <LocalLeader>sf           :call  HLPSL_InsertTemplate("hlpsl.frame")<CR>
inoremap  <buffer>  <silent>  <LocalLeader>sf           :call  HLPSL_InsertTemplate("hlpsl.frame")<CR>
vnoremap  <buffer>  <silent>  <LocalLeader>sf           :call  HLPSL_InsertTemplate("hlpsl.frame")<CR>

"
" ---------- help menu ----------------------------------------------------
"
noremap  <buffer>  <silent>  <LocalLeader>hp           :call HLPSL_HelpHLPSLsupport()<CR>
inoremap  <buffer>  <silent>  <LocalLeader>hp           :call HLPSL_HelpHLPSLsupport()<CR>
vnoremap  <buffer>  <silent>  <LocalLeader>hp           :call HLPSL_HelpHLPSLsupport()<CR>



"
" ---------- Go Defination ----------------------------------------------------
"
noremap  <buffer>  <silent>  <LocalLeader>gd           :call HLPSL_GoDefination()<CR>
inoremap  <buffer>  <silent>  <LocalLeader>gd           :call HLPSL_GoDefination()<CR>
vnoremap  <buffer>  <silent>  <LocalLeader>gd           :call HLPSL_GoDefination()<CR>



if !exists("g:HLPSL_Ctrl_j") || ( exists("g:HLPSL_Ctrl_j") && g:HLPSL_Ctrl_j != 'off' )
  nmap    <buffer>  <silent>  <C-j>   i<C-R>=HLPSL_JumpCtrlJ()<CR>
  imap    <buffer>  <silent>  <C-j>    <C-R>=HLPSL_JumpCtrlJ()<CR>
endif

"jump to defination
function! HLPSL_GoDefination(  )
	let s:cuc		= getline(".")[col(".") - 1]		" character under the cursor
	let	s:item	= expand("<cword>")							" word under the cursor
	let	s:item	='^\(\s*\)\@='.s:item.'\s*==' 
  silent call search(s:item, 'w')
  normal! zz 
endfunction

"
function! HLPSL_Indent(  )
  let s:line  = line()
  let s:line_prev  = s:line - 1 
  let s:indent = indent(s:line_prev)  
endfunction





"------------------------------------------------------------------------------
"  HLPSL_CreateGuiMenus     {{{1
"------------------------------------------------------------------------------
let s:HLPSL_MenuVisible = 0								" state variable controlling the C-menus
"
function! HLPSL_CreateGuiMenus ()
  if s:HLPSL_MenuVisible != 1
    aunmenu <silent> &Tools.Load\ HLPSL\ Support
    amenu   <silent> 60.1000 &Tools.-SEP100- :
    amenu   <silent> 60.1030 &Tools.Unload\ HLPSL\ Support <C-C>:call HLPSL_RemoveGuiMenus()<CR>
    call HLPSL_InitMenus()
    let s:HLPSL_MenuVisible = 1
  endif
endfunction    " ----------  end of function HLPSL_CreateGuiMenus  ----------

"------------------------------------------------------------------------------
"  HLPSL_ToolMenu     {{{1
"------------------------------------------------------------------------------
function! HLPSL_ToolMenu ()
  amenu   <silent> 60.1000 &Tools.-SEP100- :
  amenu   <silent> 60.1030 &Tools.Load\ HLPSL\ Support      :call HLPSL_CreateGuiMenus()<CR>
  imenu   <silent> 60.1030 &Tools.Load\ HLPSL\ Support <C-C>:call HLPSL_CreateGuiMenus()<CR>
endfunction    " ----------  end of function HLPSL_ToolMenu  ----------

"------------------------------------------------------------------------------
"  HLPSL_RemoveGuiMenus     {{{1
"------------------------------------------------------------------------------
function! HLPSL_RemoveGuiMenus ()
  if s:HLPSL_MenuVisible == 1
    if s:HLPSL_Root == ""
      aunmenu <silent> Operator
      aunmenu <silent> Constructs
      aunmenu <silent> Run
    else
      exe "aunmenu <silent> ".s:HLPSL_Root
    endif
    "
    aunmenu <silent> &Tools.Unload\ HLPSL\ Support
    call HLPSL_ToolMenu()
    "
    let s:HLPSL_MenuVisible = 0
  endif
endfunction    " ----------  end of function HLPSL_RemoveGuiMenus  ----------

if has("gui_running")
  "
  call HLPSL_ToolMenu()
  "
  if s:HLPSL_LoadMenus == 'yes'
    call HLPSL_CreateGuiMenus()
  endif
  "
  " nmap  <unique>  <silent>  <Leader>lcs   :call HLPSL_CreateGuiMenus()<CR>
  " nmap  <unique>  <silent>  <Leader>ucs   :call HLPSL_RemoveGuiMenus()<CR>
  "
endif



"
"------------------------------------------------------------------------------
"  HLPSL_Input: Input after a highlighted prompt     {{{1
"------------------------------------------------------------------------------
function! HLPSL_Input ( promp, text, ... )
  echohl Search																					" highlight prompt
  call inputsave()																			" preserve typeahead
  if a:0 == 0 || a:1 == ''
    let retval	=input( a:promp, a:text )
  else
    let retval	=input( a:promp, a:text, a:1 )
  endif
  call inputrestore()																		" restore typeahead
  echohl None																						" reset highlighting
  let retval  = substitute( retval, '^\s\+', "", "" )		" remove leading whitespaces
  let retval  = substitute( retval, '\s\+$', "", "" )		" remove trailing whitespaces
  return retval
endfunction    " ----------  end of function HLPSL_Input ----------

"avispa
let s:HLPSL_avispaCmdLineArgs = ''

function! HLPSL_avispaArguments ()
  let	s:HLPSL_avispaCmdLineArgs= HLPSL_Input(" command line arguments : ",s:HLPSL_avispaCmdLineArgs )
  call HLPSL_avispa()
endfunction    " ----------  end of function HLPSL_avispaArguments ----------

function! HLPSL_avispa()
  " update : write source file if necessary
  exec	":update"
  " run avispa  
  exec	":!avispa  "."% ".s:HLPSL_avispaCmdLineArgs	
endfunction    " ----------  end of function HLPSL_avispa----------


"hlpsl2latex
let s:HLPSL_hlpsl2latexCmdLineArgs = '-standalone'

function! HLPSL_hlpsl2latexArguments ()
  let s:HLPSL_hlpsl2latexCmdLineArgs = ''
  let	s:HLPSL_hlpsl2latexCmdLineArgs= HLPSL_Input(" command line arguments : ",s:HLPSL_hlpsl2latexCmdLineArgs )
  call HLPSL_hlpsl2latex()
endfunction    " ----------  end of function HLPSL_avispaArguments ----------

function! HLPSL_hlpsl2latex()
  " update : write source file if necessary
  exec	":update"
  " run avispa  
  exec	":!hlpsl2latex  ".s:HLPSL_hlpsl2latexCmdLineArgs." % > %<.tex"
  exec	":!pdflatex    %<.tex"
  if s:MSWIN
    silent !AcroRd32  %:r.pdf &
  else
    silent !evince %:r.pdf &
  endif
endfunction    " ----------  end of function HLPSL_hlpsl2latex----------

"hlpsl2html
let s:HLPSL_hlpsl2htmlCmdLineArgs = ''

function! HLPSL_hlpsl2htmlArguments ()
  let	s:HLPSL_hlpsl2htmlCmdLineArgs= HLPSL_Input(" command line arguments : ",s:HLPSL_hlpsl2htmlCmdLineArgs )
  call HLPSL_hlpsl2html()
endfunction    " ----------  end of function HLPSL_avispaArguments ----------

function! HLPSL_hlpsl2html()
  " update : write source file if necessary
  exec	":update"
  " run avispa  
  exec	":!hlpsl2html  ".s:HLPSL_hlpsl2htmlCmdLineArgs." % > %<.html"
  silent !firefox %:r.html &
endfunction    " ----------  end of function HLPSL_hlpsl2html----------

" hlpsl2clean
function! HLPSL_hlpsl2clean()
  " update : write source file if necessary
  exec	":update"
  " run avispa  
  exec	":!hlpsl2clean   %<" 
endfunction    " ----------  end of function HLPSL_hlpsl2html----------

"------------------------------------------------------------------------------
"  HLPSL_InsertTemplate     {{{1
"  insert a template from the template dictionary
"  do macro expansion
"------------------------------------------------------------------------------
function! HLPSL_InsertTemplate ( key, ... )

  " if !has_key( s:HLPSL_Template[s:HLPSL_ActualStyle], a:key ) &&
  " \  !has_key( s:HLPSL_Template['default'], a:key )
  " echomsg "style '".a:key."' / template '".a:key
  " \        ."' not found. Please check your template file in '".s:HLPSL_GlobalTemplateDir."'"
  " return
  " endif

  if &foldenable
    let	foldmethod_save	= &foldmethod
    set foldmethod=manual
  endif
  "------------------------------------------------------------------------------
  "  insert the user macros
  "------------------------------------------------------------------------------

  " use internal formatting to avoid conficts when using == below
  "
  let	equalprg_save	= &equalprg
  set equalprg=

  let mode  = s:HLPSL_Attribute[a:key]

  " remove <SPLIT> and insert the complete macro
  "
  if a:0 == 0
    let val = HLPSL_ExpandUserMacros (a:key)
    if val	== ""
      return
    endif
    let val	= HLPSL_ExpandSingleMacro( val, '<SPLIT>', '' )

    if mode == 'below'
      call HLPSL_OpenFold('below')
      let pos1  = line(".")+1
      put  =val
      let pos2  = line(".")
      " proper indenting
      exe ":".pos1
      let ins	= pos2-pos1+1
      exe "normal ".ins."=="
      "
    elseif mode == 'above'
      let pos1  = line(".")
      put! =val
      let pos2  = line(".")
      " proper indenting
      exe ":".pos1
      let ins	= pos2-pos1+1
      exe "normal ".ins."=="
      "
    elseif mode == 'start'
      normal gg
      call HLPSL_OpenFold('start')
      let pos1  = 1
      put! =val
      let pos2  = line(".")
      " proper indenting
      exe ":".pos1
      let ins	= pos2-pos1+1
      exe "normal ".ins."=="
      "
    elseif mode == 'append'
      if &foldenable && foldclosed(".") >= 0
        echohl WarningMsg | echomsg s:MsgInsNotAvail  | echohl None
        exe "set foldmethod=".foldmethod_save
        return
      else
        let pos1  = line(".")
        put =val
        let pos2  = line(".")-1
        exe ":".pos1
        :join!
      endif
      "
    elseif mode == 'insert'
      if &foldenable && foldclosed(".") >= 0
        echohl WarningMsg | echomsg s:MsgInsNotAvail  | echohl None
        exe "set foldmethod=".foldmethod_save
        return
      else
        let val   = substitute( val, '\n$', '', '' )
        let currentline	= getline( "." )
        let pos1  = line(".")
        let pos2  = pos1 + count( split(val,'\zs'), "\n" )
        " assign to the unnamed register "" :
        let @"=val
        normal p
        " reformat only multiline inserts and previously empty lines
        if pos2-pos1 > 0 || currentline =~ ''
          exe ":".pos1
          let ins	= pos2-pos1+1
          exe "normal ".ins."=="
        endif
      endif
      "
    endif
    "
  else
    "
    " =====  visual mode  ===============================
    "
    if  a:1 == 'v'
      let val = HLPSL_ExpandUserMacros (a:key)
      let val	= HLPSL_ExpandSingleMacro( val, s:HLPSL_TemplateJumpTarget2, '' )
      if val	== ""
        return
      endif

      if match( val, '<SPLIT>\s*\n' ) >= 0
        let part	= split( val, '<SPLIT>\s*\n' )
      else
        let part	= split( val, '<SPLIT>' )
      endif

      if len(part) < 2
        let part	= [ "" ] + part
        echomsg '<SPLIT> missing in template '.a:key
      endif
      "
      " 'visual' and mode 'insert':
      "   <part0><marked area><part1>
      " part0 and part1 can consist of several lines
      "
      if mode == 'insert'
        let pos1  = line(".")
        let pos2  = pos1
        let	string= @*
        let replacement	= part[0].string.part[1]
        " remove trailing '\n'
        let replacement   = substitute( replacement, '\n$', '', '' )
        exe ':s/'.string.'/'.replacement.'/'
      endif
      "
      " 'visual' and mode 'below':
      "   <part0>
      "   <marked area>
      "   <part1>
      " part0 and part1 can consist of several lines
      "
      if mode == 'below'

        :'<put! =part[0]
        :'>put  =part[1]

        let pos1  = line("'<") - len(split(part[0], '\n' ))
        let pos2  = line("'>") + len(split(part[1], '\n' ))
        ""			echo part[0] part[1] pos1 pos2
        "			" proper indenting
        exe ":".pos1
        let ins	= pos2-pos1+1
        exe "normal ".ins."=="
      endif
      "
    endif		" ---------- end visual mode
  endif

  " restore formatter programm
  let &equalprg	= equalprg_save

  "------------------------------------------------------------------------------
  "  position the cursor
  "------------------------------------------------------------------------------
  exe ":".pos1
  let mtch = search( '<CURSOR>', 'c', pos2 )
  if mtch != 0
    let line	= getline(mtch)
    if line =~ '<CURSOR>$'
      call setline( mtch, substitute( line, '<CURSOR>', '', '' ) )
      if  a:0 != 0 && a:1 == 'v' && getline(".") =~ '^\s*$'
        normal J
      else
        :startinsert!
      endif
    else
      call setline( mtch, substitute( line, '<CURSOR>', '', '' ) )
      :startinsert
    endif
  else
    " to the end of the block; needed for repeated inserts
    if mode == 'below'
      exe ":".pos2
    endif
  endif

  "------------------------------------------------------------------------------
  "  marked words
  "------------------------------------------------------------------------------
  " define a pattern to highlight
  call HLPSL_HighlightJumpTargets ()

  if &foldenable
    " restore folding method
    exe "set foldmethod=".foldmethod_save
    normal zv
  endif

endfunction    " ----------  end of function HLPSL_InsertTemplate  ----------



"------------------------------------------------------------------------------
" HLPSL_OpenFold     {{{1
" Open fold and go to the first or last line of this fold.
"------------------------------------------------------------------------------
function! HLPSL_OpenFold ( mode )
  if foldclosed(".") >= 0
    " we are on a closed  fold: get end position, open fold, jump to the
    " last line of the previously closed fold
    let	foldstart	= foldclosed(".")
    let	foldend		= foldclosedend(".")
    normal zv
    if a:mode == 'below'
      exe ":".foldend
    endif
    if a:mode == 'start'
      exe ":".foldstart
    endif
  endif
endfunction    " ----------  end of function HLPSL_OpenFold  ----------

"
"------------------------------------------------------------------------------
"  HLPSL_ReadTemplates     {{{1
"  read the template file(s), build the macro and the template dictionary
"
"------------------------------------------------------------------------------
let	s:style			= 'default'
function! HLPSL_ReadTemplates ( templatefile )

  if !filereadable( a:templatefile )
    echohl WarningMsg
    echomsg "HLPSL Support template file '".a:templatefile."' does not exist or is not readable"
    echohl None
    return
  endif

  let	skipmacros	= 0
  let s:HLPSL_FileVisited  += [a:templatefile]

  "------------------------------------------------------------------------------
  "  read template file, start with an empty template dictionary
  "------------------------------------------------------------------------------

  let item  		= ''
  let	skipline	= 0
  for line in readfile( a:templatefile )
    " if not a comment :
    if line !~ s:HLPSL_MacroCommentRegex
      "
      "-------------------------------------------------------------------------------
      " IF |STYLE| IS ...
      "-------------------------------------------------------------------------------
      "
      let string  = matchlist( line, s:HLPSL_TemplateIf )
      if !empty(string) 
        if !has_key( s:HLPSL_Template, string[1] )
          " new s:style
          let	s:style	= string[1]
          let	s:HLPSL_Template[s:style]	= {}
          continue
        endif
      endif
      "
      "-------------------------------------------------------------------------------
      " ENDIF
      "-------------------------------------------------------------------------------
      "
      let string  = matchlist( line, s:HLPSL_TemplateEndif )
      if !empty(string)
        let	s:style	= 'default'
        continue
      endif
      "
      "-------------------------------------------------------------------------------
      " macros and file includes
      "-------------------------------------------------------------------------------
      "
      let string  = matchlist( line, s:HLPSL_MacroLineRegex )
      if !empty(string) && skipmacros == 0
        let key = '|'.string[1].'|'
        let val = string[2]
        let val = substitute( val, '\s\+$', '', '' )
        let val = substitute( val, "[\"\']$", '', '' )
        let val = substitute( val, "^[\"\']", '', '' )
        "
        if key == '|includefile|' && count( s:HLPSL_FileVisited, val ) == 0
          let path   = fnamemodify( a:templatefile, ":p:h" )
          call HLPSL_ReadTemplates( path.'/'.val )    " recursive call
        else
          let s:HLPSL_Macro[key] = escape( val, '&' )
        endif
        continue                                     " next line
      endif
      "
      " template header
      "
      let name  = matchstr( line, s:HLPSL_TemplateLineRegex )
      "
      if name != ''
        " start with a new template
        let part  = split( name, '\s*==\s*')
        let item  = part[0]
        if has_key( s:HLPSL_Template[s:style], item ) && s:HLPSL_TemplateOverwrittenMsg == 'yes'
          echomsg "style '".s:style."' / existing HLPSL Support template '".item."' overwritten"
        endif
        let s:HLPSL_Template[s:style][item] = ''
        let skipmacros	= 1
        "
        " let s:HLPSL_Attribute[item] = 'below'
        let s:HLPSL_Attribute[item] = 'insert'
        " let s:HLPSL_Attribute[item] = 'append'
        " let s:HLPSL_Attribute[item] = 'below'
        if has_key( s:Attribute, get( part, 1, 'NONE' ) )
          let s:HLPSL_Attribute[item] = part[1]
        endif
      else
        " add to a template 
        if item != ''
          let s:HLPSL_Template[s:style][item] .= line."\n"
        endif
      endif
    endif
  endfor " ----- readfile -----
  let s:HLPSL_ActualStyle	= 'default'
  if s:HLPSL_Macro['|STYLE|'] != ''
    let s:HLPSL_ActualStyle	= s:HLPSL_Macro['|STYLE|']
  endif
  let s:HLPSL_ActualStyleLast	= s:HLPSL_ActualStyle
endfunction    " ----------  end of function HLPSL_ReadTemplates  ----------


"------------------------------------------------------------------------------
"  HLPSL_RereadTemplates     {{{1
"  rebuild commands and the menu from the (changed) template file
"------------------------------------------------------------------------------
function! HLPSL_RereadTemplates ( msg )
  let s:style							= 'default'
  let s:HLPSL_Template     = { 'default' : {} }
  let s:HLPSL_FileVisited  = []
  let	messsage							= ''
  "
  if s:installation == 'system'
    "
    if filereadable( s:HLPSL_GlobalTemplateFile )
      call HLPSL_ReadTemplates( s:HLPSL_GlobalTemplateFile )
    else
      echomsg "Global template file '".s:HLPSL_GlobalTemplateFile."' not readable."
      return
    endif
    let	messsage	= "Templates read from '".s:HLPSL_GlobalTemplateFile."'"
    "
    if filereadable( s:HLPSL_LocalTemplateFile )
      call HLPSL_ReadTemplates( s:HLPSL_LocalTemplateFile )
      let messsage	= messsage." and '".s:HLPSL_LocalTemplateFile."'"
    endif
    "
  else
    "
    if filereadable( s:HLPSL_LocalTemplateFile )
      call HLPSL_ReadTemplates( s:HLPSL_LocalTemplateFile )
      let	messsage	= "Templates read from '".s:HLPSL_LocalTemplateFile."'"
    else
      echomsg "Local template file '".s:HLPSL_LocalTemplateFile."' not readable." 
      return
    endif
    "
  endif
  if a:msg == 'yes'
    echomsg messsage.'.'
  endif

endfunction    " ----------  end of function HLPSL_RereadTemplates  ----------




"------------------------------------------------------------------------------
"  HLPSL_ExpandUserMacros     {{{1
"------------------------------------------------------------------------------
function! HLPSL_ExpandUserMacros ( key )

  if has_key( s:HLPSL_Template[s:HLPSL_ActualStyle], a:key )
    let template 								= s:HLPSL_Template[s:HLPSL_ActualStyle][ a:key ]
  else
    let template 								= s:HLPSL_Template['default'][ a:key ]
  endif
  let	s:HLPSL_ExpansionCounter	= {}										" reset the expansion counter

  "------------------------------------------------------------------------------
  "  renew the predefined macros and expand them
  "  can be replaced, with e.g. |?DATE|
  "------------------------------------------------------------------------------
  let	s:HLPSL_Macro['|BASENAME|']	= toupper(expand("%:t:r"))
  let s:HLPSL_Macro['|DATE|']  		= HLPSL_DateAndTime('d')
  let s:HLPSL_Macro['|FILENAME|']	= expand("%:t")
  let s:HLPSL_Macro['|PATH|']  		= expand("%:p:h")
  let s:HLPSL_Macro['|SUFFIX|']		= expand("%:e")
  let s:HLPSL_Macro['|TIME|']  		= HLPSL_DateAndTime('t')
  let s:HLPSL_Macro['|YEAR|']  		= HLPSL_DateAndTime('y')

  "------------------------------------------------------------------------------
  "  delete jump targets if mapping for C-j is off
  "------------------------------------------------------------------------------
  if s:HLPSL_Ctrl_j == 'off'
    let template	= substitute( template, s:HLPSL_TemplateJumpTarget1.'\|'.s:HLPSL_TemplateJumpTarget2, '', 'g' )
  endif

  "------------------------------------------------------------------------------
  "  look for replacements
  "------------------------------------------------------------------------------
  while match( template, s:HLPSL_ExpansionRegex ) != -1
    let macro				= matchstr( template, s:HLPSL_ExpansionRegex )
    let replacement	= substitute( macro, '?', '', '' )
    let template		= substitute( template, macro, replacement, "g" )

    let match	= matchlist( macro, s:HLPSL_ExpansionRegex )

    if match[1] != ''
      let macroname	= '|'.match[1].'|'
      "
      " notify flag action, if any
      let flagaction	= ''
      if has_key( s:HLPSL_MacroFlag, match[2] )
        let flagaction	= ' (-> '.s:HLPSL_MacroFlag[ match[2] ].')'
      endif
      "
      " ask for a replacement
      if has_key( s:HLPSL_Macro, macroname )
        let	name	= HLPSL_Input( match[1].flagaction.' : ', HLPSL_ApplyFlag( s:HLPSL_Macro[macroname], match[2] ) )
      else
        let	name	= HLPSL_Input( match[1].flagaction.' : ', '' )
      endif
      if name == ""
        return ""
      endif
      "
      " keep the modified name
      let s:HLPSL_Macro[macroname]  			= HLPSL_ApplyFlag( name, match[2] )
    endif
  endwhile

  "------------------------------------------------------------------------------
  "  do the actual macro expansion
  "  loop over the macros found in the template
  "------------------------------------------------------------------------------
  while match( template, s:HLPSL_NonExpansionRegex ) != -1

    let macro			= matchstr( template, s:HLPSL_NonExpansionRegex )
    let match			= matchlist( macro, s:HLPSL_NonExpansionRegex )

    if match[1] != ''
      let macroname	= '|'.match[1].'|'

      if has_key( s:HLPSL_Macro, macroname )
        "-------------------------------------------------------------------------------
        "   check for recursion
        "-------------------------------------------------------------------------------
        if has_key( s:HLPSL_ExpansionCounter, macroname )
          let	s:HLPSL_ExpansionCounter[macroname]	+= 1
        else
          let	s:HLPSL_ExpansionCounter[macroname]	= 0
        endif
        if s:HLPSL_ExpansionCounter[macroname]	>= s:HLPSL_ExpansionLimit
          echomsg "recursion terminated for recursive macro ".macroname
          return template
        endif
        "-------------------------------------------------------------------------------
        "   replace
        "-------------------------------------------------------------------------------
        let replacement = HLPSL_ApplyFlag( s:HLPSL_Macro[macroname], match[2] )
        let template 		= substitute( template, macro, replacement, "g" )
      else
        "
        " macro not yet defined
        let s:HLPSL_Macro['|'.match[1].'|']  		= ''
      endif
    endif

  endwhile

  return template
endfunction    " ----------  end of function HLPSL_ExpandUserMacros  ----------

"
"------------------------------------------------------------------------------
"  HLPSL_ExpandSingleMacro     {{{1
"------------------------------------------------------------------------------
function! HLPSL_ExpandSingleMacro ( val, macroname, replacement )
  return substitute( a:val, escape(a:macroname, '$' ), a:replacement, "g" )
endfunction    " ----------  end of function HLPSL_ExpandSingleMacro  ----------



"------------------------------------------------------------------------------
"  HLPSL_HighlightJumpTargets
"------------------------------------------------------------------------------
function! HLPSL_HighlightJumpTargets ()
  if s:HLPSL_Ctrl_j == 'on'
    exe 'match Search /'.s:HLPSL_TemplateJumpTarget1.'\|'.s:HLPSL_TemplateJumpTarget2.'/'
  endif
endfunction    " ----------  end of function HLPSL_HighlightJumpTargets  ----------




"------------------------------------------------------------------------------
"  HLPSL_JumpCtrlJ     {{{1
"------------------------------------------------------------------------------
function! HLPSL_JumpCtrlJ ()
  let match	= search( s:HLPSL_TemplateJumpTarget1.'\|'.s:HLPSL_TemplateJumpTarget2, 'c' )
  if match > 0
    " remove the target
    call setline( match, substitute( getline('.'), s:HLPSL_TemplateJumpTarget1.'\|'.s:HLPSL_TemplateJumpTarget2, '', '' ) )
  else
    " try to jump behind parenthesis or strings in the current line
    if match( getline(".")[col(".") - 1], "[\]})\"'`]"  ) != 0
      call search( "[\]})\"'`]", '', line(".") )
    endif
    normal l
  endif
  return ''
endfunction    " ----------  end of function HLPSL_JumpCtrlJ  ----------


"------------------------------------------------------------------------------
"  generate date and time     {{{1
"------------------------------------------------------------------------------
function! HLPSL_DateAndTime ( format )
  if a:format == 'd'
    return strftime( s:HLPSL_FormatDate )
  elseif a:format == 't'
    return strftime( s:HLPSL_FormatTime )
  elseif a:format == 'dt'
    return strftime( s:HLPSL_FormatDate ).' '.strftime( s:HLPSL_FormatTime )
  elseif a:format == 'y'
    return strftime( s:HLPSL_FormatYear )
  endif
endfunction    " ----------  end of function HLPSL_DateAndTime  ----------


"
"------------------------------------------------------------------------------
"  Run : help hlpslsupport     {{{1
"------------------------------------------------------------------------------
function! HLPSL_HelpHLPSLsupport ()
  try
    :help hlpslsupport
  catch
    exe ':helptags '.s:plugin_dir.'doc'
    :help hlpslsupport
  endtry
endfunction    " ----------  end of function HLPSL_HelpHLPSLsupport ----------




"
"------------------------------------------------------------------------------
"  READ THE TEMPLATE FILES
"------------------------------------------------------------------------------
call HLPSL_RereadTemplates('no')
"

" ---------------------------------------for HLPSL------------------------------------
"highlight keywords
syn keyword hlpslKeyword		 accept cons   def=  delete  dy    iknows in message    ota  played_by secret  set  start   
syn keyword hlpslFunctionKeyword		exp    hash  hash_func new inv  not xor
syn keyword hlpslPracticeFunctionKeyword	session Snd Rcv environment alice bob 	
syn keyword hlpslTypeKeyword		bool  channel nat public_key  agent  text   symmetric_key  protocol_id 
syn keyword hlpslGoalKeyword		 authentication_on secrecy_of  secret weak_authentication_on  witness request wrequest 
syn keyword hlpslReservedWord       apply attack_state  attack_states equal equations inits intruder leq pair properties property rules scrypt  section step types dummy_agent dummy_bool  dummy_chnl  dummy_chnl_dy  dummy_chnl_ota  dummy_hash dummy_msg  dummy_nat  dummy_nonce  dummy_pk  dummy_set  dummy_sk initial_state crypt contains
syn keyword hlpslLeft		 local   const   composition    intruder_knowledge    init  transition
syn keyword hlpslDefinitionKeyword end  role  goal 
syn keyword hlpslBoolean		TRUE FALSE 		
syn keyword hlpslNormalOperator	CHOOSE SUBSET UNION DOMAIN EXCEPT  ENABLE  ENABLED UNCHANGED 	 
"

syntax region hlpslString  start=/"/ skip=/\\"/ end=/"/
syntax match hlpslComment /%.*/
syntax match hlpslTuple /{[^}]*}/
syntax match hlpslExtraOperator /[\{|\}|\[|\]|\(|\)]/

syntax match hlpslSingleOperator /[+|\||\-|*|/|^|>|<|$|#|  |.|&|~|!|:|''|=|,|;]/ 
syntax match hlpslDisjunction /\\\// 
syntax match hlpslConjunction /\/\\[_]/ 

"-------------------------------- for HLPSL end--------------------------------
"-------------------------------- for PlusCal--------------------------------
"-------------------------------- for PlusCal end--------------------------------

   hi def link hlpslKeyword			Operator
   hi def link hlpslReservedWord			Identifier
   hi def link hlpslSingleOperator 			Function
   hi def link hlpslDefinitionKeyword Statement 
   hi def link hlpslBoolean			Boolean
   hi def link hlpslString			String
   hi def link hlpslTypeKeyword		Type
   hi def link hlpslFunctionKeyword	Function	
   hi def link hlpslPracticeFunctionKeyword	Function	
   hi def link hlpslLeft		Constant
   hi def link hlpslConstant			Constant
   hi def link hlpslComment			Comment
  hi def  hlpslDisjunction  ctermfg=LightGreen guifg=LightGreen
  hi def  hlpslConjunction	ctermfg=DarkGreen guifg=DarkGreen
  hi def  hlpslEqual	cterm=bold ctermfg=DarkCyan guifg=DarkCyan gui=bold
  hi hlpslExtraOperator            guifg=#640404
  hi hlpslEnd            guifg=#D1D1D1

  hi def hlpslGoalKeyword 			cterm=bold ctermfg=Cyan ctermbg=darkgrey guifg=DarkBlue gui=Bold  Italic

iab mn <c-r>= expand("%:r")

iab %%%% <c-r>=("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")<cr>

map <F7> :call HLPSL_hlpsl2html() <CR>
map <F8> :call HLPSL_hlpsl2htmlArguments() <CR>
map <F9> :call HLPSL_hlpsl2latex() <CR>
map <F10> :call HLPSL_hlpsl2latexArguments() <CR>
map <F11> :call HLPSL_avispa() <CR>
map <F12> :call HLPSL_avispaArguments() <CR>



" add comment at the end of line
nmap <leader>qe A    %%%
map <leader>cc :s=^\(//\)*=\%=g<cr>:noh<cr>
map <leader>cu :s=^\(%\)*==g<cr>:noh<cr>

let b:current_syntax = "hlpsl"

