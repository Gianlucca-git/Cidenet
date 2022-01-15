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
            '2014cdbe-c6c2-4a16-a70b-92c149452eb2',
            'Laura',
            'Daniela',
            'Aguado',
            'Rendon',
            1,
            1,
            '000101',
            'laura.daniela',
            '2022-01-03',
            '2022-01-12 18:08:05.000000',
            4
    );
    */

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

    string := email_cut_i || identification_number_i::varchar|| '.' || identification_type_id_i::varchar  || string;
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