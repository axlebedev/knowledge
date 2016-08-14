# Области видимости переменных
| Префикс | Что делает |
|:-------:|:-----------|
| `a:varname` | a parameter of the current function |
| `b:varname` | local to the current editor buffer |
| `g:varname` | global |
| `l:varname` | local to the current function |
| `s:varname` | local to the current script file |
| `t:varname` | local to the current editor tab |
| `v:varname` | one that Vim predefines |
| `w:varname` | local to the current editor window |

# Псевдопеременные
| Префикс | Что делает |
|:-------:|:-----------|
| `&varname` | A Vim option (local option if defined, otherwise global) |
| `&l:varname` | A local Vim option |
| `&g:varname` | A global Vim option |
| `@varname` | A Vim register |
| `$varname` | An environment variable |

# Общее
## Выполнить команды одну за другой
`|`: `:echom 'line1' | echom 'line2'`

# Условный оператор
Общий синтаксис:
```
if somecond
    somecode1
elseif anothercond
    somecode2
else
    somecode3
endif
```

Как вычисляется:
```
if 1
    echom 'Ok, 1 is true'
endif

if 0
    echom 'Nop, 0 is false'
endif

if 'somestring'
    echom 'Nop, string is false too!'
endif

if '987'
    echom 'This string is true!'
endif
```

Операторы сравнения:
```
if 10 < 2001      " true
if 10 == 11       " false
if 'foo' == 'foo' " true
if 'foo' == 'bar' " false

set noignorecase
if 'foo' == 'FOO'  " false
if 'foo' ==? 'FOO' " true
set ignorecase
if 'foo' == 'FOO'  " true
if 'foo' ==# 'FOO' " false
```

Операторы `==?` и `==#` с числами работают как `==`.  
Остальные операторы - `:help expr4`.  

# Строки
Строки, начинающиеся с цифр - парсятся в int, иначе приводятся к 0:
```
:echom "hello" + 10    " 10
:echom "10hello" + 10  " 20
:echom "hello10" + 10  " 10
```

## Конкатенация строк
```
:echo 'Hello ' + 'world!' " 0, '+' сначала приводит строкт к _целым_ числам
:echo '3 cats' + '2 cats!' " 5
:echo '3 cats' + '2.5 cats!' " 5

:echo 'Hello ' . 'world!' " 'Hello world!'
:echo 10 . 'world!'       " '10world!'
:echo 10.1 . 'world!'     " Error! Vim не умеет приводить float к строке
```

## Спецсимволы
`:help expr-quote`  
`:help i_CTRL-V `  
`:help literal-string`  
```
:echom "I say \"lala\""
:echom "foo\\bar"

:echo "foo\nbar"  " 2 строчки 'foo' и 'bar'
:echom "foo\nbar" " 'foo^@bar'; echom выводит exactly ту строку, как мы дали. '^@' - символ новой строки
```

Можно обойтись без лишних экранирований, если использовать одинарные кавычки:
```
:echom '\\\n\' " \\\n\
:echom 'sometext: ''lala''' " sometext: 'lala'; чтобы вывести кавычку в такой строке - пишем ее дважды
```

## Строковые функции
`:help split`  
`:help join`  
`:help functions`  
```
" Длина строки
:echom strlen('foo') " 3
:echom len('foo')    " 3

" Сплит
:echo split('one two three')      " ['one', 'two', 'three']
:echo split('one,two,three', ',') " ['one', 'two', 'three']

" Join
:echom join(['one', 'two'], '...') " 'one...two'

" Регистр
:echom tolower('Lalka') " 'lalka'
:echom toupper('Lalka') " 'LALKA'
```

# Функции
`:help function-argument`  
`:help local-variables`  
Unscoped функции _должны_ начинаться с заглавной буквы!  
Если функция ничего не вернула, то она как бы вернула 0.  
Аргументы, переданные в функцию - константы.  
```
" Объявление
function Meow(arg)
    let somevalue = a:arg + 1
    return somevalue
endfunction

" Вызов
:call Meow()
" а можно и так
:echom Meow()
```

Функция с неопределенным числом параметров:
```
function Varargs(...)
    echom a:0 " number of arguments
    echom a:1 " first argument, same as a:000[0]
    echo a:000 " list containing all the extra arguments that were passed
endfunction

:call Varargs('a', 'b')
" 2
" a
" ['a', 'b']

function Varargs2(arg, ...)
    echom a:0 " number of arguments
    echom a:arg
    echom a:1 " first argument, same as a:000[0]
    echo a:000 " list containing all the extra arguments that were passed
endfunction

:call Varargs2('a', 'b', 'c')
" 2
" a
" b
" ['b', 'c']
```

