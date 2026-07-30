select column_name, data_type, column_default 
from information_schema.columns 
where table_name = 'user_profiles'
order by ordinal_position;