if !exists("g:potion_command")
    let g:potion_command = "/home/alex/hdd/Proj/github/potion/bin/potion"
endif

function! PotionCompileAndRunFile()
    silent !clear
    execute "!" . g:potion_command . " " . bufname("%")
endfunction

nnoremap <buffer> <F5> :call PotionCompileAndRunFile()<cr>
