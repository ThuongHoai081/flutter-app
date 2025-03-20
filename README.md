# flutter-app
```bash
lib/
├── model/                            # Chứa model dữ liệu
├── presentation/                     # Giao diện (UI)
│   ├── auth/
│   │   ├── login_screen.dart         # Giao diện đăng nhập
│   │   └── register_screen.dart      # Giao diện đăng ký
│   ├── common/
│   │   └── background.dart           # Widget nền 
│   ├── product/
│   │   ├── add_edit_product_screen.dart  # Màn hình thêm / sửa sản phẩm
│   │   └── product_list_screen.dart      # Màn hình danh sách sản phẩm + xóa sản phẩm + logout
├── router/
│   └── app_router.dart               # Định tuyến các màn hình trong app
├── services/
│   ├── auth_service.dart             # Xử lý đăng nhập, đăng ký, logout (Firebase Auth)
│   ├── image_service.dart            # Xử lý upload hình lên Cloudinary
│   └── product_service.dart          # CRUD sản phẩm trên Firestore
├── utils/
│   └── validator.dart                # Validate form, input dữ liệu
├── firebase_options.dart             # Cấu hình Firebase (auto generate)
├── main.dart                         # Hàm main khởi động app
