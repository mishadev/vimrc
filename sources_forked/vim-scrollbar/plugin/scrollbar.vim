" Vim global plugin to display a curses scrollbar
" Version:              0.2.1
" Last Change:          2016 Jun 05
" Initial Author:       Loni Nix <lornix@lornix.com>
" Contributors:         Samuel Chern-Shinn Liu <sam@ambushnetworks.com>
"
" License:              Distributed under the same terms as Vim itself. See
"                       `:help license`

" Skip init if the loaded_scrollbar var is set.
if exists('g:loaded_scrollbar')
    finish
endif
let g:loaded_scrollbar=1
let g:sign_id=3
let g:sign_thumb_name="ScrollbarThumb"

" Save cpoptions.
let s:save_cpoptions=&cpoptions
set cpoptions&vim

" Set what character gets displayed for normal vs scrollbar highlighted lines.
" Default to '#' for scrollbar, '|' for non-scrollbar.
" (User can override these!)
if !exists('g:scrollbar_thumb')
    let g:scrollbar_thumb='#'
endif

" Set highlighting scheme. (User can override these!)
highlight Scrollbar_Thumb ctermfg=0 ctermbg=0 guifg=black guibg=black cterm=reverse

" Set signs we're goint to use. http://vimdoc.sourceforge.net/htmldoc/sign.html
exec "sign define ".g:sign_thumb_name." text=".g:scrollbar_thumb." texthl=Scrollbar_Thumb"

" Set up a default mapping to toggle the scrollbar (but only if user hasn't
" already done it). Default is <leader>sb.
if !hasmapto('ToggleScrollbar')
    map <silent> <unique> <leader>sb :call ToggleScrollbar()<cr>
endif

" Function to initialize the scrollbar's 'active' vars.
function! <sid>SetScrollbarActiveIfUninitialized()
    " Checks to ensure the active vars are set for global / this buffer.
    if !exists('b:scrollbar_active')
        if !exists('g:scrollbar_active')
            let g:scrollbar_active=1
        endif
        let b:scrollbar_active=g:scrollbar_active
    endif
endfunction
call <sid>SetScrollbarActiveIfUninitialized()

" Function to toggle the scrollbar.
function! ToggleScrollbar()
    call <sid>SetScrollbarActiveIfUninitialized()
    if b:scrollbar_active
        " Toggle to inactive mode.
        let b:scrollbar_active=0

        " Unset all autocmds for scrollbar.
        augroup Scrollbar_augroup
            autocmd!
        augroup END

        " Remove all signs that have been set.
        let buffer_number=bufnr("%")
        let total_lines=line('$')
        let line = 1
        while line <= total_lines
            if b:bar_cache[line] == 1
                exec ":sign unplace ".line." buffer=" . buffer_number
            endif
            let line += 1
        endwhile
        exec ":sign unplace ".total_lines." buffer=" . buffer_number
        let b:bar_cache = []
    else
        " Toggle to active. Setup the scrollbar.
        let b:scrollbar_active=1
        call <sid>SetupScrollbar()
    endif
endfunction

" Set up autocmds to react to user input.
function! <sid>SetupScrollbar()
    augroup Scrollbar_augroup
        autocmd BufEnter     * :call <sid>showScrollbar()
        autocmd BufWinEnter  * :call <sid>showScrollbar()
        autocmd CursorMoved  * :call <sid>showScrollbar()
        autocmd CursorMovedI * :call <sid>showScrollbar()
        autocmd FocusGained  * :call <sid>showScrollbar()
        autocmd VimResized   * :call <sid>showScrollbar()
    augroup END
    call <sid>showScrollbar()
endfunction

