/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Punto_4;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
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
            CallableStatement cs = conn.prepareCall("{CALL TALLERESBD2.generar_auditoria(?,?)}");

            java.util.Calendar calendar = java.util.Calendar.getInstance();
            calendar.set(2024, java.util.Calendar.SEPTEMBER, 12); 
            Date fechaInicio = new Date(calendar.getTimeInMillis());

            calendar.set(2024, java.util.Calendar.OCTOBER, 23); 
            Date fechaFin = new Date(calendar.getTimeInMillis());

            cs.setDate(1, fechaInicio);
            cs.setDate(2, fechaFin);

            cs.execute();
            cs.close();
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }        
    }
}
