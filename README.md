# bash_archiving
написати один скрипт який:
1) на вхід прийматиме від 1 до 2 аргументів, все що більше або менше - має завершуватись з кодом 2 і видавати приклад його використання у форматі:
Usage: your_script username period
username: required
period: optional with prefix minutes,hours,days
for example: your_script petya 4hours
2) your_script - має підставлятись динамічно в залежності від назви вашого скрипта, якщо скрипт lesson_x.sh тоді Usage: lesson_x.sh
3) параметр username - обовязковий, period - опціональний з префіксами minutes,hours,days, якщо period не вказаний тоді пошук без обмеження в періоді
4) біля скрипта має лежати файл config в якому будуть записані директорії в яких шукати, використати дану строку, копіювати як записано:
/etc : /usr : /var/log   : /bin:/opt  
5) в основний скрипт потрібно підвантажити конфіг та в циклі while пройтись по папкам з конфіга
6) в кожній папці шукати файли які належать username та з датою доступ потягом now - period, тобто якщо вказано 3minutes значить потрібно всі файли, до яких відбувся доступ за останні 3хв
7) всі файли які будуть знайдені запакувати в архів формату username_folder_20_02_2019-01_10_34.tgz, де 20_02_2019-01_10_34 - дата яка формується в момент створення архіва, folder - папка з якої брались файли
😍 після створення архіва, вивести його вміст не розпаковуючи


# bash_sed
[abc-abc].[.].*

#need cut stroke from 1st bracers in format "title-tile"

#!/bin/bash ls -l | sed -n ' /[^ ]$/ s/.[([a-zA-Z0-9]-[a-zA-Z0-9]).*/\1/p'

# bash_usd-uah
в докері запускати скрипт який сходить на api приватбанку https://api.privatbank.ua/#p24/exchangeArchive і дістане курс долара за останні 60днів, запити робити із інтервалом в 1 секунду, і писати в лог у форматі 01-03-2019 1usd = 26.56uah Суть задачі лог писати в докері який перенаправлятиметься в syslog системи, а в сіслог добавити конфіг, щоб все що прилітає від докера писалось в /var/log/dockers


# bash_usersadd_via_ssh
написать скрипт, который на вход принимает файл (40 строк), который содержит username и password в формате: vasya:qwerty petya:12345 и параметр add/remove.

${scriptname} ./users add ${scriptname} ./users remove

Если выбран параметр add - рандомно выбираем строку с именем и паролем, заходим по ssh на сервер под своим юзером используя ssh ключ и под sudo выполняем проверку на наличие выбранного юзера на сервере. Если юзера нет - добавляем. Если юзер есть - вывести сообщение о том, что юзер есть, выбрать следующего юзера из списка и повторить действие.

Если выбран параметр remove - создаем пустой массив. Последовательно выбираем юзера из списка и пробуем подключиться под ним по ssh. Если подключаемся - тогда выходим, заносим юзера в массив. Если не подключаемся - выводим сообщение, что имя пользователя не найдено и выбираем следующего юзера из списка, перебираем всех юзеров из файла.

