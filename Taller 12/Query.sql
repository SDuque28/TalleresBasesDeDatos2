CREATE TABLE public.empleado (
	nombre varchar NULL,
	identificacion int4 NOT NULL,
	edad int2 NULL,
	correo varchar NULL,
	salario float4 NULL,
	CONSTRAINT empleado_pk PRIMARY KEY (identificacion)
);

CREATE TABLE public.nominas (
	id_nomina int4 NOT NULL,
	fecha date NULL,
	total_ingresos float4 NULL,
	total_deducciones float4 NULL,
	total_neto float4 NULL,
	empleado_id int4 NULL,
	CONSTRAINT nominas_pk PRIMARY KEY (id_nomina),
	CONSTRAINT nominas_empleado_fk FOREIGN KEY (empleado_id) REFERENCES public.empleado(identificacion)
);

CREATE TABLE public.detalle_nomina (
	id_detalle int4 NOT NULL,
	concepto varchar NULL,
	tipo varchar NULL,
	nomina_id int4 NULL,
	CONSTRAINT detalle_nomina_pk PRIMARY KEY (id_detalle),
	CONSTRAINT detalle_nomina_nominas_fk FOREIGN KEY (nomina_id) REFERENCES public.nominas(id_nomina)
);

CREATE TABLE public.auditoria_nomina (
	id_auditoria int4 NOT NULL,
	fecha date NULL,
	nombre varchar NULL,
	identificacion int4 NULL,
	total_neto varchar NULL,
	CONSTRAINT auditoria_nomina_pk PRIMARY KEY (id_auditoria)
);

CREATE TABLE public.auditoria_empleado (
	fecha date NULL,
	nombre varchar NULL,
	identificacion int4 NULL,
	concepto varchar NULL,
	valor float4 NULL
);

CREATE OR REPLACE PROCEDURE insertar_empleados()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    v_nombre VARCHAR;
    v_identificacion INT;
    v_edad INT;
    v_correo VARCHAR;
    v_salario FLOAT4;
BEGIN
    FOR i IN 1..10 LOOP
        v_nombre := 'Santiago_' || i;
        v_identificacion := i;
        v_edad := FLOOR(RANDOM() * (30 - 10 + 1)) + 10; 
        v_correo := v_nombre || '@gmail.com';
        v_salario := ROUND(CAST(RANDOM() * (2000000 - 100000) + 100000 AS NUMERIC), 2);

        INSERT INTO empleado VALUES (v_nombre, v_identificacion, v_edad, v_correo, v_salario);
    END LOOP;
END;
$$;

CALL insertar_empleados(); 

CREATE OR REPLACE PROCEDURE generar_nominas()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    v_fecha DATE;
    v_total_ingresos FLOAT4;
    v_total_deducciones FLOAT4;
    v_total_neto FLOAT4;
    v_empleado_id INT;
BEGIN
    FOR i IN 1..10 LOOP
        v_fecha := '2024-01-01'::date + FLOOR(RANDOM() * 365)::int;
        
        v_total_ingresos := ROUND(CAST(RANDOM() * (200000 - 150000) + 150000 AS NUMERIC), 2); 
        v_total_deducciones := ROUND(CAST(RANDOM() * (100000 - 50000) + 50000 AS NUMERIC), 2); 
        v_total_neto := v_total_ingresos - v_total_deducciones;
        
        v_empleado_id := i;
        
        INSERT INTO nominas VALUES (i, v_fecha, v_total_ingresos, v_total_deducciones, v_total_neto, v_empleado_id);
    END LOOP;
END;
$$;

CALL generar_nominas();

CREATE OR REPLACE PROCEDURE generar_detalle_nomina()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    v_concepto VARCHAR;
    v_tipo VARCHAR;
    v_nomina_id INT;
    v_valor FLOAT4;
