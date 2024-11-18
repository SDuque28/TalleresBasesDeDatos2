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
import org.bson.Document;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class EliminarDatos {
        public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        
        // Eliminar los 2 ultimos registros
        Document lastDocument1 = collection.find().sort(new Document("ProductoId", -1)).first();
        Document lastDocument2 = collection.find().sort(new Document("ProductoId", -1)).skip(1).first();

        collection.deleteOne(eq("ProductoId", lastDocument1.getInteger("ProductoId")));
        collection.deleteOne(eq("ProductoId", lastDocument2.getInteger("ProductoId")));
        
        System.out.println("Los dos últimos documentos han sido eliminados.");
    }
}
