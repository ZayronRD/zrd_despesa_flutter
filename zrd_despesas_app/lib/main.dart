import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/pages/emitir_despesa.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('pt', 'BR'),
      supportedLocales: [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'app',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: Scaffold(
        appBar: AppBar(
          title: Text("TELA 1 - EMITIR DESPESA"),
          backgroundColor: Colors.grey.shade300,
        ),
        body: EmitirDespesa(),
      ),
    );
  }
}
