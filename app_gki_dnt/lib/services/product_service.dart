import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/product.dart';

class ProductService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Đăng ký thất bại';
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Đăng nhập thất bại';
    }
  }

    Future<void> logout() async => await _auth.signOut();


  Stream<List<Product>> getProducts() {
    return productsRef.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Product.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
        );
  }

  Future<List<Product>> fetchProducts() async {
    final snapshot = await productsRef.get();
    return snapshot.docs
        .map(
          (doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<void> addProduct(Product product) async {
      await productsRef.add(product.toMap());

  }

   Future<void> updateProduct(Product product) async {
    await productsRef.doc(product.id).update(product.toMap());
  }

   Future<void> deleteProduct(String id) async {
    await productsRef.doc(id).delete();
  }
}