# Числа
`:help Float`  
`:help floating-point-precision`  
```
" Целые
:echom 98   " 98
:echom 0xff " 255; 0x или 0X - похуй
:echom 010  " 8; восьмеричное
:echom 019  " 19; невалидное восьмеричное - значит десятичное

" Нецелые
:echo 100.1
:echo 5.45e+3 " или 5.45e3 - плюс можно опустить
:echo 5.45e-2

" А вот так делать нельзя
:echo 5e4 " Ошибка, точка в числе - обязательна!

" Приводится все обычно к float
:echo 2 * 2.0 " 4.0

" Когда делим два целых - остаток опускается
:echo 3 / 2   " 1
:echo 3 / 2.0 " 1.5, 3 привелось к float
```

# Execute, normal
`:help execute`  
`:help normal`  
`execute` работает как `eval` в жс.  
`normal` выполняет маппинги клавиш  
`normal!` игнорирует маппинги клавиш  
`"<cr>"` парсится как Enter, `'<cr>'` не парсится.  

Пример: `:execute "normal! gg/foo\<cr>ddastr\<esc>"`

# Регулярки
`:help magic`  
`:help pattern-overview`  
`:help match`  
`:help nohlsearch`  
`:help escape()`  
`:help shellescape()`  

По дефолту - '_magic_' режим (т.е. регулярки).  
По дефолту надо экранировать символы магическим образом:  
`:/print .\+` - это как в обычной регулярке `print .+`  

## Very magic
Если регулярку начать с `\v`, то это инициализирует '_very magic_' режим:
```
:execute "normal! gg" . '/\vfor .+ in .+:' . "\<cr>"
```

В этом режиме не надо экранировать символы.  

# Grep
`:help :grep`  
`:help :make`  
`:help quickfix-window`  
`:help cword`  
`:help cnext`  
`:help cprevious`  
`:help expand`  
`:help copen`  
`:help silent`  

`<cword>` - слово под курсором  
`<cWORD>` - СЛОВО под курсором  

## Сделаем шорткат для поиска слова под курсором
`:nnoremap <leader>g :grep -R <cword> .<cr>` - плохо, если есть рабочие символы в слове  
`:nnoremap <leader>g :grep -R '<cword>' .<cr>` - более норм, рабочие символы работать не будут  
`:nnoremap <leader>g :execute "grep -R " . shellescape("<cWORD>") . " ."<cr>` - еще лучше,
в строке могут быть одинарные кавычки.
Но все равно работать не будет, т.к. `shellescape` срабатывает раньше, чем  `<cword>`  
`:nnoremap <leader>g :exe "grep -R " . shellescape(expand("<cWORD>")) . " ."<cr>`
- еще лучше, `expand` форсирует вычисление.  
`:nnoremap <leader>g :exe "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>`
- а так он по выполнении не перескочит сразу на первое найденное.  
`nnoremap <leader>g :execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>`
- а таким макаром он еще и `quickfix` откроет после поиска  
`:nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>`
- а так просто не срем выводом.  

## Делаем плагин для этого
Делаем папку с названием плагина. В ней папка `plugin` - в ней весь код. Пример:
```
" testplugin/plugin/test-plugin.vim
nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@

function! GrepOperator(type)
    echom "Test"
endfunction
```
Таким образом мы сделали оператор (`operatorfunc`), который будет ожидать motion-команды,
а потом выполнится (вызов функции - `g@`).  

А вот так выглядит вызов для _Visual mod'а_
```
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>
```

### Поэкспериментируем с типом значений
```
nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>

function! GrepOperator(type)
    echom a:type
endfunction
```
Если вызвать этот код, то:
```
viw<leader>g " 'v'    because we were in characterwise visual mode.
Vjj<leader>g " 'V'    because we were in linewise visual mode.
<leader>giw  " 'char' because we used a characterwise motion with the operator.
<leader>gG   " 'line' because we used a linewise motion with the operator.
```

### Как получить текст, над которым работаем
`:help visualmode()`  
`:help c_ctrl-u`  
`:help operatorfunc`  
`:help map-operator`  

```
nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>

function! GrepOperator
    let saved_unnamed_register = @@(type)
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif

    echom shellescape(@@) " @@ - unnamed register

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen

    let @@ = saved_unnamed_register
endfunction
```

