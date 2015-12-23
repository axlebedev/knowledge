http://exploringjs.com/es6
Остановился: 18

TODO: разобраться, как работают _code points_ и как различать от юникодов  
TODO: хорошие советы по code style: 12.7 http://exploringjs.com/es6/ch_parameter-handling.html  
TODO: хорошие советы по code style: 13.2 http://exploringjs.com/es6/ch_callables.html  

# let, const
**Объявления `let` и `const` не возносятся наверх, как `var`.**  
Это не совсем точно: на самом деле когда мы входим в блок, то память под эти
переменные выделяется. Но при попытке обратиться к ним до определения мы
словим _ReferenceError_.

## let
`let` - это как `var`, только с блочной видимостью.  
Блок - как в плюсах - любая пара фигурных скобок.  

## const
Обращаем внимание, что даже когда объект константен - 
ссылки внутри него не константны.
```JavaScript
const obj = {};
obj.prop = 123;
console.log(obj.prop); // 123, сработало, в сам obj мы больше ничего не присвоим, а его свойствам можно

obj = Object.freeze(obj); // теперь и внутри объекта нихренашеньки не поменять
```

## Поведение в циклах
`var`: для функций внутри цикла это будет одна и та же переменная
(вспоминаем задачу о shooter)
```JavaScript
for (var i=0; i < 3; i++)
```

`let`: каждую итерацию создается новая переменная
```JavaScript
for (let i=0; i < 3; i++)
```

`const` работает как var, но нам в данном случае похуй

## Параметры функции
```JavaScript
function func1(arg) {
    let arg; // static error: duplicate declaration of `arg`
    // потому что arg в параметре компилируется в let arg в начале тела функции
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
TODO: уточнить, что имеется в виду
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
















# Объекты
В литерале добавился способ объявления функций:
```JavaScript
//es5
let obj1 = {
    var myMethod = function(x, y) { ··· };
};

//es6
let obj2 = {
    myMethod(x, y) { ··· }
};
```

Литерал можно объявлять сокращенно:
```JavaScript
let first = 'Jane';
let last = 'Doe';

let obj = { first, last }; // es6 syntax
// Same as es5:
let obj = { first: first, last: last };
```

Вычислять название ключа динамически, с помощью квадратных скобок.
Основное применение - когда используем `Symbol`
```JavaScript
let propKey = 'foo';
let obj = {
    [propKey]: true,
    ['b'+'ar']: 123,
    ['h'+'ello']() {
        return 'hi';
    }
};

// пример с Symbol
let obj = {
    * [Symbol.iterator]() { // (A)
        yield 'hello';
        yield 'world';
    }
};
for (let x of obj) {
    console.log(x);
}
// Output:
// hello
// world
```

## Object.assign
Раньше его называли `extend()`. Прикол в том, что к существующему объекту 
добавляются свойства из другого объекта 
(только own properties, на унаследованные похуй)
```JavaScript
let obj = { foo: 123 };
Object.assign(obj, { bar: true });
console.log(JSON.stringify(obj)); // {"foo":123,"bar":true}
```
Можно вызывать как `Object.assign(target, source1, source2 ...)`, тогда 
обрабатываться они будут по очереди.

`Object.assign` обрабатывает только те свойства, 
которые _enumerable_ **и** _own_. Если какое-то свойство - сеттер, то он будет
вызван с соотв. значением. Нельзя использовать метод, которые использует `super`

Пример использования: дефолтные значения
```JavaScript
let DEFAULTS = { /*some object*/ };
function processContent(options) {
    options = Object.assign({}, DEFAULTS, options); // (A)
}
```
Можно еще клонировать объект, но это грязный метод, лучше не увлекаться.

## Геттеры-сеттеры
```JavaScript
let obj = {
    get foo() {
        console.log('GET foo');
        return 123;
    },
    set bar(value) {
        console.log('SET bar to '+value);
        // return value is ignored
    }
};
```
Используется следующим образом:
```JavaScript
> obj.foo
GET foo
123
> obj.bar = true
SET bar to true
true
```

## Получить свойства объекта
 - `Object.keys(obj) : Array<string>`
   all _string-valued_ keys of all _enumerable_ _own_ (non-inherited) properties.
 - `Object.getOwnPropertyNames(obj) : Array<string>`
   all _string-valued_ keys of all _own_ properties.
 - `Object.getOwnPropertySymbols(obj) : Array<symbol>`
   all _symbol-valued_ keys of all _own_ properties.
 - `Reflect.ownKeys(obj) : Array<string|symbol>`
   all keys of all _own_ properties.
 - `Reflect.enumerate(obj) : Iterator`
   all _string-valued_ keys of all _enumerable_ properties

Порядок итерирования следующий:
 1. Индексы массива
 2. _String-valued_ keys
 3. _Symbol-valued_ keys
Кроме `Map` и `Set`, там в порядке добавления.


## Object.is
Служит для сравнения двух объектов, причем:
```JavaScript
NaN === NaN;         // false
Object.is(NaN, NaN); // true

