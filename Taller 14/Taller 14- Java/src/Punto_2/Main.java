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
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres","postgres");
            //Procedimiento generar auditoria 
            CallableStatement ejecucion = conexion.prepareCall("call public.actualizar_libro(?,?)");            
            ejecucion.setInt(1, 5);
            ejecucion.setString(2, "<libros><libro><titulo>The Metamorphosis</titulo><autor>Franz Kafka</autor><año>1920</año></libro></libros>");
            ejecucion.execute();
            ejecucion.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    
}
