import 'package:flutter/material.dart';
import '../../model/product.dart';
import '../../services/product_service.dart';
import '../../router/app_router.dart';
import '../auth/login_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = ProductService();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            // Background với wave xanh
            Container(
              color: const Color(0xFFFCF7FF),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8BB2F8), Color(0xFF6A88F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'List Product',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.black),
                          onPressed: () async {
                            final confirmLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                    'Bạn có chắc chắn muốn đăng xuất không?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmLogout == true) {
                              await firebaseService.logout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: StreamBuilder<List<Product>>(
                      stream: firebaseService.getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final products = snapshot.data!;
                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      product.hinhanh,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    product.idsanpham,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      const Icon(Icons.local_fire_department,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('${product.loaisp} Cal',
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.attach_money,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('${product.gia} VND',
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirm'),
                                          content: const Text(
                                              'Bạn có chắc chắn muốn xóa sản phẩm này?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context, false),
                                                child: const Text('Cancel')),
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context, true),
                                                child: const Text('OK')),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await firebaseService
                                            .deleteProduct(product.id);
                                      }
                                    },
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRouter.addEditProduct,
                                    arguments: product,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                            child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF6A88F7),
          child: const Icon(Icons.add),
          onPressed: () =>
              Navigator.pushNamed(context, AppRouter.addEditProduct),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../model/product.dart';
// import '../../services/product_service.dart';
// import '../../router/app_router.dart';
// import '../auth/login_screen.dart';

// class ProductListScreen extends StatelessWidget {
//   const ProductListScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final firebaseService = FirebaseService();

//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Product List'),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout),
//               onPressed: () async {
//                 await firebaseService.logout();
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (_) => const LoginScreen()));
//               },
//             ),
//           ],
//           automaticallyImplyLeading: false,
//         ),
//         body: StreamBuilder<List<Product>>(
//           stream: firebaseService.getProducts(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final products = snapshot.data!;
//               return ListView.builder(
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final product = products[index];
//                   return ListTile(
//                     leading: Image.network(product.hinhanh,
//                         width: 50, height: 50, fit: BoxFit.cover),
//                     title: Text(product.idsanpham),
//                     subtitle: Text('${product.loaisp} - ${product.gia} VND'),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: () => Navigator.pushNamed(
//                             context,
//                             AppRouter.addEditProduct,
//                             arguments: product,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () async {
//                             final confirm = await showDialog<bool>(
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 title: const Text('Xác nhận'),
//                                 content: const Text(
//                                     'Bạn có chắc chắn muốn xóa sản phẩm này?'),
//                                 actions: [
//                                   TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, false),
//                                       child: const Text('Hủy')),
//                                   TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, true),
//                                       child: const Text('Xóa')),
//                                 ],
//                               ),
//                             );
//                             if (confirm == true) {
//                               await firebaseService.deleteProduct(product.id);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add),
//           onPressed: () =>
//               Navigator.pushNamed(context, AppRouter.addEditProduct),
//         ),
//       ),
//     );
//   }
// }
