import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ServicoNotificacoes {
  static final FlutterLocalNotificationsPlugin _notificacoes =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const AndroidInitializationSettings inicializacaoAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings inicializacaoConfig =
        InitializationSettings(android: inicializacaoAndroid);

    await _notificacoes.initialize(inicializacaoConfig);
  }

  static Future<void> mostrarNotificacao({
    required int id,
    required String titulo,
    required String corpo,
    bool persistente = false,
  }) async {
    AndroidNotificationDetails androidDetalhes =
        AndroidNotificationDetails(
      'canal_cronometro',
      'Cronômetro',
      channelDescription: 'Notificações do cronômetro',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: persistente,
    );

    NotificationDetails plataformaDetalhes =
        NotificationDetails(android: androidDetalhes);

    await _notificacoes.show(id, titulo, corpo, plataformaDetalhes);
  }

  static Future<void> cancelarNotificacao(int id) async {
    await _notificacoes.cancel(id);
  }
}