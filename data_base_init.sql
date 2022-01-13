GRANT
ALL
ON DATABASE "cidenet-db" TO postgres;

/*
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
    first_name             varchar(20)  not null,
    others_names           varchar(20),
    first_last_name        varchar(20)  not null,
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
INSERT INTO public.employees (id, first_name, others_names, first_last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('a28bb51d-961a-4a09-97b8-90a847627afe', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, first_name, others_names, first_last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('68d9e5ac-a147-41e7-a94f-2562cfb951df', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado1@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, first_name, others_names, first_last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('3242b07b-8600-4b8e-afd4-111b47116a9a', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado2@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, first_name, others_names, first_last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('0603848a-e623-4e60-b961-383fcb039cb1', 'Gian', 'Lucca', 'Aguado', 'Rendon', 1, 1, '1116238356', 'gianlucca.aguado3@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, first_name, others_names, first_last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('4f8eec07-7bd4-4072-8f19-47b35b9be438', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gianlucca.aguado@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, first_name, others_names, first_last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('03fdc57f-e9bf-47d0-a25a-255f4a7f894b', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gianlucca.aguado1@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, first_name, others_names, first_last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('90b37096-2518-4ade-bdc3-f25393e65124', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gianlucca.aguado2@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');


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

 */