+0 === -0;         // true
Object.is(+0, -0); // false
```
Все остальные случаи работают как `===`.

## Работа с прототипом объекта
`__proto__` немного переделан (в геттер-сеттер? TODO), но не надо его юзать.
```JavaScript
var p = Object.getPrototypeOf(obj);
var obj = Object.create(p);
Object.setPrototypeOf(obj, proto)
```

## Работа со свойствами
Присвоение нового свойства `obj.newProperty = 123;` не сработает в след. случаях:
 1. Read-only свойство с таким же именем уже есть в цепочке прототипов
 2. Есть сеттер с таким именем. Тогда будет вызван он.
 3. Есть геттер с таким именем (сеттера нет).

В случаях 1 и 3 будет `TypeError`.  
Поможет `Object.defineProperty` (см. js_summary.md): он создает (или апдейтит)
_own_ свойство, полностью игноря цепочку прототипов.








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
// es5-функции:
parseInt('100');        // 100
parseInt('0xFF');       // 255
parseInt('0xFF', 10);   // 0
parseInt('100', 2);     // 4
// с '0b' и '0o' такое не прокатит! Даже если укажем базу
parseInt('0b100', 2);   // 0, ошибка!!!
parseInt('100', 2);     // 4, ок

// можно для этого использовать конструктор Number
Number('0b100');        // 4, тоже ок

parseFloat('0.123');

// В es6 эти методы входят в Number, работают они также
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
isNaN('???');    // true, строки приводит

Number.isNaN(x);     // true, that's it!
Number.isNaN('???'); // false, строки не приводит
```

## Number.EPSILON
Нужен, чтобы избегать ошибок округления. Обычный математический эпсилон.
```JavaScript
0.1 + 0.2 === 0.3; // false, ошибка округления
Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON; // true, вот так канонично
```

## Проверка на целое число
`Number.isInteger(value)` вернет `true`, если перед нами конечное число (не строка) 
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
Если число больше максимума ( _2^53_ ), то оно уже будет точно верным
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
Значения переменных, внимание на обратные кавычки:
```JavaScript
var x = 1, y = 2;
'('+x+', '+y+')' // es5
`(${x}, ${y})` // es6
`(${x + 1}, ${y})` // es6, можно туда в принципе любой код втыкать
```

Символы юникода, можно и с обычными кавычками:
```JavaScript
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
TODO: разобраться с юникодами, BMP и прочей строковой херотой

## Работа с юникодовыми wideчарами
// TODO: описать, что эти методы делают
```JavaScript
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












# Функции
## this в es5
Rules for this:  
 - _Function calls:_ `this` is undefined in strict mode and the global object in sloppy mode.
 - _Method calls:_ `this` is the receiver of the method call (or the first argument of call/apply).
 - _Constructor calls:_ `this` is the newly created instance.

## Параметры по умолчанию (как в плюсах)
```JavaScript
function foo(x=0, y=0)
```
Под капотом будет выглядеть так:
```JavaScript
function logSum(x=0, y=0) {
    console.log(x + y);
}
// becomes:
{
    let [x=0, y=0] = [7, 8];
    {
        console.log(x + y);
    }
}
```
**Warning!** если мы передаем `undefined`, то подставится дефолтное.

