create or replace function select_employees(
    search_i varchar, --name , others_names, last_name, second_last_name, identification_number, mail
    countries_i varchar[],
    identifications_types_i varchar[],
    departments_i varchar[],
    status_i varchar,
    cursor_i varchar,
    limit_i int
)
    returns table
            (
                total_rows              int,
                uuid_o                  uuid,
                name_o                  varchar,
                others_names_o          varchar,
                last_name_o             varchar,
                second_last_name_o      varchar,
                country_o               varchar,
                identification_type_o   varchar,
                identification_number_o varchar,
                mail_o                  varchar,
                department_o            varchar,
                status                  status_user
            )
    language plpgsql
as
$$
DECLARE
i_iterator int = 1;
    i_total    bigint ;
    s_select   varchar;
    s_from     varchar;
    s_where    varchar;
    s_sql      varchar;

BEGIN


    /*
     select * from select_employees(
        '',
        array [''],
        array [''],
        array [''],
        'enable',
        '(''Gian'',''03fdc57f-e9bf-47d0-a25a-255f4a7f894b'')',
        2
    );
     */


    s_from := ' FROM employees e, countries c, identification_type i, department d ';
    s_where := ' WHERE  e.countries_id = c.id AND e.identification_type_id = i.id AND e.department_id = d.id ';


    -- FILTRO DE BUSQUEDA -------------- BY --> name , others_names, last_name, second_last_name, identification_number, mail
    if (search_i != '') then
        s_where := s_where
                       || ' AND ( '
                       || '  lower(e.name) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR lower(e.others_names) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR  lower(e.last_name) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR  lower(e.second_last_name) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR  lower(e.identification_number) LIKE ' || chr(39) || '%' || lower(search_i) || '%' ||
                   chr(39)
                       || ' OR  lower(e.mail) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
            || ' ) ';
end if;
    -- FIN FILTRO DE BUSQUEDA -------------------------------------


    --  FILTRO DE PAISES -------------------------------------
    -- los arrays empieza su indece en 1
    if array_length(countries_i, 1) > 0 then
        if countries_i[1] != '' then
            s_where := s_where || ' AND (  c.id = ' || chr(39) || countries_i[1] || chr(39) || ' ';
            loop
i_iterator := i_iterator + 1;
                exit when i_iterator > array_length(countries_i, 1);
                s_where := s_where || ' OR  c.id = ' || chr(39) || countries_i[i_iterator] || chr(39) || ' ';
end loop;
            s_where := s_where || ' ) ' || ' ';
end if;
end if;
    i_iterator := 1;
    --   FIN FILTRO DE PAISES-------------------------------------


    --  FILTRO DE TIPO DE DOCUMENTO -------------------------------------
    if array_length(identifications_types_i, 1) > 0 then
        if identifications_types_i[1] != '' then
            s_where := s_where || ' AND (  i.id = ' || chr(39) || identifications_types_i[1] || chr(39) || ' ';
            loop
i_iterator := i_iterator + 1;
                exit when i_iterator > array_length(identifications_types_i, 1);
                s_where := s_where || ' OR  i.id = ' || chr(39) || identifications_types_i[i_iterator] || chr(39) ||
                           ' ';
end loop;
            s_where := s_where || ' ) ' || ' ';
end if;
end if;
    i_iterator := 1;
    --   FIN FILTRO DE DOCUMENTO-------------------------------------


    --  FILTRO DE DEPARTAMENTOS -------------------------------------
    if array_length(departments_i, 1) > 0 then
        if departments_i[1] != '' then
            s_where := s_where || ' AND (  d.id = ' || chr(39) || departments_i[1] || chr(39) || ' ';
            loop
i_iterator := i_iterator + 1;
                exit when i_iterator > array_length(departments_i, 1);
                s_where := s_where || ' OR  d.id = ' || chr(39) || departments_i[i_iterator] || chr(39) || ' ';
end loop;
            s_where := s_where || ' ) ' || ' ';
end if;
end if;
    i_iterator := 1;
    --   FIN FILTRO DE DEPARTAMENTOS -------------------------------------


    --   FIN FILTRO ESTADO
    if status_i != '' then
        s_where := s_where || ' AND  e.status  = ' || chr(39) || status_i || chr(39);
end if;


    -- COUNT TOTAL
execute ' SELECT count(*) ' || s_from || s_where into i_total;

s_select := ' SELECT ' || i_total::varchar || '::int as total , e.id, e.name,e.others_names,e.last_name,e.second_last_name,c.name,i.name,' ||
                ' e.identification_number,e.mail,d.name,e.status';

        -- PAGINACION   -----------------------------
            if cursor_i != '' then
    s_where := s_where || ' AND  (e.name, e.id)  >  ' || cursor_i;
end if;
    -- FIN PAGINACION   -----------------------------


    if limit_i > 0 then
        s_sql := s_select || s_from || s_where || ' ORDER BY e.name, e.id LIMIT ' || limit_i::varchar;
else
        s_sql := s_select || s_from || s_where || ' ORDER BY e.name, e.id ' ;
end if;


    -- raise notice 'QUERY -> %', s_sql;
RETURN QUERY EXECUTE s_sql;

EXCEPTION
    WHEN others THEN
        ROLLBACK;
        RAISE EXCEPTION
            USING ERRCODE = sqlstate
                ,MESSAGE = 'select_employees() [' || sqlstate || '] : ' || sqlerrm;
END
$$;