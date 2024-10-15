/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Punto_4;

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
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres","postgres");
            //Procedimiento generar auditoria 
            CallableStatement ejecucion = conexion.prepareCall("{call public.obtener_libros_por_año(?)}");            
            ejecucion.setString(1, "1948");
            ResultSet resultado = ejecucion.executeQuery();
            while(resultado.next()){
                System.out.println("Autor: " + resultado.getString("autor"));
                System.out.println("Titulo: " + resultado.getString("titulo"));
            } 
            ejecucion.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    
}
