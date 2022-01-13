create table identification_type (
                                     id serial primary key ,
                                     abbreviation varchar(5) unique not null ,
                                     name varchar unique not null
);
create table department (
                            id serial primary key ,
                            abbreviation varchar(5) unique not null ,
                            name varchar unique not null
);
create table countries
(
    id serial primary key,
    abbreviation varchar(5) unique not null ,
    name varchar unique not null,
    domain varchar unique not null
);
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