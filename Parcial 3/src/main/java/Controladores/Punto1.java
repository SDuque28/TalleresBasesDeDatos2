/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package Controladores;

// Imports Mongo
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;

import org.bson.Document;
import org.bson.conversions.Bson;

/**
 *
 * @author SANTIAGO DUQUE
 */
public class Punto1 {

    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("pruebas");
        System.out.println("Conexion Exitosa");
        crearDetalle(mongoDatabase);
    }
    
    public static void crearProducto(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        Document producto = new Document("_id","producto001").append("nombre", "camiseta")
                                                           .append("descripcion", "100% de algodon")
                                                           .append("precio", 2600)
                                                           .append("stock", 200);
        collection.insertOne(producto);
        System.out.println("Se creo un producto");
    }
    
    public static void crearPedido(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("pedidos");
        Document pedido = new Document("_id","pedido002").append("cliente", "cliente001")
                                                           .append("fecha_pedido", "24-11-02T14:00:00Z")
                                                           .append("estado", "enviado")
                                                           .append("total", 105);
        collection.insertOne(pedido);
        System.out.println("Se creo un pedido");
    }
    
    public static void crearDetalle(MongoDatabase mongoDatabase){
        MongoCollection<Document> collection = mongoDatabase.getCollection("detalle_pedidos");
        Document detalle = new Document("_id","detalle003").append("pedido_id", "pedido010")
                                                          .append("producto_id", "producto010")
                                                          .append("cantidad", 7)
                                                          .append("precio_unitario", 7.23);
        collection.insertOne(detalle);
        System.out.println("Se creo un detalle");
    }
    
    public static void modificarDetalle(MongoDatabase mongoDatabase, String id, int cantidad){
        MongoCollection<Document> collection = mongoDatabase.getCollection("detalle_pedidos");
        Bson filter = eq("_id",id);
        Bson updates = set("cantidad",cantidad);
        collection.updateOne(filter,updates);
        System.out.println("Se modifico un detalle");
    }
    
    public static void modificarPedido(MongoDatabase mongoDatabase, String id, int total){
        MongoCollection<Document> collection = mongoDatabase.getCollection("pedidos");
        Bson filter = eq("_id",id);
        Bson updates = set("total",total);
        collection.updateOne(filter,updates);
        System.out.println("Se modifico un pedido");
    }
    
    public static void modificarProducto(MongoDatabase mongoDatabase, String id, int stock){
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        Bson filter = eq("_id",id);
        Bson updates = set("stock",stock);
        collection.updateOne(filter,updates);
        System.out.println("Se modifico un producto");
    }
    
    public static void eliminarProducto(MongoDatabase mongoDatabase, String id){
        MongoCollection<Document> collection = mongoDatabase.getCollection("productos");
        Bson filter = eq("_id",id);
        collection.deleteOne(filter);
        System.out.println("Se elimino un producto");
    }
    
    public static void eliminarPedido(MongoDatabase mongoDatabase, String id){
        MongoCollection<Document> collection = mongoDatabase.getCollection("pedidos");
        Bson filter = eq("_id",id);
        collection.deleteOne(filter);
        System.out.println("Se elimino un pedido");
    }
    
    public static void eliminarDetalle(MongoDatabase mongoDatabase, String id){
        MongoCollection<Document> collection = mongoDatabase.getCollection("detalle_pedidos");
        Bson filter = eq("_id",id);
        collection.deleteOne(filter);
        System.out.println("Se elimino un detalle");
    }
}
