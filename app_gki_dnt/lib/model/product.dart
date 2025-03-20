
class Product {
  String id;
  String idsanpham;
  String loaisp;
  int gia;
  String hinhanh;

  Product({
    required this.id,
    required this.idsanpham,
    required this.loaisp,
    required this.gia,
    required this.hinhanh,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      idsanpham: map['idsanpham'] ?? '',
      loaisp: map['loaisp'] ?? '',
      gia: map['gia'] ?? 0,
      hinhanh: map['hinhanh'] ?? '',
    );
  }
  

  Map<String, dynamic> toMap() {
    return {
      'idsanpham': idsanpham,
      'loaisp': loaisp,
      'gia': gia,
      'hinhanh': hinhanh,
    };
  }
}
