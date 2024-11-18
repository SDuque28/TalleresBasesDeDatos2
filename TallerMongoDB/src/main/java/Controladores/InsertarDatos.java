/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package Controladores;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.bson.Document;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class InsertarDatos {

    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        
        // Crear 10 documentos
        List<Document> documentos = new ArrayList<>();
        for (int i = 11; i < 21; i++) {
            Document categoria = new Document("CategoriaId", 1)
                    .append("NombreCategoria", "Electrónica");

            List<Document> comentarios = Arrays.asList(
                    new Document("ComentarioId", 1)
                            .append("Texto", "Excelente producto")
                            .append("Cliente", "Juan Pérez"),
                    new Document("ComentarioId", 2)
                            .append("Texto", "Buena relación calidad-precio")
                            .append("Cliente", "Ana Gómez") );

            Document documento = new Document("ProductoId", i)
                    .append("Nombre", "Producto " + i)
                    .append("Descripción", "Descripción del producto " + i)
                    .append("Precio", 100 + i * 10)
                    .append("Categoria", categoria)
                    .append("Comentarios", comentarios);

            documentos.add(documento);
        }
        collection.insertMany(documentos);

        System.out.println("10 documentos insertados correctamente.");
    }
}
