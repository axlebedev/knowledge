TODO: разобраться, как работают _code points_ и как различать от юникодов

# let, const
**Объявления `let` и `const` не возносятся наверх, как `var`.**  
Это не совсем точно: на самом деле когда мы входим в блок, то память под эти
переменные выделяется. Но при попытке обратиться к ним до определения мы
словим _ReferenceError_.

## let
`let` - это как `var`, только с блочной видимостью.  
Блок - как в плюсах - любая пара фигурных скобок.  

## const
Обращаем внимание, что если объект константен - ссылки внутри него нет.
```JavaScript
const obj = {};
obj.prop = 123;
console.log(obj.prop); // 123

obj = Object.freeze(obj); // теперь и внутри объекта нихренашеньки не поменять
```

## Поведение в циклах
```JavaScript
// Для функций внутри цикла это будет одна и та же переменная
for (var i=0; i < 3; i++)

// Каждую итерацию создается новая переменная
for (let i=0; i < 3; i++)

// const работает как var, но нам в данном случае похуй
```

## Параметры функции
```JavaScript
function func1(arg) {
    let arg; // static error: duplicate declaration of `arg`
}

function func2(arg) {
    {
        let arg; // shadows parameter `arg`
    }
}

// Сравним с var
function func1(arg) {
    var arg; // does nothing
}
function func2(arg) {
    {
        // We are still in same `var` scope as `arg`
        var arg; // does nothing
    }
} 
```

Если у функции есть дефолтные параметры, то они рассматриваются как `let`:
```JavaScript
// OK: `y` accesses `x` after it has been declared
function foo(x=1, y=x) {
    return [x, y];
}
// Exception: `x` tries to access `y` within TDZ
function bar(x=y, y=2) {
    return [x, y];
}
```

У дефолтных параметров свой scope:
```JavaScript
let foo = 'outer';
function bar(func = x => foo) {
    // foo не виден
}
```

## Глобальный объект
`var` и _function declarations_ являются свойствами глобального объекта
(`window` в браузерах и `global` в ноде).  
`let`, `const` и классы - просто глобальные объекты, не являются ничьими 
свойствами.











# Массивы
## `for..of`
```JavaScript
var arr = ['a', 'b', 'c'];
// можно получать элемент:
for (let elem of arr)
// а можно элемент с индексом:
for (let [index, elem] of arr.entries())
```





# Number
Теперь можно в различных нотациях:
```JavaScript
var decimal = 987;
var hexadecimal = 0xFF;
var binary = 0b11;
var octal = 0o17;

hexadecimal.toString(10); // 255
(4).toString(2);          // 100
```

## Парсинг из строки в число
```JavaScript
// ES5-функции:
parseInt('100');        // 100
parseInt('0xFF');       // 255
parseInt('0xFF', 10);   // 0
parseInt('100', 2);     // 4
// с '0b' и '0o' такое не прокатит! Даже если укажем базу
parseInt('0b100', 2);   // 0, ошибка!!!
parseInt('100', 2);     // 4, ок

Number('0b100');        // 4, тоже ок

parseFloat('0.123');

// В ES6 эти методы входят в Number:
// Работают они также
Number.parseInt(val, radix);
Number.parseFloat(val);
```

## Проверка на то, что перед нами число и оно конечно
```JavaScript
var value = /*whatever*/;
Number.isFinite(value); // true if value is not ±Infinity or NaN
Number.isFinite('123'); // false, строку не приводит
isFinite('123'); // true, глобальная функция приводит
```

## Проверка на NaN
```JavaScript
let x = NaN;

x === NaN;       // false, NaN не равен даже самому себе
x !== x;         // true, но выглядит уебищно
Number.isNaN(x); // true, that's it!

Number.isNaN('???'); // false, строки не приводит
isNaN('???');        // true, строки приводит
```

## Number.EPSILON
```JavaScript
0.1 + 0.2 === 0.3; // false, ошибка округления
Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON; // true, вот так канонично
```

## Проверка на целое число
`Number.isInteger(value)` вернет `true`, если перед нами число (не строка) 
и оно не имеет дробной части:
```JavaScript
Number.isInteger(123);      // true
Number.isInteger(-123);     // true
Number.isInteger('123');    // false
Number.isInteger(123.1);    // false
Number.isInteger(NaN);      // false
Number.isInteger(Infinity); // false
```

