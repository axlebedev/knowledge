`window` содержит свойства и методы для управления окном браузера, открытия
новых окон...

`document` даёт возможность взаимодействовать с содержимым страницы.

**BOM** — это объекты для работы с чем угодно, кроме документа:
 - `navigator`
 - `screen`
 - `location`
 - `frames`
 - `history`
 - `XMLHttpRequest`

`navigator` содержит общую информацию о браузере и операционной системе.
Особенно примечательны два свойства:  
`navigator.userAgent` — содержит информацию о браузере  
`navigator.platform` — содержит информацию о платформе,
позволяет различать Windows/Linux/Mac  
`alert`/`confirm`/`prompt` — тоже входят в BOM


# DOM
Всего различают 12 типов узлов, но на практике мы работаем с четырьмя из них:
 1. **Документ** — точка входа в DOM.
 2. **Элементы** — основные строительные блоки.
 3. **Текстовые узлы** — содержат, собственно, текст.
 4. **Комментарии** — иногда в них можно включить информацию, которая не будет
 показана, но доступна из JS.

```JavaScript
document.documentElement; //HTML
document.head; // <head>...</head> // IE9+
document.body; // <body>...</body>
```
> _Тонкость_: если скрипт выполняется до того, как загрузился **body**, то
`document.body == null`  
И вообще, если какой-то элемент не определен, то в операциях с DOM возвращается
`null`, а не `undefined`

### Навигация по DOM
> Здесь и далее:
**дети** - потомки первого уровня  
**потомки** - все потомки

`elem.childNodes` - массив с детьми, константный метод  
Данный метод возвращает не JS-массив, а "коллекцию". Всякие filter и прочее
работать не будут. Для того чтобы это сделать есть два метода:
 1. `Array.prototype.method.call`
 2. `var arr = Array.prototype.slice.call(collection);`

> **Для обхода коллекции нельзя использовать `for in` !!!**


`elem.firstChild` - первый потомок  
`elem.lastChild` - последний потомок  
`elem.previousSibling` - следующий "брат"  
`elem.nextSibling` - предыдущий "брат"  
`elem.parentNode` - родитель  
`elem.hasChildNodes` - проверка, есть ли детки

Есть аналогичные методы, которые не включают текстовые узлы:  
`elem.children`  
`elem.firstElementChild`  
`elem.lastElementChild`  
`elem.previousElementSibling`  
`elem.nextElementSibling`  
`elem.parentElement`  

Отличие `elem.parentNode` от `elem.parentElement`:
```JavaScript
document.documentElement.parentNode; // document
document.documentElement.parentElement; // null
```
> В IE8- из всего этого есть только `children`, причем в возвращенной коллекции
будут и узлы-комментарии

#### Особые ссылки таблиц
`table.rows` — коллекция строк TR таблицы.  
`table.caption/tHead/tFoot` — ссылки на элементы таблицы CAPTION, THEAD, TFOOT.  
`table.tBodies` — коллекция элементов таблицы TBODY,
по спецификации их может быть несколько.  
`tbody.rows` — коллекция строк TR секции  
`tr.cells` — коллекция ячеек TD/TH  
`tr.sectionRowIndex` — номер строки в текущей секции THEAD/TBODY  
`tr.rowIndex` — номер строки в таблице  
`td/th.cellIndex` — номер ячейки в строке  

### Поиск элемента
#### По id
Как делать не надо:
```HTML
<div id="content-holder">
  <div id="content">Элемент</div>
</div>

<script>
  alert( content ); // DOM-элемент
  alert( window['content-holder'] ); // в имени дефис, поэтому через [...]
</script>
```
Такое поведение существует лишь для обратной совместимости. Для выдергивания
элемента по id используем  
`document.getElementById("идентификатор")`  
Таким образом можем искать только внутри `document`
> Если вдруг в документе несколько узлов с заданным id, то поведение не
определено (какой попадется: первый, последний - хуй знает)

#### По тегу
`elem.getElementsByTagName(tag)` - возвращает список потомков с нужным тегом
