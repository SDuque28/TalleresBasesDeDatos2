CREATE DATABASE postgres
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE IF NOT EXISTS public."Clientes"
(
    "Identificacion" integer NOT NULL,
    "Nombre" text COLLATE pg_catalog."default",
    "Edad" smallint,
    "Correo" text COLLATE pg_catalog."default",
    CONSTRAINT "Clientes_pkey" PRIMARY KEY ("Identificacion")
)

CREATE TABLE IF NOT EXISTS public."Productos"
(
    "Codigo" integer NOT NULL,
    "Nombre" text COLLATE pg_catalog."default",
    "Stock" boolean,
    "Valor_unitario" real,
    CONSTRAINT "Productos_pkey" PRIMARY KEY ("Codigo")
)

CREATE TABLE IF NOT EXISTS public."Pedidos"
(
    "Fecha" text COLLATE pg_catalog."default",
    "Cantidad" smallint,
    "Valor_total" real,
    "Producto_id" integer,
    "Cliente_id" integer,
    CONSTRAINT cliente_id_fk FOREIGN KEY ("Cliente_id")
        REFERENCES public."Clientes" ("Identificacion") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT producto_id_fk FOREIGN KEY ("Producto_id")
        REFERENCES public."Productos" ("Codigo") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

BEGIN;
INSERT INTO "Clientes"("Identificacion", "Nombre", "Edad", "Correo")
VALUES (0, 'Santiago Duque', 22, 'santiago.duquer@gmail.com'),
	   (1, 'Juan Pérez', 30, 'juan.perez@example.com'),
	   (2, 'María Gómez', 25, 'maria.gomez@example.com');

UPDATE "Clientes"
SET "Nombre" = 'Santiago Duque R', "Edad" = 23
WHERE "Identificacion" = 0;

UPDATE "Clientes"
SET "Correo" = 'maria.gomez.updated@example.com'
WHERE "Nombre" = 'María Gómez';

DELETE FROM "Clientes"
WHERE "Identificacion" = 2;
ROLLBACK;