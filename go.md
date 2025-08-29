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

# Functions
Объявление функции
```go
// func plusPlus(a int, b int, c int) int {
func plusPlus(a, b, c int) int {
    return a + b + c
}
// a := plusPlus(1, 2, 3)
```

Функция может вернуть кортеж
```go
func vals() (int, int) {
    return 3, 7
}
// x, y := vals()
```

Функция с произвольным числом параметров
```go
func sum(nums ...int) {
    total := 0
    for _, num := range nums {
        total += num
    }
    return total
}
// sum(1, 2, 3)
// sum([]int{10, 20, 30}...)
```

Function expression
```go
f := func(a int) {
	fmt.Println("a=", a)
}
```

Closure работают как обычно.  

# range
range - встроенная штука чтобь проходить по массивам, словарям, строкам:  
```go
nums := []int{2, 3, 4}
for index, num := range nums { ... }

kvs := map[string]string{"a": "apple", "b": "banana"}
for key, value := range kvs { ... }

// iterates over Unicode code points
for byte_index, rune := range "go" { ... }
```

# Pointers
Работают без хитростей  
Прикол в том что в go всё (даже массивы) подаётся по значению, т.е. если подать в функцию массив - 
он будет скопирован. Чтобы такого не было - подаём указатель а не значение.
```go
func zeroptr(iptr *int) { // на вход функции подали указатель
    *iptr = 0 // разыменовали указатель
}

func main() {
    v := 20
    zeroptr(&v) // взяли адрес переменной, т.е. сделали из пер-й указатель
    // v = 0
}
```

# Strings and runes
TODO: https://go.dev/blog/strings  
В go строка закодирована в UTF-8, и состоит из "rune" вместо обычных "char".  
Эта руна может состоять из разного числа байт (для разных языков)  
`range` знает про руны и процессит строки корректно.

# struct
```go
type person struct {
    name string
    age  int
}

func main() {
    fmt.Println(person{name: "bob", age: 20})
    fmt.Println(person{age: 20, name: "bob"})
    fmt.Println(person{name: "bob"}) // age будет дефолт для типа int, т.е. 0
    fmt.Println(person{"bob", 20}) // если мы передаём все свойства по очереди - то можно без имён свойств
}
```

Принято делать функцию-конструктор для создания struct:
```go
func newPerson(name string) *person {
    p := person{name: name}
    p.age = 42
    return &p
}
// p = newPerson("Bob")
```

Если тип нужен только в одном месте (широко исп-ся в table-driven tests):  
```go
dog := struct {
        name   string
        isGood bool
    }{
        "Rex",
        true,
    }
```

# methods
Для struct можно объявить методы:  
```go
// тип person из прошлого раздела
func (p *person) sayHi() {
    fmt.Println("hi! I'm ", p.name, " age=", p.age)
}
```
Тип `(p *person)` называется "receiver type". Он может быть указателем или нет - отличие в доступе к исходному объекту, и будет ли копироваться. Вызов метода - всегда через `.` точку.


# interfaces
TODO: https://research.swtch.com/interfaces
Интерфейс нужен как везде, для перегрузки и описания общего API.  
Используется утиная типизация, т.е. если в примере ниже типы `circle` и `rectangle` реализуют
все методы из `geometry` - то они ок. Как-то явно связывать их не надо  
```go
type geometry interface {
    area() float64
    perim() float64
}
type circle struct { ... }
type rectangle struct { ... }
func printFigure(f geometry) { ... } // сюда мы подадим и circle, и rectangle
```

### Проверка типа
`c, ok := someVar.(someType)`  
Иногда мы не знаем конкретный тип переменной. Проверить можно так:  
```go
func detectCircle(g geometry) {
    if c, ok := g.(circle); ok {
        fmt.Println("circle with radius", c.radius)
    }
}
```

# Enums
Самой штуки "enum" в языке нету. Они делаются так:  
Вот такой немного задроченный пример
```go
type ServerState int

const (
    StateIdle ServerState = iota
    StateConnected
    StateError
    StateRetrying
)

var stateName = map[ServerState]string{
    StateIdle:      "idle",
    StateConnected: "connected",
    StateError:     "error",
    StateRetrying:  "retrying",
}

// Реализуем Stringer interface
// https://pkg.go.dev/fmt#Stringer
func (ss ServerState) String() string {
    return stateName[ss]
}

// fmt.Println(stateVar)
```

# struct embedding
Вместо наследования в языке go используется композиция типов  
```go
type base struct {
    num int
}

func (b base) describe() string {
    return fmt.Sprintf("base with num=%v", b.num)
}

type container struct {
    base // An embedding looks like a field without a name.
    str string
}

func main() {
    co := container{
        base: base{
            num: 1,
        },
        str: "some name",
    }

    fmt.Printf("co={num: %v, str: %v}\n", co.num, co.str)
    fmt.Println("also num:", co.base.num)
    fmt.Println("describe:", co.describe())

    type describer interface {
        describe() string
    }

    var d describer = co
    fmt.Println("describer:", d.describe())
}
```
К полям и методам можно обращаться будто они лежат напрямую в объекте. НО всё будет переписано самым "старшим", если имена совпадают

