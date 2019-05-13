# A simple query to find the size of tables in your MYSQL database. 
select TABLE_NAME as 'TABLE',
       ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) as 'Size'
from TABLES T where TABLE_SCHEMA = 'database_name' order by (DATA_LENGTH + INDEX_LENGTH) desc
