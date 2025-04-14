import 'dart:async';
import 'package:cronometro/model/model_cronometro.dart';
import 'package:cronometro/services/service_notificacoes.dart';

class ViewmodelCronometro {
  final model_cronometro modelo = model_cronometro();
  Timer? atualizarCronometro;
  Timer? notificacaoInatividade;
  final StreamController<Duration> controladorStreamCronometro =
      StreamController<Duration>();

  Stream<Duration> get fluxoCronometro => controladorStreamCronometro.stream;
  bool get estado => modelo.estadoCronometro;
  List<Duration> listaVoltas = [];
  List<Duration> listaParcial = [];

  ViewmodelCronometro() {
    ServicoNotificacoes.inicializar();
    iniciarAtualizacoesCronometro();
  }

  void iniciarAtualizacoesCronometro() {
    atualizarCronometro = Timer.periodic(const Duration(milliseconds: 10), (
      timer,
    ) {
      if (estado) {
        controladorStreamCronometro.add(modelo.tempo);
      }
    });
  }

  void iniciarCronometro() {
    if (!estado) {
      modelo.iniciar();
      controladorStreamCronometro.add(modelo.tempo);
      ServicoNotificacoes.mostrarNotificacao(
        id: 1,
        titulo: 'Cronômetro em execução',
        corpo: 'O cronômetro está rodando...',
        persistente: true,
      );
      _configurarNotificacaoInatividade();
    }
  }

  void pausarCronometro() {
    if (estado) {
      modelo.pausar();
      ServicoNotificacoes.cancelarNotificacao(1);
      _configurarNotificacaoInatividade();
    }
  }

  void reiniciarCronometro() {
    modelo.reiniciar();
    controladorStreamCronometro.add(modelo.tempo);
    ServicoNotificacoes.mostrarNotificacao(
      id: 1,
      titulo: 'Cronômetro reiniciado',
      corpo: 'O cronômetro foi reiniciado e está em execução',
      persistente: true,
    );

    _configurarNotificacaoInatividade();
  }

  void adicionarVoltaTotal(Duration? voltaTotal) {
    final volta = voltaTotal ?? Duration.zero;
    listaVoltas.add(volta);
    ServicoNotificacoes.mostrarNotificacao(
      id: 2,
      titulo: 'Volta registrada',
      corpo:
          'Volta: ${formatarDuracao(volta)}\nTotal: ${formatarDuracao(modelo.tempo)}',
    );
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
    String milissegundos = doisDigitos(
      duracao.inMilliseconds.remainder(1000) ~/ 10,
    );
    return '$minutos:$segundos.$milissegundos';
  }

  void _configurarNotificacaoInatividade() {
    notificacaoInatividade?.cancel();
    if (!estado) {
      notificacaoInatividade = Timer(const Duration(seconds: 10), () {
        ServicoNotificacoes.mostrarNotificacao(
          id: 3,
          titulo: 'Cronômetro pausado',
          corpo: 'O cronômetro está pausado há 10 segundos. Deseja continuar?',
        );
      });
    }
  }

  void dispose() {
    atualizarCronometro?.cancel();
    notificacaoInatividade?.cancel();
    controladorStreamCronometro.close();
    ServicoNotificacoes.cancelarNotificacao(
      1,
    );
  }
}
