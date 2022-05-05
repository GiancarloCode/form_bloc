import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:form_bloc_web/constants/style.dart';

void showCopyFlash({
  required BuildContext context,
  required EdgeInsets margin,
}) =>
    showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
          margin: margin,
          position: null,
          style: null,
          alignment: Alignment.bottomRight,
          backgroundGradient: mainGradient,
          onTap: () => controller.dismiss(),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Text(
                'Copied to Clipboard',
              ),
            ),
          ),
        );
      },
    );
