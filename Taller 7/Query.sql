INSERT INTO TALLERESBD2.EMPLEADOS VALUES (1,'Santiago',155200);

CREATE OR REPLACE PROCEDURE aumentar_salario(
	p_identificacion IN VARCHAR,
	p_aumento IN NUMBER 
)
IS 
BEGIN 
	UPDATE EMPLEADOS SET salario = salario + p_aumento
	WHERE identificacion = p_identificacion;
	DBMS_OUTPUT.PUT_LINE('Se actualizo el aumento al empleado');
END;

CALL TALLERESBD2.AUMENTAR_SALARIO(1,200); 

CREATE OR REPLACE PROCEDURE verificar_edad
IS 
	edad NUMBER := 25;
BEGIN
	IF edad >= 18 THEN
		DBMS_OUTPUT.PUT_LINE('Es mayor de edad');
	END IF;
END;
		
CALL VERIFICAR_EDAD(); 

CREATE OR REPLACE PROCEDURE verificar_stock_2(
	p_producto_id IN NUMBER, 
	p_catidad_compra IN NUMBER)
IS 
	stock_producto NUMBER;
	total NUMBER;
BEGIN
	SELECT stock INTO stock_producto FROM productos WHERE codigo = p_producto_id;
	total := stock_producto - p_catidad_compra;
	IF total >= 0 THEN 
		DBMS_OUTPUT.PUT_LINE('Hay suficiente stock');
	ELSE
		DBMS_OUTPUT.PUT_LINE('No hay suficiente stock');
	END IF;
END;

CALL VERIFICAR_STOCK_2(1,22);