🧠 Architecture Overview
🔷 High-Level System Architecture
Mô hình tổng thể của ứng dụng bao gồm:
UI Layer: hiển thị giao diện và nhận tương tác từ người dùng.
Business Logic Layer: xử lý logic, bao gồm xác thực người dùng, mã hóa dữ liệu...
Data Layer: quản lý dữ liệu cục bộ và từ server (bao gồm cả các thao tác mã hóa/giải mã AES, ECC).
📌 Bạn có thể tham khảo sơ đồ kiến trúc tổng quát tại: 

![Screenshot 2025-07-05 230918](https://github.com/user-attachments/assets/0169e574-5db0-4009-bd5f-9035fae65c95)

🗂️ State Management Architecture
Ứng dụng sử dụng Riverpod để quản lý trạng thái theo mô hình tách biệt logic rõ ràng giữa UI và State.
Tất cả các trạng thái (người dùng, tin nhắn, kết nối socket) đều được lưu trữ và quản lý qua Provider.
Provider cho phép tái sử dụng logic một cách hiệu quả và đơn giản hóa việc test.
📌 Sơ đồ mô tả luồng quản lý trạng thái: 

![Screenshot 2025-07-05 233218](https://github.com/user-attachments/assets/15128172-a598-4f4b-ad3d-e7fc31fc7a08)

✅ Error Handling and Validation
Sử dụng cấu trúc Result<T> hoặc các state cụ thể (Loading, Error, Data) để xử lý lỗi rõ ràng.
Giao diện phản hồi lại các trạng thái lỗi, ví dụ: kết nối thất bại, lỗi xác thực, mã hóa không hợp lệ.
📌 Sơ đồ flow xử lý lỗi và validate:

![Screenshot 2025-07-05 233328](https://github.com/user-attachments/assets/4a72dd20-facc-4549-8711-23d6cb61e49e)

🔄 State Management Patterns
Provider kết hợp StateNotifier/AsyncNotifier để cập nhật trạng thái động.
Các trạng thái như đăng nhập, tải dữ liệu, socket kết nối đều được kiểm soát bởi một pattern rõ ràng.
📌 Flowchart mô tả các pattern quản lý trạng thái: 

![Screenshot 2025-07-05 234400](https://github.com/user-attachments/assets/44fc3242-8c74-454a-ad11-cc57e9971829)

🔒 Authentication State Management
Khi ứng dụng khởi động, trạng thái đăng nhập sẽ được kiểm tra và định tuyến người dùng về trang phù hợp.
Toàn bộ thông tin xác thực được mã hóa và lưu trữ tạm thời, không để lộ dữ liệu nhạy cảm.
📌 Flow mô tả vòng đời xác thực: 

![Screenshot 2025-07-05 234843](https://github.com/user-attachments/assets/cac9719a-ac4e-4cf5-b72e-c1d564c7d6e1)

🚪 Logout Functionality
Khi người dùng nhấn “Logout”, hệ thống sẽ:
Đóng kết nối WebSocket nếu có
Xóa token và thông tin tạm lưu trữ
Đưa người dùng về màn hình đăng nhập
📌 Sơ đồ logic của chức năng Logout: 

![Screenshot 2025-07-05 235033](https://github.com/user-attachments/assets/f07b4e3e-bb38-4f4d-905c-29de4f880019)
