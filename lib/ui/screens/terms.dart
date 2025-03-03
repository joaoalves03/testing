import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({
    super.key,
  });

  String generateLoremIpsum({int paragraphs = 1}) {
    const loremIpsumText =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

    return List.filled(paragraphs, loremIpsumText).join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Terms of Service & Privacy Policy"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Terms of Service",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                generateLoremIpsum(paragraphs: 3),
              ),
              SizedBox(height: 35),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Privacy Policy",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                generateLoremIpsum(paragraphs: 3),
              ),
            ],
          ),
        ));
  }
}
