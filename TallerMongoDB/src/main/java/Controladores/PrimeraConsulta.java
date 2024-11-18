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
import static com.mongodb.client.model.Filters.gt;
import org.bson.Document;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class PrimeraConsulta {
        public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        
        // Consultar productos con precio mayor a 10 dólares
        MongoCursor<Document> cursor = collection.find(gt("Precio", 10)).iterator();

        System.out.println("Productos con precio mayor a 10 dólares:");
        while (cursor.hasNext()) {
            Document document = cursor.next();
            System.out.println(document.toJson());
        }

        cursor.close();
    }
}
