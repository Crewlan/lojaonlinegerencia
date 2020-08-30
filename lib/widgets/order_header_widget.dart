import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lojaonlinegerencia/blocs/user_bloc.dart';

class OrderHeaderWidget extends StatelessWidget {
  final DocumentSnapshot order;

  OrderHeaderWidget(this.order);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);

    final _user = _userBloc.getUser(order.data['clientId']);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_user['name']}'),
              Text('${_user['address']}'),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Produtos: R\$${order.data['productsPrice'].toStringAsFixed(2)}',
              style: GoogleFonts.inter(),
            ),
            Text(
              'Total: R\$${order.data['totalPrice'].toStringAsFixed(2)}',
              style: GoogleFonts.inter(),
            ),
          ],
        )
      ],
    );
  }
}