Можно делать так, чтобы одни параметры зависели от других (важен порядок):
```JavaScript
function foo(x=0, y=x)
// но:

function foo(x=y, y=0) 
// не сработает, потому что мы сначала используем 'y', потом его объявляем
```
Можно даже делать их зависимыми от внешних переменных (от тех что внутри 
функции - конечно же нельзя):
```JavaScript
let superVariable;
function foo(x=superVariable)
```

## Именованные параметры (почти как в питоне)
TODO: рассмотреть поподробнее комментарий в коде ниже
```JavaScript
function selectEntries({ start=0, end=-1, step=1 } = {}) {
    // The object pattern is an abbreviation of:
    // { start: start=0, end: end=-1, step: step=1 }
}

selectEntries({ start: 10, end: 30, step: 2 });
selectEntries({ step: 3 });
selectEntries({});
selectEntries();
```

## Троеточие в параметрах
```JavaScript
function format(unuseful, ...params) {
    return params;
}
console.log(format('a', 'b', 'c')); // ['b', 'c']
console.log(format('a')); // []
```

Так что теперь **не используем `arguments`**. Профит в том, что в новом методе
`args` - всегда _Array_:
```JavaScript
// Было в es5:
function format() {
    for(var i = 0; i < arguments.length; ++i) {...}
    // arguments - это не Array!!
}
// Стало es6:
function format(...args) {
    for(var i = 0; i < args.length; ++i) {...}
    // args - это Array :)
}
```
А аргументы по умолчанию с таким подходом делаем руками:
```JavaScript
// Было в es5:
function format(x = 0, y = 0) {
    for(var i = 0; i < arguments.length; ++i) {...}
}
// Стало es6:
function format(...args) {
    let [x = 0, y = 0] = args;
    for(var i = 0; i < args.length; ++i) {...}
}
```

А вообще `arguments` теперь итерабелен, со всеми плюшками (`for of` и многоточие)

## Троеточие в вызове
Разворачивает массив в перечисление параметров:
```JavaScript
Math.max(-1, ...[-1, 5, 11], 3); // 11
// Все равно что Math.max(-1, -1, 5, 11, 3); 
```






# Arrow functions
## Синтаксиc
Входные параметры могут быть следующего вида:
 - `() => { ... }` - функция без параметров
 - `x => { ... }` или  `(x) => { ... }` - функция с одним параметром-идентификатором
 - `(x=0) => { ... }` - функция с одним параметром с дефолтным значением, скобки обязательны
 - `([x, y]) => { ... }` - функция с одним деструктурированным параметром, скобки обязательны
 - `(x, y) => { ... }` - функция с несколькими параметрами
Тело функции может выглядеть так:
 - `x => { return x * x; }` или `x => x * x` - тело состоит из одного оператора
 - `x => { throw x; }` - если тело состоит из даже одного _statement_, фиг.скобки нужны
   _statement_ отличается от _expression_ тем, что не производит значения (это грубо говоря)
 - `x => { x *= 2; return x * x}` - в теле больше одного оператора
 - `x => ({ value: 2 })` - возвращает objrct-literal, скобки обязательны
   (иначе `value` будет _label_ для `continue` и `break`, работает типа как _goto_)

```JavaScript
let arr = [1, 2, 3];
// es5 style
arr.map(function(x) {
    return x * x;
});

// es6 style
arr.map(x => x * x);
```

В составе выражений такие функции надо заворачивать в скобки:
```JavaScript
console.log(typeof () => {}); // SyntaxError
console.log(typeof (() => {})); // OK
```

## Что берется из окружающего блока (lexical):
 - `arguments`
 - `super`
 - `this`
 - `new.target`

## Правила для `this`:
 - _Function calls:_ lexical `this` etc.
 - _Method calls:_ You can use arrow functions as methods, but their `this` 
   continues to be lexical and does not refer to the receiver of a method call.
 - _Constructor calls:_ produce a `TypeError`.









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
Главное, не забывать что тут все _nesting_, и деструктурирование идет по шагам.

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


## Destructuring массива
```JavaScript
let [v0, v1, v2] = 'orange fruit dragon'.split();
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




## Destructuring объекта
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
// вычисляемое название свойства: вместо [FOO] подставится foo
let { [FOO]: f } = { foo: 123 }; // f = 123
```
Можно и с `Symbol`'ами замутить


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