## Безопасные целые
Если число больше максимума, то оно уже будет точно верным
```JavaScript
Number.isSafeInteger(number); // true если -2^53 < number < 2^53
Number.MIN_SAFE_INTEGER; // 2^53
Number.MAX_SAFE_INTEGER; // -2^53

console.log(9007199254740993); // 9007199254740992, внимание на последнюю цифру
```

## Math
Новые ES6-методы:
```JavaScript
Math.sign(x); // вернет 1, -1 или NaN

Math.trunc(value); // отсекает дробную часть, возвращает целое
Math.trunc(3.9); // 3
Math.trunc(-3.9); // -3

Math.cbrt(8); // 2, кубический корень

// еще много всего: логарифмы, тригонометрия etc.
```










# Строки
Новые строки обозначаются обратными кавычками.  

## Новые методы объекта String
Работают и для старых строк
```JavaScript
'hello'.startsWith('hell'); // true
'hello'.endsWith('ello'); // true
'hello'.includes('ell'); // true
'doo '.repeat(3); // 'doo doo doo '
```


## Значения внутри строки
```JavaScript
// Значения переменных
// внимание на обратные кавычки
var x = 1, y = 2;
'('+x+', '+y+')' // es5
`(${x}, ${y})` // es6
`(${x + 1}, ${y})` // es6, можно туда в принципе любой код втыкать

// Символы юникода, можно и с обычными кавычками
console.log('\uD83D\uDE80'); // es5: two code units
console.log('\u{1F680}');    // es6: single code point
```

## Multiline
```JavaScript
var es5multiline1 = 'lala' +
                    'bebe';
var es5multiline2 = 'lala\
                     bebe';

var es6multiline = `lala
                    bebe`;
```

## Без экранирования
```JavaScript
let raw = String.raw`Not a newline: \n`; // 'Not a newline: \\n'
```

## Итерабельность
Обращаем внимание, что кавычки - старые
```JavaScript
// Вот так - обойдет посимвольно 3 символа
for (let ch of 'abc')

// Вот так - тоже 3 символа
for (let ch of 'x\uD83D\uDE80y')

// А с помощью троеточия делаем массив
let chars = [...'abc']; // ['a', 'b', 'c']
// Можно быстро посчитать длину строки
[...'x\uD83D\uDE80y'].length; // 3

// Или реверснуть строку - полезно с двухсимвольными юникодами
[...'x\uD83D\uDE80y'].reverse().join(''); // order of \uD83D\uDE80 is preserved
// Работает только с non-BMP, проблемы с combining marks
```

## Работа с юникодовыми wideчарами
```JavaScript
// TODO: описать
'x\uD83D\uDE80y'.codePointAt(0).toString(16);
String.fromCodePoint(0x78, 0x1f680, 0x79) === 'x\uD83D\uDE80y'

// Еще вот такой есть:
String.prototype.normalize(form? : string) : string
```




# Регулярки
http://xregexp.com/ - это отдельная либа
```JavaScript
var parts = '/2012/10/Page.html'.match(XRegExp.rx`
    ^ # match at start of string only
    / (?<year> [^/]+ ) # capture top dir name as year
    / (?<month> [^/]+ ) # capture subdir name as month
    / (?<title> [^/]+ ) # capture base name as title
    \.html? $ # .htm or .html file ext at end of path
`);
console.log(parts.year); // 2012
```






# Symbol - новый примитивный тип
TODO: http://exploringjs.com/es6/ch_symbols.html





# Оператор многоточия
## Аргумент функции в объявлении
Означает "все остальное, что попало в скобки при вызове".
```JavaScript
function logAllArguments(arg1, ...args)
```

## Аргумент функции при вызове
Разворачивает массив в аргументы через запятую.  
Помогает избавиться от `apply`.
```JavaScript
function fn(arg1, arg2) {/*some code*/};
let arr = [1, 2];
fn(...arr); // тут мы как будто передали через запятую
```

## Конкатенация массивов
```JavaScript
let arr1 = ['a', 'b'];
let arr2 = ['c'];
let arr3 = ['d', 'e'];

console.log([...arr1, ...arr2, ...arr3]);
    // [ 'a', 'b', 'c', 'd', 'e' ]
```







