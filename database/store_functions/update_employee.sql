
create or replace function update_employee(
    uuid_i uuid,
    name_i varchar,
    others_names_i varchar,
    last_name_i varchar,
    second_last_name_i varchar,
    countries_id_i int,
    identification_type_id_i int,
    identification_number_i varchar,
    department_id_i int,
    status_i status_user,
    uuid_trace_i uuid
)
    returns varchar
    language plpgsql
as
$$
DECLARE
s_json                  json;
    s_sql                   varchar;
    --
    name_                   varchar;
    others_names_           varchar;
    last_name_              varchar;
    second_last_name_       varchar;
    countries_id_           int;
    identification_type_id_ int;
    identification_number_  varchar;
    department_id_          int;
    status_                 status_user;
    --
    mail_                   varchar;
domain                  varchar;
    --
    update_row              bool = false ;
    build_email             bool = false ;


BEGIN

    -- TRAER EL REGISTRO ACTUAL
    s_sql := 'SELECT  name,others_names,last_name,second_last_name, countries_id,' ||
             'identification_type_id,identification_number,department_id,status, mail ' ||
             ' FROM employees WHERE  id = ' || chr(39) || uuid_i || chr(39) || '';
    --raise notice ' s_sql %', s_sql;
Execute s_sql
    into name_,others_names_,last_name_,second_last_name_,
        countries_id_,identification_type_id_,identification_number_,
        department_id_,status_,mail_;

if name_i != name_ then
        update_row := true;
        build_email := true;
        --raise notice ' log 1';
end if;
    if not (update_row) and (others_names_i != others_names_) then
        update_row := true;
        --raise notice ' log 2';
end if;
    if not (update_row) and (last_name_i != last_name_) then
        update_row := true;
        build_email := true;
        --raise notice ' log 3';
end if;
    if not (update_row) and (second_last_name_i != second_last_name_) then
        update_row := true;
        --raise notice ' log 4';
end if;
    if not (update_row) and (identification_type_id_i != identification_type_id_) then
        update_row := true;
        build_email := true;
        -- raise notice ' log 5';
end if;
    if not (update_row) and (identification_number_i != identification_number_) then
        build_email := true;
        update_row := true;
        --raise notice ' log 6';
end if;
    if not (update_row) and (department_id_i != department_id_) then
        update_row := true;
        --raise notice ' log 7';
end if;
    if not (update_row) and (status_i != status_) then
        update_row := true;
        --raise notice ' log 8';
end if;
    if not (update_row) and (countries_id_i != countries_id_) then
        update_row := true;
        build_email := true;
        --raise notice ' log 9';
end if;

    if not (update_row) then
        return 'no update';
end if;

    -----------------------------------    DYNAMIC  BUILD EMAIL      -----------------------------------
    if build_email then

        if countries_id_i = 0 then

            s_sql := ' SELECT domain FROM countries WHERE id = ' || countries_id_::varchar;
            --raise notice ' SUB QUERY 3 -> %', s_sql;
EXECUTE s_sql into domain;
else

            s_sql := ' SELECT domain FROM countries WHERE id = ' || countries_id_i::varchar;
            --raise notice ' SUB QUERY 3 -> %', s_sql;
EXECUTE s_sql into domain;
end if;

        IF domain is null then
            RETURN 'error in build email';
end if;

        if name_i = '' then
            mail_ := name_;
else
            mail_ := name_i;
end if;

        if last_name_i = '' then
            mail_ := mail_ || '.' || last_name_;
else
            mail_ := mail_ || '.' || last_name_i;
end if;

        if identification_number_i = '' then
            mail_ := mail_ || identification_number_;
else
            mail_ := mail_ || identification_number_i;
end if;

        if identification_type_id_i = 0 then
            mail_ := mail_ || '.' || identification_type_id_::varchar;
else
            mail_ := mail_ || '.' || identification_type_id_i::varchar;
end if;

        mail_ := mail_ || domain;

        --raise notice ' EMAIL -> %', mail_;
end if;

    -----------------------------------  END  BUILD EMAIL      -----------------------------------

    -- ACTUALIZAR A NUEVO REGISTRO
UPDATE "employees"
SET "name"                   = COALESCE(NULLIF(name_i, ''), "name"),
    "others_names"           = COALESCE(NULLIF(others_names_i, ''), "others_names"),
    "last_name"              = COALESCE(NULLIF(last_name_i, ''), "last_name"),
    "second_last_name"       = COALESCE(NULLIF(second_last_name_i, ''), "second_last_name"),
    "countries_id"           = COALESCE(NULLIF(countries_id_i, 0), "countries_id"),
    "identification_type_id" = COALESCE(NULLIF(identification_type_id_i, 0), "identification_type_id"),
    "identification_number"  = COALESCE(NULLIF(identification_number_i, ''), "identification_number"),
    "mail"                   = COALESCE(NULLIF(mail_, ''), "mail"),
    "admission"              = "admission",
    "registration"           = "registration",
    "department_id"          = COALESCE(NULLIF(department_id_i, 0), "department_id"),
    "status"                 = (COALESCE(NULLIF((status_i::varchar), ''), "mail"))::status_user

WHERE id = uuid_i;


s_json := '{"name": "' || name_ || '", ' ||
              '"others_names": "' || others_names_ || '", ' ||
              '"last_name": "' || last_name_ || '", ' ||
              '"second_last_name": "' || second_last_name_ || '", ' ||
              '"countries_id": "' || countries_id_ || '", ' ||
              '"identification_type_id": "' || identification_type_id_ || '", ' ||
              '"identification_number": "' || identification_number_ || '", ' ||
              '"mail": "' || mail_ || '", ' ||
              '"department_id": "' || department_id_ || '", ' ||
              '"status": "' || status_ || '" ' ||
              ' }';


INSERT INTO users_trace
values (uuid_trace_i,
        uuid_i,
        s_json::jsonb,
        current_timestamp);

return 'finish';

EXCEPTION
    WHEN others THEN
        ROLLBACK;
        RAISE EXCEPTION
            USING ERRCODE = sqlstate
                ,MESSAGE = 'update_employee [' || sqlstate || '] : ' || sqlerrm;
END
$$;