// Ошибки нет, обе переменные не объявлены, можно объявлять и присваивать
({ foo: f, bar: b }) = someObject;
```






# Классы
```JavaScript
class Person { // (1) (2)
    constructor(name) { // (3) (8)
        this.name = name;
    }

    someMethod() {
        return 'Person called '+this.name;
    }

    someMethod() { // уже был такой метод (7)
        // Error!!!
    }

    set anotherName(value) { (5)
        this.name = name;
    }

    [name+'Method']() {
        return 'computedMethod';
    }

    static anotherMethod() { // (6)
        return 'another method called';
    }

    static get ZERO() { // (5) (6)
        return 'ZERO';
    }
}

let inst = new Person('ololo');
let err = Person('ololo'); // без new нельзя (9)
let err = new Person.prototype.someMethod(); // метод как конструктор нельзя (9)
inst.someMethod(); // 'Person called ololo' 
inst.ololoMethod(); // 'computedMethod'
inst.anotherName = 'cococo'; // (5)

Person.anotherMethod(); // 'another method called' (6)
Person.ZERO; // 'ZERO' (5) (6)
```
 1. На самом деле `typeof Person` будет `function`, но вызвать его как функцию мы
    не сможем (_TypeError_), только через `new`.  
 2. Классы **не hoisted**! Это связано с тем, что наследование разворачивается
    в много строк кода. Если попытаться обратиться к классу до его объявления - 
    получим _ReferenceError_.  
 3. Метод `constructor` - специальный, он становится равен самому классу:
    `Person.prototype.constructor === Person // true`  
 4. В конструкторах унаследованных классов перед любыми обращениями к `this`
    необходимо сначала вызвать `super`-конструктор.  
 5. Геттеры-сеттеры, к ним обращаемся без скобок, как к свойствам
 6. Можно статические методы, статические свойства нельзя (обходится с помощью
    статических гет-сет).
 7. Несколько раз объявить свойства класса с одним именем нельзя.
 8. Метод `constructor` не может быть генератором или гет-сеттером.
 9. Класс не может быть вызван как функция, а метод не может быть вызван как
    конструктор.

В отличие от литералов (у них функции enumerable-ные):
Статические свойства, свойства прототипа: `writable` и `configurable`, но не `enumerable`.
`constructor` и `prototype`: не `writable`, не `configurable`, не `enumerable`.



## Наследование
Super-method calls: `super.method('abc')` в объявлении методов и конструктора.  
Super-constructor calls: `super(8)` в объявлении конструктора класса.

```JavaScript
class Employee extends Person {
    constructor(name, title) {
        this.someMethod(); // Error! (1)
        super(name);
        // Only available inside the special method constructor() inside a derived class definition.
    }
    someMethod() {
        return super.method();
        // 'super.method()' : only available within method definitions 
        // inside either object literals or derived class definitions.
    }
}
```
 1. Любое (прямое или косвенное) использование `this` в конструкторе должно
    быть **после** `super()` (вызова конструктора родителя).
 2. Дважды использовать `super` вызовет _ReferenceError_. 
 3. Если мы не вызвали `super` или не инициализировали `this`, то _ReferenceError_.
    (это если мы возвращаем неявно, `return` в коде нет).
 4. Если мы возвращаем не-объект, вернется `this`. Если он не проинициализирован,
    будет _TypeError_.

Для того, чтобы `super` работал как надо, в объекте должно быть 
`property [[HomeObject]]`. Вообще использовать `super` можно везде, где есть 
_prototype_, будь то объявление класса или литерал.
Методы мы можем вызывать отдельно от класса
(тут все как в es5, `this` не валиден. `super`-методы отработают как надо).
Если мы вызовем метод класса как конструктор, то вывалится `TypeError`.

### Наследование от встроенных классов
Можно.
TODO: `new.target` 16.4.2
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
Обращаем внимание, что если у нас литерал, то после методов ставится запятая,
а если класс - нет.






# Оператор многоточия
## В массивах
Разворачивает итерабельное что-нибудь в элементы массива
```JavaScript
[1, ...[2,3], 4]; // [1, 2, 3, 4]
```

