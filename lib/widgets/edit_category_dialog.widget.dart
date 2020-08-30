import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojaonlinegerencia/blocs/category_bloc.dart';
import 'package:lojaonlinegerencia/widgets/image_source_sheet.dart';

class EditCategoryDialogWidget extends StatefulWidget {
  final DocumentSnapshot category;

  EditCategoryDialogWidget({this.category});

  @override
  _EditCategoryDialogWidgetState createState() =>
      _EditCategoryDialogWidgetState(category: category);
}

class _EditCategoryDialogWidgetState extends State<EditCategoryDialogWidget> {
  final CategoryBloc _categoryBloc;

  _EditCategoryDialogWidgetState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(
            text: category != null ? category.data['title'] : "");

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSourceSheet(
                            onImageSelected: (image) {
                              Navigator.of(context).pop();
                              _categoryBloc.setImage(image);
                            },
                          ));
                },
                child: StreamBuilder(
                    stream: _categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if (snapshot.data != null)
                        return CircleAvatar(
                          child: snapshot.data is File
                              ? Image.file(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                ),
                          backgroundColor: Colors.transparent,
                        );
                      else
                        return Icon(Icons.image);
                    }),
              ),
              title: StreamBuilder<String>(
                  stream: _categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _controller,
                      onChanged: _categoryBloc.setTitle,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return FlatButton(
                        onPressed: snapshot.data
                            ? () {
                                _categoryBloc.delete();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text("Excluir"),
                        textColor: Colors.red,
                      );
                    }),
                StreamBuilder<bool>(
                    stream: _categoryBloc.submitValid,
                    builder: (context, snapshot) {
                      return FlatButton(
                          onPressed: snapshot.hasData
                              ? () async {
                                  await _categoryBloc.saveData();
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Text("Salvar"));
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
