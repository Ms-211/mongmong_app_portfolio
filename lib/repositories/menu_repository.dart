import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/menu_item.dart';

class MenuRepository {
  Future<List<MenuItem>> loadMenus() async {
    final jsonString = await rootBundle.loadString('assets/db/menus.json');
    final jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((json) => MenuItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
