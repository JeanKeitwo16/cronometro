class model_cronometro {
  final Stopwatch cronometro = Stopwatch();
  bool estadoCronometro = false;
  Duration get tempo => cronometro.elapsed;

  void iniciar() {
    cronometro.start();
    estadoCronometro = true;
  }

  void pausar() {
    cronometro.stop();
    estadoCronometro = false;
  }

  void reiniciar() {
    cronometro.reset();
    estadoCronometro = true;
  }
}
