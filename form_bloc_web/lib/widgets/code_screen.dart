import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_bloc_web/constants/style.dart';
import 'package:form_bloc_web/widgets/code_card.dart';
import 'package:form_bloc_web/widgets/copy_flash.dart';
import 'package:form_bloc_web/widgets/gradient_button.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({Key? key,
    this.codePath,
    this.extraDependencies,
  }) : super(key: key);

  final String? codePath;

  final String? extraDependencies;

  @override
  CodeScreenState createState() => CodeScreenState();
}

class CodeScreenState extends State<CodeScreen> {
  String? _code;

  @override
  void didChangeDependencies() {
    DefaultAssetBundle.of(context).loadString(widget.codePath!).catchError((_) {
      setState(() {
        _code = 'Example code not found';
      });
    }).then<void>((String? code) {
      if (mounted) {
        setState(() {
          _code = code ?? 'Example code not found';
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_code == null) {
      body = Container();
    } else {
      body = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: child,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              CodeCard.pubspec(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                bottomPaddingCopyMessage: 85,
                extraDependencies: widget.extraDependencies,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: CodeCard.main(
                  code: _code,
                  showCopyButton: false,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: body,
      floatingActionButton: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: GradientElevatedButton(
            onPressed: _copy,
            height: 45,
            width: 140,
            gradient: mainGradient,
            borderRadius: BorderRadius.circular(20.0),
            child: const Text(
              "COPY",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _code));

    showCopyFlash(
      context: context,
      margin: const EdgeInsets.only(bottom: 85, right: 21),
    );
  }
}
