import 'package:mysql1/mysql1.dart';

abstract class Database {
  // Propiedades
  static final String _host = 'localhost';
  static final int _port = 8889;
  static final String _user = 'iker';
  static final String _password = '1234';

  // Métodos
  static instalacion() async {
    var settings = ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      password: _password,
    );
    var conn = await MySqlConnection.connect(settings);
    try {
      await _crearDB(conn);
      await _crearTablaUsuarios(conn);
      await _crearTablaClientes(conn);
      await _creartablaCitas(conn);
      await _crearTablaPeluqueros(conn);
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  static Future<MySqlConnection> conexion() async {
    var settings = ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: 'peluqueriaDB');

    return await MySqlConnection.connect(settings);
  }

  static _crearDB(conn) async {
    await conn.query('CREATE DATABASE IF NOT EXISTS peluqueriaDB');
    await conn.query('USE peluqueriaDB');
    print('Conectado a peluqueriaDB');
  }

  static _crearTablaUsuarios(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS usuarios(
        idusuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(10) NOT NULL
    )''');
  }

  static _creartablaCitas(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS citas(
        idcita INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        idcliente INT,
        nombre VARCHAR(50) NOT NULL,
        apellido VARCHAR(50) NOT NULL,
        fecha DATETIME NOT NULL UNIQUE,
        FOREIGN KEY (idcliente) REFERENCES clientes(idcliente)
    )''');
  }

  static _crearTablaClientes(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS clientes(
        idcliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL,
        apellido VARCHAR(50) NOT NULL,
        password VARCHAR(10) NOT NULL,
        numerotelefono VARCHAR(9) NOT NULL
    )''');
  }

  static _crearTablaPeluqueros(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS peluqueros(
        idPeluquero INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombrePeluquero VARCHAR(50) NOT NULL,
        passPeluquero VARCHAR(10) NOT NULL
    )''');
  }
}
