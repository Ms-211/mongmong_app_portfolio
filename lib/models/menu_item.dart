class MenuItem {
  final String menuName;
  final String category;
  final String subCategory;
  final int price;
  final String imageFile;

  const MenuItem({
    required this.menuName,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.imageFile,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuName: _string(json['menu_name']),
      category: _string(json['category']),
      subCategory: _string(json['sub_category']),
      price: _int(json['price']),
      imageFile: _string(json['image_file']),
    );
  }

  String get name => menuName;
  String get imagePath => 'assets/images/menu/$imageFile';
  bool get hasImage => imageFile.trim().isNotEmpty;

  String get displayCategory {
    final value = subCategory.trim().isNotEmpty ? subCategory : category;
    return value.replaceAll(' ', '');
  }

  String get priceText {
    final text = price.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return '$buffer원';
  }

  static int _int(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _string(dynamic value) {
    return value?.toString() ?? '';
  }
}
