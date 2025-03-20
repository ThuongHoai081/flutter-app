import 'package:flutter/material.dart';
import '../../model/product.dart';
import '../../services/product_service.dart';
import '../../services/image_service.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final TextEditingController _idsanphamController = TextEditingController();
  final TextEditingController _loaispController = TextEditingController();
  final TextEditingController _giaController = TextEditingController();
  final ProductService _productService = ProductService();
  final ImageService _imageService = ImageService();

  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _idsanphamController.text = widget.product!.idsanpham;
      _loaispController.text = widget.product!.loaisp;
      _giaController.text = widget.product!.gia.toString();
      _imageUrl = widget.product!.hinhanh;
    }
  }

  Future<void> _uploadImage() async {
    final url = await _imageService.uploadImage();
    if (url != null) {
      setState(() => _imageUrl = url);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload hình thành công')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload thất bại')));
    }
  }

  Future<void> _saveProduct() async {
    if (_idsanphamController.text.trim().isEmpty ||
        _loaispController.text.trim().isEmpty ||
        _giaController.text.trim().isEmpty ||
        _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')));
      return;
    }

    final product = Product(
      id: widget.product?.id ?? '',
      idsanpham: _idsanphamController.text.trim(),
      loaisp: _loaispController.text.trim(),
      gia: int.parse(_giaController.text.trim()),
      hinhanh: _imageUrl ?? '',
    );

    if (widget.product == null) {
      await _productService.addProduct(product);
    } else {
      await _productService.updateProduct(product);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8BB2F8),
        title: Text(widget.product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _idsanphamController,
                decoration: const InputDecoration(
                  labelText: 'ID Sản phẩm',
                  prefixIcon: Icon(Icons.qr_code),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _loaispController,
                decoration: const InputDecoration(
                  labelText: 'Loại sản phẩm',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _giaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _imageUrl == null
                  ? ElevatedButton.icon(
                      onPressed: _uploadImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Thêm ảnh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8BB2F8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel,
                              color: Colors.red, size: 30),
                          onPressed: () {
                            setState(() => _imageUrl = null);
                          },
                        ),
                      ],
                    ),
              const SizedBox(height: 30),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _saveProduct,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 136, 34),
                          Color.fromARGB(255, 255, 177, 41),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: const Text(
                      "Lưu sản phẩm",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
