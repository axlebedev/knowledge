_TODO: 4, 5, 6, 7.11-7.15, 8.2-8.4, !!!10, A3_
git-scm.com/book/en/v2

# Общие понятия
`HEAD` - указатель на последний коммит текущей ветки  
`HEAD^n` - предок коммита (предки на одном уровне, 'в ширину')  
`HEAD~n` - предок коммита (дедушки, 'в глубину')  
`HEAD~3` и `HEAD^^^` эквивалентны (третий дедушка, или папа папы папы)  

`<commit1>..<commit2>` - общее обозначение range коммитов  
`^<commit1>` - 'не': не включит коммит и его потомков  

`git show HEAD@{5}` - покажет указаетель 5 из reflog  
`git show master{yesterday}` - покажет первый коммит из вчерашнего дня  

`branch1...branch2` - _оператор троеточия_ покажет коммиты, которые есть (достижимы) только в одной из веток, хорошо в сочетании с `--left-right`  

**С ключом `--patch`** работают следующие команды:
 - add
 - reset
 - save
 - stash

## Общие команды
`git config` - изменить конфиг  
`git help` - просмотр справки  
`git init` - создать новый репозиторий  

`git clone` - [клонирует](#git-clone) репозиторий



## Понемногу всего
`git status -s` - статус в коротком формате

`git diff --staged` (или `--cached`, это синонимы) - дифф тех изменений, которые уже git add

`git commit -v` - в комментариях в коммитмесседже будут диффы  
`git commit --amend` - дополнить предыдущий коммит  

`git add -i` - интерактивный мод  

`git rm --cached` - удалит файл из индекса, на диске его не трогаем. После этого можно добавить в .gitignore

`git rev-parse branchname` - укажет номер последнего коммита на той ветке

`git reflog` - покажет историю перемещений HEAD


## `git mv` переместить файл
`git mv <oldfilename> <newfilename>` - эквивалентно следующим трем строкам:

```
mv <oldfilename> <newfilename>
git rm <oldfilename>
git add <newfilename>
```

## `git tag` поставить метку (тег) на коммит
Теги бывают двух типов - простые указатели на коммит, и полноценные со всей инфой как у коммита.  
`git tag` - просмотреть теги в алфавитном порядке  
`git tag -l <mask>` - просмотреть теги с фильтрацией по маске, например `'supertag*'`  

`git tag <tagname>` - создать простой тег. Не использовать `-a`, `-s` и `-m`  
`git tag -a <tagname>` - создать сложный тег  
`git tag -a <tagname> <commit>` - создать сложный тег для определенного коммита  
`git checkout -b <newbranchname> <newtagname>` - создать ветку, и там сразу прилепить метку  

`git show <tagname>` - вывести инфу о tagname  

`git push <remotename> <tagname>` - отправить ветку на серв (просто `push` не отправляет метки)  
`git push origin --tags` - отправить все метки  
\* `git pull` и без дополнительных параметров стянет теги  


# Работа с файлами и коммитами

## `git stash` спрятать unstaged изменения
`git stash` или `git stash save` - спрятать изменения  
`git stash list` - показать список стэшей  
`git stash apply` - применить стэш обратно  
`git stash apply stash@{2}` - применить какой-то конкретный стэш из списка  
`git stash apply --index` - TODO  
`git stash drop` - удалить стэш  
`git stash --keep-index` - не стэшить те файлы, которые мы уже add  
`git stash -u` или `--include-untracked` - застэшит даже те файлы, которых еще нет в индексе  
`git stash --patch` - стэшить не целиком файлы  
`git stash branch <branchname>` - восстановить стэш в новую ветку <branchname>, и дропнуть этот стэш  
`git stash --all` - застэшить все, даже если файлов нет в индексе  

## `git clean` удалить файлы
`git clean -f` - удалить все untracked файлы  
`git clean -f -d` - удалить все untracked файлы и папки, которые в результате станут пустыми  
`git clean -n` - показать те файлы, которые эта команда удалит при запуске без -n  
`git clean -x` - удалить файлы и папки, даже если они есть в gitignore  
`git clean -i` - интерактивный режим  

## `git reset` отменить изменения
Что делает git reset:
1. Move the branch HEAD points to (stop here if --soft)
2. Make the Index(staging area) look like HEAD (stop here if --mixed)
3. Make the Working Directory look like the Index

`git reset <commit>` - переместит HEAD текущей ветки на коммит <commit>  
`--soft` - переместит HEAD, изменения которые останутся - будут уже в индексе (git status - зеленый)  
`--mixed` - [эта по умолчанию] переместит HEAD, изменения которые останутся - не будут в индексе (git status - красный)  
`--hard` - переместит HEAD, никаких изменений сохранено не будет  

`git reset <filename>` - эквивалентно `git reset --mixed HEAD <filename>` - просто отменит git add  
Можно например засунуть в Index файл с коммита c1c1c1: git reset c1c1c1 -- file.txt
--patch работает с reset и checkout.

Чтобы слепить ряд 'WIP' коммитов, мы можем сделать `git reset --soft HEAD~3`, и после этого `git commit`

reset от checkout отличается тем, что первый сдвигает не только HEAD, но и указатель ветки, а checkout ветку не трогает


# Дебаг

## `git grep` поиск по файлам
`git grep <regex>` - покажет все файлы, в которых будет найден регексп.  
`-n` - показать номера строк  
`--count` - покажет количество совпадений в файле  
`-p` - покажет, в какой функции найдено совпадение (постарается угадать своими силами :)  
`--and` - ищет несколько регулярок в одной строке  
`--break`  
`--heading`  
можно указывать указатель (ветку, тег или коммит), в котором искать  


## `git log` работа с историей коммитов
`git log -p` - выведет диффы для каждого коммита  
`git log --stat` - выведет статистику для каждого коммита  

`git log --since=2.weeks` (можно еще `--after`)  
`git log --until="2008-01-15"` - или `--before` - например "2 years 1 day 3 minutes ago".  

`git log --author="<authorname>"` - фильтр по автору  
`git log --grep="<keyword>"` - фильтр по словам в сообщении. Не испольовать вместе с author! Для этого есть --all-match  
`git log -S<function_name>` - _без пробела!_ покажет только те коммиты, где `<function_name>` есть в диффах  
`git log -- <path>` - покажет только те коммиты, где изменялись файлы из заданного фолдера  

`git log -S<pattern>` - _без пробела!_ найти коммиты, в диффах которых есть <pattern>  
`git log -L :<function_name>:<filename>` - For example, if we wanted to see every change made to the function <function_name> in the <filename> file  
`git log -L '/function function_name/',/^}/:zlib.c` - это если гит нашего языка не понимает - даем регулярки  
You could also give it a range of lines or a single line number and you’ll get the same sort of output.  


## `git blame` работа в содержимым файлов и историей коммитов
`git blame <filename>` - покажет файл, для каждой строки выведет коммит в котором она была изменена  
`-L 12,22` - ... в строках 12-22  
`-С` - покажет имя файла на тот момент, когда строчка изменилась (если файл переименовывался в течение работы)  
В выводе блейма: если перед коммитом стоит `^` - значит эта строчка не менялась с первого коммита, когда этот файл появился  

## `git bisect` двоичный поиск по коммитам
`git bisect` - двоичный поиск:
1. `git bisect start` - начать
2. `git bisect bad` - указать что на этом коммите баг есть
3. `git bisect good <commit>` - указать коммит без бага
4. Дальше он нам будет чекаутить коммиты, а мы - указывать, `git bisect good` или `bad`
5. Когда закончим, то делаем `git bisect reset`.

Также мы можем подавать на исполнение скрипт: `git bisect run somescript.sh` он должен возвращать 0 если ок и не-0 если не-ок.  
Можем давать просто команду (`make` или `make test` например)


# Работа с ветками и удаленными репозиториями

## `git remote` работа с удаленными (remote) репозиториями
`git remote -v` - вывести список удаленных репозиториев  
`git remote add pb https:-github.com/paulboone/ticgit` - добавить удаленный репозиторий  
`git fetch <origin>` - получить изменения, которые есть в origin, но нет у меня. Ветки не смержит  
`git remote show <origin>` - покажет ветки с сервера, и какие локальные будут пу[ш,лл]иться в них  
`git remote rename <origin> <newnamefororigin>` - изменить shortname удаленного репозитория  
`git remote rm <someremote>` - удалить удаленный репозиторий  

## `git fetch` вытянуть изменения, не мержить
`git fetch <remotename>` - получить изменения, которые есть в `<remotename>`, но нет у меня.  
\* Ветки не подтягиваются, подтягиваются только указатели на них: `origin/anotherbranch`  
`git fetch --all` - подтянуть все ветки, которые мы отслеживаем.  

## `git pull` вытянуть и смержить изменения
`git pull` - делает `git fetch --all` и мержит все сама. Лучше не пользоваться.  
`git pull --rebase` - сделает rebase вместо merge

## `git push` отправить изменения на сервер
Осторожно: `git push` отправляет все локальные ветки, даже если они нахуй на сервере не нужны.  
`git push <удал. сервер> <лок. ветка>:<удал. ветка>` - Общий синтаксис: отпавить локальную ветку на удаленную ветку удаленного сервера  
`git push <remotename> <branchname>` - отправить локальную ветку <branchname> на сервер <remotename>  
`git push <remotename> :<branchname>` - удалить ветку <branchname> с сервера <remotename>  

## `git rebase` переместить наши коммиты на другой коммит в основании дерева
https://git-scm.com/book/en/v2/Git-Branching-Rebasing - тут есть все, что я хотел знать о rebase  

`git rebase <master>` - находясь на ветке, взять все коммиты с мастера и воткнуть в свою историю коммитов  
После этого можно перейти на master и смержить, получится ff-мерж.

`git rebase --onto master server client` - “Check out the client branch, figure out the patches from the common ancestor of the client and server branches, and then replay them onto master.”  
`git rebase <basebranch> <topicbranch>` - заребейзить <topicbranch> на ветку <basebranch>  
**Не ребейзить ветки, которые уже существуют где-то кроме локального компа!** А то будут повторяющиеся коммиты  
Если такая хуйня произошла, то `git rebase <remotewhererebased>/<branchname>`.  
У `rebase` тоже есть `-i` интерактивный мод, можно менять коммиты местами, склеивать их, разделять один на несколько, менять сообщения и т.д.

## `git filter-branch` работа массово над всеми коммитами в истории
`git filter-branch` - уберкоманда, которая работает над всеми коммитами в истории  
`git filter-branch --tree-filter 'rm -f passwords.txt' HEAD` - удалить из всех коммитов файл passwords.txt  
`git filter-branch --subdirectory-filter trunk HEAD` - корнем станет папка trunk, также удалятся все коммиты, где эта папка не затрагивалась  
Можно еще много чего, например сменить e-mail автора коммита (условно с помощью bash-функции) и т.д.

## `git branch` работа с ветками
_'fast-forward'_ означает, что гит ничего сливать не будет, просто прицепит коммиты к ветке.  
Если на обеих сливаемых ветках уже были коммиты - то он будет делать 'трехходовое слияние',
в результате родится новый коммит с мержем.

`git checkout -b <branchname> <remotename>/<branchname>` - создать локальный branchname с удаленного, будет отслеживаться  
`git checkout --track <remotename>/<branchname>` - синоним прошлой  

`git branch` - посмотреть, какие у нас есть ветки  
`git branch -v` - +последний коммит каждой из них  
`git branch -vv` - + каким remote веткам они соответствуют  

`git branch --merged` - вывести только те ветки, которые **уже** смержены в текущую  
`git branch --no-merged` - вывести только те ветки, которые **не** смержены в текущую  
`git branch <branchname>` - создать ветку branchname  
`git branch -d <branchname>` - удалить ветку branchname. Не даст удалить несмерженную ветку  
`git branch -D <branchname>` - удалить ветку branchname. Даст удалить несмерженную ветку  
`git checkout <branchname>` - перейти на ветку branchname  
`git checkout -b <branchname>` - создать и перейти на ветку branchname  
`git branch -u <remote>/<remotebranch>` - настроить отслеживание удаленной ветки для локальной  

## `git merge` слить два коммита в один
В мержконфликтах:
```
<<<<<<< HEAD:filename
a line of code
=======
another line of code
>>>>>>> somebranch:filename
```
Сверху - то что у нас есть, снизу - то что прилетело

Есть еще команда `git merge-file`:  
`git merge-file <ourfile> <basefile> <theirfile>`

Перед большим мержем лучше всего все unstaged изменения закоммитить в какую-ниб временную ветку.  
`git merge --abort` - попытается откатиться к тому состоянию, которое было до момента git merge.  
`--abort` может облажаться, если у нас на момент мержа были unstaged изменения.  

Следующие две особенно полезны когда у нас хуйня с line-ending'ами, или если кто-то заменил отступы пробелами на табы.  
`-Xignore-all-space` - игнорить вообще все пробелы в диффаобщим коммтом  
`-Xignore-space-change` - рассматривает последовательности из одного и более пробельных символов как одинаковые  

`-Xours`, `-Xtheirs` - автоматически разрешать конфликты в чью-то сторону  


Во время мержа можно получить копии всех трех сторон (:1, :2 и :3 - всегда будут означаить базу/наш/их):  
`git show :1:hello.rb > hello.common.rb`  
`git show :2:hello.rb > hello.ours.rb`  
`git show :3:hello.rb > hello.theirs.rb`  

`git ls-files -u` - также можно получить blob'ы файлов  

Перед окончание мержа можно сделать `git diff`:  
`git diff --ours` покажет дифф между нашей веткой до мержа и после
`git diff --theirs` покажет дифф между 'их' веткой до мержа и после
`git diff --base` покажет дифф между общим коммтом до мержа и после

`git checkout --conflict` - This will re-checkout the file again and replace the merge conflict markers. This can be useful if you want to reset the markers and try to resolve them again.  
`git checkout --conflict <filename>`  
`git checkout --conflict=base3 <filename>` - даст не только 'их' и 'нашу' версию кода в файлах, но еще и общего предка  
`git checkout --conflict=merge <filename>` - это по умолчанию  
`git config --global merge.conflictstyle diff3` - меняем умолчания  
`git checkout --ours` или `--theirs` - вытянуть версию какой-то из сторон  

Для просмотра коммитов мержа используем git log с параметром `--left-right` и троеточечным `HEAD...MERGE_HEAD`  
`git log --left-right --merge` - выведет коммиты для текущего конфликтного файла  

### Как ОТМЕНИТЬ мерж:  
Если мы никуда не пушили, то `git reset --hard` - наш друг

`git revert` - создаст новый коммит, в котором происходит откат на предыдущий коммит  
`git revert -m 1 HEAD` - после мержа, -m 1 указывает, на какую из веток мы откатываемся (1 - на нашу ветку, 2 - на мержируемую)  
но потом будет заебно снова мержить с мержируемой веткой, поэтому не стоит так делать. Если очень надо - то https:-git-scm.com/book/en/v2/Git-Tools-Advanced-Merging (reverse the commit)

`git merge -s ours <branchname>` - супер-опция: просто сделает вид что смержила в дереве истории, но на деле там нихуяшеньки не мержится, просто копируется контент последнего our коммита


# Дополнения

## rebase от Игоря:
```
git commit -m «» // что-то закоммитили
git fetch // вытянули с сервера обновления, без мержа
git rebase --merge origin/develop // отребейзили текущую ветку на origin/develop
git push // запушили ветку
git checkout develop // перешли на develop
git merge --no-ff feature/zoomRefactored // смержили develop с нашей веткой через no-ff
```

## Что делает `git clone` <a name="git-clone"></a>
```
mkdir <dirname>
cd <dirname>
git init
git remote add <remotename>
git fetch
git checkout
```
