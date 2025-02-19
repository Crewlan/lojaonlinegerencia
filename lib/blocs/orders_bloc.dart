import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SorteCriteria { READY_FIRST, READY_LAST }

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;

  List<DocumentSnapshot> _orders = [];

  Firestore _firestore = Firestore.instance;
  SorteCriteria _criteria;

  OrdersBloc() {
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.documentID == oid);
            _orders.add(change.document);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == oid);
            break;
        }
      });

      _sort();
    });
  }

  void setOrderCriteria(SorteCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SorteCriteria.READY_FIRST:
        _orders.sort((a, b) {
          int sa = a.data['status'];
          int sb = b.data['status'];

          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });
        break;
      case SorteCriteria.READY_LAST:
        _orders.sort((a, b) {
          int sa = a.data['status'];
          int sb = b.data['status'];

          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }

    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
