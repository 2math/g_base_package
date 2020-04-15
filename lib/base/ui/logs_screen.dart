import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger_flutter/logger_flutter.dart';

class LogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogConsoleOnShake(
        dark: true,
        child: Center(
          child: Text("Shake Phone to open Console."),
        ),
      ),
    );
  }
}
