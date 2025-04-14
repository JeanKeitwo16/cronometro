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

  TextStyle _tamanhoTexto(double tamanhoFonte, {FontWeight? weight}) {
    return TextStyle(
      fontSize: tamanhoFonte * tamanhoTexto,
      fontWeight: weight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Cronômetro",
            style: _tamanhoTexto(20, weight: FontWeight.bold),
          ),
          actions: [
            Semantics(
              label: "Alterar o tema do aplicativo",
              child: IconButton(
                icon: Icon(
                  modoEscuro ? Icons.dark_mode : Icons.light_mode,
                  color: modoEscuro ? Colors.white : Colors.black,
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
                  color: modoEscuro ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    tamanhoTexto = tamanhoTexto == 1.0 ? 1.5 : 1.0;
                  });
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                StreamBuilder<Duration>(
                  stream: _viewmodel.fluxoCronometro,
                  builder: (context, snapshot) {
                    final duracao = snapshot.data ?? Duration.zero;
                    return Text(
                      _viewmodel.formatarDuracao(duracao),
                      style: _tamanhoTexto(48, weight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
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
                          padding: const EdgeInsets.all(30),
                        ),
                        child: Icon(
                          _viewmodel.estado
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 30 * tamanhoTexto,
                          color: modoEscuro ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
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
                          padding: const EdgeInsets.all(30),
                        ),
                        child: Icon(
                          Icons.replay_outlined,
                          size: 30 * tamanhoTexto,
                          color: modoEscuro ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Semantics(
                      label: "Adicionar Volta",
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _viewmodel.adicionarVoltaTotal(_viewmodel.modelo.tempo);
                            if (_viewmodel.listaVoltas.length > 1) {
                              _viewmodel.adicionarVoltaParcial(
                                _viewmodel.listaVoltas.last -
                                    _viewmodel.listaVoltas[_viewmodel.listaVoltas.length - 2],
                              );
                            } else {
                              _viewmodel.adicionarVoltaParcial(_viewmodel.listaVoltas.last);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(30),
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 30 * tamanhoTexto,
                          color: modoEscuro ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Voltas",
                  style: _tamanhoTexto(20, weight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _viewmodel.listaVoltas.length,
                    itemBuilder: (context, i) {
                      final index = _viewmodel.listaVoltas.length - 1 - i;
                      return ListTile(
                        leading: Icon(
                          Icons.directions_walk,
                          size: 24 * tamanhoTexto,
                        ),
                        title: Text(
                          "N° ${index + 1}",
                          style: _tamanhoTexto(16),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _viewmodel.formatarDuracao(_viewmodel.listaVoltas[index]),
                              style: _tamanhoTexto(14),
                            ),
                            if (index < _viewmodel.listaParcial.length)
                              Text(
                                _viewmodel.formatarDuracao(_viewmodel.listaParcial[index]),
                                style: _tamanhoTexto(14),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}