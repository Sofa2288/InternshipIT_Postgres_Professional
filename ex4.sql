-- [4] ускорить запрос "semi-join", добиться времени выполнения < 10sec
-- оценка производительности запроса
EXPLAIN ANALYZE
select day from t2 where t_id in ( select t1.id from t1 where t2.t_id = t1.id) and ;
-- оптимизация запроса 
-- применение фильтрации до соединения таблиц перед join 
EXPLAIN ANALYZE
SELECT t2.day
FROM t2
where t2.day > to_char(date_trunc('day', now() - interval '1 month'), 'yyyymmdd') and  EXISTS (
    SELECT 1 FROM t1 WHERE t1.id = t2.t_id
)