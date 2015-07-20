# Шпаргалка по JS

<a name="Foo"/>

###Debug
Отсчет времени по метке:
```JavaScript
console.time('1') //начнет отсчет времени
console.timeEnd('1') //закончит отсчет времени и выведет в консоль
```
###Типы данных
####Арифметические операторы
Унарный `+` приводит к _Number_.
```JavaScript
var arg = /*что угодно*/;
+arg; //Number
+null; //0
+''; //0
+'123'; //123
+'+38'; //38
+'abc'; //NaN
+undefined //NaN
```
Бинарный `+` приводит к _Number_, если у обоих аргументов задан _valueOf_.  
Если нет (объект, массив...) - то приводит все к _String_ и делает конкатенацию.

Бинарные `-`, `*`, `/` приводят к _Number_.

Унарные `++` и `--` приводят к _Number_.

####Сравнение
`==` - сравнение с приведением типов.
`===` - строгое сравнение.

Если один из операндов - _Number_ или _Boolean_, то все приводится к числу,  
если _String_ - то все приводится к строке.  
_null_ и _undefined_ равны только друг другу (и самим себе).  
_NaN_ не равен вообще ничему.
```JavaScript
+0 === -0; //true
NaN == NaN; //false
null == undefined; //true
['x'] == 'x'; //true
true == 1; //true
```

Строки сравниваются по кодам символов. Чтобы сравнивать в алфавитном порядке,
юзаем `str.localeCompare`:
```JavaScript
'ёжик' < 'ящик'; //false
'ёжик'.localeCompare('ящик'); //-1, т.е. меньше
```

Объекты и массивы сравниваются не по содержимому, а на равенство указателей!
```JavaScript
var a = {};
a  == {};	// false
a === {};	// false
a  == a;	// true
a === a;	// true
```

Но если определены `valueOf` или `toString`, то нестрого сравнить можно:
```JavaScript
var num = {
    val: 5,
    valueOf: function() {return this.val;}
}
5 == num; //true
5 === num; //false


var str = {
    val: 'abc',
    toString: function() {return this.val;}
}
'abc' == str; //true
'abc' === str;//false

new Number(5)  == 5;// true
new Number(5) === 5;// false

(function(){
    this  == 5;	// true
    this === 5;	// false
}).call(5);
```

####Побитовые операторы
`&`, `|`, `^`, `>>`, `>>>`, `<<`, `~`

Все они работают с 32-разрядными signed int.
`>>>` - побитовый сдвиг вправо (дополняя слева нулями).  
`^` используется для округления числа до целого:
```JavaScript
12.345 ^ 0; // 12
```
С помощью `~` делается проверка на -1:
```JavaScript
(~num) //true if num != -1
```

####Логические операторы
`&&`, `||`, `!`

`&&` возвращает первый ложный операнд (или последний если все истинны).  
`||` возвращает первый истинный операнд (или последний если все ложны).  
С помощью `!` можно привести значение к _Boolean_:
```JavaScript
!!123; //true
```
**Приведение к _Boolean_**:  
`0`, `''`, `null`, `undefined`, `NaN` => false;  
`[]`, `{}` и все остальное => true

Выражение в _if, while, for_ приводится к _Boolean_.

####switch case
В _case_ сравнивает строго, т.е. через `===`

####typeof
`typeof(arg)` или `typeof arg`
```JavaScript
typeof(null); //object - это ошибка в языке
typeof []; //object
typeof {}; //object
```

####eval
Без `"use strict"` запускает код в текущей области видимости,  
с `"use strict"` - создается своя область видимости (внешние функции и
переменные читать/писать можно, внутри объявленные внутри и останутся).

####Boolean
Не надо создавать _Boolean_ как объект!
```JavaScript
var b1 = true;
if(b1)
    ok(); //тут все нормально
var b2 = new Boolean(false)
if(b2)
    ok(); //тут сработает, хотя мы инициализировали false. Потому что это объект.
```