BEGIN
    FOR i IN 1..10 LOOP
        v_concepto := 'concepto ' || i;
        v_tipo := CASE WHEN RANDOM() < 0.5 THEN 'Ingreso' ELSE 'Deducción' END;
        v_valor := ROUND(CAST(RANDOM() * (140000 - 70000) + 70000 AS NUMERIC), 2);
        v_nomina_id := i;

        INSERT INTO detalle_nomina VALUES (i, v_concepto, v_tipo, v_nomina_id);
    END LOOP;
END;
$$;

CALL generar_detalle_nomina();

CREATE OR REPLACE FUNCTION validar_presupuesto_nomina()
RETURNS TRIGGER AS $$
DECLARE
    total_nominas FLOAT4;
BEGIN
    SELECT SUM(total_neto) INTO total_nominas
    FROM public.nominas;

    IF total_nominas + NEW.total_neto > 12000000 THEN
        RAISE EXCEPTION 'No se puede insertar la nómina. El total neto excede el presupuesto de 12,000,000';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_presupuesto_nomina
BEFORE INSERT ON public.nominas
FOR EACH ROW
EXECUTE FUNCTION validar_presupuesto_nomina();

INSERT INTO nominas VALUES (11, '2024-01-23'::Date,160125.36,52731.16,11000000,10);

CREATE OR REPLACE FUNCTION auditoria_nomina()
RETURNS TRIGGER AS $$
DECLARE
    v_nombre VARCHAR;
    v_identificacion INTEGER;
    nuevo_id_auditoria INTEGER;
BEGIN
    SELECT nombre, identificacion INTO v_nombre, v_identificacion
    FROM public.empleado WHERE identificacion = NEW.empleado_id;

    SELECT COALESCE(MAX(id_auditoria), 0) + 1 INTO nuevo_id_auditoria
    FROM public.auditoria_nomina;

    INSERT INTO public.auditoria_nomina VALUES (nuevo_id_auditoria, CURRENT_DATE, v_nombre, v_identificacion, NEW.total_neto);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_nomina
AFTER INSERT ON public.nominas
FOR EACH ROW
EXECUTE FUNCTION auditoria_nomina();

INSERT INTO nominas VALUES (11, '2024-06-06'::Date, 153200, 72100, 81100, 1);

CREATE OR REPLACE FUNCTION verificar_presupuesto_nomina()
RETURNS TRIGGER AS $$
DECLARE
    suma_actual_salarios NUMERIC;
BEGIN
    SELECT SUM(salario) INTO suma_actual_salarios
    FROM public.empleado WHERE identificacion != NEW.identificacion;

    IF (suma_actual_salarios + NEW.salario) > 12000000 THEN
        RAISE EXCEPTION 'El nuevo salario excede el presupuesto de nómina de 12,000,000';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_presupuesto_nomina
BEFORE UPDATE ON public.empleado
FOR EACH ROW
EXECUTE FUNCTION verificar_presupuesto_nomina();

UPDATE public.empleado SET salario = 12500 WHERE identificacion = 1;

CREATE OR REPLACE FUNCTION registrar_auditoria_empleado()
RETURNS TRIGGER AS $$
DECLARE
    v_concepto VARCHAR;
    v_diferencia FLOAT4;
BEGIN
    IF NEW.salario > OLD.salario THEN
        v_concepto := 'Aumento';
    ELSE
        v_concepto := 'Disminucion';
    END IF;
	 v_diferencia := NEW.salario - OLD.salario;

    INSERT INTO public.auditoria_empleado VALUES (CURRENT_DATE, NEW.nombre, NEW.identificacion, v_concepto, v_diferencia);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_empleado
AFTER UPDATE ON public.empleado
FOR EACH ROW
WHEN (OLD.salario IS DISTINCT FROM NEW.salario) 
EXECUTE FUNCTION registrar_auditoria_empleado();

UPDATE public.empleado SET salario = 250000 WHERE identificacion = 1;