# Функции
## Параметры по умолчанию (как в плюсах)
```JavaScript
function foo(x=0, y=0)
```

## Именованные параметры (как в питоне)
```JavaScript
function selectEntries({ start=0, end=-1, step=1 }) // TODO
```





# Arrow functions
```JavaScript
let arr = [1, 2, 3];
// es5 style
arr.map(function(x) {
    return x * x;
});

// es6 style
arr.map(x => x * x);
```
А еще они не переделывают `this`: он остается каким был при вызове.  





# Destructuring
Паттерн деструктурирования может быть 3 видов:
 1. Assignment target. `x`
 2. Object pattern. `{ first: «pattern», last: «pattern» }`
 3. Array pattern. `[ «pattern», «pattern» ]`
Да-да, их можно вкладывать друг в друга:
```JavaScript
let obj = { a: [{ foo: 123, bar: 'abc' }, {}], b: true };
let { a: [{foo: f}] } = obj; // f = 123
```

А также можно и так:
```JavaScript
let {length : len} = 'abc'; // len = 3
let {toString: s} = 123; // s = Number.prototype.toString
```

А если у нас не будет найдено нужное свойство, то будет `undefined`:
```JavaScript
let [x] = []; // x = undefined
let {prop:y} = {}; // y = undefined
```

Можно подставлять дефолтные значения:
```JavaScript
let [x=3, y] = []; // x = 3; y = undefined
let {foo: x=3, bar: y} = {}; // x = 3; y = undefined

// Можно даже какой-нибудь вызов функции например
let {prop: y=someFunc()} = someValue;

// Аккуратно! Если свойство есть, только оно undefined - то дефолт.
let [x=1] = [undefined]; // x = 1
let {prop: y=2} = {prop: undefined}; // y = 2

// Были рассмотрены дефолтные значения для переменных (тип 1)
// Рассмотрим же для типов 2 и 3:
let [{ prop: x } = {}] = []; // Все работает!
```
Главное, не забывать что тут все _nesting_, и деструктурирование идет по шагам.

А вообще с левую часть можно запихивать не только примитивные переменные:
```JavaScript
// Пример 1
let obj = {};
let arr = [];

({ foo: obj.prop, bar: arr[0] }) = { foo: 123, bar: true };

console.log(obj); // {prop:123}
console.log(arr); // [true]

// Пример 2
let obj = {};
[first, ...obj.rest] = ['a', 'b', 'c'];
    // first = 'a'; obj.rest = ['b', 'c']
```

Можно делать как в питоне:
```JavaScript
[a, b] = [b, a];
```
А можно как в лиспе:
```JavaScript
let [first, ...rest] = ['a', 'b', 'c']; // first = 'a'; rest = ['b', 'c']
// только хвост не изымается, пидр
```


## Массив
```JavaScript
let [ , v1, v2] = 'orange fruit dragon'.split();
```

Обход массива, учитываем индексы:
```JavaScript
let arr1 = ['a', 'b'];
for (let [index, element] of arr1.entries()) {}
```

Можно пропускать ненужное:
```JavaScript
let arr1 = ['a', 'b', 'c'];
let [,,z] = arr1; // z = 'c'
```

Оператор многоточия работает:
```JavaScript
let [x, ...y] = 'abc'; // x='a'; y=['b', 'c']
let [x, y, ...z] = 'a'; // x='a'; y=undefined, z = []

// Классный пример:
let [x, ...[y, z]] = ['a', 'b', 'c']; // x = 'a'; y = 'b'; z = 'c'
// Оператор многоточия работает следующим образом:
// [y, z] = ['b', 'c']
```

Не забываем, что итератор в стрингах работает с 21-разрядными _code points_,
а не с 16-разрядными юникодами:
```JavaScript
let [x,y,z] = 'a\uD83D\uDCA9c'; // x='a'; y='\uD83D\uDCA9'; z='c'
```

Деструктурироване работает и для _Set_. Итератор возвращает элементы в том 
порядке, в котором они были внесены.
```JavaScript
let [x,y] = new Set(['a', 'b']); // x='a'; y='b’;
```

