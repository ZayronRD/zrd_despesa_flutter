import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:zrd_despesas_app/pages/emitir_despesa.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/auth/auth_gate.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://cwxqwmmjgjngylxdjqyf.supabase.co',
    anonKey: 'sb_publishable_aubBydGARANhZRKb7Oy1qA_39qnY9ja',
  );
  runApp(MyApp());
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: AuthGate(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text("TELA 1 - EMITIR DESPESA"),
      //     backgroundColor: Colors.grey.shade300,
      //   ),
      //   // body: EmitirDespesa(),
      // ),
    );
  }
}
