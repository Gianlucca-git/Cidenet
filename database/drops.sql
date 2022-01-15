drop table if exists countries cascade;

drop table if exists department cascade;

drop table if exists employees cascade;

drop table if exists identification_type cascade;

drop table if exists users_trace cascade;

drop type if exists status_user;

drop function if exists insert_employees(uuid, varchar, varchar, varchar, varchar, integer, integer, varchar, varchar,
    varchar, varchar, integer) cascade;

drop function if exists select_employees(varchar, character varying[], character varying[], character varying[],
    varchar, varchar, integer) cascade;

drop function if exists update_employee(uuid, varchar, varchar, varchar, varchar, integer, integer, varchar, integer,
    status_user, uuid) cascade;





