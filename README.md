# Итоговый проект по курсу "Administrator Linux. Basic"

**Название задания:** 

  - Настроить систему виртуальных машин и разработать план по восстановлению. 

**Текст задания:** 

  - Создать репозитории в GitHub (конфиги, скрипты). 
  - Настроить вебсервер с балансировкой нагрузки.
  - Настроить MySQL репликацию (master-slave). 
  - Написать скрипт для бэкапа БД со slave сервера (потаблично с указанием позиции бинлога).
  - Настроить систему мониторинга и логирования.
  - Разработать план аварийного восстановления.
  - Продемонстрировать аварийное восстановление.

## 1. Структура системы виртуальных машин

  Всего 4 виртуальные машины: master, slave1, slave2, log.

  Установленные программы:
  
  - На master (ip 192.168.0.200) установлен nginx, mysql, node-exporter, loki+promtail.  
  - На slave1, slave2 (ip 192.168.0.201, 192.168.0.202) установлен apache2, mysql.  
  - На log (ip 192.168.0.205) установлен prometheus, grafana.  
	
  Выполненные задания:
  
  - Балансивовка: с сервера master (nginx) на slave1, slave2 (apache).  
  - Репликация mysql: с mastr на slave1, slave2.
  - На slave1, slave2 находятся скрипты для бэкапа БД mysql.  
  - Мониторинг: на log установлен мониторинг машины master (prometheus + grafana), \
    на master происходит сбор метрик (node exporter) и логов с nginx (loki + promtail).  	

## 2. Установка (на всех VM стоит Ubuntu 20 LTS)

  - Нужно вручную зайти на каждую VM и посмотреть IP.
  - Далее на каждой машине выполнить скрипт <имя-машины>-init.sh с аргументом - последним числом IP. \
    Этот скрипт установит статический IP на VM, загрузит необходимые файлы и установит необходимые пакеты. \
    Машина запросит несколько раз логин (master на всех VM) и пароль (changeme).
  - Далее на каждой машине зайти в репозиторий configs и выполнить скрипт set-configs.sh. \
    Этот скрипт настроит пакеты и настроит репликацию БД.
  - [Для демонстрации работающей репликации запустить set-databases.sh на master. \
    После этого можно увидеть, что БД появились на slave1, slave2.]
  - Для бэкапа БД с машины slave1 выполнить на рабочем компьютере get-databases.sh.
  - Для визуализации мониторинга и логирования выполнить в браузере http://192.168.0.205:3000. \
    На открывшемся сайте grafana ввести login и пароль admin, затем skip. \
  - Затем для мониторинга: Create a data source -> prometheus, \
    ввести URL: http://localhost:9090, нажать Save&test. \
    На левой панели: + -> Import -> load a json file -> log-configs/monitoring.json. \
    Установить Victoria metrics: Prometheus, нажать Import.
  - Для логирования: на левой панели: "колесико" -> Data sources, Add data sources -> loki, \
    ввести URL: http://192.168.0.200:3100, нажать Save&test. \
    На левой панели: + -> Import -> load a json file -> log-configs/logging.json. \
    Установить Victoria metrics: loki, нажать Import. \
    Чтобы появились логи, нужно выставить в правом верхнем углу время last 5 minutes \
    и зайти в браузере на http://192.168.0.200, или выполнить на master команду curl http://2.2.2.2
 
## 3. Аварийное восстановление

  Отличается от установки только пунктом, который написан в квадратных скобках:
  - [Для восстановления БД запустить restore-databases.sh на master. \
    После этого БД восстановится из сделанного заранее бэкапа.]

## 4. Примечание

  При установке Grafana, Loki и Promtaile я пользуюсь .deb пакетами, \
  которые не получилось залить на Github, но они находятся на домашнем компьютере \
  в папках log-configs и master-configs.
