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

/**
 *
 * @author SANTIAGO DUQUE
 */
public class Punto2 {
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");  
        productosMayor20(mongoDatabase);
        pedidosMayor100(mongoDatabase);
        detalleConProducto(mongoDatabase);
    }
    
    public static void productosMayor20(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        try (MongoCursor<Document> cursor = collection.find(gt("precio", 20)).iterator()) {
            System.out.println("Productos con precio mayor a 20 dolares:");
            while (cursor.hasNext()) {
                Document document = cursor.next();
                System.out.println(document.toJson());
            }
        }
    }
    
    public static void pedidosMayor100(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("pedidos");
        try (MongoCursor<Document> cursor = collection.find(gt("total", 100)).iterator()) {
            System.out.println("Pedidos con el total mayor a 100 dolares:");
            while (cursor.hasNext()) {
                Document document = cursor.next();
                System.out.println(document.toJson());
            }
        }
    }
    
    public static void detalleConProducto(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("detalle_pedidos");
        try (MongoCursor<Document> cursor = collection.find(eq("producto_id", "producto010")).iterator()) {
            System.out.println("Detalles con el producto_id igual a producto010:");
            while (cursor.hasNext()) {
                Document document = cursor.next();
                System.out.println(document.toJson());
            }
        }
    }
}
