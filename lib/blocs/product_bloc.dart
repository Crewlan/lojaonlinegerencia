import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc extends BlocBase {
  final _loadingController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();
  final _createdController = BehaviorSubject<bool>();

  String categoryId;

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

  Stream<bool> get outCreated => _createdController.stream;

  DocumentSnapshot product;

  Map<String, dynamic> unSavedData;

  ProductBloc({this.categoryId, this.product}) {
    if (product != null) {
      unSavedData = Map.of(product.data);
      unSavedData['images'] = List.of(product.data['images']);
      unSavedData['sizes'] = List.of(product.data['sizes']);

      _createdController.add(true);
    } else {
      unSavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': []
      };

      _createdController.add(false);
    }
    _dataController.add(unSavedData);
  }

  void saveTitle(String title) {
    unSavedData['title '] = title;
  }

  void saveDescription(String description) {
    unSavedData['description '] = description;
  }

  void savePrice(String price) {
    unSavedData['price '] = double.parse(price);
  }

  void saveImages(List images) {
    unSavedData['images '] = images;
  }

  void saveSizes(List sizes) {
    unSavedData['sizes '] = sizes;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);

    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unSavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection('products')
            .document(categoryId)
            .collection('items')
            .add(Map.from(unSavedData)..remove("images"));
        await _uploadImages(dr.documentID);
        await dr.updateData(unSavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String productId) async {
    for (int i = 0; i < unSavedData['images'].length; i++) {
      if (unSavedData['images'][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unSavedData['images'][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unSavedData['images'][i] = downloadUrl;
    }
  }

  void deleteProduct() {
    product.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
