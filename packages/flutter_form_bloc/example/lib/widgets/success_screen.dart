import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.tag_faces,
              size: 150,
            ),
            SizedBox(height: 10),
            Text(
              'Success',
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 45),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
