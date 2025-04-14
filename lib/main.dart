import 'package:cronometro/services/service_notificacoes.dart';
import 'package:cronometro/view/view_cronometro.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServicoNotificacoes.inicializar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ViewCronometro();
  }
}