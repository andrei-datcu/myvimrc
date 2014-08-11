set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'spf13/vim-autoclose'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-powerline'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'matchit.zip'
Plugin 'scrooloose/syntastic'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mhinz/vim-signify'

Plugin 'restore_view.vim'

Plugin 'xoria256.vim'
Plugin 'noahfrederick/vim-hemisu'
Plugin 'spf13/vim-colors'

" Python
Plugin 'python.vim'
Plugin 'python_match.vim'
Plugin 'pythoncomplete'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set cursorline

set showmatch " Show matching brackets/parenthesis
set incsearch " Find as you type search
set hlsearch " Highlight search terms
set ignorecase " Case insensitive search
set smartcase " Case sensitive when uc present
set wildmenu " Show list instead of just completing
set wildmode=list:longest,full " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,] " Backspace and cursor keys wrap too
set scrolljump=5 " Lines to scroll when cursor leaves screen
set scrolloff=3 " Minimum lines to keep above and below cursor
set foldenable " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

set nowrap " Do not wrap long lines
set autoindent " Indent at the same level of the previous line
set shiftwidth=4 " Use indents of 4 spaces
set expandtab " Tabs are spaces, not tabs
set tabstop=4 " An indentation every four columns
set softtabstop=4 " Let backspace delete indent
set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current

autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml,perl autocmd BufWritePre <buffer> call StripTrailingWhitespace()

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

autocmd FileType c,cpp,h let w:lengtherror=matchadd('ErrorMsg', '\%>79v.\+', -1)
autocmd FileType java let w:lengtherror=matchadd('ErrorMsg', '\%>99v.\+', -1)

set foldmethod=syntax
set nospell
set noexpandtab
set relativenumber
set backup
set autochdir
set viminfo='10,\"100,:20,%,n~/.vim/.viminfo'
colorscheme default "For the indent_guides to work ok
set t_Co=256
set laststatus=2 "Always show statusline
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" Restore cursor
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

 " Strip whitespace {
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction


" Initialize directories {
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }
    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif
    " To specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories, add the following to
    " your .vimrc.before.local file:
    " let g:spf13_consolidated_directory = <full path to desired directory>
    " eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
    if exists('g:spf13_consolidated_directory')
        let common_dir = g:spf13_consolidated_directory . prefix
    else
        let common_dir = parent . '/.' . prefix
    endif
    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction

 " Cscope
if has("cscope")
    "set cscopetag
    " Look for a 'cscope.out' file starting from the current directory,
    " going up to the root directory.
    let s:dirs = split(getcwd(), "/")
    while s:dirs != []
        let s:path = "/" . join(s:dirs, "/")
        if (filereadable(s:path . "/cscope.out"))
            execute "cs add " . s:path . "/cscope.out " . s:path . " -v"
            let CS_DB = s:path
            break
        endif
        let s:dirs = s:dirs[:-2]
    endwhile

    set csto=0  " Use cscope first, then ctags
    set cst     " Only search cscope
    set csverb  " Make cs verbose
    set cspc=3  " Commands listed

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@><C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@><C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@><C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@><C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@><C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@><C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :vert scs find e <C-R>=expand("<cword>")<C

    nmap <F12> :!find <C-r>=CS_DB<CR> -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > <C-r>=CS_DB<CR>/cscope.files<CR>
        \:!cscope -b -i <C-r>=CS_DB<CR>/cscope.files -f <C-r>=CS_DB<CR>/cscope.out<CR>
        \:cs kill -1<CR>
        \:cs add <C-r>=CS_DB<CR>/cscope.out<CR>
endif

