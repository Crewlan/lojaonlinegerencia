import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSizeDialog extends StatelessWidget {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controller,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
                child: Text(
                  'Add',
                  style: GoogleFonts.inter(),
                ),
                textColor: Colors.pinkAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
