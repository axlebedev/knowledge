[nginx.org/ru/docs/beginners_guide](https://nginx.org/ru/docs/beginners_guide.html)

По умолчанию, конфигурационный файл называется nginx.conf и расположен 
в каталоге `/usr/local/nginx/conf`, `/etc/nginx` или `/usr/local/etc/nginx`.

# Запуск

Чтобы запустить nginx, нужно выполнить исполняемый файл.
Когда nginx запущен, им можно управлять, вызывая исполняемый файл с параметром `-s`.
Используйте следующий синтаксис:

`nginx -s сигнал`
Где сигнал может быть одним из нижеследующих:

`stop` — быстрое завершение
`quit` — плавное завершение
`reload` — перезагрузка конфигурационного файла
`reopen` — переоткрытие лог-файлов

> Команда должна быть выполнена под тем же пользователем, под которым был запущен nginx.

# Структура конфигурационного файла 

nginx состоит из _модулей_.  
_Модули_ настраиваются _директивами_, в конфигурационном файле.
_Директивы_ делятся на **простые** и **блочные**.  
**Простая директива** состоит из имени и параметров, разделённых пробелами, и оканчивается точкой с запятой (;).  
> `server_name sn.xyz;`

**Блочная директива** устроена так же, как и простая директива, но вместо точки с запятой 
после имени и параметров следует набор дополнительных инструкций, помещённых внутри 
фигурных скобок (`{` и `}`).  
> map $http_upgrade $connection_upgrade {  
>   default upgrade;  
>   ''   '';  
> }

**Контекст**. Если у блочной директивы внутри фигурных скобок можно задавать другие директивы,
то она называется **контекстом** (примеры: `events`, `http`, `server` и `location`).
> server {
>   listen 80;
> }

**Комментарий** начинается с `#`

Директивы, помещённые в конфигурационном файле вне любого контекста, 
считаются находящимися в контексте `main`. 
Директивы `events` и `http` располагаются в контексте `main`, `server` — в `http`, а `location` — в `server`.

### `server`

В общем случае конфигурационный файл может содержать несколько блоков server,
различаемых по портам, на которых они слушают, и по имени сервера.

# Раздача статического содержимого

Пример: раздавать html из папки `www` и картинки из папки `image`  
Для этого потребуется отредактировать конфигурационный файл и настроить блок `server`
внутри блока `http` с двумя блоками `location`.

Конфиг:
```
http {
    server {
        location / {
            root /data/www;
        }
        location /images/ {
            root /data;
        }
    }
}
```

Запросы, URI которых не начинаются на /images/, будут отображены на каталог /data/www.
Например, в результате запроса http://localhost/some/example.html в ответ будет отправлен файл /data/www/some/example.html.
