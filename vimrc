" .vimrc
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details
" For multi-byte character support (CJK support, for example):
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1


""----  Indention settings  ----------------------------------------------------
set tabstop=3
set shiftwidth=3
set expandtab             
set smarttab
set autoindent


""----  Search settings  -------------------------------------------------------
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase

""----  Number column settings  ------------------------------------------------
set number
set relativenumber
set numberwidth=4


""----  Fold settings  ---------------------------------------------------------
set foldmethod=syntax      "  Enable folding
set foldlevelstart=20      "  Effectively open all folds on file open


""----  Misc. Settings  --------------------------------------------------------
set showcmd
set backspace=2
set formatoptions=c,q,r,t
set ruler
set background=dark
set mouse=a
" set autochdir
set spell spelllang=en_gb
set shell=zsh\ --login


""----  Open on previous position  ---------------------------------------------
if has("autocmd")
   au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
            \| exe "normal! g'\"" | endif
endif

""----  Custom key mapping  ----------------------------------------------------
map  <silent> <Up>   gk
imap <silent> <Up>   <C-o>gk
map  <silent> <Down> gj
imap <silent> <Down> <C-o>gj
map  <silent> <home> g<home>
imap <silent> <home> <C-o>g<home>
map  <silent> <End>  g<End>
imap <silent> <End>  <C-o>g<End>


""----  File name auto completion settings  ------------------------------------
set wildmenu
set wildmode=longest,full
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp


""----  Vundle settings  -------------------------------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'scrooloose/nerdtree'
Plugin 'godlygeek/tabular'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'
Plugin 'Yggdroot/indentLine'
Plugin 'mkitt/tabline.vim'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-latex/vim-latex'
Plugin 'drmingdrmer/vim-syntax-markdown'
call vundle#end()
filetype on 
filetype plugin on
filetype indent on 

""----  Molokai settings  ------------------------------------------------------
syntax on
set t_Co=256
colorscheme molokai
let g:molokai_original=1
hi Normal ctermbg=none  

""----  YouCompleteMe, UltiSnip with super tab ---------------------------------
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" Disable Tex concealing
let g:tex_conceal = ""
" Disable YCM auto complete windows 
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0 
" Disable auto syntaz checker 
let g:ycm_register_as_syntastic_checker = 0


""----  NERDTree settings  -----------------------------------------------------
autocmd VimEnter * NERDTree 
autocmd VimEnter * wincmd p 
nmap <F8> :NERDTreeToggle<CR>
let g:nerdtree_tabs_open_on_console_startup = 1


""----  AirLine Settings  ------------------------------------------------------
set term=xterm-256color
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
autocmd VimEnter * AirlineTheme molokai
let g:airline_section_x=airline#section#create([' ','%{getcwd()}'])
let g:airline_section_y=airline#section#create([' ','filetype'])
let g:airline_section_warning=('')

""----  Markdown syntax settings  ----------------------------------------------
let g:vim_markdown_math=1
let g:vim_markdown_frontmatter=1

function Astyle()
   exec "%!astyle"
endfunction