" Main function that is called every time a user navigates the current buffer.
function! <sid>showScrollbar()
    call <sid>SetScrollbarActiveIfUninitialized()
    " Quit if the initialized active vars are set to false.
    if g:scrollbar_active==0 || b:scrollbar_active==0
        return
    endif

    " Buffer number.
    let buffer_number=bufnr("%")
    " Total # lines.
    let total_lines=line('$')
    " First line visible in the current window (at top of the buffer).
    let buffer_top=line('w0')
    " Last line visible in the current window. (at bottom of the buffer).
    let buffer_bottom=line('w$')
    " Text height.
    let buffer_size=buffer_bottom-buffer_top

    " If the window height is the same or greater than the total # of lines, we
    " don't need to show a scrollbar. The whole page is visible in the buffer!
    if winheight(0) >= total_lines || total_lines > 50000
        return
    endif

    " Performance enhancer: don't redraw unless buffer window is changed.
    if !exists('b:buffer_top') || !exists('b:buffer_bottom')
        let b:buffer_top=buffer_top
        let b:buffer_bottom=buffer_bottom
    elseif b:buffer_top==buffer_top && b:buffer_bottom==buffer_bottom
        return
    else
        let b:buffer_top=buffer_top
        let b:buffer_bottom=buffer_bottom
    endif

    " How much padding at the top and bottom to give the scrollbar.
    let offset_top = floor(buffer_top*1.0/total_lines*buffer_size)
    let tumb_size = ceil(buffer_size*1.0/total_lines*buffer_size)
    " Draw the signs based on the delimiters calculated above!

    let scrollbar = []
    let tumb_start = buffer_top + offset_top
    let tumb_end = tumb_start + tumb_size
    let buffer_line = buffer_top
    while buffer_line <= buffer_bottom
        if buffer_line >= tumb_start && buffer_line <= tumb_end
            call add(scrollbar, 1)
        else
            call add(scrollbar, -1)
        endif
        let buffer_line+=1
    endwhile

    let invalidate_cache = !exists('b:bar_cache') || total_lines+1 != len(b:bar_cache)
    if invalidate_cache
        call InitCache()
    endif

    let bar_line = 0
    while bar_line < len(scrollbar)
        let line_num = (bar_line+buffer_top)
        let miss_cache = scrollbar[bar_line] != get(b:bar_cache, line_num, -1)
        if miss_cache
            if scrollbar[bar_line] == 1
                exec ":sign place ".line_num." line=".line_num." name=".g:sign_thumb_name." buffer=".buffer_number
            else
                exec ":sign unplace ".line_num." buffer=".buffer_number
            endif
        endif
        let bar_line += 1
    endwhile

    let b:bar_cache = b:bar_cache[:buffer_top-1] + scrollbar + b:bar_cache[buffer_bottom+1:]

endfunction

function! InitCache() abort
  let our_signs = []
  let other_signs = []
  let buffer_number=bufnr("%")
  let total_lines=line('$')
  let b:bar_cache = []
  let line = 0
  while line <= total_lines
      let line+=1
      call add(b:bar_cache, -1)
  endwhile

  redir => signs
    silent exec ":sign place buffer=".bufnr("%")
  redir END

  for sign_line in filter(split(signs, '\n')[2:], 'v:val =~# "="')
    " Typical sign line:  line=88 id=1234 name=ScrollbarThumb
    let components  = split(sign_line)
    let line        = str2nr(split(components[0], '=')[1])
    let id          = str2nr(split(components[1], '=')[1])
    let name        =        split(components[2], '=')[1]
    if name =~# 'ScrollbarThumb'
      if line != total_lines
          exec ":sign unplace ".id." buffer=".buffer_number
      endif
      let b:bar_cache[line] = -1
    endif
  endfor
  " set one of the list line to avoid bar blinks on unplace
  exec ":sign place ".total_lines." line=".total_lines." name=".g:sign_thumb_name." buffer=".buffer_number
endfunction

" Call setup if vars are set for 'active' scrollbar.
"
if g:scrollbar_active != 0
    call <sid>SetupScrollbar()
endif
"
" Restore cpoptions.
let &cpoptions=s:save_cpoptions
unlet s:save_cpoptions
"
" vim: set filetype=vim fileformat=unix expandtab softtabstop=4 shiftwidth=4 tabstop=8:
