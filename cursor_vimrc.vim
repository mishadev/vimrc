"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Combined Vimrc for Cursor - Keybindings Only
" Extracted from ~/.vim_runtime/vimrcs/
" Excludes: GUI settings, colorschemes, highlighting, plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" IMPORTANT: Set leader key FIRST before any mappings
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Set timeout length for key sequences (important for leader key to work)
set timeoutlen=1000
set ttimeoutlen=100

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Fast saving
nnoremap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W :w !sudo tee % > /dev/null


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Encoding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing # searches backwards for the current selection
vnoremap <silent> # :<C-u>let @/='\V'.escape(@",'\')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you Ag after the selected text
" Note: Ag plugin won't work, but mapping is kept for compatibility
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ag and put the cursor in the right position
" Note: Ag plugin won't work, but mapping is kept for compatibility
map <leader>g :Ag 

" Search and replace for visually selected text - now on ,r (leader+r)
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Replace single character - remapped to leader+r since 'r' is now redo
nnoremap <leader>r r

" Note: Cope mappings kept but may not work without plugins
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
function! TogglePaste()
    setlocal paste!
    echo "Paste mode: " . (&paste ? "ON" : "OFF")
endfunction
nnoremap <leader>pt :call TogglePaste()<CR>

" Redo mapped to just 'r' in normal mode (overrides replace char)
nnoremap r <C-r>

" Reload vimrc (moved to different key to free up ,r for redo)
noremap <silent> <Leader>rv :so $MYVIMRC<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Map ½ to something useful
map ½ $
cmap ½ $
imap ½ $


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $( <esc>`>a)<esc>`<i(<esc>
vnoremap $) <esc>`>a)<esc>`<i(<esc>

vnoremap $[ <esc>`>a]<esc>`<i[<esc>
vnoremap $] <esc>`>a]<esc>`<i[<esc>

vnoremap ${ <esc>`>a}<esc>`<i{<esc>
vnoremap $} <esc>`>a}<esc>`<i{<esc>

vnoremap $$ <esc>`>a'<esc>`<i'<esc>
vnoremap $' <esc>`>a'<esc>`<i'<esc>
vnoremap $" <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $( ()<esc>i
inoremap $[ []<esc>i
inoremap ${ {}<esc>i
inoremap $' ''<esc>i
inoremap $" ""<esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Extended keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Save with Ctrl-a
nmap <C-a> :w<CR>
imap <C-a> <ESC>:w<CR>

" Paste word and copy it back (for repeated pasting)
" Pastes at cursor position, then yanks the just-pasted text for repeated pasting
nmap <leader>p p`[v`]y

" Paste from register 0 (using different key to avoid conflict)
nnoremap <leader>pp viw"0p

" Enter to insert new line below
nmap <CR> o<Esc>k

" Shift-Enter to insert new line above
nmap <S-CR> O<Esc>j

" Leader + space to add space
nmap <leader><space> a<space><Esc>

" * search - search by word in normal mode
nnoremap * :keepjumps normal! mf*`f<CR>

" Visual mode: * and Shift+* search by selection
vnoremap <silent> * :<C-u>call VisualSearch()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> g* :<C-u>call VisualSearch()<CR>/<C-R>=@/<CR><CR>

" Window resizing
nnoremap <silent> <leader>[ :vertical resize +20<CR>
nnoremap <silent> <leader>] :vertical resize -20<CR>

" Indent entire file
nnoremap <silent> <leader>= mpggVG=`pzz

" Disable Ex mode
map q: <Nop>
nnoremap Q <nop>

" ALT-h/k for half page scrolling
map <ALT-h> <C-d>
map <ALT-k> <C-u>

" Trigger completion
inoremap <Nul> <C-n>

" Toggle paste mode
set pastetoggle=<F3>

" Toggle list (show whitespace)
set nolist
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:·
noremap <Leader>x :set list!<CR>

" Move lines up/down
nnoremap <S-j> :m .+1<CR>==
nnoremap <S-k> :m .-2<CR>==

vnoremap <S-j> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv

" Cursor line
set cursorline
nnoremap <Leader>c :set cursorline!<CR>

" Redo - Ctrl+R in normal mode (native Vim)
" Cmd+R also mapped to redo on Mac via <D-r>
" Leader+r (,r) also does redo - see mapping above
nnoremap <D-r> <C-r>

" Jump navigation - Cmd+o (back) and Cmd+i (forward) on Mac
nnoremap <D-o> <C-o>
nnoremap <D-i> <C-i>

" Search for visually highlighted text (using C-r in visual mode)
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Text wrapping and folding
set nowrap
set foldlevel=20
set nofoldenable
set number

" System clipboard integration
vnoremap <C-C> "+y

" Auto-reload file when changed externally
au CursorHold,CursorHoldI * checktime

" Join lines and remove leading spaces
nnoremap <C-j> :normal! J:s/^\s*//<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python section
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f #--- <esc>a
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 
au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#

" Template files
au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako
au BufNewFile,BufRead *.pm.tp set syntax=html
au BufNewFile,BufRead *.tp set syntax=html
au BufNewFile,BufRead *.template set syntax=html
au BufNewFile,BufRead *.toml.tpl set syntax=yaml

" CoffeeScript section
function! CoffeeScriptFold()
    setl foldmethod=indent
endfunction
au FileType coffee call CoffeeScriptFold()

" Git commit - start at first line
au FileType gitcommit call setpos('.', [0, 1, 1, 0])

" Shell section - tmux compatibility
if exists('$TMUX') 
    set term=screen-256color 
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        " Note: Ag plugin won't work, but function kept for compatibility
        call CmdLine("Ag '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

" Helper function for visual mode search
function! VisualSearch()
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    let @/ = '\V' . l:pattern
    let @" = l:saved_reg
endfunction

