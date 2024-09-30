/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Controladores;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.ZoneId;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            // TODO code application logic here
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres","postgres");
            //Procedimiento generar auditoria 
            CallableStatement ejecucion1 = conexion.prepareCall("call public.generar_auditoria_2(?,?)");            
            ejecucion1.setDate(1, java.sql.Date.valueOf(LocalDate.of(2020, 9, 22)));
            ejecucion1.setDate(2, java.sql.Date.valueOf(LocalDate.of(2020, 9, 24)));
            ejecucion1.execute();
            ejecucion1.close();
            //Procedimiento para simular ventas
            CallableStatement ejecucion2 = conexion.prepareCall("call public.simular_ventas_mes()"); 
            ejecucion2.execute();
            ejecucion2.close();
            //Funcion para hallar las transacciones totales en un mes para un empleado
            CallableStatement ejecucion3 = conexion.prepareCall("{call public.transacciones_total_mes(?,?)}"); 
            ejecucion3.setInt(1, 6);
            ejecucion3.setInt(2, 0);
            ResultSet resultado = ejecucion3.executeQuery();
            int transacciones = 0;
            while(resultado.next()){
                transacciones = resultado.getInt(1);
            }          
            System.out.println("Transacciones = " + transacciones);
            ejecucion3.execute();
            ejecucion3.close();
            //Funcion para hallar los servicios no pagados
            CallableStatement ejecucion4 = conexion.prepareCall("{call public.servicios_no_pagados_mes(?)}"); 
            ejecucion4.setInt(1, 6);
            ResultSet resultado2 = ejecucion4.executeQuery();
            BigDecimal monto = new BigDecimal(0);
            while(resultado2.next()){
                monto = resultado2.getBigDecimal(1);
            }          
            System.out.println("Monto total de los clientes que no han pagado = " + monto);
            ejecucion4.execute();
            ejecucion4.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
