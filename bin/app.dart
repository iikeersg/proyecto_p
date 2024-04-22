import 'dart:io';
import 'Cliente.dart';

class App {
  static inicioApp() async {
    String? respuesta;
    int? eleccion;
    do {
      stdout.writeln("¡Hola bienvenido a tu peluqueria");
      stdout.writeln("""Identifícate como:
1 : Cliente
2 : Peluquero""");
      respuesta = stdin.readLineSync() ?? "e";
      eleccion = int.tryParse(respuesta);
    } while (eleccion != 1 && eleccion != 2);
    switch (eleccion) {
      case 1:
        Cliente cliente = Cliente();
        cliente.menuCliente();
        break;
      default:
    }
  }
}
