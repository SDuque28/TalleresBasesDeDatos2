/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Punto_2;

import java.sql.*;

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
            CallableStatement ejecucion = conexion.prepareCall("{call public.total_por_contrato(?)}"); 
            ejecucion.setInt(1, 1); 
            ResultSet resultado = ejecucion.executeQuery();
            while(resultado.next()){
                System.out.println("Nombre: " + resultado.getString("nombre_empleado"));
                System.out.println("Fecha Pago: " + resultado.getDate("fecha_pago"));
                System.out.println("Ano: " + resultado.getString("año"));
                System.out.println("Mes: " + resultado.getString("mes"));
                System.out.println("Total Devengado: " + resultado.getFloat("total_devengado"));
                System.out.println("Total Deducciones: " + resultado.getFloat("total_deducciones"));
                System.out.println("Total Nomina: " + resultado.getFloat("total_nomina"));
            }          
            ejecucion.execute();
            ejecucion.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    
}
