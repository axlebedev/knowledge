" превентим исполнение кода, если он уже был исполнен
if exists("b:current_syntax")
    finish
endif

" Основное тело

" Определяем ключевые слова
syntax keyword potionKeyword loop times to while
syntax keyword potionKeyword if elsif else
syntax keyword potionKeyword class return
" Указываем: все, что мы определили как 'potionKeyword',
" должно подсвечиваться как Keyword текущей цветовой схемы
highlight link potionKeyword Keyword


" Определяем функции
syntax keyword potionFunction print join string
" 'potionFunction' => 'Function'
highlight link potionFunction Function


" Для сравнения по регуляркам используем match. Не забываем про `\v` в начале регекса
" ВНИМАНИЕ: в keyword мы могли в одной строке указать несколько кейвордов
" в match так делать нельзя. Одна команда - один регекс.
syntax match potionComment "\v#.*$"
highlight link potionComment Comment


" Порядок важен. Сначала '-', потом '-=', а то просто '-' будет иметь больший приоритет
syntax match potionOperator "\v\="
syntax match potionOperator "\v\*"
syntax match potionOperator "\v/"
syntax match potionOperator "\v\+"
syntax match potionOperator "\v-"
syntax match potionOperator "\v\?"
syntax match potionOperator "\v\*\="
syntax match potionOperator "\v/\="
syntax match potionOperator "\v\+\="
syntax match potionOperator "\v-\="
highlight link potionOperator Operator


syntax match potionConstant /\v\d+(e[\+\-]\d+)?/
syntax match potionConstant /\v\\.d+(e[\+\-]\d+)?/
syntax match potionConstant /\v\d+\.(e[\+\-]\d+)?/
syntax match potionConstant /\v\d+\.\d+(e[\+\-]\d+)?/
syntax match potionConstant /\v0x[a-fA-F0-9]+/
highlight link potionConstant Constant

" А теперь 'region' на примере строк
" Регионы имеют начало и конец. skip - задаем когда не засчитываем то, что подходит под end
syntax region potionString start=/\v"/ skip=/\v\\./ end=/\v"/
highlight link potionString String

" Устанавливаем флаг для превента
let b:current_syntax = "potion"
