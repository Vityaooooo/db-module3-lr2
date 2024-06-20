# practNode
Приминение триггера не возможно, возникает ошибка Error Code: 1362. Updating of NEW row is not allowed in after trigger, которая указывает на то, что в триггере AFTER UPDATE была попытка обновить строку, которая уже была обновлена. В триггере AFTER нельзя изменять строки, которые вызвали триггер.


Возможным решением данной проблемы может быть использование триггера BEFORE UPDATE. Триггер BEFORE UPDATE сработает перед обновлением строки, позволяя корректировать значения до внесения изменений.