## Аргумент функции в объявлении
Означает "все остальное, что попало в скобки при вызове".
```JavaScript
function logAllArguments(arg1, ...args) { /*some code*/ }
logAllArguments(1, 2, 3, 4) // arg1 = 1, args = [2, 3, 4]
```

## Аргумент функции при вызове
Разворачивает массив в аргументы через запятую.  
Помогает избавиться от `apply`.
```JavaScript
function fn(arg1, arg2) {/*some code*/};
let arr = [1, 2];
fn(...arr); // тут мы как будто сделали fn(1, 2)
```

## Конкатенация массивов
```JavaScript
let arr1 = ['a', 'b'];
let arr2 = ['c'];
let arr3 = ['d', 'e'];

console.log([...arr1, ...arr2, ...arr3]);
    // [ 'a', 'b', 'c', 'd', 'e' ]
```

## Приведение итерабельного _чего-нибудь_ к массиву
```JavaScript
let set = new Set([11, -1, 6]);
let arr = [...set]; // [11, -1, 6]
```
Вообще есть способ получше (_Array.from_), в главе про массивы





# Итерабельность и итераторы
TODO
**Iterable** - структура данных, в которой определен метод с ключом 
`Symbol.iterator` для получения данных.
**Iterator** - указатель для прохода по элементам. Возвращает объекты через
метод `next()`.
```JavaScript
let arr = ['a', 'b', 'c'];
let iter = arr[Symbol.iterator]();

iter.next(); // { value: 'a', done: false }
iter.next(); // { value: 'b', done: false }
iter.next(); // { value: 'c', done: false }
iter.next(); // { value: undefined, done: true }
```
Объекты, которые созданы через литерал - не итерабельны.  





# Генераторы
Выглядят, как указатели на функцию:
```JavaScript
// Generator function expression:
const foo = function* (x) { ··· };
// Function declaration:
function* foo(x) { ··· }
```

## this в генераторах
 - _Function/method calls:_ `this` is handled like it is with traditional 
functions. The results of such calls are generator objects.  
 - _Constructor calls:_ Accessing `this` inside a generator function causes 
a `ReferenceError`. The result of a constructor call is a generator object.





# Контейнеры

## Массивы
Что-то итерабельное можно привести к массиву с помощью `...`:
```JavaScript
let map = new Map().set(false, 'no').set(true, 'yes');
[...map.keys()]; // [ false, true ]
[...map]; // [ [ false, 'no' ], [ true, 'yes' ] ]
```

### for..of
```JavaScript
var arr = ['a', 'b', 'c'];
// можно получать элемент:
for (let elem of arr)
// а можно элемент с индексом:
for (let [index, elem] of arr.entries())
```

### Array.from
Приводит _что-то_ к массиву. _Что-то_ либо итерабельно, либо оно должно
иметь проиндексированные элементы и `length`.
```JavaScript
let arrayLike = {
    '0': 'a',
    '1': 'b',
    '2': 'c',
    length: 3
};

// es5:
var arr1 = [].slice.call(arrayLike); // ['a', 'b', 'c']

// es6:
let arr2 = Array.from(arrayLike); // ['a', 'b', 'c']

// TypeError: Cannot spread non-iterable object.
let arr3 = [...arrayLike];
```
**Бонус**: если вторым аргументом подать какую-нибудь функцию,
то сделает **map**:
```JavaScript
let arr2 = Array.from(arrayLike, ch => ch.toUpperCase()); // ['A', 'B', 'C']
```
Еще пара бонусов:
```JavaScript
Array.from([0,,2]); // [ 0, undefined, 2 ]
Array.from(new Array(5), () => 'a'); // [ 'a', 'a', 'a', 'a', 'a' ]
Array.from(new Array(5), (x,i) => i); // [ 0, 1, 2, 3, 4 ]
```

### Array.of
Создает новый массив:
```JavaScript
Array.of(item_0, item_1, ···)
// или то же самое:
new Array(item_0, item_1, ···)
```
Позволяет избежать ошибок, когда мы передаем всего один параметр в `new Array`.
Также помогает, когда мы наследуем `Array` и передаем в конструктор какие-то
нужные штуки.

