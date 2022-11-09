import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogConsoleOnShake(
        dark: true,
        child: const Center(
          child: Text("Shake Phone to open Console."),
        ),
      ),
    );
  }
}
