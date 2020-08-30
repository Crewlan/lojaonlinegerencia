import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lojaonlinegerencia/blocs/orders_bloc.dart';
import 'package:lojaonlinegerencia/blocs/user_bloc.dart';
import 'package:lojaonlinegerencia/tabs/orders_tab.dart';
import 'package:lojaonlinegerencia/tabs/products_tab.dart';
import 'package:lojaonlinegerencia/tabs/user_tabs.dart';
import 'package:lojaonlinegerencia/widgets/edit_category_dialog.widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (p) {
              _pageController.animateToPage(p,
                  duration: Duration(microseconds: 500), curve: Curves.easeIn);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Clientes')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), title: Text('Pedidos')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text('Produtos')),
            ]),
      ),
      body: BlocProvider<UserBloc>(
        bloc: _userBloc,
        child: BlocProvider<OrdersBloc>(
          bloc: _ordersBloc,
          child: PageView(
            controller: _pageController,
            onPageChanged: (p) {
              setState(() {
                _page = p;
              });
            },
            children: <Widget>[
              UsersTab(),
              OrdersTab(),
              ProductsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  // ignore: missing_return
  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: 'Concluidos Abaixo',
                labelStyle:
                    GoogleFonts.inter(fontSize: 14, color: Colors.black),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SorteCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: 'Concluidos Acima',
                labelStyle:
                    GoogleFonts.inter(fontSize: 14, color: Colors.black),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SorteCriteria.READY_FIRST);
                }),
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EditCategoryDialogWidget(),
            );
          },
        );
    }
  }
}