### Итерирование по массиву
 - `keys()`
 - `values()`
 - `entries()`
```JavaScript
Array.from(['a', 'b'].keys()); // [ 0, 1 ]
Array.from(['a', 'b'].values()); // [ 'a', 'b' ]
Array.from(['a', 'b'].entries()); // [ [ 0, 'a' ], [ 1, 'b' ] ]

for (let [index, elem] of ['a', 'b'].entries()) {···}
```

### Поиск в массиве
`predicate = function(element, index, array)`  
`find(predicate, thisArg?)` - возвращает первый элемент, для которого predicate
вернул `true`.  
`undefined` если не найдено.
```JavaScript
[6, -5, 8].find(x => x < 0); // -5
[6, 5, 8].find(x => x < 0); // undefined
```

`Array.prototype.findIndex(predicate, thisArg?)` - возвращает индекс первого
элемента с true предикатом.  
`-1` если не найдено.  
Пустые элементы воспринимает как `undefined`.
```JavaScript
[6, -5, 8].findIndex(x => x < 0); // 1
[6, 5, 8].findIndex(x => x < 0); // -1
```

### Другие методы
 - `Array.prototype.copyWithin(target : number, start : number, end = this.length) : This`
Копирует элементы с индексами _[start,end)_ в индекс _target_.  
Если два range перекрываются, то предпочтение отдается источнику.  
Изменяет массив, на котором вызван.
```JavaScript
let arr = [0,1,2,3];
arr.copyWithin(2, 0, 2); // [ 0, 1, 0, 1 ]
arr; // [ 0, 1, 0, 1 ]
```

 - `Array.prototype.fill(value : any, start=0, end=this.length) : This`
Заполняет массив значениями по индексам _[start,end)_.  
Изменяет массив, на котором вызван.
```JavaScript
let arr = ['a', 'b', 'c'];
arr.fill(7); // [ 7, 7, 7 ]
arr; // [ 7, 7, 7 ]
new Array(3).fill(7); // [ 7, 7, 7 ]
['a', 'b', 'c'].fill(7, 1, 2); // [ 'a', 7, 'c' ]
```



## Map
Ключом может быть не обязательно строка, любое значение (даже объект).
```JavaScript
let map = new Map();
map.get(key);
map.set(key, 1); // изменяет map и возвращает его
map.delete(key); // если такой ключ есть - удаляет и возвращает true, иначе ничего не происходит и false
map.has(key);
map.size();
map.clear();
```

Для конструктора может быть любой итерируемый контейнер пар "ключ-значение":
```JavaScript
let map = new Map([
    [ 1, 'one' ],
    [ 2, 'two' ],
    [ 3, 'three' ], // trailing comma is ignored
]);
// аналогично:
let map = new Map()
    set( 1, 'one' ).
    set( 2, 'two' ).
    set( 3, 'three' );
```

### Как получается доступ по ключу
Так же, как и `===`, только `NaN` равен самому себе.
```JavaScript
NaN === NaN; // false
map.set(NaN, 123);
map.get(NaN); // 123, ok

+0 === -0; // true
map.set(+0, 123);
map.get(-0); // 123, ok

map.set(+0, 123);
map.get(-0); // 123, ok

// объекты сравниваются по адресу, даже два пустых объекта не равны
({}) === ({}); // false
map.set({}, 123).set({}, 456);
map.length(); // 2

//неизвестные значения возвращают undefined
map.get(unknownKey); // undefined
```

### Итерирование
 - `keys()`
 - `values()`
 - `entries()`
```JavaScript
for (let key of map.keys()) {···}

for (let value of map.values()) {···}

for (let [key, value] of map.entries()) {···}
```

### forEach
`Map.prototype.forEach((value, key, map) => void, thisArg?) : void`

В Map-ах нет `filter()` или `map()`. Обходится с помощью приведения мапа к массиву.  
Чтобы смержить два мапа, тоже приводим к массивам.  

### WeakMap
Не итерабелен.  
TODO
`WeakMap` не защищает ключи от сборки мусора (т.е. мы можем не беспокоиться
об утечках памяти).  
Ключи должны быть объектами. Методы те же, за исключением иторирования (нельзя
ни по ключам, ни по значениям. Clear тоже нельзя).

