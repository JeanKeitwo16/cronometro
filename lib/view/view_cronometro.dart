import 'package:cronometro/viewmodel/viewmodel_cronometro.dart';
import 'package:flutter/material.dart';

class ViewCronometro extends StatefulWidget {
  const ViewCronometro({super.key});

  @override
  State<ViewCronometro> createState() => _ViewCronometroState();
}

class _ViewCronometroState extends State<ViewCronometro> {
  final ViewmodelCronometro _viewmodel = ViewmodelCronometro();
  bool modoEscuro = false;
  double tamanhoTexto = 1.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Semantics(
                label: "Alterar o tema do aplicativo",
                child: IconButton(
                  icon: Icon(
                    modoEscuro ? Icons.dark_mode : Icons.light_mode,
                    color: modoEscuro
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    setState(() {
                      modoEscuro = !modoEscuro;
                    });
                  },
                ),
              ),
              Semantics(
                label: "Aumentar ou Diminuir o tamanho do texto",
                child: IconButton(
                  icon: Icon(
                    Icons.text_fields,
                    color: modoEscuro
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    setState(() {
                      tamanhoTexto = tamanhoTexto == 1.0 ? 2.0 : 1.0;
                    });
                  },
                ),
              ),
            ],
          ),
          body: child,
        );
      },
      debugShowCheckedModeBanner: false,
      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<Duration>(
                stream: _viewmodel.fluxoCronometro,
                builder: (context, snapshot) {
                  final duracao = snapshot.data ?? Duration.zero;
                  return Text(
                    _viewmodel.formatarDuracao(duracao),
                    style: TextStyle(
                      fontSize: 48 * tamanhoTexto,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Semantics(
                label: "Iniciar ou Pausar",
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_viewmodel.estado) {
                        _viewmodel.pausarCronometro();
                      } else {
                        _viewmodel.iniciarCronometro();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(40),
                  ),
                  child: Icon(
                    _viewmodel.estado
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 30,
                    color: modoEscuro
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: "Reiniciar",
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _viewmodel.reiniciarCronometro();
                      _viewmodel.pausarCronometro();
                      _viewmodel.limparListaVoltas();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(40),
                  ),
                  child: Icon(
                    Icons.replay_outlined,
                    size: 30,
                    color: modoEscuro
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: "Adicionar Volta",
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _viewmodel.adicionarVoltaTotal(_viewmodel.modelo.tempo);
                      if (_viewmodel.listaVoltas.length > 1) {
                        _viewmodel.adicionarVoltaParcial(
                          _viewmodel.listaVoltas.last -
                              _viewmodel.listaVoltas[
                                  _viewmodel.listaVoltas.length - 2],
                        );
                      } else {
                        _viewmodel
                            .adicionarVoltaParcial(_viewmodel.listaVoltas.last);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(40),
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: modoEscuro
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = _viewmodel.listaVoltas.length - 1;
                          i >= 0;
                          i--)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.directions_walk),
                            Text('N° ${i + 1}'),
                            Text(_viewmodel
                                .formatarDuracao(_viewmodel.listaVoltas[i])),
                            if (i < _viewmodel.listaParcial.length)
                              Text(_viewmodel
                                  .formatarDuracao(_viewmodel.listaParcial[i]))
                          ],
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
