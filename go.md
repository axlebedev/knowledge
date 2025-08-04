# Go
packages: 'maps', 'slices'

## Hello world
```go
// hello-world.go
package main
import "fmt"
func main() {
    fmt.Println("hello world")
}
```

```bash
$ go run hello-world.go
hello world

$ go build hello-world.go
$ ls
hello-world    hello-world.go

$ ./hello-world
hello world
```

## Types
- integer  
- float  
- string  
- bool  

OK: int + float, string + string  
Not OK: string + int, string + float  

## Variables
```go
var a = "initial" // auto typing
var b, c = 1, 2 // multiple vars
var d int = 3 // manual typing
e := 4 // equal to 'var e int = 4'
var f int // undefined, but has "default value": for numbers - 0, or "" for strings, or false for bool
const s string = "constant" // const is for primitive types
```

## For
Есть 4 вида:  
while, обычный цикл как везде, range INT, range ARRAY  
Фигурные скобки обязательны!
Можно делать `continue`
```go
// same as "while"
i := 1
for i <= 3 { 
    fmt.Println(i)
    i = i + 1
}

// like C++
for j := 0; j < 3; j++ {
    fmt.Println(j)
}

// go-exclusive
for index := range 3 {
    fmt.Println("range", index)
}

var nums []int{1, 2, 3}
for index, value := range nums {
    fmt.Println(index, value)
}
```

## If else
Условие можно не заключать в скобки. Тело - обязательно в фигурных!
```go
if 8%2 == 0 || 7%2 == 0 {
    fmt.Println("either 8 or 7 are even")
}
```

Можно объявить переменную, которая будет замкнута в блоках `if-else`
```go
if num := 9; num < 0 {
    fmt.Println(num, "is negative")
} else if num < 10 {
    fmt.Println(num, "has 1 digit")
} else {
    fmt.Println(num, "has multiple digits")
}
```

Тернарников нет!

## Switch
```go
i := 2
switch i {
case 1:
    fmt.Println("one")
case 2:
    fmt.Println("two")
case 3:
    fmt.Println("three")
}
```

Можно два условие подставить в один `case`, разделив запятой:
```go
switch time.Now().Weekday() {
case time.Saturday, time.Sunday:
    fmt.Println("It's the weekend")
default:
    fmt.Println("It's a weekday")
}
```

Можно вообще не задавать переменную в `switch`, а считать условия в `case`:
```go
switch {
case time.Now().Hour() < 12:
    fmt.Println("It's before noon")
default:
    fmt.Println("It's after noon")
}
```

Можно работать с типами:
```go
whatAmI := func(i interface{}) {
    // Такая конструкция возможна только внутри type switch
    switch t := i.(type) {
    case bool:
        fmt.Println("I'm a bool")
    case int:
        fmt.Println("I'm an int")
    default:
        fmt.Printf("Don't know type %T\n", t)
    }
}
whatAmI(true)
whatAmI(1)
whatAmI("hey")
```

## Array
Простой си-массив
```go
// массив из 5 интов, заполнен дефолтными интовыми значениями, т.е. нулями
var a [5]int

// с инициализацией - используем :=
b := [5]int{1, 2, 3, 4, 5}
// Нумерация с нуля: b[0] = 1 и т.д.
// Длина - len(b)

// длину можно не указывать
c := [...]int{1, 2, 3, 4, 5}

// инициализировать можно не всё подряд
d := [...]int{100, 3: 400, 500}
// d = [100, 0, 0, 400, 500]

// можно делать многомерные массивы
e := [2][2]int{
    {10, 20},
    {11, 21},
}
```

WARN! Переменная, которая хранит массив - value, т.е. если мы передадим её в функцию - то она будет скопирована

## Slices
Slice - это некий аналог вектора в С++
```go
// по дефолту slice == nil, len(slice) == 0
var slice []string

// Можно инициализировать
slice := []int{0, 1, 2, 3}

// Можно присваивать одно другому
var s2 []int
s2 = slice
```

