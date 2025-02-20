import 'package:flutter/material.dart';

class CurricularUnitScreen extends StatefulWidget {
  final int curricularUnitId;

  const CurricularUnitScreen({
    super.key,
    required this.curricularUnitId
  });

  @override
  CurricularUnitState createState() => CurricularUnitState();
}

class CurricularUnitState extends State<CurricularUnitScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Propinas"),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}