import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class CodeCard extends StatelessWidget {
  final String code;
  final String fileName;
  final bool showCopyButton;
  final EdgeInsets padding;
  final double bottomPaddingCopyMessage;

  CodeCard({
    Key key,
    @required this.code,
    this.fileName,
    this.showCopyButton = true,
    this.padding,
    this.bottomPaddingCopyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          if (fileName != null)
            Container(
              alignment: Alignment.centerLeft,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                margin: EdgeInsets.all(0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    fileName,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          Stack(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(fileName != null ? 0.0 : 4.0),
                    topRight: Radius.circular(4.0),
                    bottomLeft: Radius.circular(4.0),
                    bottomRight: Radius.circular(4.0),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16, 28, 16, 28),
                  child: SelectableText.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 18.0),
                      children: <TextSpan>[
                        DartSyntaxHighlighter(SyntaxTheme.gravityLight())
                            .format(code.substring(0, code.length - 1)),
                      ],
                    ),
                  ),
                ),
              ),
              if (showCopyButton)
                Positioned(
                  top: 0,
                  right: 0,
                  height: 24,
                  width: 80,
                  child: GradientRaisedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));

                      showCopyFlash(
                        context: context,
                        margin: EdgeInsets.only(
                            bottom: bottomPaddingCopyMessage ?? 20, right: 20),
                      );
                    },
                    elevation: 0.0,
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0)),
                    child: Center(
                      child: Text(
                        "COPY",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  factory CodeCard.pubspec({
    String extraDependencies,
    EdgeInsets padding,
    double bottomPaddingCopyMessage,
  }) =>
      CodeCard(
        code: '''
dependencies:
  flutter_form_bloc: ^0.19.0${extraDependencies == null ? '' : '\n${extraDependencies.substring(0, extraDependencies.length - 1)}'}
''',
        fileName: 'pubspec.yaml',
        showCopyButton: true,
        padding: padding,
        bottomPaddingCopyMessage: bottomPaddingCopyMessage,
      );

  factory CodeCard.main({
    @required String code,
    showCopyButton = true,
    String nestedPath,
    EdgeInsets padding,
  }) =>
      CodeCard(
        code: code,
        fileName: 'main.dart' + (nestedPath != null ? ' > $nestedPath' : ''),
        showCopyButton: showCopyButton,
        padding: padding,
      );
}