"=====================================================
"字數計算 Civa 版：計算 CJKV 文字 + CJKV 標點 + 英文字 字數
"   作者：Civa Lin 林雪凡 - Version: 1.0
"
"   目標是和 word 類軟體算得一樣準！歡迎提交 patch！
"
"   CJKV 文字與標點，每個字符單獨算一個字。其他字符則每個 word 算一個字。
"   以下內容沒有計算在內：
"       - 英文半形標點不算在字數之內。
"       - 空白不算字數，注意全形空白「　」\u3000 也不算。
"       - 少數特殊標點符號：如「…」\u2026 與「—」\u2014 等極少數符號，
"         因為和英文標點放在同區中，故也未算在中文標點之內，有需要可自行添加。
"       - 「中日韓統一表意文字擴充區」中的罕用字沒有算在內，因為搜尋字串會
"         太長 Vim 不執行 (至少 7.3 是如此)……囧rz
"
"   參考資料見：
"       - 基本說明:  http://chukaml.tripod.com/linguistics/han/index.html
"       - 碼表:      http://chukaml.tripod.com/linguistics/unicode/index.html
"       - 字符說明:
"         http://chukaml.tripod.com/linguistics/unicode/codeChart/index.html
"
"   其他銘謝：
"       - 早期框架來源：  http://kenshin54.iteye.com/blog/876203
function! CalWordCount()
   "以下模式中各段落……
   "\<\w*\> 為英文字
   let l:cmd = []
   "頭部
   let l:cmd = add(l:cmd, '%s/')
   let l:cmd = add(l:cmd, '\(')
   "單純字元比對
   let l:cmd = add(l:cmd, '[')
   "3000 ~ 303f = 「中日韓符號和標點」
   let l:cmd = add(l:cmd, '\u3001-\u303f') "\u3000為全形空白
   "3040 ~ 309f = 「日文假名」
   let l:cmd = add(l:cmd, '\u3040-\u309f') "平假名
   let l:cmd = add(l:cmd, '\u30a0-\u30ff') "片假名
   "3100 ~ 312f = 「注音符號」，31A0 ~ 31BF = 「注音符號擴充」
   let l:cmd = add(l:cmd, '\u3100-\u312f')
   let l:cmd = add(l:cmd, '\u31a0-\u31bf')
   "4e00 ~ 9fff = 「中日韓統一表意文字」
   let l:cmd = add(l:cmd, '\u4e00-\u4eff\u4f00-\u4fff\u5000-\u50ff\u5100-\u51ff\u5200-\u52ff\u5300-\u53ff\u5400-\u54ff\u5500-\u55ff\u5600-\u56ff\u5700-\u57ff\u5800-\u58ff\u5900-\u59ff\u5a00-\u5aff\u5b00-\u5bff\u5c00-\u5cff\u5d00-\u5dff\u5e00-\u5eff\u5f00-\u5fff\u6000-\u60ff\u6100-\u61ff\u6200-\u62ff\u6300-\u63ff\u6400-\u64ff\u6500-\u65ff\u6600-\u66ff\u6700-\u67ff\u6800-\u68ff\u6900-\u69ff\u6a00-\u6aff\u6b00-\u6bff\u6c00-\u6cff\u6d00-\u6dff\u6e00-\u6eff\u6f00-\u6fff\u7000-\u70ff\u7100-\u71ff\u7200-\u72ff\u7300-\u73ff\u7400-\u74ff\u7500-\u75ff\u7600-\u76ff\u7700-\u77ff\u7800-\u78ff\u7900-\u79ff\u7a00-\u7aff\u7b00-\u7bff\u7c00-\u7cff\u7d00-\u7dff\u7e00-\u7eff\u7f00-\u7fff\u8000-\u80ff\u8100-\u81ff\u8200-\u82ff\u8300-\u83ff\u8400-\u84ff\u8500-\u85ff\u8600-\u86ff\u8700-\u87ff\u8800-\u88ff\u8900-\u89ff\u8a00-\u8aff\u8b00-\u8bff\u8c00-\u8cff\u8d00-\u8dff\u8e00-\u8eff\u8f00-\u8fff\u9000-\u90ff\u9100-\u91ff\u9200-\u92ff\u9300-\u93ff\u9400-\u94ff\u9500-\u95ff\u9600-\u96ff\u9700-\u97ff\u9800-\u98ff\u9900-\u99ff\u9a00-\u9aff\u9b00-\u9bff\u9c00-\u9cff\u9d00-\u9dff\u9e00-\u9eff\u9f00-\u9fff')
   "fe10 ~ fe1f = 「豎式標點」
   let l:cmd = add(l:cmd, '\ufe10-\ufe1f')
   "FF00 ~ FFEF = 「全形與半形字符」
   let l:cmd = add(l:cmd, '\uff00-\uffef')
   let l:cmd = add(l:cmd, ']')
   "單純字元比對結束
   " 英文字 (word) 匹配
   let l:cmd = add(l:cmd, '\|')
   let l:cmd = add(l:cmd, '\<\w*\>')
   "尾部
   let l:cmd = add(l:cmd, '\)')
   let l:cmd = add(l:cmd, '/&/gn')

   exe join(l:cmd, '')
endfunction

