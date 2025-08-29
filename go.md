# Go

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

### Пример: IntOrString
1. Без union-типа
```go
type IntOrString[T int | string] struct {
    value T
}

func (ios IntOrString[T]) Get() T {
    return ios.value
}

func (ios IntOrString[T]) String() string {
    return fmt.Sprintf("%v", ios.value)
}

func main() {
    intVal := IntOrString[int]{value: 42}
    strVal := IntOrString[string]{value: "hello"}
    
    fmt.Println(intVal.Get()) // 42
    fmt.Println(strVal.Get()) // hello
}
```

2. С union-типом
```go
type IntOrStringUnion interface {
    int | string
}

func PrintValue[T IntOrStringUnion](value T) {
    fmt.Printf("Value: %v (type: %T)\n", value, value)
}

func main() {
    PrintValue(42)      // Value: 42 (type: int)
    PrintValue("hello") // Value: hello (type: string)
}
```

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

## Map
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

## Functions
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

## range
range - встроенная штука чтобь проходить по массивам, словарям, строкам:  
```go
nums := []int{2, 3, 4}
for index, num := range nums { ... }

kvs := map[string]string{"a": "apple", "b": "banana"}
for key, value := range kvs { ... }

// iterates over Unicode code points
for byte_index, rune := range "go" { ... }
```

## Pointers
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

## Strings and runes
TODO: https://go.dev/blog/strings  
В go строка закодирована в UTF-8, и состоит из "rune" вместо обычных "char".  
Эта руна может состоять из разного числа байт (для разных языков)  
`range` знает про руны и процессит строки корректно.

## struct
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

## methods
Для struct можно объявить методы:  
```go
// тип person из прошлого раздела
func (p *person) sayHi() {
    fmt.Println("hi! I'm ", p.name, " age=", p.age)
}
```
Тип `(p *person)` называется "receiver type". Он может быть указателем или нет - отличие в доступе к исходному объекту, и будет ли копироваться. Вызов метода - всегда через `.` точку.


## interfaces
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

## Enums
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

## struct embedding
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

## Generics
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

## Итераторы
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

## Errors
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

## Goroutines
В go можно вызвать любую функцию как async:
```go
func f(from string) {
    for i := range 3 {
        fmt.Println(from, ":", i)
    }
}

func main() {
    f("direct")
    go f("goroutine")
    // можно и function expression
    go func(msg string) {
        fmt.Println(msg)
    }("going")

    // Это самый тупой пример. Потом будут WaitGroup...
    time.Sleep(time.Second)
    fmt.Println("done")
}
```

## Channels
Каналы нужны для коммуникации между горутинами
```go
func main() {
    messages := make(chan string) // создает новый канал для передачи строк
    // "chan string" - тип "канал, передающий строки"

    //  messages <- "str" - отправляет строку в канал
    go func() { messages <- "ping" }()

    // Блокирующая строка!!!
    // Ждёт сообщения в канале (первого "непрочитанного")
    msg := <-messages
    fmt.Println(msg)
}
```
Если сендер или ресивер в главном потоке - то программа будет их дожидаться.

### Channel buffering
По дефолту в канал нельзя отправить сообщение если ещё нет получателя.  
Можно сделать чтобы канал который может прихранить значения до лучших времён (второй аргумент в функции make)  
```go
func main() {
    // У нас дальше работают 2 сообщения, поэтому поставили 2. Меньше нельзя (ошибка компиляции), больше - можно
    messages := make(chan string, 2)

    messages <- "buffered"
    messages <- "channel"

    fmt.Println(<-messages)
    fmt.Println(<-messages)
}
```

### Channel syncronization
Самый простой пример - передавать канал в функцию которую мы будем ждать:  
> If you removed the <- done line from this program, the program would exit before the worker even started.
```go
func worker(done chan bool) {
    fmt.Print("working...")
    time.Sleep(time.Second)
    fmt.Println("done")

    done <- true
}

func main() {

    done := make(chan bool, 1)
    go worker(done)

    <-done
}
```

### Channel directions
> When using channels as function parameters, you can specify if a channel is meant to only send or receive values. This specificity increases the type-safety of the program
```go
func ping(pings chan<- string, msg string) {
    pings <- msg
}

func pong(pings <-chan string, pongs chan<- string) {
    msg := <-pings
    pongs <- msg
}
```

### select
Мы хотим дождаться нескольких каналов (неважно в каком порядке):  
Для этого делаем `for range N { select { case M: ... }}`  
Важно: в примере ниже мы ждём 2 сообщения. Было бы 1 - программа выходила бы после первого месседжа. Было бы 3 - компиляция бы упала
```go
func main() {
    c1 := make(chan string)
    c2 := make(chan string)

    go func() {
        time.Sleep(1 * time.Second)
        c1 <- "one"
    }()
    go func() {
        time.Sleep(2 * time.Second)
        c2 <- "two"
    }()

    for range 2 {
        select {
        case msg1 := <-c1:
            fmt.Println("received", msg1)
        case msg2 := <-c2:
            fmt.Println("received", msg2)
        }
    }
}
```
В этом примере функция `go func()` может выдавать хоть 30 значений, но мы дождёмся только первые 2

