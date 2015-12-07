# let, const
`let` - это как `var`, только с блочной видимостью.  
Блок - как в плюсах - любая пара фигурных скобок.  
`const` - не может быть слева от оператора присваивания.  





# Массивы
## `for..of`
```JavaScript
var arr = ['a', 'b', 'c'];
// можно получать элемент:
for (let elem of arr)
// а можно элемент с индексом:
for (let [index, elem] of arr.entries())
```






# Строки
Новые строки обозначаются обратными кавычками.  
Ниже перечислены некоторые фишки:

## Значения внутри строки
```JavaScript
var x = 1, y = 2;
'('+x+', '+y+')' // es5
`(${x}, ${y})` // es6
// внимание на обратные кавычки
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
```JavaScript
// пример с массивом
let [ , v1, v2] = 'orange fruit dragon'.split();

// пример с объектом
let obj = { foo: 123 };
let {writable, configurable} = Object.getOwnPropertyDescriptor(obj, 'foo');
```




# Классы
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





# Новые типы данных
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
