-- [3] ускорить запрос "anti-join", добиться времени выполнения < 10sec
-- оценка производительности запроса 
explain analyse
select day from t2 where t_id not in ( select t1.id from t1 );
-- создание индекса для ускорения поиска по t_id 
CREATE INDEX CONCURRENTLY t2_t_id_idx 
ON t2(t_id);
-- вариант с LEFT JOIN и проверкой на NULL 
explain analyse 
SELECT t2.day
FROM t2
LEFT JOIN t1 ON t2.t_id = t1.id
WHERE t1.id IS NULL;
-- вариант с NOT EXISTS 
explain analyse 
SELECT t2.day
FROM t2
WHERE NOT EXISTS (
    SELECT 1 FROM t1 WHERE t1.id = t2.t_id  
);
-- итог: оба варианта (JOIN и NOT EXISTS) демонстрируют 
-- улучшение производительности