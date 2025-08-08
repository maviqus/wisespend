#!/bin/bash

echo "🔄 Dọn dẹp và khôi phục môi trường iOS Flutter..."

# B1: Dừng mọi tiến trình flutter/xcodebuild đang chạy
echo "🛑 Dừng các tiến trình build cũ..."
killall -9 dart flutter xcodebuild 2>/dev/null

# B2: Xóa cache build Flutter
echo "🧹 Xóa build cache Flutter..."
flutter clean

# B3: Lấy lại dependencies
echo "📦 Tải lại dependencies Flutter..."
flutter pub get

# 🔹 B3.5: Tạo lại file Generated.xcconfig
echo "⚙️ Tạo lại file build iOS..."
flutter build ios --config-only

# B4: Xóa pods cũ
echo "🗑 Xóa pods cũ..."
rm -rf ios/Pods ios/Podfile.lock

# B5: Cài pods mới
echo "📥 Cài pods mới..."
cd ios && pod install && cd ..

# B6: Xóa DerivedData của Xcode
echo "🗑 Xóa DerivedData của Xcode..."
rm -rf ~/Library/Developer/Xcode/DerivedData

# B7: Hoàn tất
echo "✅ Hoàn tất! Bạn có thể chạy lại: flutter run"