### Timeouts, `<-time.After()`
Можно через обычный channel и `time.Sleep`  
А можно так: `<-time.After(3 * time.Second)`

### Non-blocking channel operations
Чтобы получать сигнал не блокируя поток, надо делать `select` с `default`:  
```go
select {
case msg := <-messages:
    fmt.Println("received message", msg)
default:
    fmt.Println("no message received")
}
```
Тогда если сообщение ещё не залетело в канал - будет default.  
TODO: не помогает если сообщений вообще нет. Разобраться

Можно делать не только non-blocking receive, но и send:
```go
    select {
    case messages <- "hi":
        fmt.Println("sent message", msg)
    default:
        fmt.Println("no message sent")
    }
```
Если "messages" никто не читает - то код пойдёт в default

### Closing channels
Делается через `close(ourchannel)`  
Потом мы можем проверить так: `val, ok := <-ourchannel`. Если `ok` false - то канал закрыт.
```go
func main() {
    jobs := make(chan int, 5)
    close(jobs)

    _, ok := <-jobs
    fmt.Println("received more jobs:", ok)
}
```

### Range over channels
Если канал уже закрыт - можно сделать по нему range
```go
func main() {
    queue := make(chan string, 2)
    queue <- "one"
    queue <- "two"
    queue <- "three"
	close(queue)

    for elem := range queue {
        fmt.Println(elem)
    }
}
```
Но если какое-то значение из "queue" получить до range - то в range оно не попадёт.  
Если не закрыть канал - то range обвалит компиляцию

## Timers
> Timers represent a single event in the future  
Таймер тоже делается через канал:
```go
func main() {
    timer1 := time.NewTimer(2 * time.Second)

    <-timer1.C // type Timer struct { C <-chan Time }
    fmt.Println("Timer 1 fired")

    timer2 := time.NewTimer(time.Second)
    stop2 := timer2.Stop()
    if stop2 { // true or false
        fmt.Println("Timer 2 stopped")
    }
}
```
В отличие от `time.Sleep`, этот таймер можно кэнсельнуть (`timer2.Stop()`)

## Tickers
> Timers are for when you want to do something once in the future - tickers are for when you want to do something repeatedly at regular intervals. 
Т.е. tickers - это как timers только repeatedly at regular intervals
```go
ticker := time.NewTicker(500 * time.Millisecond)
t := <-ticker.C
ticker.Stop()
```

Ещё бывает `time.Tick()` - результат просто будет бесконечно тикать, его нельзя остановить
```go
t := time.Tick(500 * time.Millisecond)
```

## Worker pool
Worker pool - это паттерн, когда мы создаём N потоков и выполняем задачи в этих потоках.  
Напр. у нас 20 задач и 3 потока - потоки будут брать "верхнюю" задачу пока задачи не закончатся.  
В примере ниже - мы вызываем функцию `worker` несколько раз, но подаём на вход одни и теже "jobs"  
```go
func worker(id int, jobs <-chan int, results chan<- int) {
    for j := range jobs {
        fmt.Println("worker", id, "started  job", j)
		var ran int = rand.Int() % 5 + 1
		fmt.Println("ran = ", ran)
        time.Sleep(time.Duration(ran) * time.Second)
        fmt.Println("worker", id, "finished job", j)
        results <- j * 2
    }
}

func main() {
    const numJobs = 5
    jobs := make(chan int, numJobs)
    results := make(chan int, numJobs)

    for w := 1; w <= 3; w++ {
// Сначала мы создали воркеры, потом наполняем очередь jobs. Так можно. Можно и наоборот
        go worker(w, jobs, results)
    }

    for j := 1; j <= numJobs; j++ {
        jobs <- j
    }
    close(jobs)

    for a := 1; a <= numJobs; a++ {
        <-results
    }
}
```

