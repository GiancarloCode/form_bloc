import 'package:flutter/material.dart';

class UnderConstruction extends StatelessWidget {
  const UnderConstruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.sentiment_very_satisfied,
            size: 140,
            color: Colors.black.withAlpha(180),
          ),
          const SizedBox(height: 12),
          Text(
            'Under Construction',
            style: TextStyle(
              fontSize: 35,
              color: Colors.black.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}