####Number
Особые значения: `NaN` и `Infinity`.
```JavaScript
Что_угодно <арифм. оператор> NaN; //NaN
```

Проверка на _NaN_ и _Infinity_:
```JavaScript
isNaN(arg); //arg приводится к числу
isFinite(arg); //вернет true если arg != NaN или +-Infinity
```

_**String**_ to _**Number**_  
`parseInt(str)`, `parseFloat(str)` будут парсить строку с первого символа,
первый "неправильный" символ и все что за ним отбрасываются.  
Нестроковые аргументы приводятся к строке.
```JavaScript
parseInt(''); //NaN
parseInt('px12'); //NaN
parseInt('12px'); //12
parseFloat('12.3.4.54'); //12.3
```

**Округление**:
```JavaScript
arg.toFixed(n); //округлить arg до n знаков после запятой, n >= 0
//можно и с числовыми литералами (но не забываем что у них есть своя точка)
12.toFixed(2); //ошибка!
12.0.toFixed(2); //12.00
```

Очень аккуратно работаем с флоатами:
```JavaScript
.1 + .2; //0.30000000000000004
```

_Хитрый пример:_
```JavaScript
alert( 9999999999999999 ); // выведет 10000000000000000
```

####String
Символ на _n_-й позиции:
```JavaScript
strVar.charAt(n);
strVar[n];
```
```JavaScript
    "".charAt(0); //пустая строка
    ""[0]; //undefined
```

Многострочная строка: каждая линия оканчивается на `\`
```JavaScript
var ssstring = "lalala \
                bebebe";
