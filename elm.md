http://package.elm-lang.org/packages/elm-lang/core/5.1.1

## Типы
```elm
"hello" : String

2 : number
```

_Деление бывает целочисленное и обычное_:
```elm
2 / 1
2 : Float

2 // 1
2 : Int
```

С типами все строго!
```elm
"hello" + 2
Ошибка, '+' - сложение number'ов

"hello" ++ 2
Ошибка, '++' - конкатенация строк

"hello" ++ "2"
"hello2" : String
```

## Функции
```elm
isNegative n = n > 0
<function> : number -> Bool

> isNegative -7
True

> isNegative (-3 * -4)
False
```

Применение записывается как `funcName arg1 arg2 ...`

## If-then-else
Это, по сути, просто тернарник
```elm
> if True then "hello" else "world"
"hello"
```

Elm не умеет приводить не-bool к булевым значениям. Если попытаемся - компилятор ругнется.  

## Списки
__Все элементы списка должны иметь один тип!__  
Вот пример, там еще много встроенных функций
```elm
> names = [ "Alice", "Bob", "Chuck" ]
["Alice","Bob","Chuck"]

> List.isEmpty names
False

> List.length names
3

> List.reverse names
["Chuck","Bob","Alice"]

> numbers = [1,4,3,2]
[1,4,3,2]

> List.sort numbers
[1,2,3,4]

> double n = n * 2
<function>

> List.map double numbers
[2,8,6,4]
```

## Кортежи
```elm
> import String

> goodName name = \
|   if String.length name <= 20 then \
|     (True, "name accepted!") \
|   else \
|     (False, "name was too long; please limit it to 20 characters")

> goodName "Tom"
(True, "name accepted!")
```

## Записи
```elm
> point = { x = 3, y = 4 }
{ x = 3, y = 4 }

> point.x
3

> bill = { name = "Gates", age = 57 }
{ age = 57, name = "Gates" }

> bill.name
"Gates"
```

Доступ к полю - это тоже функция
```elm
> .name bill
"Gates"

> List.map .name [bill,bill,bill]
["Gates","Gates","Gates"]
```

Можно объявлять функции с деструктурированием, можно создавать записи на ходу:
```elm
> under70 {age} = age < 70
<function>

> under70 bill
True

> under70 { species = "Triceratops", age = 68000000 }
False
```

Можно делать так:
```elm
> { bill | name = "Nye" }
```
Это эквивлентно js:
```javascript
{ ...bill, name: "Nye" }
```

Отличия от жс-объектов:
- You cannot ask for a field that does not exist.
- No field will ever be undefined or null.
- You cannot create recursive records with a this or self keyword.
