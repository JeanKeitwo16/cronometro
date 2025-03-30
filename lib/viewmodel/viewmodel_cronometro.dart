import 'dart:async';
import 'package:cronometro/model/model_cronometro.dart';

class ViewmodelCronometro {
  final model_cronometro modelo = model_cronometro();
  Timer? atualizarCronometro;
  final StreamController<Duration> controladorStreamCronometro =
      StreamController<Duration>();
  Stream<Duration> get fluxoCronometro => controladorStreamCronometro.stream;
  bool get estado => modelo.estadoCronometro;
  List<Duration> listaVoltas = [];
  List<Duration> listaParcial = [];
  ViewmodelCronometro() {
    iniciarAtualizacoesCronometro();
  }
  void iniciarAtualizacoesCronometro() {
    atualizarCronometro =
        Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (estado) {
        controladorStreamCronometro.add(modelo.tempo);
      }
    });
  }

  void iniciarCronometro() {
    if (!estado) {
      modelo.iniciar();
      controladorStreamCronometro.add(modelo.tempo);
    }
  }

  void pausarCronometro() {
    if (estado) {
      modelo.pausar();
    }
  }

  void reiniciarCronometro() {
    modelo.reiniciar();
    controladorStreamCronometro.add(modelo.tempo);
  }

  void adicionarVoltaTotal(Duration? voltaTotal) {
    listaVoltas.add(voltaTotal ?? Duration.zero);
  }

  void adicionarVoltaParcial(Duration? voltaParcial) {
    listaParcial.add(voltaParcial ?? Duration.zero);
  }

  void limparListaVoltas() {
    listaVoltas.clear();
    listaParcial.clear();
  }

  String formatarDuracao(Duration duracao) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    String minutos = doisDigitos(duracao.inMinutes.remainder(60));
    String segundos = doisDigitos(duracao.inSeconds.remainder(60));
    String milissegundos =
        doisDigitos(duracao.inMilliseconds.remainder(1000) ~/ 10);
    return '$minutos:$segundos.$milissegundos';
  }
}
