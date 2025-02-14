import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? error;
  final VoidCallback? callback;
  final bool shouldBeLogged;
  final IconData icon;

  const ErrorMessage({
    super.key,
    this.error,
    this.callback,
    this.shouldBeLogged = false,
    this.icon = Icons.error
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48),
            Text("Ocorreu um erro", style: const TextStyle(fontSize: 24)),
            if(error != null) Text(error!, textAlign: TextAlign.center),
            if(callback != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FilledButton(
                    onPressed: callback,
                    child: Text("Tentar Novamente")
                ),
              )
          ],
        )
    );
  }

}