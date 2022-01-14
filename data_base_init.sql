GRANT
ALL
ON DATABASE "cidenet-db" TO postgres;

/*
drop table if exists countries cascade;

drop table if exists department cascade;

drop table if exists employees cascade;

drop table if exists identification_type cascade;

drop table if exists users_trace cascade;

drop type if exists status_user;

drop function if exists insert_employees(uuid, varchar, varchar, varchar, varchar, integer, integer, varchar, varchar,
    varchar, varchar, integer) cascade;

create table identification_type (
                                     id serial primary key ,
                                     abbreviation varchar(5) unique not null ,
                                     name varchar unique not null
);
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (1, 'CC', 'Cedula de Ciudadania');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (2, 'TI', 'Tarjeta de Identidad');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (3, 'CE', 'Cedula de Extranjeria');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (4, 'P', 'Pasaporte');


create table department (
                            id serial primary key ,
                            abbreviation varchar(5) unique not null ,
                            name varchar unique not null
);
INSERT INTO public.department (id, abbreviation, name) VALUES (1, 'ADM', 'Administracion');
INSERT INTO public.department (id, abbreviation, name) VALUES (2, 'FIN', 'Financiera');
INSERT INTO public.department (id, abbreviation, name) VALUES (3, '', 'COMPRAS');
INSERT INTO public.department (id, abbreviation, name) VALUES (4, 'INF', 'Infraestructura');
INSERT INTO public.department (id, abbreviation, name) VALUES (5, 'OP', 'Operacion');
INSERT INTO public.department (id, abbreviation, name) VALUES (6, 'TH', 'Talento Humano');
INSERT INTO public.department (id, abbreviation, name) VALUES (7, 'SV', 'Servicios Varios');


create table countries
(
    id serial primary key,
    abbreviation varchar(5) unique not null ,
    name varchar unique not null,
    domain varchar unique not null
);
INSERT INTO public.countries (id, abbreviation, name, domain) VALUES (1, 'COL', 'Colombia', '@cidenet.com.co');
INSERT INTO public.countries (id, abbreviation, name, domain) VALUES (2, 'USA', 'Estados Unidos', '@cidenet.com.us');

create type status_user as enum ('enable', 'disable', 'stand-by');

create table employees
(
    id                     uuid         not null
        primary key,
    name             varchar(20)  not null,
    others_names           varchar(20),
    last_name        varchar(20)  not null,
    second_last_name       varchar(20)  not null,
    countries_id           integer
        constraint employees_countries_fk
            references countries
            on update cascade,
    identification_type_id integer
        constraint employees_identification_fk
            references identification_type
            on update cascade,
    identification_number  varchar(20)  not null,
    mail                   varchar(300) not null
        unique,
    admission              date    not null CHECK ( (admission <= current_timestamp) and (admission > current_timestamp - interval '1 month')),
    registration           timestamp    not null CHECK (registration >= admission),
    department_id          integer
        constraint employees_department_fk
            references department
            on update cascade on delete cascade,
    status                 status_user default 'enable'
);
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('a28bb51d-961a-4a09-97b8-90a847627afe', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('68d9e5ac-a147-41e7-a94f-2562cfb951df', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado1@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('3242b07b-8600-4b8e-afd4-111b47116a9a', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado2@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('0603848a-e623-4e60-b961-383fcb039cb1', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado3@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('4f8eec07-7bd4-4072-8f19-47b35b9be438', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gianlucca.aguado@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('03fdc57f-e9bf-47d0-a25a-255f4a7f894b', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gianlucca.aguado1@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('90b37096-2518-4ade-bdc3-f25393e65124', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gianlucca.aguado2@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');


create table users_trace
(
    id uuid primary key,
    user_id uuid not null
        constraint employees_fk
            references employees
            on update cascade on delete cascade,
    fields jsonb not null,
    modification  timestamp not null
);

create or replace function insert_employees(
    uuid_i uuid,
    name_i varchar, --validate in  back
    others_names_i varchar, --validate in  back
    last_name_i varchar, --validate in  back
    second_last_name_i varchar, --validate in  back
    countries_id_i int,
    identification_type_id_i int,
    identification_number_i varchar,
    email_cut_i  varchar, -- part generated in back
    admission_i varchar, --validate in  back
    registration_i varchar, --validate in  back
    department_id_i int
    )
    returns varchar
    language plpgsql
as
$$
DECLARE
string varchar;
    i_count_mail bigint = 0;
    i_count bigint = 0;

BEGIN

    -- PRUEBA
    /*
    select * from insert_employees(
            '2314cdbe-c6c2-4a16-a70b-92c149452eb1',
            'Laura',
            'Daniela',
            'Aguado',
            'Rendon',
            1,
            1,
            '00010',
            'laura.daniela',
            '2022-01-03',
            '2022-01-12 18:08:05.000000',
            4
    );
    */

    -----------------------------------       VALIDATE MAIL       -----------------------------------
    -- count the same emails to list them
    string := ' SELECT COUNT(*) FROM employees WHERE countries_id = ' || countries_id_i::varchar || ' AND  mail like '||chr(39)|| email_cut_i||'%' ||chr(39) ;
    --raise notice ' SUB QUERY 1 -> %', string;
EXECUTE string into i_count_mail;
-----------------------------------    END VALIDATE MAIL       -----------------------------------


-----------------------------------       VALIDATE IDENTIFICATION       -----------------------------------
string := ' SELECT COUNT(*) FROM employees WHERE identification_type_id = ' || identification_type_id_i::varchar || ' AND  identification_number = '||chr(39)|| identification_number_i ||chr(39) ;
    --raise notice ' SUB QUERY 2 -> %', string;
EXECUTE string into i_count;

IF i_count != 0 then
        RETURN 'invalid identification';
end if;
    -----------------------------------   END  VALIDATE IDENTIFICATION       -----------------------------------


    -----------------------------------      BUILD EMAIL      -----------------------------------
    string := ' SELECT domain FROM countries WHERE id = ' || countries_id_i::varchar ;
    --raise notice ' SUB QUERY 3 -> %', string;
EXECUTE string into string;

IF string is null then
        RETURN 'error in build email';
end if;

    IF i_count_mail = 0 then
        string := email_cut_i || i_count_mail::varchar || string;
ELSE
        string := email_cut_i ||(i_count_mail+1)::varchar || string;
end if;

    --raise notice ' EMAIL -> %', string;

    -----------------------------------  END  BUILD EMAIL      -----------------------------------

INSERT INTO employees values (
                                 uuid_i,
                                 name_i ,
                                 others_names_i ,
                                 last_name_i ,
                                 second_last_name_i ,
                                 countries_id_i ,
                                 identification_type_id_i,
                                 identification_number_i ,
                                 string  ,
                                 admission_i::date ,
                                 registration_i::timestamp,
                                 department_id_i
                             );

RETURN 'finished successfully';

EXCEPTION
    WHEN unique_violation THEN
        GET STACKED DIAGNOSTICS string = CONSTRAINT_NAME;
        RAISE EXCEPTION '%', string;
WHEN others THEN
        ROLLBACK;
        RAISE EXCEPTION
            USING ERRCODE = sqlstate
                ,MESSAGE = 'insert_employees() [' || sqlstate || '] : ' || sqlerrm;
END
$$;
 */