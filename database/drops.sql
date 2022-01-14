drop table if exists countries cascade;

drop table if exists department cascade;

drop table if exists employees cascade;

drop table if exists identification_type cascade;

drop table if exists users_trace cascade;

drop type if exists status_user;

drop function if exists insert_employees(uuid, varchar, varchar, varchar, varchar, integer, integer, varchar, varchar,
    varchar, varchar, integer) cascade;

