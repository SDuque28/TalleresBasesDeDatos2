/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controladores;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import org.bson.conversions.Bson;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class Punto3 {
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");  
        crearReserva(mongoDatabase);
    }
    
    public static void crearReserva(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("reservas");
        Document cliente = new Document("nombre","Santiago").append("correo", "santiago@gmail.com")
                                                            .append("telefono", "32178952654")
                                                            .append("direccion", "Calle Siempre Viva");
        Document habitacion = new Document("tipo","suite").append("numero", 101)
                                                          .append("precio_noche", 204.3)
                                                          .append("capacidad", 2)
                                                          .append("descripcion", "Linda suite");
        Document reserva = new Document("_id", "reserva001").append("cliente", cliente)
                                                            .append("habitacion", habitacion)
                                                            .append("fecha_entrada", "2024-01-22")
                                                            .append("fecha_salida", "2024-02-22")
                                                            .append("total", 740.00)
                                                            .append("estado_pago", "Pagado")
                                                            .append("metodo_pago", "Tarjeta")
                                                            .append("fecha_reserva", "2024-01-13");
        collection.insertOne(reserva);
        System.out.println("Se creo la reserva");
    }
    
    public static void modificarReserva(MongoDatabase mongoDatabase, String id, int total){
        MongoCollection<Document> collection = mongoDatabase.getCollection("reservas");
        Bson filter = eq("_id",id);
        Bson updates = set("total",total);
        collection.updateOne(filter,updates);
        System.out.println("Se modifico la reserva");
    }
    
    public static void eliminarReserva(MongoDatabase mongoDatabase, String id){
        MongoCollection<Document> collection = mongoDatabase.getCollection("reservas");
        Bson filter = eq("_id",id);
        collection.deleteOne(filter);
        System.out.println("Se elimino la reserva");
    }
}
