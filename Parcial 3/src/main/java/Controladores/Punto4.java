/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controladores;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;
import org.bson.Document;
import org.bson.conversions.Bson;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class Punto4 {
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");  
        habitacionesSencilla(mongoDatabase);
        precio_noche(mongoDatabase);
    }
    
    public static void habitacionesSencilla(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("reservas");
        Bson filter = eq("habitacion.tipo","Sencilla");
        MongoCursor<Document> cursor = collection.find(filter).iterator();
        System.out.println("Habitaciones de tipo sencilla:");
        while (cursor.hasNext()) {
            Document document = cursor.next();
            System.out.println(document.toJson());
        }        
    }
    
    public static void precio_noche(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("reservas");
        Bson filter = gt("habitacion.precio_noche",100);
        MongoCursor<Document> cursor = collection.find(filter).iterator();
        System.out.println("Habitaciones con el precio noche mayor a 100:");
        while (cursor.hasNext()) {
            Document document = cursor.next();
            System.out.println(document.toJson());
        }    
    }
}
