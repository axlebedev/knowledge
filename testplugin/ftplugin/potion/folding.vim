" Пример 1: фолд по инденту
" Ставим фолдметод (как в :help usr_28)
" setlocal foldmethod=indent
" По дефолту у вима foldignore стоит символ #, выключаем это
" setlocal foldignore=

" Пример 2: фолд по expr
setlocal foldmethod=expr
setlocal foldexpr=GetPotionFold(v:lnum)

" эта функция возвращает indent данной строки
function! s:IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

" эта функция вернет номер следущей непустой строки
function! s:NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

" эта функция возвращает foldlevel данной строки
function! s:GetPotionFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        " -1 - наименьший из соседних фолдов
        " (если по соседству начинается фолд, то это засчитывается как level - 1
        return '-1'
    endif

    let this_indent = s:IndentLevel(a:lnum)
    let next_indent = s:IndentLevel(s:NextNonBlankLine(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        " Например >1 означает, что на этой строке должен начинаться фолд левела 1
        return '>' . next_indent
    endif
endfunction
