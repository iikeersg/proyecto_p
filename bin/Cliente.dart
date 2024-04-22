import 'dart:io';
import 'Database.dart';

class Cliente {
  int? idcliente;
  String? nombre;
  String? apellido;
  String? password;
  String? numerotelefono;

  menuCliente() {
    String? respuesta;
    int? eleccion;
    stdout.writeln("""Que quiere realizar:
1 : Inicio de sesión
2 : Nuevo cliente
        """);
    respuesta = stdin.readLineSync() ?? "e";
    eleccion = int.tryParse(respuesta);
    switch (eleccion) {
      case 1:
        //Iniciar sesion
        stdout.writeln("Introduzca nombre de cliente:");
        String nombre = stdin.readLineSync() ?? "e";
        stdout.writeln("Introduzca contraseña de cliente:");
        String password = stdin.readLineSync() ?? "e";
        break;
      default:
        //Crear nuevo Cliente
        //Nombre
        stdout.writeln("Introduzca su nombre:");
        String nombre = stdin.readLineSync() ?? "e";
        //Apellido
        stdout.writeln("Introduzca su apellido:");
        String apellido = stdin.readLineSync() ?? "e";
        //Contraseña
        stdout.writeln("Introduzca su nueva contraseña:");
        String password = stdin.readLineSync() ?? "e";
        //Numero teléfono
        stdout.writeln("Introduzca su numero de teléfono:");
        String numerotelefono = stdin.readLineSync() ?? "e";
        insertarUsuario(nombre, apellido, password, numerotelefono);
    }
  }

  insertarUsuario(nombre, apellido, password, numerotelefono) async {
    var conn = await Database.conexion();
    try {
      await conn.query(
          'INSERT INTO clientes (nombre, apellido, password, numerotelefono) VALUES (?,?,?,?)',
          [nombre, apellido, password, numerotelefono]);
      print('Usuario insertado correctamente');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }
}
