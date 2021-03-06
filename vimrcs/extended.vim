"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system
if has("mac") || has("macunix")
    set gfn=Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
    set gfn=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
    set gfn=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=Monospace\ 11
endif

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Colorscheme
set background=dark
colorscheme peaksea


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :e! ~/.vim_runtime/my_configs.vim<cr>
autocmd! bufwritepost vimrc source ~/.vim_runtime/my_configs.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry


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
" => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $( <esc>`>a)<esc>`<i(<esc>
vnoremap $[ <esc>`>a]<esc>`<i[<esc>
vnoremap ${ <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a'<esc>`<i'<esc>
vnoremap $' <esc>`>a'<esc>`<i'<esc>
vnoremap $" <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $( ()<esc>i
inoremap $[ []<esc>i
inoremap ${ {<esc>o}<esc>O
inoremap $' ''<esc>i
inoremap $" ""<esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" extra peace

hi Identifier ctermfg=49
hi Function ctermfg=51
hi ExtraWhitespace ctermbg=9

augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
       \ matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction

nmap <F8> :TagbarOpenAutoClose<CR>
nmap <C-a> :w<CR>
imap <C-a> <ESC>:w<CR>
nmap <leader>pp viw"0p
nmap <CR> o<Esc>k
nmap <S-CR> O<Esc>j
nmap <leader><space> a<space><Esc>
nnoremap * :keepjumps normal! mf*`f<CR>
nnoremap <silent> <leader>[ :vertical resize +20<CR>
nnoremap <silent> <leader>] :vertical resize -20<CR>
nnoremap <silent> <leader>= mpggVG=`pzz
map q: <Nop>
nnoremap Q <nop>
map <ALT-h> <C-d>
map <ALT-k> <C-u>
inoremap <Nul> <C-n>

set pastetoggle=<Leader>v

set nolist
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:·
hi SpecialKey guifg=#232839 guibg=NONE gui=NONE ctermfg=0 ctermbg=NONE cterm=NONE
noremap <Leader>x :set list!<CR>

hi DiffAdd     ctermfg=none ctermbg=4 guifg=white guibg=green cterm=none
hi DiffChange  ctermfg=none ctermbg=4 guifg=white guibg=green cterm=none
hi DiffText    ctermfg=none ctermbg=2 guifg=white guibg=red cterm=none
hi DiffDelete  ctermfg=none ctermbg=5 guifg=white guibg=red cterm=none

noremap <silent> <Leader>df :NERDTreeClose<CR> :windo :diffthis<CR>
noremap <silent> <Leader>fd :NERDTreeToggle<CR> :windo :diffoff<CR>

set autoread
au CursorHold,CursorHoldI * checktime

nnoremap <S-j> :m .+1<CR>==
nnoremap <S-k> :m .-2<CR>==

vnoremap <S-j> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv

set cursorline
hi CursorLine guifg=NONE guibg=#232839 gui=NONE ctermfg=NONE ctermbg=0 cterm=NONE
nnoremap <Leader>c :set cursorline!<CR>

" search for visually hightlighted text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

set nowrap
set foldlevelstart=20
set number
" set relativenumber

vnoremap <C-C> :w !xsel -i -b<CR><CR>
vnoremap <C-V> :r !xsel -o -b<CR><CR>
noremap <silent> <Leader>r :so $MYVIMRC<CR>

hi Scrollbar_Clear ctermfg=8 ctermbg=8 guifg=green guibg=black cterm=none
hi Scrollbar_Thumb ctermfg=0 ctermbg=0 guifg=darkgreen guibg=black cterm=reverse

set colorcolumn=121,501,1001,1501
hi ColorColumn ctermbg=0

autocmd BufNewFile,BufRead *.pm.tp set syntax=html
autocmd BufNewFile,BufRead *.tp set syntax=html
autocmd BufNewFile,BufRead *.template set syntax=html
