import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.text,
    super.key,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text ?? 'An error occurred'),
      ),
    );
  }
}
