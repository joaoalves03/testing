import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/logo.dart';

class Translation {
  final String language;
  final List<String> contributors;

  const Translation({
    required this.language,
    required this.contributors,
  });
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<Translation> translations = [
    Translation(
      language: 'Português',
      contributors: ['Carolina Sá'],
    ),
    Translation(
      language: 'English',
      contributors: ['Carolina Sá'],
    ),
    // Add new languages here
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: [
              Logo(
                size: 48,
              ),
              Text("Version: v1.0")
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Text(
              "O goIPVC é uma interface alternativa à aplicação oficial do IPVC, 'myipvc', desenvolvida por estudantes e ex-estudantes do IPVC. Não tem qualquer afiliação com o Instituto Politécnico de Viana do Castelo.",
              textAlign: TextAlign.justify,
            ),
          ),
          Divider(),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: FilledCard(
              paddingHorizontal: 0,
              paddingVertical: 0,
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.code),
                      title: Text("Github"),
                      trailing: Icon(Icons.open_in_new_rounded),
                      visualDensity: VisualDensity.compact,
                      onTap: () async {
                        final url = Uri.parse('https://github.com/ei-ipvc/goipvc');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    ListTile(
                        leading: Icon(Icons.feedback_rounded),
                        title: Text("Feedback"),
                        trailing: Icon(Icons.arrow_forward_rounded),
                        visualDensity: VisualDensity.compact
                    ),
                    ListTile(
                        leading: Icon(Icons.list_alt_rounded),
                        title: Text("Changelog"),
                        trailing: Icon(Icons.arrow_forward_rounded),
                        visualDensity: VisualDensity.compact
                    )
                  ],
                )
              ]
            ),
          ),

          // Still to be decided
          // Divider(),
          //
          // Center(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(vertical: 6),
          //     child: Text(
          //       "Equipa",
          //       style: Theme.of(context).textTheme.headlineSmall,
          //     ),
          //   ),
          // ),
          //
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: FilledCard(
          //     children: [
          //       Center(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Text(
          //               "Lead Developer",
          //               style: Theme.of(context).textTheme.titleSmall,
          //             ),
          //             Text(
          //               "Matthew Rodrigues",
          //               style: Theme.of(context).textTheme.titleLarge,
          //             ),
          //           ],
          //         ),
          //       )
          //     ]
          //   ),
          // ),
          //
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: FilledCard(
          //     children: [
          //       Center(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Text(
          //               "Flutter Developer & Designer",
          //               style: Theme.of(context).textTheme.titleSmall,
          //             ),
          //             Text(
          //               "Pedro Cunha",
          //               style: Theme.of(context).textTheme.titleLarge,
          //             ),
          //           ],
          //         ),
          //       )
          //     ]
          //   ),
          // ),

          Divider(),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Traduções",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: translations.map((translation) => IntrinsicWidth(
                child: FilledCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translation.language,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: translation.contributors.map((contributor) => Text(
                              contributor,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 12
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    )
                  ]
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
