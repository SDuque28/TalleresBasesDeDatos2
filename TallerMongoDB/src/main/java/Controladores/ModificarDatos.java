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
import static com.mongodb.client.model.Updates.*;
import org.bson.Document;
import org.bson.conversions.Bson;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class ModificarDatos {
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        
        // Actualizar 5 registros
        for (int i = 11; i <= 15; i++) {
            Bson filter = eq("ProductoId", i);

            Bson updates = combine(
                    set("Precio", 999), 
                    push("Comentarios", new Document("ComentarioId", 3) 
                            .append("Texto", "Actualización automática")
                            .append("Cliente", "Usuario de Pruebas"))
            );

            collection.updateOne(filter, updates);
        }
        System.out.println("5 documentos actualizados correctamente.");
    }
}
