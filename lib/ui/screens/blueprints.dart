import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/header.dart';

class BlueprintScreen extends StatefulWidget {
  const BlueprintScreen({super.key});

  @override
  BlueprintScreenState createState() => BlueprintScreenState();
}

class BlueprintScreenState extends State<BlueprintScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'https://via.placeholder.com/1280x768',
      'https://via.placeholder.com/1280x768',
      'https://via.placeholder.com/1280x768',
    ];

    double itemSize = MediaQuery.of(context).size.width; // full width of screen

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: List.generate(imageUrls.length, (index) {
              return GestureDetector(
                onTap: () async {
                  if (!mounted) return; // check before accessing context
                  await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                  if (!mounted) return; // ensure context is still valid
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LandscapeScreen(imageUrl: imageUrls[index]),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  width: itemSize,
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class LandscapeScreen extends StatefulWidget {
  final String imageUrl;

  const LandscapeScreen({required this.imageUrl, super.key});

  @override
  State<LandscapeScreen> createState() => _LandscapeScreenState();
}

class _LandscapeScreenState extends State<LandscapeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piso'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            if (mounted) Navigator.pop(context); // guard context usage here
          },
        ),
      ),
      body: Center(
        child: Image.network(widget.imageUrl, fit: BoxFit.contain),
      ),
    );
  }
}
