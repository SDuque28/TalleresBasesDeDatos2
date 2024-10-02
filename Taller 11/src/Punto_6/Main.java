/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Punto_6;

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
            CallableStatement cs = conn.prepareCall("{ ? = CALL TALLERESBD2.total_por_contrato(?) }");

            // Registrar el primer parámetro como cursor
            cs.registerOutParameter(1, OracleTypes.CURSOR);

            // Establecer el ID de contrato como parámetro de entrada
            cs.setInt(2, 1);  // Por ejemplo, para el ID de contrato 1

            // Ejecutar la función
            cs.execute();

            // Obtener el cursor de resultados
            ResultSet rs = (ResultSet) cs.getObject(1);

            // Recorrer los resultados
            while (rs.next()) {
                String nombreEmpleado = rs.getString("nombre");
                Date fechaPago = rs.getDate("fecha_pago");
                String año = rs.getString("año");
                String mes = rs.getString("mes");
                float totalDevengado = rs.getFloat("total_devengado");
                float totalDeducciones = rs.getFloat("total_deducciones");
                float totalNomina = rs.getFloat("total");

                // Mostrar los resultados en la consola
                System.out.println("Nombre: " + nombreEmpleado);
                System.out.println("Fecha de Pago: " + fechaPago);
                System.out.println("Ano: " + año);
                System.out.println("Mes: " + mes);
                System.out.println("Total Devengado: " + totalDevengado);
                System.out.println("Total Deducciones: " + totalDeducciones);
                System.out.println("Total Nomina: " + totalNomina);
                System.out.println("-----------------------------------");
            }
            // Cerrar ResultSet, CallableStatement y Connection
            
            cs.execute();
            cs.close();
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }        
    }
}