## WaitGroups
Нужны когда нам нужно дождаться несколько горутин.  
Мы создаём экземпляр WaitGroup и все горутины которых будем ждать - запускаем через `wg.Go(func() { ... })`  
NOTE: Если мы передаём `wg` как аргумент - пердавать надо указатель!
```go
func worker(id int) {
    fmt.Printf("Worker %d starting\n", id)

    time.Sleep(time.Second)
    fmt.Printf("Worker %d done\n", id)
}

func main() {
    var wg sync.WaitGroup

    for i := 1; i <= 5; i++ {
        wg.Go(func() {
            worker(i)
        })
    }

    wg.Wait()
}
```
Если нужно ещё и ошибки ловить - работаем с [errgroup](https://pkg.go.dev/golang.org/x/sync/errgroup)  
Порядок, в котором запустятся воркеры - в общем случае не определён.

Другой вариант - через `wg.Add(int)` и `wg.Done()`:  
```go
    doIncrement := func(name string) {
		c.inc(name)
        wg.Done()
    }

    wg.Add(2)
    go doIncrement("a")
    go doIncrement("a")

    wg.Wait() // Дождётся 2 wg.Done()
```

## Rate limiting
Rate limiting - паттерн, когда мы ограничиваем число одновременных работ.  
Вот пример реализации на go:
```go
    requests := make(chan int, 5)
    for i := 1; i <= 5; i++ {
        requests <- i
    }
    close(requests)

    limiter := time.Tick(200 * time.Millisecond)

    for req := range requests {
        <-limiter
        fmt.Println("request", req, time.Now())
    }
```
"limiter" выстреливает каждые 200 мс.  

Пример посложнее: здесь rate limiting + первые 3 задачи выполняются сразу
```go
    burstyLimiter := make(chan time.Time, 3)

    for range 3 {
        burstyLimiter <- time.Now()
    }

    go func() {
        for t := range time.Tick(200 * time.Millisecond) {
            burstyLimiter <- t
        }
    }()

    burstyRequests := make(chan int, 5)
    for i := 1; i <= 5; i++ {
        burstyRequests <- i
    }
    close(burstyRequests)
    for req := range burstyRequests {
        <-burstyLimiter
        fmt.Println("request", req, time.Now())
    }
```

## Atomic counters
> The primary mechanism for managing state in Go is communication over channels
"Atomic counters" - это значения которые могут быть расшарены между потоками и быть безопасны с т.зр. чтения-записи и race condition:  
```go
package main

import (
    "fmt"
    "sync"
    "sync/atomic"
)

func main() {
    var ops atomic.Uint64
    var wg sync.WaitGroup

    for range 50 {
        wg.Add(1)

        go func() {
            for range 1000 {
                ops.Add(1)
            }
            wg.Done()
        }()
    }

    wg.Wait()

    fmt.Println("ops:", ops.Load()) // ops: 50000
}
```
TODO: `atomic.AddUint64`, `atomic.LoadUint64` - методы для работы с обычными переменными

## Mutexes
Мьютексы передаём по указателю!  
```go
type Container struct {
    mu       sync.Mutex // ----------- !!!
    counters map[string]int
}

func (c *Container) inc(name string) {
    c.mu.Lock() // ----------- !!! Эта строчка будет ждать пока мьютекс разлочится
    defer c.mu.Unlock() // ----------- !!!
	time.Sleep(time.Second)
    c.counters[name]++
}

func main() {
    c := Container{
        counters: map[string]int{"a": 0, "b": 0},
        // явно можно не создавать мьютекс, он по дефолту unlocked
    }

    var wg sync.WaitGroup

    doIncrement := func(name string) {
		c.inc(name)
        wg.Done()
    }

    wg.Add(2)
    go doIncrement("a")
    go doIncrement("a")

    wg.Wait()
    fmt.Println(c.counters)
}
}
```

## Stateful goroutines
Можно не лочить ресурсы явно через мьютексы, а использовать горутины и каналы.  
> This channel-based approach aligns with Go’s ideas of sharing memory by communicating and having each piece of data owned by exactly 1 goroutine.  

В примере ниже мы разделяем операции read и write через channel, так что операции записи/чтения не пересекаются (см. `go func()`)  
Даже переменная в которой храним значение скрыта внутри `go func`, снаружи до неё не добраться.
Вот полный код примера:  
```go
package main

import (
    "fmt"
    "math/rand"
    "sync/atomic"
    "time"
)

type readOp struct {
    key  int
    resp chan int // Этот канал - не readsChannel! для каждой readOp он свой
}
type writeOp struct {
    key  int
    val  int
    resp chan bool // Этот канал - не readsChannel! для каждой writeOp он свой
}

func main() {
	// Эти два - тупо счётчики которые покажем в конце. В логике работы они не участвуют
    var readOpsCount uint64
    var writeOpsCount uint64

    // Эти каналы используются для связи между горутинами
    readsChannel := make(chan readOp)
    writesChannel := make(chan writeOp)

    // > state will be owned by a single goroutine
    go func() { // ----- Вот здесь мы разделяем чтение и запись
        var mainState = make(map[int]int)
        for {
            select {
            case read := <-readsChannel:
                read.resp <- mainState[read.key]
            case write := <-writesChannel:
                mainState[write.key] = write.val
                write.resp <- true
            }
        }
    }()

    for range 100 {
        go func() {
            for {
                read := readOp{
                    key:  rand.Intn(5),
                    resp: make(chan int)}
                readsChannel <- read
                <-read.resp
                atomic.AddUint64(&readOpsCount, 1)
                time.Sleep(time.Millisecond)
            }
        }()
    }

    for range 10 {
        go func() {
            for {
                write := writeOp{
                    key:  rand.Intn(5),
                    val:  rand.Intn(100),
                    resp: make(chan bool)}
                writesChannel <- write
                <-write.resp
                atomic.AddUint64(&writeOpsCount, 1)
                time.Sleep(time.Millisecond)
            }
        }()
    }

    time.Sleep(time.Second)

    readOpsFinal := atomic.LoadUint64(&readOpsCount)
    fmt.Println("readOps:", readOpsFinal)
    writeOpsFinal := atomic.LoadUint64(&writeOpsCount)
    fmt.Println("writeOps:", writeOpsFinal)
}
```

## Sorting
Есть встроенная функция сортировки для слайсов из примитивных типов (она МУТИРУЕТ исходный слайс) `slices.Sort`:
```go
    strs := []string{"c", "a", "b"}
    slices.Sort(strs)

    ints := []int{7, 2, 4}
    slices.Sort(ints)

    s := slices.IsSorted(ints) // можно сначала проверить, надо ли сортировать или нет
```

### Custom sort functions
Работает `slices.SortFunc`  
`cmp.Compare` возвращает -1, 0, 1  
Пример, где мы сортируем строки по длине (а не по алфавиту)  
```go
    fruits := []string{"peach", "banana", "kiwi"}

    lenCmp := func(a, b string) int {
        return cmp.Compare(len(a), len(b))
    }

    slices.SortFunc(fruits, lenCmp)
    fmt.Println(fruits)
```

Пример, где мы сортируем по полю "age" (если структуры большие - лучше использовать слайс указателей, чтобы не было лишних копирований)
```go
    type Person struct {
        name string
        age  int
    }

    people := []Person{
        Person{name: "Jax", age: 37},
        Person{name: "TJ", age: 25},
        Person{name: "Alex", age: 72},
    }

    slices.SortFunc(people,
        func(a, b Person) int {
            return cmp.Compare(a.age, b.age)
        })
    fmt.Println(people)
}
```

## Panic
> A panic typically means something went unexpectedly wrong. Mostly we use it to fail fast on errors that shouldn’t occur during normal operation, or that we aren’t prepared to handle gracefully.
Т.е. ключевое - "unexpectedly wrong"
```go
func main() {
    // Программа вывалится здесь и дальше не пойдёт
    panic("a problem")

    _, err := os.Create("/tmp/file")
    if err != nil {
        panic(err)
    }
}
```

## Defer
`defer` будет вызван после того, как функция завершена.  
Логически это аналог `finally` из других языков (TODO: я не очень понял этот момент)
```go
func main() {
    f := createFile("/tmp/defer.txt")
    defer closeFile(f) // Эта строчка будет вызвана после выхода из main
    writeFile(f)
}
```
Если в одном блоке есть несколько `defer` - они будут вызыываться по модели LIFO

## Recover
`recover` может "спасти" программу которая вывалилась по panic.  
> An example of where this can be useful: a server wouldn’t want to crash if one of the client connections exhibits a critical error. Instead, the server would want to close that connection and continue serving other clients. In fact, this is what Go’s net/http does by default for HTTP servers.  
`recover` должен запускаться внутри `defer`.

```go
func mayPanic() {
    panic("a problem")
}

func main() {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Recovered. Error:\n", r)
        }
    }()

    mayPanic()

    // Сюда код не зайдёт
    fmt.Println("After mayPanic()")
}
```

## String functions
В коде ниже - встроенные функции для работы со строками.  
Все функции - в доке [pkg.go.dev/strings](https://pkg.go.dev/strings)
Также здесь пример алиаса для импорта (`s "strings"`) и функции (`p = fmt.Println`)  
```go
package main

import (
    "fmt"
    s "strings"
)

var p = fmt.Println

func main() {

    p("Contains:  ", s.Contains("test", "es"))
    p("Count:     ", s.Count("test", "t"))
    p("HasPrefix: ", s.HasPrefix("test", "te"))
    p("HasSuffix: ", s.HasSuffix("test", "st"))
    p("Index:     ", s.Index("test", "e"))
    p("Join:      ", s.Join([]string{"a", "b"}, "-"))
    p("Repeat:    ", s.Repeat("a", 5))
    p("Replace:   ", s.Replace("foo", "o", "0", -1))
    p("Replace:   ", s.Replace("foo", "o", "0", 1))
    p("Split:     ", s.Split("a-b-c-d-e", "-"))
    p("ToLower:   ", s.ToLower("TEST"))
    p("ToUpper:   ", s.ToUpper("test"))
}
```

### String formatting: `fmt.Printf`
`%v`: Структуры можно писать через `%v`, `%+v` (с именами полей), `%#v` (с именем типа)  
`%T`: Написать тип
`%t`: boolean
`%d`: integer (+ все опции из printf)
`%b`: integer в двоичном виде
`%c`: char для данного инт
`%x`: integer в 16-ном виде; string - выведет вместо каждого символа его код
`%f`: float (+ все опции из printf)
`%e`, `%E`: float в виде "мантисса+порядок"
`%s`: string
`%q`: string, на выводе будет обёрнут в ""
`%p`: pointer

### Text templates
Самый простой пример (без обработки ошибок для краткости, но она нужна):  
```go
	// Define a simple template string
	tmplStr := "Hello, {{.Name}}! You are {{.Age}} years old."

	// Create a new template and parse the string
    // "myTemplate" - рандомное имя, в этом коде оно похуистично
	tmpl := template.New("myTemplate")
	tmpl, _ = tmpl.Parse(tmplStr)
    // Чтобы выбросить панику, делаем так: tmpl := template.Must(tmpl.Parse(tmplStr))

	// Define data to be passed to the template
	data := struct {
		Name string
		Age  int
	}{
		Name: "Alice",
		Age:  30,
	}

	tmpl.Execute(os.Stdout, data)
```

Можно делать if-else: `"{{if . }} yes {{else}} no {{end}}\n"`  
TODO: Можно делать trim слева и справа: `"{{- .}}"`, `"{{. -}}"`, `"{{-.-}}"`  
Можно выводить слайсы, массивы, maps, channels: `"Range: {{range .}}{{.}} {{end}}\n"`
Можно обращаться к полям входной структуры: `{{.Field}}`

## Regexp
Используется диалект `RE2`, отличный от Perl (нету lookahead, lookbehind, backref, ...)
Есть много встроенных функций:  
```go
func main() {
    match, _ := regexp.MatchString("p([a-z]+)ch", "peach") // true

    r, _ := regexp.Compile("p([a-z]+)ch")
    fmt.Println(r.MatchString("peach"))
    fmt.Println(r.FindString("peach punch"))
    fmt.Println("idx:", r.FindStringIndex("peach punch"))
    fmt.Println(r.FindStringSubmatch("peach punch"))
    fmt.Println(r.FindStringSubmatchIndex("peach punch"))
    fmt.Println(r.FindAllString("peach punch pinch", -1))
    fmt.Println("all:", r.FindAllStringSubmatchIndex("peach punch pinch", -1))
    fmt.Println(r.FindAllString("peach punch pinch", 2))
    fmt.Println(r.Match([]byte("peach")))

    r = regexp.MustCompile("p([a-z]+)ch")
    fmt.Println("regexp:", r)

    fmt.Println(r.ReplaceAllString("a peach", "<fruit>"))

    in := []byte("a peach")
    out := r.ReplaceAllFunc(in, bytes.ToUpper)
    fmt.Println(string(out))
}
```

## JSON
### Go => JSON
В go есть встроенные утили для работы с json  
`json.Marshal()` - преобразует в JSON байты (Pointers будут автоматически разыменованы)  
`json.MarshalIndent()` - форматированный вывод  
Теги `json:"name"` - управляют именами полей в JSON  
`omitempty` - пропускает поле, если оно пустое  
```go
    data := map[string]int{
        "a": 1,
        "b": 2,
    }
    
    // ----- 1. Basic -----
    jsonBytes, err := json.Marshal(data) // Вернёт []byte
    if err != nil {
        panic(err)
    }
    
    fmt.Println(string(jsonBytes))
    // Output: {"a":1,"b":2}

    // ----- 2. Formatted output -----
    jsonBytes, _ := json.MarshalIndent(data, "$", "!!")
    fmt.Println(string(jsonBytes))
    // Output:
    // {
    // $!!"a": 1,
    // $!!"b": 2
    // $}

    // ----- 3. Custom types -----
    type Data struct {
        // Названия полей должны начинаться с большой буквы!
        A int
        littleLetter int `json:"little"` // Этого поля не будет в json
        // Можно сделать кастомное имя поля в json
        B int `json:"b"`
        // Если этого поля нет или оно = дефолт, то в джсон он не попадёт
        C int `json:"c",omitempty`
    }
    jsonBytes, _ := json.Marshal(Data{A: 1, B: 2})
    fmt.Println(string(jsonBytes))
    // Output: {"a":1,"b":2}

    // ----- 4. Primitive values -----
    // Примитивные значения, arrays, maps
    jsonBytes, _ := json.Marshal(100500)
    fmt.Println(string(jsonBytes))
    // Output: 100500
```

### JSON => Go
Обратная операция делается через `err = json.Unmarshal()`  
```go
type Data struct {
    A int
	B int  `json:"bbb"`
}

func main() {
    var data Data
    if err := json.Unmarshal([]byte(`{"a":1,"bbb":2}`), &data) { // Unmarshal вернёт ошибку, её надо проверить!
        panic(err)
    }
	fmt.Printf("data: %+v", data)
    // Output: data: {A:1 B:2}⏎ 
}
```

Если не знаем что будет в json'е - делаем map[string]interface{} и потом приводим типы
```go
    var data map[string]interface{}
    json.Unmarshal([]byte(`{"a":1.333,"b":2}`), &data)
	fmt.Printf("data: %+v\n", data)
    // Output: data: {a:1.333 b:2}⏎ 

	// fmt.Println("a=", data.a) // Будет ошибка компиляции!
	fmt.Println("a=", data["a"], data["a"].(float64) + 5)
```

### []byte(`string...`) vs encoders
Для того чтобы прочитат json - в прошлом примере использовали тип `byte[]` но можно и без этого  
Вот этот пример переведёт **go-структуру в json** и выведет в os.Stdout
```go
    enc := json.NewEncoder(os.Stdout)
    d := map[string]int{"apple": 5, "lettuce": 7}
    enc.Encode(d)
```

Этот пример переведет **json в go**  
```go
    str := `{"page": 1, "fruits": ["apple", "peach"]}`
    dec := json.NewDecoder(strings.NewReader(str))

	type response2 struct {
		Page   int      `json:"page"`
		Fruits []string `json:"fruits"`
	}
    res1 := response2{}
    dec.Decode(&res1) // если res1 что-то содержит - старые данные потеряются!
    fmt.Println(res1)
```

## XML
В целом принцип как json, см. [https://gobyexample.com/xml](gobyexample.com/xml)

## Time
В go есть широкий набор для работы с датавременем и Duration  
```go
    p := fmt.Println

    now := time.Now()
    p(now)

    then := time.Date( // type = time.Time
        2009, 11, 17, 20, 34, 58, 651387237, time.UTC)
    p(then)

    p(then.Year())
    p(then.Month())
    p(then.Day())
    p(then.Hour())
    p(then.Minute())
    p(then.Second())
    p(then.Nanosecond())
    p(then.Location())

    p(then.Weekday())

    p(then.Before(now))
    p(then.After(now))
    p(then.Equal(now))

    diff := now.Sub(then) // type = time.Duration
    p(diff)

    p(diff.Hours())
    p(diff.Minutes())
    p(diff.Seconds())
    p(diff.Nanoseconds())

    p(then.Add(diff))
    p(then.Add(-diff))
```

### Epoch 
Time может работать с Unix epoch
```go
    now := time.Now()
    fmt.Println(now) // 2025-09-01 17:15:03.686053667 +0300 MSK m=+0.000011717
    fmt.Println(now.Unix()) // 1756736103
    fmt.Println(now.UnixMilli()) // 1756736103686
    fmt.Println(now.UnixNano()) // 1756736103686053667

    // convert integer seconds or nanoseconds since the epoch into the corresponding time
    fmt.Println(time.Unix(now.Unix(), 0)) // 2025-09-01 17:15:03 +0300 MSK
    fmt.Println(time.Unix(0, now.UnixNano())) // 2025-09-01 17:15:03.686053667 +0300 MSK
```

### Time formatting/parsing
`time.Format()`, `time.Parse()`  
```go
    t := time.Now()
    fmt.Println(t.Format(time.RFC3339)) // 2025-09-01T17:36:10+03:00

    t1, e := time.Parse(
        time.RFC3339,
        "2012-11-01T22:08:41+00:00")
    fmt.Println(t1) // 2012-11-01 22:08:41 +0000 +0000

    fmt.Println(t.Format("9:04PM")) // 5:36PM
    fmt.Println(t.Format("Mon Jan _2 15:04:05 2006"))
    fmt.Println(t.Format("2006-01-02T15:04:05.999999-07:00"))
    form := "3 04 PM"
    t2, e := time.Parse(form, "8 41 PM")
    fmt.Println(t2)

    fmt.Printf("%d-%02d-%02dT%02d:%02d:%02d-00:00\n",
        t.Year(), t.Month(), t.Day(),
        t.Hour(), t.Minute(), t.Second())

    ansic := "Mon Jan _2 15:04:05 2006"
    _, e = time.Parse(ansic, "8:41PM")
    fmt.Println(e)
```

Важно! Для кастомных форматов надо использовать конкретную дату `Mon Jan 2 15:04:05 MST 2006`

Есть предопределённые форматы:
```go
const (
    ANSIC       = "Mon Jan _2 15:04:05 2006"
    UnixDate    = "Mon Jan _2 15:04:05 MST 2006"
    RubyDate    = "Mon Jan 02 15:04:05 -0700 2006"
    RFC822      = "02 Jan 06 15:04 MST"
    RFC822Z     = "02 Jan 06 15:04 -0700"
    RFC850      = "Monday, 02-Jan-06 15:04:05 MST"
    RFC1123     = "Mon, 02 Jan 2006 15:04:05 MST"
    RFC1123Z    = "Mon, 02 Jan 2006 15:04:05 -0700"
    RFC3339     = "2006-01-02T15:04:05Z07:00"
    RFC3339Nano = "2006-01-02T15:04:05.999999999Z07:00"
    Kitchen     = "3:04PM"
    Stamp       = "Jan _2 15:04:05"
    StampMilli  = "Jan _2 15:04:05.000"
    StampMicro  = "Jan _2 15:04:05.000000"
    StampNano   = "Jan _2 15:04:05.000000000"
)
```

Еще, конечно, можно использовать `Printf` c `var.Year(), ...`

## Random numbers 
```go
import "math/rand/v2"

rand.IntN(100) // 0 <= n < 100
rand.Float64() // 0 <= n < 1
```

Можно объявить свой рандомизатор со своим seed:  
```go
s2 := rand.NewPCG(42, 1024)
r2 := rand.New(s2)
r2.IntN(100)
```

В [pkg.go.dev/math/rand/v2](https://pkg.go.dev/math/rand/v2) есть ещё много всего.

## Number Parsing (string => number)
Импортится `strconv`:  
```go
    f, _ := strconv.ParseFloat("1.234", 64)
    i, _ := strconv.ParseInt("123", 0, 64)
    d, _ := strconv.ParseInt("0x1c8", 0, 64)
    u, _ := strconv.ParseUint("789", 0, 64)
    k, _ := strconv.Atoi("135") // ----- Вот самый простой парс строки в инт
    _, error := strconv.Atoi("wat")
}
```

## URL Parsing
Parse this example URL, which includes a scheme, authentication info, host, port, path, query params, and query fragment.  
`s := "postgres://user:pass@host.com:5432/path?k=v#f"`  

Собственно, всё в этом примере:  
```go
    s := "postgres://user:pass@host.com:5432/path?argumentkey=argumentvalue#sharp"

    u, err := url.Parse(s)
    if err != nil {
        panic(err)
    }

    fmt.Println(u.Scheme)

    fmt.Println(u.User)
    fmt.Println(u.User.Username())
    p, _ := u.User.Password()
    fmt.Println(p)

    fmt.Println(u.Host)
    host, port, _ := net.SplitHostPort(u.Host)
    fmt.Println(host)
    fmt.Println(port)

    fmt.Println(u.Path)
    fmt.Println(u.Fragment)

    fmt.Println(u.RawQuery)
    m, _ := url.ParseQuery(u.RawQuery)
    fmt.Println(m)
    fmt.Println(m["argumentkey"][0])
```

## SHA256 Hashes
Преобразование строки в хеш:
```go
    s := "sha256 this string we should defend under hash"
    h := sha256.New()
    h.Write([]byte(s))
    bs := h.Sum(nil) // The argument to Sum can be used to append to an existing byte slice: it usually isn’t needed.
    fmt.Println(s)
    fmt.Printf("%x\n", bs)
```
Аккуратно! Если используем, надо проверить [hash strength](https://en.wikipedia.org/wiki/Cryptographic_hash_function)
 
## base64
[]byte можно переводить в base64 (в общем формате и в формате url)
```go
import b64 "encoding/base64"
data := "some string here"
sEnc := b64.StdEncoding.EncodeToString([]byte(data)) // string
sDec, _ := b64.StdEncoding.DecodeString(sEnc) // []byte, use string(sDec)
uEnc := b64.URLEncoding.EncodeToString([]byte(data)) // string
uDec, _ := b64.URLEncoding.DecodeString(uEnc) // []byte, use string(uDec)
```

### Отличия standard base64 от url base64
| Характеристика | Standard Base64 | URL Base64 |
|----------------|-----------------|------------|
| **Алфавит кодирования** | `A-Z`, `a-z`, `0-9`, `+`, `/` | `A-Z`, `a-z`, `0-9`, `-`, `_` |
| **Символ заполнения** | `=` (обязательно) | `=` (часто опускается) |
| **Безопасность в URL** | ❌ Небезопасен | ✅ Безопасен |
| **Использование в параметрах** | ❌ Проблемы с `+`, `/`, `=` | ✅ Оптимизирован для query-параметров |
| **Читаемость человеком** | ✅ Хорошая | ✅ Хорошая |
| **Размер данных** | Одинаковый (4/3 от оригинала) | Одинаковый (4/3 от оригинала) |
| **Основное применение** | Email, XML, JSON, общие данные | URL, cookies, имена файлов, веб-токены |
| **Стандарт** | RFC 4648 Section 4 | RFC 4648 Section 5 |

## Reading files
Самый базовый способ - прочитать сразу весь файл в []byte
```go
dat, err := os.ReadFile("/tmp/dat")
// ...check(err)
fmt.Print(string(dat))
```

Для более сложных вещей используем `f, err := os.Open("./dot")`
 
Чтение первых 5 байт:
```go
b1 := make([]byte, 5)
n1, err := f.Read(b1)
fmt.Printf("%d bytes: %s\n", n1, string(b1))
```

Чтение начиная с N-го байта делается так: сначала ставим курсор потом `Read`:
```go
o2, err := f.Seek(6, io.SeekStart) // N = 6
b2 := make([]byte, 2) // будем читать 2 байта
n2, err := f.Read(b2) // прочитали 2 байта
n2, err = f.Read(b2) // прочитали следующие 2 байта
```

### Перемещение курсора
```go
// Перемещение на 6 байтов вперед от начала
_, err := f.Seek(6, io.SeekStart)
// Перемещение на 2 байта вперед от текущей позиции
_, err = f.Seek(2, io.SeekCurrent)  // SeekCurrent = текущая позиция
// Перемещение на 4 байта назад от конца файла  
_, err = f.Seek(-4, io.SeekEnd)     // SeekEnd = конец файла
```

### ReadAtLeast
`n, err := io.ReadAtLeast(reader, buffer, minBytes)` - гарантирует что будет прочитано minBytes,
заблокирует поток пока не прочитает (обычный Read такого не гарантирует и ничего не блокирует)  
Нужно такое, когда мы читаем конкретные данные - бинарные форматы, хедеры в протоколах связи и т.д.  
Когда у нас произвольные данные или поток - это нам не нужно.

### bufio
Пакет bufio предоставляет буферизированные реализации для чтения и записи, которые предлагают два ключевых преимущества:
1. Эффективность при множественных мелких чтениях
Решает такую проблему:
```go
f, _ := os.Open("file.txt")
/* решение */ reader := bufio.NewReader(f)  // Буфер обычно 4KB
for i := 0; i < 1000; i++ {
    b := make([]byte, 10)
    /* проблема */ n, _ := f.Read(b)  // Системный вызов каждый раз! Медленно при многих мелких чтениях
    /* решение */ n, _ := reader.Read(b)    // Чтение из буфера
    process(b[:n])
}
f.Close()
```
Как это работает: буфер сразу читает большой кусок (обычно 4KB) и потом отдаёт программе понемногу.
Когда большой кусок заканчивается - читает ещё один

2. Дополнительные методы чтения
- `Peek(n)` - подглядывание без продвижения позиции
- `ReadBytes(delim)` и `ReadString(delim)` - чтение до разделителя
- `ReadLine()` - чтение строки с обработкой разных форматов
- `ReadSlice(delim)` и `ReadBytes(delim)`
- `UnreadByte()` и `UnreadRune()` - возврат назад

### Пример сетевой обработки
```go
func handleConnection(conn net.Conn) {
    reader := bufio.NewReader(conn)
    
    for {
        // Чтение команды до символа новой строки
        command, err := reader.ReadString('\n')
        if err != nil {
            break
        }
        
        command = strings.TrimSpace(command)
        processCommand(command)
    }
}
```

### f.Close()
Не забываем закрыть файл! Обычно делаем defer сразу после открытия

## Writing files
`filename := "/home/alex/proj/gotest/dot"`

##### Самый простой пример:
```go
d1 := []byte("hello\ngo\n")
err := os.WriteFile(filename, d1, 0644)
check(err)
```

##### Посложнее:
```go
f, err := os.Create(filename)
check(err)
defer f.Close() // принято закрывать файл сразу после открытия в defer

d2 := []byte{115, 111, 109, 101, 10}
n2, err := f.Write(d2)
check(err)
fmt.Printf("wrote %d bytes\n", n2)

n3, err := f.WriteString("writes\n")
check(err)
fmt.Printf("wrote %d bytes\n", n3)

f.Sync() // Issue a Sync to flush writes to stable storage
```

##### bufio
```go
f, err := os.Create(filename)
w := bufio.NewWriter(f)
n4, err := w.WriteString("buffered\n")
check(err)
fmt.Printf("wrote %d bytes\n", n4)

w.Flush() // ensure all buffered operations applied
```

## Line filters
**Line Filters** (фильтры строк) — это утилиты или программы, которые обрабатывают текстовые данные построчно, применяя к каждой строке определенные операции или преобразования. Это классическая концепция из UNIX-философии.

Основные характеристики:  
- Построчная обработка — читают ввод построчно
- Преобразование — изменяют или фильтруют каждую строку
- Потоковая обработка — работают с stdin/stdout
- Комposability — могут соединяться в конвейеры (pipelines)

#### Пример: Простой фильтр - преобразует текст в верхний регистр
```go
scanner := bufio.NewScanner(os.Stdin)

for scanner.Scan() { // ввод текста в консоли
    line := scanner.Text()
    fmt.Println(strings.ToUpper(line))
}

if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "error:", err)
    os.Exit(1)
}
```

## File paths
`filepath` позволяет получить имя файла, безопасно для системы, удалить лишние сепараторы и лишние части пути  
В общем, как `path.join` в ноде.
```go
filepath.Join("dir1", "dir2", "filename") // dir1/dir2/filename
filepath.Join("dir1//", "filename") // dir1/filename
filepath.Join("dir1/../dir1", "filename") // dir1/filename
```

Много удобных функций для работы с filepath:
```go
p := filepath.Join("dir1", "dir2", "config.json")
fmt.Println("Dir(p):", filepath.Dir(p)) // dir1/dir2
fmt.Println("Base(p):", filepath.Base(p)) // filename
fmt.Println(filepath.IsAbs("dir/file")) // false
fmt.Println(filepath.IsAbs("/dir/file")) // true

ext := filepath.Ext(p) // .json
strings.TrimSuffix(filename, ext) // dir1/dir2/config

rel, err := filepath.Rel("a/b", "a/b/t/file") // t/file
rel, err = filepath.Rel("a/b", "a/c/t/file") // ../c/t/file
```

## Directories
Много функций для работы с папками, аналоги линуксовых:  
`os.Mkdir` - "mkdir"  
`os.MkdirAll` - "mkdir", но если подать долгий путь - создаст все папки по пути  
`os.RemoveAll` - "rm -rf"  
`os.ReadDir` - "ls"  
`os.Chdir` - "cd"  
`filepath.WalkDir("subdir", callback)` - рекурсивно пройти по папке (пройти по файлам и папкам, зайти в папки...) и вызвать в каждой - callback

## Temp files and dirs
Создаём временный файл и сразу открываем его на чтение/запись  
`f, err := os.CreateTemp("", "sample") ... os.Remove(f.Name())`  
Когда создаём временную папку - возвращается только её имя. Файлы внутри неё можно создать как обычные  
`dname, err := os.MkdirTemp("", "sampledir") ... os.RemoveAll(dname)`

## Embed files and dirs
В бинарник можно встраивать файл (напр. текстовый или бинарный) и потом работать с его содержимым:  
```go
import (
    _ "embed" // типа мы просто импортим этот пакет но в коде не используем
)

// Это происходит специальным синтаксисом комментария:
/. go:embed filepath и ниже объявляем переменную соотв. типа - контент файла залетит туда
//go:embed folder/single_file.txt
var fileString string

//go:embed folder/single_file.txt
var fileByte []byte

// Папка встраивается вот так (можно с wildcard)
//go:embed folder/single_file.txt
//go:embed folder/*.hash
var folder embed.FS

func main() {
    print(fileString)
    print(string(fileByte))

    content1, _ := folder.ReadFile("folder/file1.hash")
    print(string(content1))

    content2, _ := folder.ReadFile("folder/file2.hash")
    print(string(content2))
}
```
