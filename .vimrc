

set wildmenu
set omnifunc=cppcomplete

"基础
syntax on
set showmode
set showcmd
set encoding=utf-8
set t_Co=256
filetype indent plugin on

"缩进
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=4 expandtab
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 softtabstop=4 expandtab

"外观
set number
"set cursorlineaa
"set linebreak
set wrapmargin=2
set laststatus=1
set ruler
set textwidth=1000
set relativenumber

"搜索
set showmatch
set hlsearch
set incsearch
set ignorecase

"编辑
set nobackup
set swapfile
set directory=~/.vim/swap
set undofile
set undodir=~/.vim/undo
set noerrorbells
set novisualbell
set history=500
set autoread

"补全括号
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap {<CR> {<CR>}<ESC>Ox<BS>
inoremap { {}<LEFT>

"inoremap <c-l> <Right>
"inoremap <c-k> <Up>
"inoremap <c-j> <Down>
"inoremap <c-h> <Left>
"inoremap <c-o> <Backspace>

noremap <c-g> :w<CR>
noremap <c-y> yyp
inoremap <c-g> <Esc>:w<CR>
noremap <c-c> G$vgg
inoremap <c-x> <Esc>ddi
inoremap <c-y> <Esc>yypi

inoremap <CR> <CR>x<BS>
noremap o ox<BS>
noremap O Ox<BS>


" fix meta-keys which generate <Esc>a .. <Esc>z
"let c='a'
"while c <= 'z'
"  exec "set <M-".toupper(c).">=\e".c
"  exec "imap \e".c." <M-".toupper(c).">"
"  let c = nr2char(1+char2nr(c))
"endw



"自动插入文件头
autocmd BufNewFile *.* exec ":call SetTitle()"

func SetTitle()
	if &filetype == 'c'
		call setline(1,"#include<stdio.h>")
	endif
	if &filetype == 'cpp'
		call setline(1,"#include<cstdio>")
		call append(line("$"),"#include<cmath>")
		call append(line("$"),"#include<cstring>")
	endif
	if (&filetype == 'cpp')+(&filetype == 'c')
		call append(line("$"),"int main(int argc,char **argv){")
		call append(line("$"),"	return 0;")
		call append(line("$"),"}")
		normal G
		normal kk
		normal $
	endif
	if &filetype == 'sh'
		call setline(1,"#!/bin/sh")
		call append(line("$"),"")
		normal G
	endif
	if &filetype == 'java'
		call setline(1,"public class Main{")
		call append(line("$"),"	public static void main(String argv[]){")
		call append(line("$"),"	}")
		call append(line("$"),"}")
		normal G
		normal kk
		normal $
	endif
    if &filetype == 'javascript'
        call setline(1, "import React, { Component } from \"react\";")
        call append(line("$"), "")
        call append(line("$"), "class ".expand('%:r')." extends Component{")
        call append(line("$"), "  constructor(props){")
        call append(line("$"), "    super(props);")
        call append(line("$"), "  }")
        call append(line("$"), "")
        call append(line("$"), "  render(){")
        call append(line("$"), "  }")
        call append(line("$"), "}")
        call append(line("$"), "")
        call append(line("$"), "export default ".expand('%:r').";")
        call append(line("$"), "")
    endif
endfunc


"Compile

func CompileWithoutOptimization()
	if &filetype == 'cpp'
		exec "!echo exec: g++ -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O0 -g -std=c++11 -o %< && g++ % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O0 -g -std=c++11 -o %<"
"		exec "!g++ % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O0 -g -std=c++11 -o %<"
	elseif &filetype == 'c'
		exec "!echo gcc % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O0 -g -o %< && gcc % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O0 -g -o %<"
"		exec "!gcc % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O0 -g -o %<"
	endif
endfunc

func Compile()
	if &filetype == 'cpp'
		exec "!echo exec: g++ -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O2 -g -std=c++11 -o %< && g++ % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O2 -g -std=c++11 -o %<"
"		exec "!g++ % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O2 -g -std=c++11 -o %<"
	elseif &filetype == 'c'
		exec "!echo gcc % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O2 -g -o %< && gcc % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O2 -g -o %<"
"		exec "!gcc % -Wall -Wextra -fsanitize=address -fsanitize=leak -fsanitize=undefined -Wstrict-overflow -O2 -g -o %<"
	endif
endfunc

func ExecProgram()
	exec "!time ./%<"
endfunc

func DebugProgram()
	exec "!gdb %<"
endfunc

noremap <F12> :call Compile()<CR>
noremap <F11> :call CompileWithoutOptimization()<CR>
noremap <F10> :call ExecProgram()<CR>
noremap <F9> :call DebugProgram()<CR>