```

Подстрока:  
`substring(start, end)`  
Если _start_ > _end_ то они меняются местами.  
Если _start_ < 0 то _start_ = 0, аналогично с _end_.

`substr(start [, length])`  
_start_ - как в _substring_.  
Вместо _end_ - _length_.

`slice(start [, end])`  
Как _substring_, но отрицательные агрументы будут
 считаться с конца (как в питоне)

###Функции
**Function declaration**
```JavaScript
function foo() { return 5; }
```
Такая функция будет объявлена до выполнения кода.

**Anonymous function expression**
```JavaScript
var foo = function() { return 5; }
```
А такая - только когда до неё дойдет (на самом деле до выполнения кода
будет объявлена _var foo = undefined_).

**Named function expression**
```JavaScript
var foo = function bar() { return 5; }
```
Из внешнего кода мы не сможем вызвать _bar()_, зато использовать изнутри
для рекурсивных вызовов.

**Как не надо объявлять** (еще один способ объявления)
```JavaScript
var sum = new Function('a,b', ' return a+b; ');
```
Первый параметр - аргументы, второй - тело.



Если функция ничего не возвращает, то вернется _undefined_.

_arguments_ лучше не изменять, потому что изменятся ли
именованные параметры от этого - хз, зависит от интерпретатора.
_'use strict'_ решает проблему - при изменении _arguments_ именованные параметры не меняются.

Как в питоне _f(arg1 = 1, arg3 = 4)_ нельзя, это обходится с помощью
_f(options)_, где _options = {arg1: 1, arg3: 4}_.

//TODO: https://javascriptweblog.wordpress.com/2010/07/06/function-declarations-vs-function-expressions/


#####Декораторы:
https://learn.javascript.ru/decorators
```JavaScript
function decorate(f) {
    //some code...
    return function() {
        return f.apply(this, arguments);
    }
}
function Func() {};
Func = decorate(Func);
```
Примеры использования: Проверка типов входных данных, проверка прав и т.д.

#####bind:
Позволяет привязать контекст (`this`) к функции, возвращает функцию:
`var wrapper = func.bind(context[, arg1, arg2...])` - _arg1_, _arg2_...
будут добавлены _перед_ явно переданными аргументами
```JavaScript
function f() {
    console.log(this);
}
var g = f.bind("Context");
f() //выведется 'Context'
```

В следующем примере мы сохраним _user_ как _this_, и его состояние на момент _setTimeout_:
```JavaScript
setTimeout(user.sayHi.bind(user), 1000);
```

**Частичное применение**  
Функция, которая вызывает другую функцию с какими-то дефолтными аргументами
```JavaScript
function mul(a,b) {return a*b;}; //перемножает два аргумента
var double = mul.bind(null, 2); //контекст = null, первый аргумент = 2
double(3); //вернет 6
```

**Каррирование**  
Функция, которая возвращает функцию. Строго говоря, возвращенная функция принимает только один аргумент, становятся возможны вызовы func(1)(2)(3)...  
Не путать с _частичным применением_!


_Форвардинг вызова_ - вызываем функцию через к-л декоратор
чтобы изнутри все выглядело будто нет никакого декоратора.
```JavaScript
var result = f.apply(this, arguments);
```

#####call:  
`func.call(object, arg1, arg2)` = _func(arg1, arg2)_ с явно указанным _this = object_.  
Возвращает результат вызова функции.
```JavaScript
var join = [].join; // скопируем ссылку на функцию в переменную
var argStr = join.call(arguments, ':'); //и вызовем ее для arguments
```

#####apply:  
`func.apply(object, [arg1, arg2])` это все равно что `func.call(object, arg1, arg2)`.  
Только передаются не отдельные аргументы, а массив аргументов.

###Области видимости
Задачка с циклом:
```JavaScript
for (var i = 0; i < 10; i++) {
    var shooter = function(cur) {
    	return function() { // функция-стрелок
      		alert( cur ); // выводит свой номер
    	};
    } (i);
    shooters.push(shooter);
}
```

###Массивы
```JavaScript
var arr1 = [10]; //Массив из одного элемента равного 10
var arr2 = new Array(10); //Массив из 10 элементов равных undefined
```

`pop()` - возвращает длину до попа.  
`shift()` - работает как pop_front.  
`push()` - возвращает полученную длину, может принимать несколько аргументов.  
`unshift()` - работает как push_front, возвращает полученную длину, может принимать несколько аргументов.

Для обхода массива не надо использовать _for in_! А то выведутся все свойства
не только по цифровым индексам.  
`arr.length` - номер наибольшего индекса + 1. Может быть слева
от оператора присваивания (только вот нахуя?).

`string.split(symbol, num)`
```JavaScript
"a,b,c,d".split(',', 2); // 'a', 'b'
"abcd".split(''); // 'a', 'b', 'c', 'd'
```

`join(sym)`
```JavaScript
[1, 2, 3].join('+'); // '1+2+3'
new Array(4).join("ля"); // ляляляля
```

`splice( start, deleteCount, [elem1[, elem2[, ...[, elemN]]]] )`
начиная с позиции `start` удалить `deleteCount` элементов, и туда же
вставить элементы `elem1, elem2...`  
`start` может быть и отрицательным - тогда отсчет начнется с конца.  
Вовращает массив из удаленных элементов.

`slice(begin, end)` возвращает участок массива от `begin` до `end`, не включая `end`.
Исходный массив при этом не меняется. Отрицательные аргументы можно.

`sort(function(a, b) {})` если функция не указана, то все элементы приводит
к строке и сравнивает в лексикографическом порядке.
```JavaScript
sort(function(a, b) {
	//Она должна возвращать:
	//Положительное значение, если a > b,
	//Отрицательное значение, если a < b,
	//Если равны — можно 0, но вообще — не важно
})
```

`reverse()`

`concat(param1, param2 ...)`: `param` может быть массивом,
тогда добавится не массив, а элементы из массива
```JavaScript
var arr = [1, 2];
var newArr = arr.concat([3, 4], 5); //[1, 2, 3, 4, 5]
```

`indexOf(searchElement[, fromIndex])`,
`lastIndexOf(searchElement[, fromIndex])` - используется строгое сравнение `===`

`Array.isArray(arr)` проверяет, а не массив ли это?

###Объекты
Всегда и везде передаются по ссылке!

В следующем коде будут два разных объекта. Например в первом есть метод `toString()`:
```JavaScript
var obj = {};
var obj = Object.create(null);
```

Проверка на существование поля, удаление поля:
```JavaScript
if('member' in person) func();//проверка на существование поля
delete obj.member;
obj.member; //undefined
```

Обход полей объекта: `for(key in obj)` при таком обходе сначала идут отсортированные числа, потом -
строки в порядке объявления. Если мы не хотим сортировать строки вида `'12'`
(числа) - то пишем их как `'+12'` - тогда они и сортироваться не будут, и прекрасно приводятся к числу.

**Приведение к строке и числу** реализуется переопределением методов
`valueOf()` и `toString()`. Они необязательно должны возвращать именно
_Number_ и _String_, любой примитив. Он потом будет приведен дополнительно.

**Геттеры и сеттеры**
```JavaScript
var user = {
  firstName: "Вася",
  surname: "Петров",
  get fullName() {
    return this.firstName + ' ' + this.surname;
  },
  set fullName(value) {
    var split = value.split(' ');
    this.firstName = split[0];
    this.surname = split[1];
  }
};
user.fullName //вернет "Вася Петров"
user.fullName = "Petya Ivanov" //все сработает
```

**Свойства объекта** (работает аналогично Q_PROPERTY)
```JavaScript
Object.defineProperty(obj, prop, descriptor)
```
Дескриптор — объект, который описывает поведение свойства.
В нём могут быть следующие поля:  
 * `value` — значение свойства, по умолчанию undefined.  
 * `writable` — значение свойства можно менять, если true. По умолчанию false.  
 * `configurable` — если true, то свойство можно удалять, а также менять его в дальнейшем при помощи новых вызовов defineProperty. По умолчанию false.  
 * `enumerable` — если true, то свойство будет участвовать в переборе for..in. По умолчанию false.  
 * `get` — функция, которая возвращает значение свойства. По умолчанию undefined. Вызывается как переменная-член без скобок справа от присваивания  
 * `set` — функция, которая записывает значение свойства. По умолчанию undefined. Вызывается как переменная-член без скобок слева от присваивания.  

Запрещено одновременно указывать значение `value` и функции `get`/`set`. Либо значение, либо функции для его чтения-записи, одно из двух.  
Также запрещено и не имеет смысла указывать `writable` при наличии `get`/`set`-функций  

**Статические члены**  
Имеем класс _Animal_. В нем можно делать статические члены:
```JavaScript
Animal.count = 0; //вот статическое свойство класса
Animal.setCount = function(n) {
    this.count = n;
} //доступ из статических методов к статическим полям через this.
```

**Методы объекта**  
 * `Object.defineProperties(obj, descriptors)`, `descriptors` - это {} пар prop-descriptor.
 * `Object.keys(obj)` - массив _enumerable_ свойств.
 * `Object.getOwnPropertyNames(obj)` - вернет вообще все свойства, даже не-_enumerable_
 * `Object.getOwnPropertyDescriptor(obj, prop)`
 * `Object.preventExtensions(obj)` - после этого новые свойства больше не добавить
 * `Object.isExtensible(obj)`
 * `Object.seal(obj)` - после этого свойства больше не добавить, не удалить, все становятся не-_configurable_
 * `Object.isSealed(obj)`
 * `Object.freeze(obj)` - как прошлый + запрет изменения, все свойства становятся не-_writable_
 * `Object.isFrozen(obj)`

**_this_ в методах объекта**  
Вызов `obj.method()` (объект-точка-метод-скобки)  
или `obj[method]()` (объект-метод в квадратных скобках-скобки)  
порождает значение специального типа _Reference Type_ (base-name-strict):  
 * _base_ — как раз объект,
 * _name_ — имя свойства,
 * _strict_ — вспомогательный флаг для передачи use strict.  
Без скобок (`obj.method`) просто получаем name и используем, без привязки к base
```JavaScript
user.hi(); // this - это user
(user.name == "Вася" ? user.hi : user.bye)(); // this - это хз что
```
**[[Class]]**  
Если написать:
`{}.toString.call(date)` - выведет `[object Date]` - здесь _Date_ - это значение секретного свойства `[[Class]]`
Можно выдрать это свойство через {}.toString.call(obj).slice(8, -1).
Работает только для встроенных типов.

###Наследование
#####Функциональный паттерн
```JavaScript
function Machine(power) {}
function CoffeeMachine(power) {
    Machine.apply(this, arguments);
}
```
Если делать таким макаром, то приватные поля _Machine_ будут
не видны в _CoffeeMachine_. Как недорешение: условиться протектед-члены делать
публичными, но чтобы имя начиналось с \_.

**Переопределение методов**:
```JavaScript
var parentMethod = this.method;
this.method = function() {
    parentMethod.call(this); //здесь если method родителя не забинден на this -
                             //то все сломается к пизде. Для этого юзаем call
    //свой код
}
```
Соответственно, если родительский метод вообще не используется в потомке -
то просто переопределяем.

#####Прототипный паттерн
**__proto__** (когда объявляем объекты без new)
```JavaScript
var animal = {};
var rabbit = {};
rabbit.__proto__ = animal;
```
При переборе полей через _for in_ будут перебираться все -
 и собственные, и прототипные.  
`hasOwnProperty()` - Проверка на то что свойство принадлежит именно этому классу (а не родителю).

Готовый пример **Extend**:
```JavaScript
function extend(Child, Parent) {
    var F = function() { };
    F.prototype = Parent.prototype;
    Child.prototype = new F();
    Child.prototype.constructor = Child;
    Child.superclass = Parent.prototype; //это если мы потом захотим обратиться к методам родителя
}
```

#####Паразитический паттерн  
Для такого наследования не будет работать _instanceof_!  
Суть: имеем фабрику _Animal_, объявляем другую фабрику _Rabbit_, который внутри себя вызовет _Animal_ и будет потом издеваться над полученным объектом.
```JavaScript
function Animal() {
    var private = 10
    return {
        public: 'public',
        getter: function() {
            return private;
        }
    }
}

