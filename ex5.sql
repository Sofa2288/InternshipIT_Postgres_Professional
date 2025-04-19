-- [5] ускорить работу "savepoint + update", добиться постоянной во времени 
-- производительности (число транзакций в секунду)
-- сокращение числа точек сохранения (savepoint)
-- добавлено обновление поля name
-- достигнута стабильная скорость выполнения
psql -X -q > generate_100_subtrans.sql <<'EOF'

select '\set id random(1,10000000)'

-- инициализация транзакции
union all select 'BEGIN;'

-- создание контрольных точек с группировкой по 10 операций обновления
union all select 'savepoint batch_' || (v.id/10) || ';' || E'\n' ||
       string_agg('update t1 set name = md5(random()::text) where id = :id;', E'\n' 
       order by sub.id) || E'\n'
from generate_series(1,100) v(id),
     generate_series(1,10) sub(id)
group by v.id/10

-- фиксация транзакции
union all select E'COMMIT;\n'
\g (tuples_only=true format=unaligned)
EOF


