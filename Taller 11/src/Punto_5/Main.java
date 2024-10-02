/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Punto_5;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.pool.OracleDataSource;

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
        Main main = new Main();
        main.Conectar();
    }
    
    public void Conectar(){
        try {
            OracleDataSource od;
            od = new OracleDataSource();
            od.setURL("jdbc:oracle:thin:@//localhost:1521/XEPDB1");
            od.setUser("system");
            od.setPassword("postgres");

            Connection conn = od.getConnection();
            CallableStatement cs = conn.prepareCall("{? = CALL TALLERESBD2.obtener_nomina_empleado(?, ?, ?)}");
            cs.registerOutParameter(1, OracleTypes.CURSOR); 

            cs.setString(2, "1"); 
            cs.setString(3, "3"); 
            cs.setString(4, "2000"); 

            // Ejecutar la función
            cs.execute();

            // Obtener el cursor
            ResultSet rs = (ResultSet) cs.getObject(1);

            // Procesar los resultados
            while (rs.next()) {
                String nombreEmpleado = rs.getString("nombre");
                float totalDevengado = rs.getFloat("total_devengado");
                float totalDeducciones = rs.getFloat("total_deducciones");
                float totalNomina = rs.getFloat("total");

                // Mostrar en pantalla
                System.out.println("Empleado: " + nombreEmpleado + 
                                   "\nTotal Devengado: " + totalDevengado + 
                                   "\nTotal Deducciones: " + totalDeducciones + 
                                   "\nTotal Nomina: " + totalNomina);
            }
            
            cs.execute();
            cs.close();
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }        
    }
}
