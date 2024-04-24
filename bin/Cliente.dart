import 'dart:io';
import 'Database.dart';
import 'package:mysql1/mysql1.dart';

class Cliente {
  int? idcliente;
  String nombre = "s";
  String? apellido;
  String? password;
  String? numerotelefono;

  Cliente();
  Cliente.fromMap(ResultRow map) {
    idcliente = map['idcliente'];
    nombre = map['nombre'];
    password = map['password'];
    apellido = map['apellido'];
    numerotelefono = map['numerotelefono'];
  }

  //menus

  menuCliente() async {
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
        stdout.writeln("Introduzca su nombre:");
        String nombre = stdin.readLineSync() ?? "e";
        stdout.writeln("Introduzca su contraseña:");
        String password = stdin.readLineSync() ?? "e";
        Cliente cliente = Cliente();
        cliente.nombre = nombre;
        cliente.password = password;
        await loginCliente(cliente);
        await menuClienteLoged(nombre);

        break;

      default:
        crearCliente();
    }
  }

  menuClienteLoged(String nombre) async {
    String? respuesta;
    int? eleccion;
    do {
      stdout.writeln("""Que desea realizar:
1 : Crear cita
2 : Ver mis citas
3 : Borrar mis citas
""");
      respuesta = stdin.readLineSync() ?? "e";
      eleccion = int.tryParse(respuesta);
    } while (eleccion != 1 && eleccion != 2 && eleccion != 3);
    switch (eleccion) {
      case 1:
        Cliente clienteGet = await get(nombre);
        stdout.writeln("Introduce la fecha de tu cita");
        String fecha = stdin.readLineSync() ?? "e";
        crearCita(clienteGet.nombre, fecha, clienteGet.idcliente);
        break;
      case 2:
        Cliente clienteGet = await get(nombre);
        List listaCitas = await Cliente().allCitas(clienteGet.idcliente);
        for (Cliente elemento in listaCitas) {
          print("$elemento.nombre - $elemento.fecha ");
        }
        break;
      default:
        Cliente clienteGet = await get(nombre);
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
      print('Error al insertar usuario: $e');
    } finally {
      await conn.close();
    }
  }

  loginCliente(Cliente cliente) async {
    var conn = await Database.conexion();
    try {
      var resultado = await conn
          .query('SELECT * FROM clientes WHERE nombre = ?', [cliente.nombre]);
      Cliente cliente2 = Cliente.fromMap(resultado.first);
      if (cliente2.password == cliente.password) {
        print("Sesión iniciada correctamente");
      } else {}
    } catch (e) {
      print("Error al iniciar sesión");
      menuCliente();
    } finally {
      await conn.close();
    }
  }

  get(String nombre) async {
    var conn = await Database.conexion();
    try {
      var resultado =
          await conn.query("SELECT * FROM clientes WHERE nombre = ?", [nombre]);
      var registro = Cliente.fromMap(resultado.first);
      return registro;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  allCitas(numero) async {
    var conn = await Database.conexion();
    try {
      var resultado =
          await conn.query('SELECT * FROM citas WHERE idcliente = ?', [numero]);
      List registros = resultado.map((row) => Cliente.fromMap(row)).toList();
      return registros;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  crearCliente() async {
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
    await insertarUsuario(nombre, apellido, password, numerotelefono);
    menuCliente();
  }

  crearCita(nombre, fecha, idcliente) async {
    var conn = await Database.conexion();
    try {
      await conn.query(
          'INSERT INTO citas (idcliente, nombre, fecha) VALUES (?,?,?)',
          [idcliente, nombre, fecha]);
      print('Cita creada correctamente');
    } catch (e) {
      print('Error al crear cita: $e');
    } finally {
      await conn.close();
    }
  }
}
