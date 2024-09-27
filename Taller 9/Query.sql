CREATE TABLE public.empleados (
	id_empleado int4 NOT NULL,
	nombre varchar NULL,
	identificación varchar NULL,
	contrato_id int4 NULL,
	CONSTRAINT empleados_pk PRIMARY KEY (id_empleado),
	CONSTRAINT empleados_tipo_contrato_fk FOREIGN KEY (contrato_id) REFERENCES public.tipo_contrato(id_contrato)
);

CREATE TABLE public.tipo_contrato (
	id_contrato int4 NOT NULL,
	descripcion varchar NULL,
	cargo varchar NULL,
	salario_total float4 NULL,
	CONSTRAINT tipo_contrato_pk PRIMARY KEY (id_contrato)
);

CREATE TABLE public.nomina (
	id_nomina int4 NOT NULL,
	mes varchar NULL,
	año varchar NULL,
	fecha_pago date NULL,
	total_devengado float4 NULL,
	total_deducciones float4 NULL,
	total float4 NULL,
	empleado_id int4 NULL,
	CONSTRAINT nomina_pk PRIMARY KEY (id_nomina),
	CONSTRAINT nomina_empleados_fk FOREIGN KEY (empleado_id) REFERENCES public.empleados(id_empleado)
);

CREATE TABLE public.detalles_nomina (
	id_detalles_nomina int4 NULL,
	concepto_id int4 NULL,
	valor float4 NULL,
	nomina_id int4 NULL,
	CONSTRAINT detalles_nomina_conceptos_fk FOREIGN KEY (concepto_id) REFERENCES public.conceptos(id_concepto),
	CONSTRAINT detalles_nomina_nomina_fk FOREIGN KEY (nomina_id) REFERENCES public.nomina(id_nomina)
);


CREATE OR REPLACE PROCEDURE generar_contratos()
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO public.tipo_contrato (id_contrato, descripcion, cargo, salario_total)
        VALUES (
            i, 
            'descripcion ' || i, 
            'cargo ' || i, 
            (100000 + (RANDOM() * (800000 - 100000)))::numeric
        );
    END LOOP;
END;
$$;

call generar_contratos();

CREATE OR REPLACE PROCEDURE generar_empleados()
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO public.empleados
        VALUES (
            i, 
            'santiago ' || i, 
            (100000000 + (i * 20000000))::varchar, 
            i 
        );
    END LOOP;
END;
$$;

call generar_empleados();

CREATE OR REPLACE PROCEDURE generar_conceptos()
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 1..15 LOOP
        INSERT INTO public.conceptos
        VALUES (
            i,
            'daniela ' || i, 
            (50000 + (RANDOM() * (100000 - 50000)))::float4,  
            (1 + TRUNC(RANDOM() * 20))::int2,  
            (10000 + (RANDOM() * (50000 - 10000)))::float4,  
            (10000 + (RANDOM() * (50000 - 10000)))::float4,  
            (1 + TRUNC(RANDOM() * 50))::int2  
        );
    END LOOP;
END;
$$;

call generar_conceptos();

CREATE OR REPLACE PROCEDURE generar_nominas()
LANGUAGE plpgsql
AS $$
DECLARE
    mes_random int;
    año_random int;
    dia_random int;
    total_devengado float4;
    total_deducciones float4;
BEGIN
    FOR i IN 1..5 LOOP
        mes_random := (1 + TRUNC(RANDOM() * 12))::int;
        año_random := (2000 + TRUNC(RANDOM() * 25))::int;
        dia_random := (1 + TRUNC(RANDOM() * 28))::int;  
        
        total_devengado := (80000 + (RANDOM() * (100000 - 80000)))::float4;
        total_deducciones := (40000 + (RANDOM() * (70000 - 40000)))::float4;
        
        INSERT INTO public.nomina 
        VALUES (
            i,
            mes_random::varchar, 
            año_random::varchar,
            MAKE_DATE(año_random, mes_random, dia_random),  -- Generar fecha de pago con el mes y año
            total_devengado,
            total_deducciones,
            total_devengado - total_deducciones,  -- Total es la resta entre devengado y deducciones
            i  -- empleado_id va de 1 a 5
        );
    END LOOP;
END;
$$;

call generar_nominas();

CREATE OR REPLACE PROCEDURE generar_detalles_nomina()
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 1..15 LOOP
        INSERT INTO public.detalles_nomina (id_detalles_nomina, concepto_id, valor, nomina_id)
        VALUES (
            i,
            i,  
            (50000 + (RANDOM() * (100000 - 50000)))::float4,  
            (1 + TRUNC(RANDOM() * 5))::int4  
        );
    END LOOP;
END;
$$;

call generar_detalles_nomina();

CREATE OR REPLACE FUNCTION obtener_nomina_empleado(
    p_identificacion varchar, 
    p_mes varchar, 
    p_año varchar
)
RETURNS TABLE (
    nombre_empleado varchar,
    total_devengado float4,
    total_deducciones float4,
    total_nomina float4
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.nombre, n.total_devengado, n.total_deducciones, n.total
	FROM empleados e
    JOIN nomina n ON e.id_empleado = n.empleado_id
    WHERE e.identificación = p_identificacion  AND n.mes = p_mes  AND n.año = p_año;
END;
$$;

SELECT * FROM obtener_nomina_empleado('120000000', '3', '2008');

CREATE OR REPLACE FUNCTION total_por_contrato(
    p_id_contrato int
)
RETURNS TABLE (
    nombre_empleado varchar,
    fecha_pago date,
    año varchar,
    mes varchar,
    total_devengado float4,
    total_deducciones float4,
    total_nomina float4
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.nombre, n.fecha_pago, n.año, n.mes, n.total_devengado, n.total_deducciones, n.total
    FROM public.empleados e
    JOIN public.nomina n ON e.id_empleado = n.empleado_id
    JOIN public.tipo_contrato tc ON e.contrato_id = tc.id_contrato
    WHERE tc.id_contrato = p_id_contrato;
END;
$$;

SELECT * FROM total_por_contrato(1);