### Как ограничить область видимости функции
`:help <SID>`

```
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    ...code
endfunction
```

# Списки
`:help List`

Списки могут содержать значения разных типов:
```
:echo ['foo', [3, 'bar']]
```

Индекс можно брать с начала (с нуля) либо с конца (-1 - последний элемент, и т.д.):
```
:echo [0, [1, 2]][1]    " [1, 2]
:echo [0, [1, 2]][-2]   " 0
```

Конкатенируются знаком `+`:
```
:let list = [1, 2]
:echo list + [3] " [1, 2, 3]
:let list += [3] " можно и так
```

Сравнение списков: если списки имеют одинаковую длину, и для каждого индеска выполняется
`list1[index] == list2[index]`, то они считаются равными.  
Исключение: `[2] == ["2"]` - false, строка не приведется к числу.

Можно деструктурировать:
```
let list = [1, 2]
let [a, b] = list " a = 1, b = 2
```
Если длина списка не подходит кол-ву переменных, то будет ошибка. Но можно так (внимание на `;`):
```
let list = [1, 2, 3, 4]
let [a, b; rest] = list " a = 1, b = 2, rest = [3, 4]
let [a, b, c, d; rest] = list " rest = []
```

## Slice
Можно делать slicing как в питоне (аккуратно, работает _не совсем_ как в питоне):
```
:echo ['a', 'b', 'c', 'd', 'e'][0:2]      " ['a', 'b', 'c']
:echo ['a', 'b', 'c', 'd', 'e'][0:10000]  " ['a', 'b', 'c', 'd', 'e']
:echo ['a', 'b', 'c', 'd', 'e'][-2:-1]    " ['d', 'e']
:echo ['a', 'b', 'c', 'd', 'e'][1:]       " ['b', 'c', 'd', 'e']
:echo ['a', 'b', 'c', 'd', 'e'][:1]       " ['a', 'b']

" Аккуратно!
let s = 0
let e = 1
:echo ['a', 'b', 'c', 'd', 'e'][s:e]       " ошибка, s:e - это как одна переменная
:echo ['a', 'b', 'c', 'd', 'e'][s : e]       " ['a', 'b']

" Можно изменять range
let list = [1, 2, 3, 4]
let list[1:2] = [10, 20]
```

Slice работает и со строками. Внимание! Вне слайса (просто получить по индексу) отрицательные 
в строках не работают!

## Функции списков
`:help add()`  
`:help len()`  
`:help get()`  
`:help index()`  
`:help join()`  
`:help reverse()`  
`:help functions`  

```
let list = [1, 2]

add(list, 3) " работает как push_back
extend(list, [3, 4]) " работает как конкатенация
insert(list, 'a') " работает как push_front
insert(list, 'a', 3) " засунуть новые элемент перед индексом 3
remove(list, 3) " удалить элемент по индексу 3
unlet list[3]

len(list) " длина списка
get(list, index, 'default') " получает элемент списка на заданном индексе, если по индексу ничего нет - то дефолт

index(list, value) " находит индекс первого вхождения value (или -1 если не найдено)

join(list, separator) " сделать строку из списка
split(list, sep)

max(list)
min(list)
count(list, value)

reverse(list) " реверснуть
filter(list, ???)
sort(list)
map(list, ???)

copy(list)
deepcopy(list)

string(list)
```

## Обход списка
В этом примере все элементы должны быть одного типа, иначе ошибка
```
for item in list
    echo item
endfor
```

# Циклы
`:help for`  
`:help while`  

## for
```
:let c = 0

:for i in [1, 2, 3, 4]
:  let c += i
:endfor

:echom c
```

## while
```
:let c = 1
:let total = 0

:while c <= 4
:  let total += c
:  let c += 1
:endwhile

:echom total
```

# Dictionary
Ключи - всегда приводятся к строкам.  
```
let obj = {'a': 1, 100: 'foo'}

echo obj['a']
echo obj[100]

" так тоже можно
echo obj.a
echo obj.100

" добавить новое значение по ключу
let obj.newVal = 100500

" удалить
unlet obj.newVal
remove(obj, 'newVal')
```

## Функции словарей
`:help Dictionary`  
`:help get()`  
`:help has_key()`  
`:help items()`  
`:help keys()`  
`:help values()`  

```
get(obj, index, default)
has_key(obj, key)
items({'a': 100, 5: 'five'}) " [['a', 100], [5, 'five']]
```

# Toggling
http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
