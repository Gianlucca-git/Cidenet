INSERT INTO public.identification_type (id, abbreviation, name) VALUES (1, 'CC', 'Cedula de Ciudadania');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (2, 'TI', 'Tarjeta de Identidad');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (3, 'CE', 'Cedula de Extranjeria');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (4, 'P', 'Pasaporte');

INSERT INTO public.department (id, abbreviation, name) VALUES (1, 'ADM', 'Administracion');
INSERT INTO public.department (id, abbreviation, name) VALUES (2, 'FIN', 'Financiera');
INSERT INTO public.department (id, abbreviation, name) VALUES (3, '', 'COMPRAS');
INSERT INTO public.department (id, abbreviation, name) VALUES (4, 'INF', 'Infraestructura');
INSERT INTO public.department (id, abbreviation, name) VALUES (5, 'OP', 'Operacion');
INSERT INTO public.department (id, abbreviation, name) VALUES (6, 'TH', 'Talento Humano');
INSERT INTO public.department (id, abbreviation, name) VALUES (7, 'SV', 'Servicios Varios');

INSERT INTO public.countries (id, abbreviation, name, domain) VALUES (1, 'COL', 'Colombia', '@cidenet.com.co');
INSERT INTO public.countries (id, abbreviation, name, domain) VALUES (2, 'USA', 'Estados Unidos', '@cidenet.com.us');

INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('2314cdbe-c6c2-4a16-a70b-92c149452eb1', 'Laura', 'Daniela', 'Aguado', 'Rendon', 1, 1, '00010', 'laura.daniela0@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('a28bb51d-961a-4a09-97b8-90a847627afe', 'Andres', 'Lucca', 'Kennedy', 'Rendon', 1, 1, '1116238356', 'andres.kennedy@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('0603848a-e623-4e60-b961-383fcb039cb1', 'Aura', '', 'Cadena', 'Rendon', 1, 1, '1116238356', 'aura.cadena@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('4f8eec07-7bd4-4072-8f19-47b35b9be438', 'Luis', 'Lucca', 'Ocampo', 'Rendon', 2, 1, '1116238356', 'luis.ocampo@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('68d9e5ac-a147-41e7-a94f-2562cfb951df', 'Carlos', 'Lucca', 'Mendoza', 'Rendon', 1, 1, '1116238356', 'carlos.mendoza@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('90b37096-2518-4ade-bdc3-f25393e65124', 'Gian', '', 'Lopez', 'Rendon', 2, 1, '1116238356', 'gian.lopez@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('03fdc57f-e9bf-47d0-a25a-255f4a7f894b', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gian.aguado@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('60e1ec05-49c6-4944-807e-afc96d26c4bf', 'Nancy', 'Lucca', 'Parra', 'Ocampo', 1, 1, '1001', 'nancy.parra@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('c822c1e2-247d-4bb2-83fd-daf82773afd2', 'alberto', 'alfoso', 'de la calle', 'Ruiz', 1, 1, '01', 'alberto.delacalle@cidenet.com.co', '2022-01-03', '2022-01-12 13:00:00.000000', 4, 'enable');
