/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Punto_3;

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
            CallableStatement ejecucion = conexion.prepareCall("{call public.obtener_autor_libro_por_isbn(?)}");            
            ejecucion.setInt(1, 5);
            ResultSet resultado = ejecucion.executeQuery();
            String autor = "";
            while(resultado.next()){
                autor = resultado.getString(1);
            } 
            System.out.println("El autor del libro es: " + autor);
            ejecucion.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    
}
