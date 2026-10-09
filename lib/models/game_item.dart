class GameItem {
  final String gameName;
  final int minPlayer;
  final int maxPlayer;
  final int recommendedPlayer;
  final int difficulty;
  final int minPlayTime;
  final int maxPlayTime;
  final String genre;
  final String? tags;
  final String zone;
  final String location;
  final bool isPick;
  final bool isActive;
  final String youtubeId;
  final String imageFile;
  final String description;
  final DateTime addedDt;

  const GameItem({
    required this.gameName,
    required this.minPlayer,
    required this.maxPlayer,
    required this.recommendedPlayer,
    required this.difficulty,
    required this.minPlayTime,
    required this.maxPlayTime,
    required this.genre,
    required this.tags,
    required this.zone,
    required this.location,
    required this.isPick,
    required this.isActive,
    required this.youtubeId,
    required this.imageFile,
    required this.description,
    required this.addedDt,
  });

  factory GameItem.fromJson(Map<String, dynamic> json) {
    return GameItem(
      gameName: _string(json['game_name']),
      minPlayer: _int(json['min_player']),
      maxPlayer: _int(json['max_player']),
      recommendedPlayer: _int(json['recommended_player']),
      difficulty: _int(json['difficulty']),
      minPlayTime: _int(json['min_play_time']),
      maxPlayTime: _int(json['max_play_time']),
      genre: _string(json['genre']),
      tags: _nullableString(json['tags']),
      zone: _string(json['zone']),
      location: _string(json['location']),
      isPick: _bool(json['is_pick']),
      isActive: _bool(json['is_active']),
      youtubeId: _string(json['youtube_id']),
      imageFile: _string(json['image_file']),
      description: _string(json['description']),
      addedDt: _dateTime(json['added_dt']),
    );
  }

  String get name => gameName;
  int get minPlayers => minPlayer;
  int get maxPlayers => maxPlayer;
  int get time => maxPlayTime;
  String get imagePath => 'assets/images/games/$imageFile';
  String get addedDateText {
    final month = addedDt.month.toString().padLeft(2, '0');
    final day = addedDt.day.toString().padLeft(2, '0');
    return '${addedDt.year}-$month-$day';
  }

  String get players {
    if (minPlayer == maxPlayer) {
      return '$minPlayer인';
    }
    return '$minPlayer~$maxPlayer인';
  }

  String get tagText {
    final tag = tags;
    if (tag == null || tag.trim().isEmpty) {
      return genre;
    }
    return '$genre / $tag';
  }

  String get locationText {
    final zoneText = zone.trim();
    final locationText = location.trim();

    if (zoneText == locationText) {
      return zoneText;
    }

    return '$zoneText ($locationText)';
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

  static bool _bool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1';
  }

  static String _string(dynamic value) {
    return value?.toString() ?? '';
  }

  static String? _nullableString(dynamic value) {
    final text = value?.toString();
    if (text == null || text.trim().isEmpty) {
      return null;
    }
    return text;
  }

  static DateTime _dateTime(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime(2024, 1, 1);
  }
}
