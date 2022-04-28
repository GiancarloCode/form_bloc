import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceScreen extends StatelessWidget {
  final Widget app;

  const DeviceScreen({
    Key? key,
    required this.app,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - (kIsWeb ? 135 : 160);
    height = height < 480 ? 480 : height;

    final width = MediaQuery.of(context).size.width > 350.0
        ? 350.0
        : MediaQuery.of(context).size.width;

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: kIsWeb ? 0.95 : 1.0,
                child: SizedBox(
                  height: height,
                  width: width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 2.0,
                    margin: const EdgeInsets.all(kIsWeb ? 0 : 15),
                    child: MaterialApp(
                      home: app,
                      theme: ThemeData(
                        fontFamily: 'JosefinSans',
                      ),
                      debugShowCheckedModeBanner: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
