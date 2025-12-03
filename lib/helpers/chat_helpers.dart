import "package:flutter/material.dart";

import "package:blacksheep/widgets/text/now_text.dart";
import "package:blacksheep/widgets/buttons/small_button_flexible.dart";

// a helper for showing a popup that confirms another function
Future<void> showDialogHelper({
  required BuildContext context,
  required String contentText,
  required action,
  String? titleText,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: NowText(body: titleText ?? 'Please confirm', color: Colors.red),
        content: NowText(body: contentText),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const NowText(body: 'Cancel'),
          ),
          SmallButtonFlexible(
            text: 'Ok',
            handler: action,
            forgroundColor: Colors.red,
          ),
        ],
        backgroundColor: Colors.white,
      );
    },
  );
}