function Rabbit() {
    var me = Animal();
    var anotherPrivate = 0;
    me.publicMethod = function() {};
    me.constructor = arguments.callee; //Не пропустить эту строчку
    return me;
}
```

#####Через анонимную функцию  
Вызов `new method` эквивалентен вызову `new method()` - пустые скобки подставятся сами.
```JavaScript
var a = new function() {
  	this.b = 2;
} //работает как конструктор
a.b; //2
```
Помимо простого обращения `obj.__proto__` есть методы:
 * `Object.getPrototypeOf(obj)`
 * `Object.setPrototypeOf(obj, proto)`
 * `Object.create(proto, descriptors)` - второй аргумент - дескрипторы свойств.

Множественного наследования таким образом нет, реализовывать через цепочку наследования

**prototype** (когда объекты объявляются через _new_)
```JavaScript
var animal = {};
function Rabbit(name) {}
Rabbit.prototype = animal;//так не совсем правильно, см. ниже
var rabbit = new Rabbit();
```

У любого _prototype_ есть конструктор, этим можно пользоваться:
```JavaScript
var rabbit = new Rabbit();
var rabbit2 = new rabbit.constructor();
```

Этот конструктор легко потерять:
```JavaScript
Rabbit.prototype = { jumps: true } //всё, конструктора больше нет
//Но вообще так лучше не делать
```

А вообще классы объявляем как в видосе с **udacity**:
```JavaScript
Rabbit.prototype = Object.create(Animal.prototype);
//это пишем ДО объявления остальных методов в прототипе, а то они затрутся
Rabbit.prototype.constructor = Rabbit;
//это если мы собираемся потом использовать конструктор из прототипа
```

Вызов родительского конструктора из дочернего:
```JavaScript
function Rabbit(name) {
  Animal.apply(this, arguments);
}
```

Вызов родительских методов из дочерних примерно так же:
```JavaScript
Rabbit.prototype.run = function() {
   Animal.prototype.run.apply(this, arguments);
   this.jump();
}
```

**Проверка типа с учетом цепочки наследования**: `instanceof`
```JavaScript
rabbit instanceof Rabbit; //true
rabbit instanceof Animal; //true
```

####Date, Time
`new Date()` - вернет текущее время.  
`Date(msecs)` - c 01.01.1970 GMT+0.  
`Date(datestring)` - конструируем из строки.  
`Date(year, month, date=1, hours=0, minutes=0, seconds=0, ms=0)` -
_year_ - 4 цифры, _month_ = от 0 до 11
`getFullYear()`, `getMonth()`, `getDate()`, `getHours()`, `getMinutes()`, `getSeconds()`, `getMilliseconds()`, `getDay()` - номер дня в неделе от 0 до 6.  
Есть аналогичные сеттеры, есть аналогичные методы для UTC  
`toLocaleString(локаль, опции)`  
`toString()`, `toDateString()`, `toTimeString()`  
`parse(str)`  
`now()`  аналогичен вызову `+new Date()`, но в отличие от него
не создаёт промежуточный объект даты, а поэтому — во много раз быстрее.  
При бинарном `+` используется `toString`, а не `valueOf`.

####JSON
Прокатывают только двойные кавычки.  
`JSON.parse(str, reviver)`, где `reviver` -
это `функция(key, value) -> value` которая может пропарсить значение
каким-то особым образом. Необязательный аргумент.

`JSON.stringify(value, replacer, space)` при этом у всех объектов вызывается
 метод `toJSON()`. Если его нет - просто перечисляются свойства, функции пропускаются.  
`replacer` - массив тех свойств, которые будут добавлены
либо функция `replacer(key, value) -> value`  
`space` - количество пробелов в отступе (влияет только на красоту).
```JavaScript
JSON.stringify(user, function(key, value) {
  if (key == 'window') return undefined;
  return value;
});
JSON.stringify(user, ["name", "age"])
```

###setTimeout
`setTimeout(func / code, delay[, arg1, arg2...]) -> timerId`
Аргументы передадутся функции, необязательный параметр.  
Отменить можно через `clearTimeout(timerId)`.

Аналогично: `setInterval`/`clearInterval`. Тут учитывается время
 _между стартами функций_ кроме IE, который считает время между концом прошлой и стартом следующей
Чтобы в остальных было как в IE - делаем рекурсивный `setTimeout`.

Во время показа алертов в браузере этот таймер может заморозиться
(opera/chrome/safari) а может и нет (IE/firefox)

Все эти дела опасны в плане утечек памяти:
пока активен таймер - то не чистится функция и ее замыкание.

В каждом браузере есть минимальное значение задержки,
обычно это 4мс в новых и 15мс в старых.
```JavaScript
setInterval(.., 0) //в IE не сработает, в остальных сработает с минимальной задержкой
```
Если вкладка неактивна - таймер будет срабатывать реже (зависит от браузера).

Можно использовать `setTimeout` на долгих задачах чтобы иногда возвращать управление браузеру и чтобы он не подвисал.

###try-catch-finally
Синтаксис как в плюсах:
```JavaScript
try {}
catch(err) {}
finally {}
```
`err` - это объект, у него есть свойства `name`, `message`, `stack` (может быть еще, зависит от браузера)

Из асинхронно запущенных методов, естественно, ничего не поймает.
`finally` выполняется всегда: если в `try`/`catch` есть `return`, то `finally` выполнится перед ним.

Если что, выкидываем `throw err`, _err_ объект как описано выше, но в принципе может быть и
просто число или строка.  
В JavaScript встроен ряд конструкторов для стандартных ошибок:
`SyntaxError`, `ReferenceError`, `RangeError` и некоторые другие.

**"Проброс ошибки"**:
если мы в `catch`-блоке не знаем как обработать ошибку - то можем выкинуть ее дальше через `throw`
тогда она либо уйдет в `catch` внешнего кода, либо повалит скрипт.  
**"Оборачивание исключения"**:
Мы пробрасываем ошибку, обрабатываемую во внешнем коде, но в нее запихиваем исходную ошибку
чтобы внешний код имел о ней представление

### window.onerror
`window.onerror = function(message, url, lineNumber)` -
функция в браузерах, которая вызывается при необрабатываемой ошибке.


### Автоматическое тестирование:
https://learn.javascript.ru/testing

### ES6
1. Объявление переменных  
`let` - область видимости - блок кода, в цикле для каждой итерации создается своя новая переменная
`const` - как let, только упадет если такая переменная встретится слева от оператора присваивания

2. Вызов функций  
как в питоне:
```JavaScript
let [firstName, lastName] = ["Илья", "Кантор"];
firstName; //"Илья"
```

3. Оператор многоточия  
`...` - оператор многоточия.

4. Присваивание сразу нескольких переменных  

  * Через `let`, дальше как в питоне:
```JavaScript
var arr[1,2];
let [a, b] = arr; //a = 1, b = 2
```

  * Остаток массива выдергиваем через `...`:
```JavaScript
let [firstName, lastName, ...rest] = "Юлий Цезарь Император Рима".split(" ");
rest; // ["Император", "Рима"]
```

  * Можно ставить дефолтные значения:
```JavaScript
let [firstName="Гость", lastName="Анонимный"] = [];
```

  * С объектами такое тоже прокатит:
```JavaScript
let options = {
    title: "Меню",
    width: 100,
    height: 200
};
let {title, width, height} = options;
title; //"Меню"
let {width: w, height: h, title} = options;
w; //100
let {width: w, height: h, title, somevar = 100500} = options;
somevar; //100500
```

    Нюанс:
```JavaScript
	let a, b;
    	{a, b} = {a:5, b:6};//Выражение внутри {} будет воспринято как блок кода
      	({a, b} = {a:5, b:6});//а тут норм
