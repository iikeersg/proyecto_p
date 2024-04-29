import 'dart:io';
import 'Database.dart';
import 'package:mysql1/mysql1.dart';

class Cita {
  int? idcita;
  int? idcliente;
  String? nombre;
  DateTime? fecha;
  String? apellido;

  Cita();
  Cita.fromMap(ResultRow map) {
    idcita = map['idcita'];
    idcliente = map['idcliente'];
    nombre = map['nombre'];
    fecha = map['fecha'];
    apellido = map['apellido'];
  }
}
