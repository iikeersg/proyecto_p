import 'Cita.dart';
import 'Database.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
import 'Cliente.dart';

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
    do {
      stdout.writeln("""Que quiere realizar:
1 : Inicio de sesión
2 : Nuevo Peluquero
        """);
      respuesta = stdin.readLineSync() ?? "e";
      eleccion = int.tryParse(respuesta);
    } while (eleccion != 1 && eleccion != 2);
    switch (eleccion) {
      case 1:
        //Iniciar sesion
        await iniciarSesion();
        break;

      default:
        crearPeluquero();
    }
  }

  menuPeluqueroLoged(nombrePeluquero) async {
    String? respuesta;
    int? eleccion;
    do {
      stdout.writeln("""Bienvenido $nombrePeluquero :
1 : Cambiar citas
2 : Ver citas
3 : Salir
""");
      respuesta = stdin.readLineSync() ?? "e";
      eleccion = int.tryParse(respuesta);
    } while (eleccion != 1 && eleccion != 2 && eleccion != 3);
    switch (eleccion) {
      case 1:
        //cambiar citas
        int? idcliente;
        stdout.writeln("A que cliente le quieres cambiar la cita");
        respuesta = stdin.readLineSync() ?? "e";
        idcliente = int.tryParse(respuesta);
        cambiarCita(idcliente);
        break;

      case 2:
        //ver citas
        int? idcliente;
        DateTime? diacita;
        stdout.writeln("De que dia quieres ver la cita:");
        respuesta = stdin.readLineSync() ?? "e";
        diacita = DateTime.tryParse(respuesta);
        try {
          List listacitas = await todasLasCitasPorFecha(diacita);
          for (Cita cita in listacitas) {
            stdout.writeln(
                "En el dia ${cita.fecha} tiene esta cita ${cita.idcita} y este cliente ${cita.nombre}");
          }
        } catch (e) {
          print('Error al ver citas: $e');
        } finally {}

      default:
    }
  }

  todasLasCitasPorFecha(DateTime? diacita) async {
    var conn = await Database.conexion();
    var resultado =
        await conn.query('SELECT * FROM citas WHERE fecha =?', [diacita]);
    List registros = resultado.map((row) => Cita.fromMap(row)).toList();
    await conn.close();
    return registros;
  }

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

  cambiarCita(idcliente) async {
    String? respuesta;
    int? citacambiar;
    String? fecha;
    List listaCitas = await Cliente().allCitas(idcliente);
    Cita cita = Cita();
    for (Cita cita in listaCitas) {
      stdout.writeln(
          "El cliente ${cita.nombre} ${cita.apellido} tiene una cita el dia ${cita.fecha} el id de la cita es ${cita.idcita}");
    }
    stdout.writeln("Que cita quiere cambiar, escriba su *id* :");
    respuesta = stdin.readLineSync() ?? "e";
    citacambiar = int.tryParse(respuesta);
    stdout.writeln("Elija la nueva fecha y hora *YYYY-MM-DD HH:MM:SS*:");
    fecha = stdin.readLineSync() ?? "e";

    var conn = await Database.conexion();
    try {
      await conn.query("UPDATE citas SET fecha = (?) WHERE idcita = (?)",
          [fecha, citacambiar]);
      stdout.writeln("Cita cambiada con exito");
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  iniciarSesion() async {
    stdout.writeln("Introduzca su nombre:");
    String nombre = stdin.readLineSync() ?? "e";
    stdout.writeln("Introduzca su contraseña:");
    String password = stdin.readLineSync() ?? "e";
    Peluquero peluquero = Peluquero();
    peluquero.nombrePeluquero = nombre;
    peluquero.passPeluquero = password;
    await loginPeluquero(peluquero);
    await menuPeluqueroLoged(nombre);
  }
}
