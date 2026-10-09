import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/game_item.dart';

class GameRepository {
  Future<List<GameItem>> loadGames() async {
    final jsonString = await rootBundle.loadString('assets/db/games.json');
    final jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((json) => GameItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