Может использоваться для хранения "приватных" данных (данные сохраняем не в 
объекте, а в мапе, по ключу объекта).



## Set
Множество. В конструктор можно подавать что угодно, лишь бы итерировалось.  
Если в конструктор подано более одного аргумента - остальные игнорятся.  
Доступ и сравнение ключей - как в Map.  
`for of` работает ок (перебирает в порядке добавления).  
Для фильтрации/маппинга приводим к массиву.
```JavaScript
let arr = [5, 1, 5, 7, 7, 5];
let set = new Set(arr); // [ 5, 1, 7 ]

set.add(key);
set.has(key);
set.delete(key); // если такой ключ есть - удаляет и возвращает true, иначе ничего не происходит и false
set.size();
set.clear();
```

### Операции над множеством
 1. Объединение: `let union = new Set([...set1, ...set2]);`
 2. Пересечение: `let intersection = new Set([...set1].filter(x => set2.has(x)));`
 3. Разность: `let intersection = new Set([...set1].filter(x => !set2.has(x)));`

### Итерирование
 - `entries()`
 - `keys()`

### WeakSet
Не итерабелен.  
Аналогично WeakMap.

## Typed Array
Нужны для оперирования бинарными данными.  
Бывают следующие типмассивы:
 - `Int8Array`
 - `Uint8Array`
 - `Uint8CArray` 
 - `Int16Array`
 - `Uint16Array` 
 - `Int32Array`
 - `Uint32Array` 
 - `Float32Array`	
 - `Float64Array`
`ArrayBuffer` служит для хранения данных, для представления - TypedArrays и DataViews.  
TODO.




 

# Модули
В верстке делается так:
```HTML
<script type="module">
```

## Вариант 1: именованные экспорты
```JavaScript
//------ lib.js ------
export const sqrt = Math.sqrt;
export function square(x) { return x * x; }

// а можно так
const MY_CONST = 123;
let add = (x, y) => x + y;
export { MY_CONST, add };
export { MY_CONST as CONST, add };

//------ main.js ------
import square from 'lib';
import { square, diag } from 'lib';
import { square as localSquare, diag } from 'lib';
import * as lib from 'lib';
import theDefault, { name1, name2 } from 'src/my_lib'; // вместо theDefault - любое удобное имя, 
// подставится дефолтное значение. В таком списке должно быть первым!
import { default as foo } // ага, default - это просто еще один идентификатор по большому счету
import 'lib'; //ничего не заимпортит, тупо выполнит lib
```

## Вариант 2: дефолтный экспорт
Функции/классы можно именовать, а можно и нет. Экспорт - единственное место,
где жс допускает _анонимные_ function/class declaration.
```JavaScript
//------ myFunc.js ------
export default function () { ··· } // no semicolon!
//или
export default class { ··· } // no semicolon!
//или
let foo = 123;
export { foo as default };

//------ main1.js ------
import myFunc from 'myFunc';
myFunc();
```

## Заметки про модули
 0. Надо быть аккуратнее с транспайлом модулей: какой-нибудь babel может облажаться.
 1. Top-level переменные в модуле не глобальны, а локальны для модуля.  
 2. Когда импортим - то расширение `.js` можно не писать.
 3. Все модули - синглтоны. Даже если мы вызвали модуль несколько раз из разных
    мест, выполнится он всего один раз.  
 4. На один `export` должен быть только один declaration или expression:
    вот так `export default const foo = 1, bar = 2, baz = 3;` нельзя!
 5. Imports are hoisted.
 6. Абсолютно всё (даже примитивы) в импортах передаются по ссылке. Но они read-only
 7. Циклические зависимости разрешены (_не рекомендовано_).
 8. Если мы делаем `export *`, то дефолтный экспорт игнорируется.
 9. Можно нагуглить лоадер модулей (чтобы например делать что-то на onload модуля),
    но это пока не вошло в стандарт. 17.5.1

## Чего нельзя
Нижеперечисленное делается с помощью нестандартных module loader API.
 1. Динамически вычислимое имя модуля.
 2. Импорт или нет в зависимости от выполнения к-л условий: импорт должен
    быть на top-level.
 3. Деструктуринг.