```

  * Можно вкладывать конструкции друг в друга:
```JavaScript
let options = {
    size: {
        width: 100,
        height: 200
    },
    items: ["Пончик", "Пирожное"]
}
let { title="Меню", size: {width, height}, items: [item1, item2] } = options;
alert(`${title} ${width} ${height} ${item1} ${item2}`);// Меню 100 200 Пончик Пирожное
```

5. Генерирование объектов  
Можно при вызове функций генерить объект на ходу:
```JavaScript
function showMenu({title, width, height}) {};
```

6. Аргументы по умолчанию  
В функции можно объявлять параметры по умолчанию (синтаксис как в плюсах).
Тогда все, что `undefined` будет заменяться дефолтным значением.
`null` и `NaN` заменяться не будут.

7. Функции с переменным числом аргументов  
  Чтобы избавиться от `arguments`, можно объявить функцию с переменным числом аргументов:
```JavaScript
function showName(firstName, lastName, ...rest)
```
  `...` можно использовать и при вызове функции:
```JavaScript
let numbers = [2, 3, 15];
Math.max(...numbers); //все равно что Math.max.apply(Math, numbers);
```

8. Function.name  
У функций появилось поле `name`:
```JavaScript
function func() {};
func.name; //"func"
//или даже
let func = function() {}; //тоже будет name = "func"
```

9. У функций, объявленных черех _function declaration_ видимость теперь блочная.

10. Объявление функции через `=>`  
```JavaScript
let inc = x => x+1; //все равно что let inc = function(x) {return x+1;};
let sum = (a,b) => a + b;
let getTime = () => "";
let getTime = () => {f1(); f2(); return ""};
```
В таких функциях нет своего `this` (он берется из вызвавшего кода),
нет своего `arguments`.

11. Новый строковый литерал  
\` (обратная кавычка):
```JavaScript
var newstring = `lalala`
```
 - допустимо делать многострочную строку
 - вставлять выражения через `${varname}` или даже `${arg1 + arg2}` например.
```JavaScript
var a = 1, b = 2;
var string = `${a} + ${b} = ${a+b}`;
```

[Foo](#foo)
