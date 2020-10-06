ALTER TABLE users_log RENAME TO users_log_temp;
CREATE TABLE users_log(id INTEGER PRIMARY KEY,date TEXT,user_id INTEGER,log INTEGER);
INSERT INTO users_log(date, user_id, log) SELECT date, user_id, log FROM users_log_temp;
DROP TABLE users_log_temp;
select row_number()  over (order by min(date), user_id) - 1 as id, user_id, min(date) as start_date, max(date) as end_date, log as status, count(*) as length from (select users_log.*,(row_number() over (order by id) - row_number() over (partition by log order by id)) as grp from users_log) users_log group by grp, log, user_id ORDER BY start_date, user_id;