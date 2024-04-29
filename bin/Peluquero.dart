import 'Database.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';

class Peluquero {
  int? idPeluquero;
  String? nombrePeluquero;
  String? passPeluquero;

  Peluquero();
  Peluquero.fromMap(ResultRow map) {
    idPeluquero = map['idPeluquero'];
    nombrePeluquero = map['nombrePeluquero'];
    passPeluquero = map['passPeluquero'];
  }

  menuPeluquero() async {
    String? respuesta;
    int? eleccion;
    stdout.writeln("""Que quiere realizar:
1 : Inicio de sesión
2 : Nuevo Peluquero
        """);
    respuesta = stdin.readLineSync() ?? "e";
    eleccion = int.tryParse(respuesta);
    switch (eleccion) {
      case 1:
        //Iniciar sesion
        stdout.writeln("Introduzca su nombre:");
        String nombre = stdin.readLineSync() ?? "e";
        stdout.writeln("Introduzca su contraseña:");
        String password = stdin.readLineSync() ?? "e";
        Peluquero peluquero = Peluquero();
        peluquero.nombrePeluquero = nombre;
        peluquero.passPeluquero = password;
        await loginPeluquero(peluquero);
        await menuPeluqueroLoged(nombrePeluquero);
        break;

      default:
        crearPeluquero();
    }
  }

  menuPeluqueroLoged(nombrePeluquero) async {}

  loginPeluquero(Peluquero peluquero) async {
    var conn = await Database.conexion();
    try {
      var resultado = await conn.query(
          'SELECT * FROM peluqueros WHERE nombrePeluquero = ?',
          [peluquero.nombrePeluquero]);
      Peluquero peluquero2 = Peluquero.fromMap(resultado.first);
      if (peluquero2.passPeluquero == peluquero.passPeluquero) {
        print("Sesión iniciada correctamente");
      } else {
        print("Error al iniciar sesión");
        menuPeluquero();
      }
    } catch (e) {
      print("Error al iniciar sesión");
      menuPeluquero();
    } finally {
      await conn.close();
    }
  }

  crearPeluquero() async {
    //Crear nuevo Cliente
    //Nombre
    stdout.writeln("Introduzca su nombre:");
    String nombre = stdin.readLineSync() ?? "e";
    //Contraseña
    stdout.writeln("Introduzca su nueva contraseña:");
    String password = stdin.readLineSync() ?? "e";
    await insertarPeluquero(nombre, password);
    menuPeluquero();
  }

  insertarPeluquero(nombre, password) async {
    var conn = await Database.conexion();
    try {
      await conn.query(
          'INSERT INTO peluqueros (nombrePeluquero, passPeluquero) VALUES (?,?)',
          [nombre, password]);
      print('Peluquero insertado correctamente');
    } catch (e) {
      print('Error al insertar peluquero: $e');
    } finally {
      await conn.close();
    }
  }
}
