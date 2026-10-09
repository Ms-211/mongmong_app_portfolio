import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../repositories/game_repository.dart';
import 'game_detail_screen.dart';

class GameSearchScreen extends StatefulWidget {
  final bool pickOnly;
  final String initialPlayerFilter;
  final String initialDifficultyFilter;
  final String initialGenreFilter;
  final String initialTimeFilter;
  final String title;
  final bool recommendationMode;

  const GameSearchScreen({
    super.key,
    this.pickOnly = false,
    this.initialPlayerFilter = '전체',
    this.initialDifficultyFilter = '전체',
    this.initialGenreFilter = '전체',
    this.initialTimeFilter = '전체',
    this.title = '보드게임 찾기',
    this.recommendationMode = false,
  });

  @override
  State<GameSearchScreen> createState() => _GameSearchScreenState();
}

class _GameSearchScreenState extends State<GameSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GameRepository _gameRepository = GameRepository();

  List<GameItem> games = [];
  bool isLoading = true;

  List<GameItem> get filteredGames {
    final query = _searchController.text.trim().toLowerCase().replaceAll(
      ' ',
      '',
    );

    if (widget.recommendationMode) {
      return _recommendedGames(query);
    }

    return games.where((game) {
      final gameName = game.name.toLowerCase().replaceAll(' ', '');

      final matchesSearch = query.isEmpty || gameName.contains(query);
      final matchesNewGame = !newGameOnly || _isRecentlyAdded(game);

      final matchesPlayer =
          playerFilter == '전체' ||
          (playerFilter == '2인' && game.recommendedPlayer == 2) ||
          (playerFilter == '3인' && game.recommendedPlayer == 3) ||
          (playerFilter == '4인' && game.recommendedPlayer == 4) ||
          (playerFilter == '3~4인' &&
              game.recommendedPlayer >= 3 &&
              game.recommendedPlayer <= 4) ||
          (playerFilter == '5~6인' &&
              game.recommendedPlayer >= 5 &&
              game.recommendedPlayer <= 6) ||
          (playerFilter == '7인+' && game.recommendedPlayer >= 7);

      final matchesDifficulty =
          difficultyFilter == '전체' ||
          _difficultyFilterText(game.difficulty) == difficultyFilter;

      final matchesGenre = genreFilter == '전체' || game.genre == genreFilter;

      final matchesTime =
          timeFilter == '전체' ||
          (timeFilter == '10분 이하' && game.time <= 10) ||
          (timeFilter == '10분~20분' && game.time > 10 && game.time <= 20) ||
          (timeFilter == '20분~40분' && game.time > 20 && game.time <= 40) ||
          (timeFilter == '40~60분' && game.time > 40 && game.time <= 60) ||
          (timeFilter == '60분 이상' && game.time >= 60);

      return matchesSearch &&
          matchesNewGame &&
          matchesPlayer &&
          matchesDifficulty &&
          matchesGenre &&
          matchesTime;
    }).toList();
  }

  // 추천 모드에서는 선택 조건을 모두 정확히 만족하는 게임만 남기지 않고,
  // 각 게임에 추천 점수를 부여한 뒤 점수가 높은 순서로 보여준다.
  // 선택 인원이 실제 플레이 가능 인원 범위에 들어가는 게임만 후보로 삼고,
  // 그중 PICK 게임, 추천 인원 일치, 장르 일치, 난이도 1단계 이내,
  // 플레이 시간 근접 여부에 가산점을 준다.
  // 40점 이상인 게임을 점수순으로 정렬한 뒤 상위 40개만 노출한다.
  List<GameItem> _recommendedGames(String query) {
    final scoredGames = <_ScoredGame>[];

    for (final game in games) {
      final gameName = game.name.toLowerCase().replaceAll(' ', '');
      if (query.isNotEmpty && !gameName.contains(query)) {
        continue;
      }

      if (!_isPlayableBySelectedPlayer(game)) {
        continue;
      }

      final score = _recommendationScore(game);
      if (score >= 40) {
        scoredGames.add(_ScoredGame(game: game, score: score));
      }
    }

    scoredGames.sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;

      final pickCompare = (b.game.isPick ? 1 : 0).compareTo(
        a.game.isPick ? 1 : 0,
      );
      if (pickCompare != 0) return pickCompare;

      final difficultyCompare = a.game.difficulty.compareTo(b.game.difficulty);
      if (difficultyCompare != 0) return difficultyCompare;

      return a.game.name.compareTo(b.game.name);
    });

    return scoredGames.take(40).map((scored) => scored.game).toList();
  }

  int _recommendationScore(GameItem game) {
    var score = 0;

    if (game.isPick) {
      score += 30;
    }

    score += _playerScore(game);
    score += _genreScore(game);
    score += _difficultyScore(game);
    score += _timeScore(game);

    return score;
  }

  bool _isPlayableBySelectedPlayer(GameItem game) {
    if (playerFilter == '전체') {
      return true;
    }

    final selectedRange = _playerRange(playerFilter);
    if (selectedRange == null) {
      return true;
    }

    return game.minPlayer <= selectedRange.max &&
        game.maxPlayer >= selectedRange.min;
  }

  int _playerScore(GameItem game) {
    if (playerFilter == '전체') {
      return 0;
    }

    final selectedRange = _playerRange(playerFilter);
    if (selectedRange == null) {
      return 0;
    }

    final exactRecommended =
        game.recommendedPlayer >= selectedRange.min &&
        game.recommendedPlayer <= selectedRange.max;
    if (exactRecommended) {
      return 30;
    }

    return 0;
  }

  _IntRange? _playerRange(String filter) {
    switch (filter) {
      case '2인':
        return const _IntRange(2, 2);
      case '3인':
        return const _IntRange(3, 3);
      case '4인':
        return const _IntRange(4, 4);
      case '3~4인':
        return const _IntRange(3, 4);
      case '5~6인':
        return const _IntRange(5, 6);
      case '7인+':
        return const _IntRange(7, 99);
      default:
        return null;
    }
  }

  int _genreScore(GameItem game) {
    if (genreFilter == '전체') {
      return 0;
    }
    return game.genre == genreFilter ? 30 : 0;
  }

  int _difficultyScore(GameItem game) {
    if (difficultyFilter == '전체') {
      return 0;
    }

    final selectedDifficulty = difficultyFilter.length;
    final difference = (game.difficulty - selectedDifficulty).abs();

    if (difference == 0) {
      return 25;
    }
    if (difference == 1) {
      return 12;
    }
    return 0;
  }

  int _timeScore(GameItem game) {
    if (timeFilter == '전체') {
      return 0;
    }

    final selectedIndex = _timeRangeIndex(timeFilter);
    final gameIndex = _timeRangeIndexByMinute(game.time);
    if (selectedIndex == null || gameIndex == null) {
      return 0;
    }

    final difference = (gameIndex - selectedIndex).abs();
    if (difference == 0) {
      return 25;
    }
    if (difference == 1) {
      return 10;
    }
    return 0;
  }

  int? _timeRangeIndex(String filter) {
    switch (filter) {
      case '10분 이하':
        return 0;
      case '10분~20분':
        return 1;
      case '20분~40분':
        return 2;
      case '40분~60분':
        return 3;
      case '60분 이상':
        return 4;
      default:
        return null;
    }
  }

  int? _timeRangeIndexByMinute(int minute) {
    if (minute <= 10) {
      return 0;
    }
    if (minute <= 20) {
      return 1;
    }
    if (minute <= 40) {
      return 2;
    }
    if (minute <= 60) {
      return 3;
    }
    return 4;
  }

  void searchGames() {
    setState(() {});
  }

  String _difficultyFilterText(int difficulty) {
    final count = difficulty.clamp(1, 5);
    return List.filled(count, '★').join();
  }

  @override
  void initState() {
    super.initState();
    playerFilter = widget.initialPlayerFilter;
    difficultyFilter = widget.initialDifficultyFilter;
    genreFilter = widget.initialGenreFilter;
    timeFilter = widget.initialTimeFilter;
    loadGames();
  }

  Future<void> loadGames() async {
    final loadedGames = await _gameRepository.loadGames();

    if (!mounted) return;

    final activeGames =
        loadedGames
            .where((game) => game.isActive && (!widget.pickOnly || game.isPick))
            .toList()
          ..sort((a, b) {
            final pickCompare = (b.isPick ? 1 : 0).compareTo(a.isPick ? 1 : 0);
            if (pickCompare != 0) return pickCompare;

            final difficultyCompare = a.difficulty.compareTo(b.difficulty);
            if (difficultyCompare != 0) return difficultyCompare;

            return a.name.compareTo(b.name);
          });

    setState(() {
      games = activeGames;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String playerFilter = '전체';
  String difficultyFilter = '전체';
  String genreFilter = '전체';
  String timeFilter = '전체';
  bool newGameOnly = false;

  List<String> get selectedFilters {
    final list = <String>[];
    if (newGameOnly) list.add('신작게임');
    if (playerFilter != '전체') list.add(playerFilter);
    if (difficultyFilter != '전체') list.add(difficultyFilter);
    if (genreFilter != '전체') list.add(genreFilter);
    if (timeFilter != '전체') list.add(timeFilter);
    return list;
  }

  void resetFilters() {
    setState(() {
      playerFilter = '전체';
      difficultyFilter = '전체';
      genreFilter = '전체';
      timeFilter = '전체';
      newGameOnly = false;
    });
  }

  void openFilterModal() {
    String tempPlayer = playerFilter;
    String tempDifficulty = difficultyFilter;
    String tempGenre = genreFilter;
    String tempTime = timeFilter;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) {
        final modalSize = MediaQuery.sizeOf(context);
        final modalW = modalSize.width;
        final modalH = modalSize.height;

        // 필터 모달 크기 조정 값.
        final modalWidth = modalW * 0.9;
        final modalPaddingH = modalW * 0.02;
        final modalPaddingV = modalH * 0.024;
        final modalTitleSize = modalW * 0.025;
        final titleBottomGap = modalH * 0.026;
        final sectionBottomGap = modalH * 0.014;
        final sectionTitleWidth = modalW * 0.085;
        final sectionTitleSize = modalW * 0.017;
        final optionWidth = modalW * 0.12;
        final optionHeight = modalH * 0.108;
        final optionFontSize = modalW * 0.018;
        final optionGap = modalW * 0.008;
        final optionRunGap = modalH * 0.008;
        final checkIconSize = modalW * 0.019;
        final actionTopGap = modalH * 0.012;
        final actionButtonPaddingV = modalH * 0.018;
        final actionButtonTextSize = modalW * 0.019;

        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 20,
              ),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width - 12,
                  ),
                  width: modalWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: modalPaddingH,
                    vertical: modalPaddingV,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8EA),
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '필터 선택',
                          style: TextStyle(
                            fontSize: modalTitleSize,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF3A2415),
                          ),
                        ),
                        SizedBox(height: titleBottomGap),
                        FilterSection(
                          title: '추천 인원',
                          options: const ['전체', '2인', '3~4인', '5~6인', '7인+'],
                          selected: tempPlayer,
                          sectionBottomGap: sectionBottomGap,
                          titleWidth: sectionTitleWidth,
                          titleSize: sectionTitleSize,
                          optionWidth: optionWidth,
                          optionHeight: optionHeight,
                          optionFontSize: optionFontSize,
                          optionGap: optionGap,
                          optionRunGap: optionRunGap,
                          checkIconSize: checkIconSize,
                          onSelected: (value) {
                            modalSetState(() => tempPlayer = value);
                          },
                        ),
                        FilterSection(
                          title: '난이도',
                          options: const [
                            '전체',
                            '★',
                            '★★',
                            '★★★',
                            '★★★★',
                            '★★★★★',
                          ],
                          selected: tempDifficulty,
                          sectionBottomGap: sectionBottomGap,
                          titleWidth: sectionTitleWidth,
                          titleSize: sectionTitleSize,
                          optionWidth: optionWidth,
                          optionHeight: optionHeight,
                          optionFontSize: optionFontSize,
                          optionGap: optionGap,
                          optionRunGap: optionRunGap,
                          checkIconSize: checkIconSize,
                          onSelected: (value) {
                            modalSetState(() => tempDifficulty = value);
                          },
                        ),
                        FilterSection(
                          title: '장르',
                          options: const ['전체', '파티', '전략', '추리', '협동', '순발력'],
                          selected: tempGenre,
                          sectionBottomGap: sectionBottomGap,
                          titleWidth: sectionTitleWidth,
                          titleSize: sectionTitleSize,
                          optionWidth: optionWidth,
                          optionHeight: optionHeight,
                          optionFontSize: optionFontSize,
                          optionGap: optionGap,
                          optionRunGap: optionRunGap,
                          checkIconSize: checkIconSize,
                          onSelected: (value) {
                            modalSetState(() => tempGenre = value);
                          },
                        ),
                        FilterSection(
                          title: '시간',
                          options: const [
                            '전체',
                            '10분 이하',
                            '10분~20분',
                            '20분~40분',
                            '40분~60분',
                            '60분 이상',
                          ],
                          selected: tempTime,
                          sectionBottomGap: sectionBottomGap,
                          titleWidth: sectionTitleWidth,
                          titleSize: sectionTitleSize,
                          optionWidth: optionWidth,
                          optionHeight: optionHeight,
                          optionFontSize: optionFontSize,
                          optionGap: optionGap,
                          optionRunGap: optionRunGap,
                          checkIconSize: checkIconSize,
                          onSelected: (value) {
                            modalSetState(() => tempTime = value);
                          },
                        ),
                        SizedBox(height: actionTopGap),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: OutlinedButton(
                                onPressed: () {
                                  modalSetState(() {
                                    tempPlayer = '전체';
                                    tempDifficulty = '전체';
                                    tempGenre = '전체';
                                    tempTime = '전체';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: actionButtonPaddingV,
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFFD8C3A5),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Text(
                                  '초기화',
                                  style: TextStyle(
                                    fontSize: actionButtonTextSize,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF6B4A2E),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: modalW * 0.014),
                            Expanded(
                              flex: 7,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    playerFilter = tempPlayer;
                                    difficultyFilter = tempDifficulty;
                                    genreFilter = tempGenre;
                                    timeFilter = tempTime;
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7E45D6),
                                  padding: EdgeInsets.symmetric(
                                    vertical: actionButtonPaddingV,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Text(
                                  '적용하기',
                                  style: TextStyle(
                                    fontSize: actionButtonTextSize,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedFilters;
    final screenSize = MediaQuery.sizeOf(context);
    final screenW = screenSize.width;
    final screenH = screenSize.height;

    // 보드게임 찾기 화면 크기 조정 값.
    final pagePaddingH = screenW * 0.03;
    final pagePaddingTop = screenH * 0.018;
    final pagePaddingBottom = screenH * 0.024;
    final topButtonHeight = screenH * 0.068;
    final topButtonHPadding = screenW * 0.014;
    final topButtonIconSize = screenH * 0.034;
    final topButtonTextSize = screenW * 0.016;
    final titleSize = screenW * 0.038;
    final headerToSearchGap = screenH * 0.026;
    final searchBarHeight = screenH * 0.064;
    final searchBarHPadding = screenW * 0.018;
    final searchIconSize = screenH * 0.044;
    final searchTextSize = screenW * 0.018;
    final filterButtonWidth = screenW * 0.18;
    final filterButtonTextSize = screenW * 0.02;
    final searchToFilterGap = screenH * 0.012;
    final appliedMinHeight = selected.isEmpty
        ? screenH * 0.032
        : screenH * 0.058;
    final appliedPaddingH = screenW * 0.0126;
    final appliedFontSize = screenW * 0.0126;
    final gridTopGap = screenH * 0.008;
    final gridGapH = screenW * 0.016;
    final gridGapV = screenH * 0.02;
    final showNewGameButton =
        !widget.recommendationMode && widget.title == '보드게임 찾기';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          ),

          // Positioned.fill(
          //   child: Container(color: Colors.white.withValues(alpha: 0.5)),
          // ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    pagePaddingH,
                    pagePaddingTop,
                    pagePaddingH,
                    pagePaddingBottom,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              height: topButtonHeight,
                              padding: EdgeInsets.symmetric(
                                horizontal: topButtonHPadding,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE0C8A3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back_rounded,
                                    color: const Color(0xFF5B371B),
                                    size: topButtonIconSize,
                                  ),
                                  SizedBox(width: screenW * 0.004),
                                  Text(
                                    '뒤로',
                                    style: TextStyle(
                                      fontSize: topButtonTextSize,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF5B371B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF3A2415),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: showNewGameButton
                                ? () {
                                    setState(() {
                                      newGameOnly = true;
                                    });
                                  }
                                : () {
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  },
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              height: topButtonHeight,
                              padding: EdgeInsets.symmetric(
                                horizontal: topButtonHPadding,
                              ),
                              decoration: BoxDecoration(
                                color: newGameOnly && showNewGameButton
                                    ? const Color(0xFFFFF0C5)
                                    : const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: newGameOnly && showNewGameButton
                                      ? const Color(0xFFFFA928)
                                      : const Color(0xFFE0C8A3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    showNewGameButton
                                        ? Icons.auto_awesome_rounded
                                        : Icons.home_rounded,
                                    color: const Color(0xFF5B371B),
                                    size: topButtonIconSize,
                                  ),
                                  SizedBox(width: screenW * 0.004),
                                  Text(
                                    showNewGameButton ? '신작게임' : '홈',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: topButtonTextSize,
                                      color: const Color(0xFF5B371B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: headerToSearchGap),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: searchBarHeight,
                              padding: EdgeInsets.symmetric(
                                horizontal: searchBarHPadding,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFD8C3A5),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    size: searchIconSize,
                                    color: const Color(0xFF999999),
                                  ),
                                  SizedBox(width: screenW * 0.012),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onSubmitted: (_) => searchGames(),
                                      onChanged: (_) => setState(() {}),
                                      style: TextStyle(
                                        fontSize: searchTextSize,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '게임 이름을 검색해보세요!',
                                        hintStyle: TextStyle(
                                          color: const Color(0xFFAAAAAA),
                                          fontSize: searchTextSize * 0.9,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  if (_searchController.text.isNotEmpty)
                                    IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 32,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: screenW * 0.02),
                          SizedBox(
                            height: searchBarHeight,
                            width: filterButtonWidth,
                            child: ElevatedButton.icon(
                              onPressed: openFilterModal,
                              icon: Icon(
                                Icons.tune_rounded,
                                size: searchIconSize * 0.72,
                              ),
                              label: Text(
                                '필터',
                                style: TextStyle(
                                  fontSize: filterButtonTextSize,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7E45D6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: searchToFilterGap),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: appliedMinHeight,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: appliedPaddingH,
                          vertical: screenH * 0.002,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE8D2AE),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '적용중 :',
                              style: TextStyle(
                                fontSize: appliedFontSize,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF3A2415),
                              ),
                            ),
                            SizedBox(width: screenW * 0.012),
                            Expanded(
                              child: selected.isEmpty
                                  ? Text(
                                      '전체 게임',
                                      style: TextStyle(
                                        fontSize: appliedFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF7A5A3A),
                                      ),
                                    )
                                  : Wrap(
                                      spacing: screenW * 0.008,
                                      runSpacing: 6,
                                      children: selected.map((filter) {
                                        return FilterBadge(
                                          text: filter,
                                          onRemove: () {
                                            setState(() {
                                              if (filter == '신작게임') {
                                                newGameOnly = false;
                                              } else if (filter ==
                                                  playerFilter) {
                                                playerFilter = '전체';
                                              } else if (filter ==
                                                  difficultyFilter) {
                                                difficultyFilter = '전체';
                                              } else if (filter ==
                                                  genreFilter) {
                                                genreFilter = '전체';
                                              } else if (filter == timeFilter) {
                                                timeFilter = '전체';
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                            ),
                            SizedBox(width: screenW * 0.008),
                            TextButton.icon(
                              onPressed: resetFilters,
                              icon: Icon(
                                Icons.refresh_rounded,
                                size: appliedFontSize * 0.85,
                              ),
                              label: const Text('전체 초기화'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF6B4A2E),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenW * 0.004,
                                  vertical: 0,
                                ),
                                textStyle: TextStyle(
                                  fontSize: appliedFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 28),
                      // Row(
                      //   children: [
                      //     const Text(
                      //       '총 68개의 게임이 검색됐어요!',
                      //       style: TextStyle(
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.w800,
                      //         color: Color(0xFF3A2415),
                      //       ),
                      //     ),
                      //     const Spacer(),
                      //     Container(
                      //       height: 54,
                      //       padding: const EdgeInsets.symmetric(horizontal: 22),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(16),
                      //         border: Border.all(color: const Color(0xFFD8C3A5)),
                      //       ),
                      //       child: const Row(
                      //         children: [
                      //           Text(
                      //             '인기순',
                      //             style: TextStyle(
                      //               fontSize: 22,
                      //               fontWeight: FontWeight.w800,
                      //               color: Color(0xFF3A2415),
                      //             ),
                      //           ),
                      //           SizedBox(width: 16),
                      //           Icon(Icons.arrow_drop_down_rounded, size: 34),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: gridTopGap),
                      Expanded(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : filteredGames.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 100,
                                      color: Color(0xFF8A6A45),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      '앗! 찾으시는 게임이 없네요 :(\n',
                                      style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF8A6A45),
                                      ),
                                    ),

                                    SizedBox(height: 12),
                                    Text(
                                      '몽이가 그 게임도 데려올 수 있도록 \n카운터에 알려주세요!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF8A6A45),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                //padding: const EdgeInsets.only(bottom: 30),
                                itemCount: filteredGames.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: gridGapV,
                                      crossAxisSpacing: gridGapH,
                                      childAspectRatio: 1.12,
                                    ),
                                itemBuilder: (context, index) {
                                  return GameCard(game: filteredGames[index]);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoredGame {
  final GameItem game;
  final int score;

  const _ScoredGame({required this.game, required this.score});
}

class _IntRange {
  final int min;
  final int max;

  const _IntRange(this.min, this.max);
}

bool _isRecentlyAdded(GameItem game) {
  final now = DateTime.now();
  final twoMonthsAgo = DateTime(now.year, now.month - 2, now.day);
  final addedDate = DateTime(
    game.addedDt.year,
    game.addedDt.month,
    game.addedDt.day,
  );

  return !addedDate.isBefore(twoMonthsAgo);
}

class GameCard extends StatelessWidget {
  final GameItem game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 보드게임 카드 크기 조정 값.
    final imagePaddingH = screenW * 0.009;
    final imagePaddingTop = screenH * 0.014;
    final imagePaddingBottom = screenH * 0.007;
    final gameNameSize = screenW * 0.019;
    final infoPaddingH = screenW * 0.009;
    final infoPaddingV = screenH * 0.008;
    final infoTextSize = screenW * 0.016;
    final infoIconSize = screenH * 0.018;
    final difficultyLabelSize = screenW * 0.015;
    final pickTextSize = screenW * 0.014;
    final pickIconSize = screenH * 0.018;
    final isNewGame = _isRecentlyAdded(game);
    final showBadge = isNewGame || game.isPick;
    final badgeText = isNewGame ? '신작' : '추천';
    final badgeIcon = isNewGame
        ? Icons.auto_awesome_rounded
        : Icons.star_rounded;
    final badgeColor = isNewGame
        ? const Color(0xFF22A979)
        : const Color.fromARGB(255, 231, 85, 49);
    final badgeIconColor = isNewGame
        ? const Color(0xFFFFF5A3)
        : Colors.amber;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GameDetailScreen(game: game)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8D8BE), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      imagePaddingH,
                      imagePaddingTop,
                      imagePaddingH,
                      imagePaddingBottom,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Image.asset(
                                game.imagePath,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                errorBuilder: (_, _, _) {
                                  return Container(
                                    color: const Color(0xFFFFE8BC),
                                    child: const Center(
                                      child: Icon(
                                        Icons.casino_rounded,
                                        size: 70,
                                        color: Color(0xFFB7832F),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenH * 0.006),
                        Text(
                          game.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: gameNameSize,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: infoPaddingH,
                    vertical: infoPaddingV,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1E9FF),
                    border: Border(
                      top: BorderSide(color: Color(0xFFE8D8BE), width: 2),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.groups_rounded, size: infoIconSize),
                          SizedBox(width: screenW * 0.002),
                          Text(
                            game.players,
                            style: TextStyle(
                              fontSize: infoTextSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: screenW * 0.006),
                          Icon(Icons.schedule_rounded, size: infoIconSize),
                          SizedBox(width: screenW * 0.002),
                          Text(
                            '${game.time}분',
                            style: TextStyle(
                              fontSize: infoTextSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: screenW * 0.006),
                          Icon(Icons.category_rounded, size: infoIconSize),
                          SizedBox(width: screenW * 0.002),
                          Flexible(
                            child: Text(
                              game.genre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: infoTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenH * 0.004),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '난이도 :',
                            style: TextStyle(
                              fontSize: difficultyLabelSize,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(width: screenW * 0.003),
                          StarDifficulty(count: game.difficulty),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showBadge)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenW * 0.007,
                    vertical: screenH * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        badgeIcon,
                        color: badgeIconColor,
                        size: pickIconSize,
                      ),
                      SizedBox(width: screenW * 0.002),
                      Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: pickTextSize,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StarDifficulty extends StatelessWidget {
  final int count;

  const StarDifficulty({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final starSize = MediaQuery.sizeOf(context).width * 0.019;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index >= count) {
          return const SizedBox.shrink();
        }
        return Icon(Icons.star_rounded, size: starSize, color: Colors.orange);
      }),
    );
  }
}

class FilterBadge extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  const FilterBadge({super.key, required this.text, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final badgeFontSize = screenW * 0.014;
    final deleteIconSize = screenW * 0.012;

    return Chip(
      label: Text(
        text,
        style: TextStyle(
          fontSize: badgeFontSize,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF5A3218),
        ),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE8D2AE)),
      deleteIcon: Icon(Icons.close_rounded, size: deleteIconSize),
      onDeleted: onRemove,
    );
  }
}

class FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final double sectionBottomGap;
  final double titleWidth;
  final double titleSize;
  final double optionWidth;
  final double optionHeight;
  final double optionFontSize;
  final double optionGap;
  final double optionRunGap;
  final double checkIconSize;
  final ValueChanged<String> onSelected;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.sectionBottomGap,
    required this.titleWidth,
    required this.titleSize,
    required this.optionWidth,
    required this.optionHeight,
    required this.optionFontSize,
    required this.optionGap,
    required this.optionRunGap,
    required this.checkIconSize,
    required this.onSelected,
  });

  double _scaledOptionFontSize(String option, bool isSelected) {
    final textLength = option.characters.length;
    final selectedScale = isSelected ? 0.88 : 1.0;

    if (textLength >= 7) {
      return optionFontSize * 0.78 * selectedScale;
    }
    if (textLength >= 6) {
      return optionFontSize * 0.84 * selectedScale;
    }
    if (textLength >= 5) {
      return optionFontSize * 0.9 * selectedScale;
    }
    return optionFontSize * selectedScale;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: sectionBottomGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: titleWidth,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3A2415),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: optionGap,
              runSpacing: optionRunGap,
              children: options.map((option) {
                final isSelected = selected == option;
                final optionTextSize = _scaledOptionFontSize(
                  option,
                  isSelected,
                );

                return SizedBox(
                  width: optionWidth,
                  height: optionHeight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => onSelected(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: EdgeInsets.symmetric(
                          horizontal: optionWidth * 0.08,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7E45D6)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7E45D6)
                                : const Color(0xFFE8D2AE),
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isSelected)
                              Positioned(
                                left: 0,
                                child: Icon(
                                  Icons.check_rounded,
                                  size: checkIconSize,
                                  color: Colors.white,
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: isSelected ? optionWidth * 0.14 : 0,
                              ),
                              child: Text(
                                option,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: optionTextSize,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF5A3218),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFAA22),
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Icon(icon, color: Colors.white, size: 44),
        ),
      ),
    );
  }
}

class GameTag extends StatelessWidget {
  final String text;

  const GameTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6C8D36),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