Если мы придумаем такой генератор (возвращает по очереди натуральные числа), 
то и тут все будет работать:
```JavaScript
function* allNaturalNumbers() {
  for (let n = 0; ; n++) {
    yield n;
  }
}

let [x, y, z] = allNaturalNumbers(); // x=0; y=1; z=2
```

Фейл нас ждет, если мы попытаемся деструктурировать в массив что-то
неитерабельное:
```JavaScript
let x;
[x] = [true, false]; // OK, Arrays are iterable
[x] = 'abc'; // OK, strings are iterable
[x] = { * [Symbol.iterator]() { yield 1 } }; // OK, iterable

[x] = {}; // TypeError, empty objects are not iterable
[x] = undefined; // TypeError, not iterable
[x] = null; // TypeError, not iterable
```
Таким образом мы можем проверять _нечто_ на итерабельность:
```JavaScript
[] = {}; // TypeError, empty objects are not iterable
[] = undefined; // TypeError, not iterable
[] = null; // TypeError, not iterable
```




## Объект
```JavaScript
let {writable, configurable} = Object.getOwnPropertyDescriptor(obj, 'foo');

// Делаем именно так:
let obj = { first: 'Jane', last: 'Doe' };
let { last, first } = obj; // first = 'Jane', last = 'Doe'
let { last } = obj; // last = 'Doe'
let { first: f, last: l } = obj; // f = 'Jane', l = 'Doe'

// Вот еще пример:
let arr2 = [
    {name: 'Jane', age: 41},
    {name: 'John', age: 40},
];
for (let {name: n, age: a} of arr2) {
    console.log(n, a);
}
```

Аккуратнее с типами:
```JavaScript
let { prop: x } = undefined; // TypeError
let { prop: y } = null; // TypeError

// В следующих выражениях заворачивание в скобки обязательно, 
// ибо в жс нельзя начинать выражение с фигурных скобок
({} = [true, false]); // OK, Arrays are coercible to objects
({} = 'abc'); // OK, strings are coercible to objects

({} = undefined); // TypeError
({} = null); // TypeError
```

Если название свойства заранее неизвестно - не беда:
```JavaScript
const FOO = 'foo';
// вместо [FOO] подставится foo
let { [FOO]: f } = { foo: 123 }; // f = 123
```
Можно и с символами замутить


## Возможные ошибки
**Нельзя** смешивать в одном выражении объявление переменных и не-объявление:
```JavaScript
// Здесь интерпретатор ломается: мы f объявили, а b - нет. Так нельзя
let f;
let { foo: f, bar: b } = someObject;
    // SyntaxError: Duplicate declaration, f

// Ошибки нет, обе переменные уже объявлены, можно присваивать
let f;
let b;
({ foo: f, bar: b }) = someObject;

```






# Классы
Классы **не hoisted**! Это связано с тем, что наследование определено как
выражения.

```JavaScript
class Person {
    constructor(name) {
        this.name = name;
    }
    someMethod() {
        return 'Person called '+this.name;
    }
}
```

## Наследование
```JavaScript
class Employee extends Person {
    constructor(name, title) {
        super(name);
        this.title = title;
    }
    someMethod() {
        return super.describe() + ' (' + this.title + ')';
    }
}
```

### Наследование от `Error`
```JavaScript
class MyError extends Error {
}
```

## Определение методов
```JavaScript
// Было
var obj = {
    foo: function () { ··· },
    bar: function () { this.foo(); }, 
}

// Стало
let obj = {
    foo() { ··· },
    bar() { this.foo(); },
}
```





# Контейнеры
## Map
Ключом может быть не обязательно строка, любое значение.
```JavaScript
let map = new Map();
map.get(key);
map.set(key, 1);
```





# Модули
## Вариант 1
```JavaScript
//------ lib.js ------
export const sqrt = Math.sqrt;
export function square(x) { return x * x; }
export function diag(x, y) { return sqrt(square(x) + square(y)); }

//------ main1.js ------
import { square, diag } from 'lib';

//------ main2.js ------
import * as lib from 'lib'; // (A)
console.log(lib.square(11)); // 121
```

## Вариант 2
```JavaScript
//------ myFunc.js ------
export default function () { ··· } // no semicolon!

//------ main1.js ------
import myFunc from 'myFunc';
myFunc();
```