# Generics
Также известны как "type parameters"  

### Функция с generic-типом
```go
func SlicesIndex[S ~[]E, E comparable](s S, v E) int { ... }
```
`S ~[]E` - параметр типа, который должен быть слайсом элементов типа E
`E comparable` - тип элементов должен поддерживать сравнение (==, !=)

### Структура с generic-типом
```go
type List[T any] struct {
    head, tail *element[T]
}

type element[T any] struct {
    next *element[T]
    val  T
}

func (lst *List[T]) Push(v T) {
    if lst.tail == nil { // Если список пуст
        lst.head = &element[T]{val: v}
        lst.tail = lst.head
    } else { // Добавление в конец
        lst.tail.next = &element[T]{val: v}
        lst.tail = lst.tail.next
    }
}

func (lst *List[T]) AllElements() []T {
    var elems []T
    for e := lst.head; e != nil; e = e.next {
        elems = append(elems, e.val)
    }
    return elems
}

func main() {
    var s = []string{"foo", "bar", "zoo"}
    // Автоматический вывод типов
    fmt.Println("index of zoo:", SlicesIndex(s, "zoo"))
    // Явное указание типов
    _ = SlicesIndex[[]string, string](s, "zoo")
    // Работа с обобщенным списком
    lst := List[int]{} // !!! вот здесь даём параметр типу
    lst.Push(10)
    lst.Push(13)
    lst.Push(23)
    fmt.Println("list:", lst.AllElements()) // [10 13 23]
}
```
т.е. то что в плюсах или ts пишется через `<>`, здесь - через `[]`: `Vector<int>` vs `List[int]`

# Итераторы
Описаны в типе `iter.Seq[T]`. Являют собой мощный механизм для ленивых вычислений и работы с последовательностями.
Их преимущества:
- Ленивые вычисления - элементы вычисляются только когда запрашиваются
- Экономия памяти - не нужно хранить всю коллекцию в памяти
- Бесконечные последовательности - можно работать с потоками данных
- Прерывание - потребитель может остановить итерацию в любой момент

```go
type Seq[T any] func(yield func(T) bool)
```
Это функция, которая принимает callback yield (название на самом деле любое, в основном используют это) и вызывает его для каждого элемента  

Пример функции для фибоначчи  
```go
func genFib() iter.Seq[int] {
    return func(yield func(int) bool) {
        a, b := 1, 1
        for {
            if !yield(a) {  // Прерываемся, если потребитель больше не хочет элементы
                return
            }
            a, b = b, a+b
        }
    }
}
```

А если есть метод кот. возвращает итератор - то это можно использовать в range!
```go
func (lst *List[T]) All() iter.Seq[T] {
    return func(yield func(T) bool) {
        for e := lst.head; e != nil; e = e.next {
            if !yield(e.val) {  // Если yield вернул false - выходим
                return
            }
        }
    }
}

// for e := range lst.All() { ... }
```

В пакете `slices` есть несколько функций для перевода списка с итератором => в слайс

# Errors
`import "errors"`  
Есть встроенный тип `error`. 
Создать ошибку можно так:  
```go
errors.New("can't work with 42")
fmt.Errorf("no more tea available")
```

### Wrapping errors
Каждая ошибка может содержать в себе другую ошибку (которая напр. опишет контекст)
Обычно проверяют на nil: `if err != nil`

##### fmt.Errorf и %w
```go
var ErrPower = fmt.Errorf("can't boil water")
var ComplexErr = fmt.Errorf("making tea: %w", ErrPower)
```

### errors.Is, errors.As
`Is` проверяет, есть ли в цепочке конкретная ошибка
```go
// Similar to:
//   if err == ErrNotFound { … }
if errors.Is(err, ErrNotFound) { … }
```

`As` проверяет, есть ли в цепочке ошибака с конкретным типом
```go
// Similar to:
//   if e, ok := err.(*QueryError); ok { … }
var e *QueryError
// Note: *QueryError is the type of the error.
if errors.As(err, &e) { … }
```

### Custom error
```go
// CustomError - кастомная ошибка с дополнительными полями
type CustomError struct {
    Code    int
    Message string
    Err     error // Вложенная ошибка
}

// Error реализует интерфейс error
func (e *CustomError) Error() string {
    if e.Err != nil {
        return fmt.Sprintf("%s (code: %d): %v", e.Message, e.Code, e.Err)
    }
    return fmt.Sprintf("%s (code: %d)", e.Message, e.Code)
}

// Unwrap для поддержки цепочки ошибок
func (e *CustomError) Unwrap() error {
    return e.Err
}

func main() {
    customerrorinstance := &CustomError{
        Code:    100500,
        Message: "You are loser",
        Err:     nil,
    }
    fmt.Println(customerrorinstance)
    // You are loser (code: 100500)
}
```


