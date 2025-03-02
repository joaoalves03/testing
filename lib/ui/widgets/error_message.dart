import 'package:flutter/material.dart';
import 'package:goipvc/ui/widgets/card.dart';

class ErrorMessage extends StatelessWidget {
  final String? message;
  final String? error;
  final String? stackTrace;
  final VoidCallback? callback;
  final bool shouldBeLogged;
  final IconData icon;

  const ErrorMessage({
    super.key,
    this.message,
    this.error,
    this.stackTrace,
    this.callback,
    this.shouldBeLogged = false,
    this.icon = Icons.error,
  });

  void showErrorDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Erro",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(error ?? "Nenhum detalhe adicional disponível."),
                if (stackTrace != null) ...[
                  SizedBox(height: 16),
                  ExpandableCard(
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    title: "Stack Trace",
                    body: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SelectableText(
                              stackTrace!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 48),
          Text(
              message ?? "Ocorreu um erro",
              style: const TextStyle(fontSize: 24)
          ),
          if (callback != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FilledButton(
                onPressed: callback,
                child: Text("Tentar Novamente"),
              ),
            ),
          if (error != null)
            TextButton(
              onPressed: () => showErrorDetails(context),
              child: Text("Ver Problema"),
            ),
        ],
      ),
    );
  }
}