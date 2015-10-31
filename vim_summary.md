Встроенную документацию смотреть так:  
`:help something` или `:h something`

# Command-line mode
`:` - Ex command
`/` - forward search
`?` - backward search
`=` - Vim script expression

# Normal mode
`.` - повторить последнюю команду

## Команды
|Команда | Синоним | Перевод | Что делает|
|:------:|:-------:|:-------:|:----------|
| `a` |  | append | перейти в **insert mode** после курсора
| `i` |  | insert | перейти в **insert mode** перед курсором
| `x` |  | delete char | удалить символ под курсором
| `d{motion}`  |  | delete | удалить {motion}
| `c{motion}`  | `d{motion}i` | change | удалить {motion} и перейти в **insert mode**
| `s`  | `xi` | subst char | удалить символ под курсором и перейти в **insert mode**
| `>{motion}`  |  |  | увеличить отступ
| `<{motion}`  |  |  | уменьшить отступ
| `A`  | `$a` |  | перейти в **insert mode** в конце строки


## Движения
`$` - до конца строки
`G` - до конца буфера

# Insert mode

# Visual mode
