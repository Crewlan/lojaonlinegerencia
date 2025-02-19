import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lojaonlinegerencia/widgets/add_sizes_dialog_widget.dart';

class ProductSizes extends FormField<List> {
  ProductSizes({
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return SizedBox(
                height: 34,
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.5,
                  ),
                  children: state.value.map((s) {
                    return GestureDetector(
                      onLongPress: () {
                        state.didChange(state.value..remove(s));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border:
                                Border.all(color: Colors.pinkAccent, width: 3)),
                        alignment: Alignment.center,
                        child: Text(
                          s,
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList()
                    ..add(GestureDetector(
                      onTap: () async {
                        String size = await showDialog(
                          context: context,
                          builder: (context) => AddSizeDialog(),
                        );

                        if (size != null)
                          state.didChange(state.value..add(size));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                                color: state.hasError
                                    ? Colors.red
                                    : Colors.pinkAccent,
                                width: 3)),
                        alignment: Alignment.center,
                        child: Text(
                          "+",
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),
                    )),
                ),
              );
            });
}