##### make
make - функция для создания пустого слайса заданной длины  
> When called, make allocates an array and returns a slice that refers to that array.  
```go
// func make([]T, len, cap) []T
s := make([]int, 3)
// slice == [0, 0, 0], len(s) == 3, cap(s) == 3
```

##### cap()
У slice есть особое свойство - cap(acity) - определяет кол-во элементов, которые можно быстро добваить в слайс
```go
s = make([]string, 3)
// len(s) == 3, cap(s) == 3
```

##### append
Если capacity хватает - просто добавит элемент. Если нет - увеличит (min удвоит, или сколько дали аргументов) (WARN! выделит новую память)
```go
// len(s) == 3, cap(s) == 3
s = append(s, "newvalue") 
// len(s) == 4, cap(s) == 6
s1 = append(s, "newvalue", "newvalue", "newvalue") 
// len(s1) == 7, cap(s1) == 7
s2 = append(s, "newvalue")
s2 = append(s, "newvalue")
s2 = append(s, "newvalue")
// len(s2) == 7, cap(s2) == 12
```

Можно склеивать два слайса
```go
s1 := []int{1, 2, 3}
s2 := []int{4, 5, 6}
s1 = append(s1, s2...) // [1, 2, 3, 4, 5, 6]
```

##### copy
`copy` позволяет копировать один слайс в другой, возвращает кол-во скопированных эл-тов  
`func copy(dst, src []T) int`  
```go
// Дано: source = {0, 1, 2}, destination = {0, 0, 0}
copy(destination, source)
// destination = {0, 1, 2}
```

Если у аргументов разные длины - то copy будет работать с наименьшей:
```go
// Дано: source = {0, 1, 2}, destination = {0, 0}
copy(destination, source)
// destination = {0, 1}

// Дано: source = {0, 1}, destination = {0, 0, 0}
copy(destination, source)
// destination = {0, 1, 0}
```

Если аргументы ссылаются на один и тот же участок памяти - то "souce" перезатрётся:
```go
source := []int{0,1,2,3}
x := source[:3]
y := source[1:]
fmt.Println("source=", source) // [0,1,2,3]
fmt.Println("x=", x) // [0,1,2]
fmt.Println("y=", y) // [1,2,3]
copy(y, x)
fmt.Println("source=", source) // [0,0,1,2]
fmt.Println("x=", x) // [0,0,1]
fmt.Println("y=", y) // [0,1,2]
```

##### [:]
Можно присваивать "срезы" слайса:
```go
// Дано: source = {0, 1, 2, 3, 4}
c := source[:] // c = {0, 1, 2, 3, 4}, этот синтаксис можно использовать для конвертации array => slice
// начальный индекс включается в результат, конечный - нет
c := source[0:5] // c = {0, 1, 2, 3, 4}
c := source[1:4] // c = {1, 2, 3}
c := source[1:] // c = {1, 2, 3, 4}
c := source[:4] // c = {0, 1, 2, 3}
```
Внимание! Элементы среза ссылаются на оригинальное место в памяти
```go
c[2] = 200 // WARN: source[2] = 200
```

##### Equal
Есть утилка `slices.Equal`
```go
import "slices"
s1 := []string{"a", "b", "c"}
s2 := []string{"a", "b", "c"}
slices.Equal(s1, s2) // true
```

# Map
```go
// Creation: make(map[key-type]val-type).
m := make(map[string]int) // empty map
// Initialize
m2 := map[string]int{"foo": 1, "bar": 2}

m["piska"] = 100500
// m["piska"] = 100500
// m["unexisted-key"] = 0 // zero value of "int"
value, present = m["unexist2"] // 0, false
value, present = m["piska"] // 100500, true
delete(m, "piska")
clear(m)
```
https://gobyexample.com/functions
