import 'package:flutter/material.dart';
import 'game_search_screen.dart';

class GameRecommendScreen extends StatefulWidget {
  const GameRecommendScreen({super.key});

  @override
  State<GameRecommendScreen> createState() => _GameRecommendScreenState();
}

class _GameRecommendScreenState extends State<GameRecommendScreen> {
  String? player;
  String? mood;
  String? difficulty;
  String? time;

  bool get isReady => player != null;

  String get _genreFilter {
    switch (mood) {
      case '신나는 파티':
        return '파티';
      case '전략적인':
        return '전략';
      case '추리/몰입형':
        return '추리';
      case '협동/팀워크':
        return '협동';
      case '순발력':
        return '순발력';
      default:
        return '전체';
    }
  }

  void _findRecommendGames() {
    if (!isReady) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameSearchScreen(
          title: '추천 게임 결과',
          recommendationMode: true,
          initialPlayerFilter: player!,
          initialGenreFilter: _genreFilter,
          initialDifficultyFilter: difficulty ?? '전체',
          initialTimeFilter: time ?? '전체',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1850),
                child: LayoutBuilder(
                  builder: (context, screen) {
                    final screenW = screen.maxWidth;
                    final screenH = screen.maxHeight;

                    // 보드게임 추천 화면 크기 조정 값.
                    // 숫자를 키우면 해당 요소가 커지거나 간격이 넓어진다.
                    final horizontalPadding = screenW * 0.022;
                    final topPadding = screenH * 0.014;
                    final bottomPadding = screenH * 0.018;
                    final titleSize = screenW * 0.038;
                    final subtitleSize = screenW * 0.018;
                    final subtitleGap = screenH * 0.006;
                    final questionTopGap = screenH * 0.016;

                    final topButtonHeight = screenH * 0.074;
                    final topButtonHPadding = screenW * 0.018;
                    final topButtonIconSize = screenH * 0.038;
                    final topButtonTextSize = screenW * 0.018;

                    final actionButtonWidth = screenW * 0.46;
                    final actionButtonHeight = screenH * 0.074;
                    final actionButtonIconSize = screenH * 0.04;
                    final actionButtonTextSize = screenW * 0.022;
                    final actionTopGap = screenH * 0.01;

                    final sectionPaddingH = screenW * 0.014;
                    final sectionPaddingV = screenH * 0.008;
                    final sectionBottomGap = screenH * 0.008;
                    final numberSize = screenH * 0.062;
                    final sectionIconSize = screenH * 0.036;
                    final sectionTitleWidth = screenW * 0.15;
                    final sectionTitleSize = screenW * 0.0243;
                    final dividerHeight = screenH * 0.075;
                    final optionGap = screenW * 0.008;
                    final optionIconSize = screenH * 0.048;
                    final optionTextSize = screenW * 0.0198;
                    final difficultyTextSize = screenW * 0.0252;

                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        topPadding,
                        horizontalPadding,
                        bottomPadding,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _TopButton(
                                icon: Icons.arrow_back_rounded,
                                label: '뒤로',
                                height: topButtonHeight,
                                horizontalPadding: topButtonHPadding,
                                iconSize: topButtonIconSize,
                                textSize: topButtonTextSize,
                                onTap: () => Navigator.pop(context),
                              ),
                              const Spacer(),
                              Text(
                                '보드게임 추천',
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF3A2415),
                                ),
                              ),
                              const Spacer(),
                              _TopButton(
                                icon: Icons.home_rounded,
                                label: '홈',
                                height: topButtonHeight,
                                horizontalPadding: topButtonHPadding,
                                iconSize: topButtonIconSize,
                                textSize: topButtonTextSize,
                                onTap: () {
                                  Navigator.popUntil(
                                    context,
                                    (route) => route.isFirst,
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: subtitleGap),
                          Text(
                            '몇 가지 질문에 답해주시면, 딱 맞는 보드게임을 추천해드려요!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF5B371B),
                            ),
                          ),
                          SizedBox(height: questionTopGap),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final sectionHeight =
                                    (constraints.maxHeight -
                                        actionTopGap -
                                        actionButtonHeight) /
                                    4;

                                return Column(
                                  children: [
                                    SizedBox(
                                      height: sectionHeight,
                                      child: RecommendQuestionSection(
                                        number: '01',
                                        icon: Icons.groups_rounded,
                                        title: '인원수',
                                        isRequired: true,
                                        options: const [
                                          '2인',
                                          '3인',
                                          '4인',
                                          '5~6인',
                                          '7인+',
                                        ],
                                        selected: player,
                                        horizontalPadding: sectionPaddingH,
                                        verticalPadding: sectionPaddingV,
                                        bottomGap: sectionBottomGap,
                                        numberSize: numberSize,
                                        sectionIconSize: sectionIconSize,
                                        titleWidth: sectionTitleWidth,
                                        titleSize: sectionTitleSize,
                                        dividerHeight: dividerHeight,
                                        optionGap: optionGap,
                                        optionIconSize: optionIconSize,
                                        optionTextSize: optionTextSize,
                                        difficultyTextSize: difficultyTextSize,
                                        onSelected: (value) {
                                          setState(() => player = value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: sectionHeight,
                                      child: RecommendQuestionSection(
                                        number: '02',
                                        icon: Icons.celebration_rounded,
                                        title: '분위기',
                                        isRequired: false,
                                        options: const [
                                          '신나는 파티',
                                          '전략적인',
                                          '추리/몰입형',
                                          '협동/팀워크',
                                          '순발력',
                                        ],
                                        selected: mood,
                                        horizontalPadding: sectionPaddingH,
                                        verticalPadding: sectionPaddingV,
                                        bottomGap: sectionBottomGap,
                                        numberSize: numberSize,
                                        sectionIconSize: sectionIconSize,
                                        titleWidth: sectionTitleWidth,
                                        titleSize: sectionTitleSize,
                                        dividerHeight: dividerHeight,
                                        optionGap: optionGap,
                                        optionIconSize: optionIconSize,
                                        optionTextSize: optionTextSize,
                                        difficultyTextSize: difficultyTextSize,
                                        onSelected: (value) {
                                          setState(() => mood = value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: sectionHeight,
                                      child: RecommendQuestionSection(
                                        number: '03',
                                        icon: Icons.bar_chart_rounded,
                                        title: '난이도',
                                        isRequired: false,
                                        options: const [
                                          '★',
                                          '★★',
                                          '★★★',
                                          '★★★★',
                                          '★★★★★',
                                        ],
                                        selected: difficulty,
                                        horizontalPadding: sectionPaddingH,
                                        verticalPadding: sectionPaddingV,
                                        bottomGap: sectionBottomGap,
                                        numberSize: numberSize,
                                        sectionIconSize: sectionIconSize,
                                        titleWidth: sectionTitleWidth,
                                        titleSize: sectionTitleSize,
                                        dividerHeight: dividerHeight,
                                        optionGap: optionGap,
                                        optionIconSize: optionIconSize,
                                        optionTextSize: optionTextSize,
                                        difficultyTextSize: difficultyTextSize,
                                        onSelected: (value) {
                                          setState(() => difficulty = value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: sectionHeight,
                                      child: RecommendQuestionSection(
                                        number: '04',
                                        icon: Icons.schedule_rounded,
                                        title: '시간',
                                        isRequired: false,
                                        options: const [
                                          '10분 이하',
                                          '10분~20분',
                                          '20분~40분',
                                          '40분~60분',
                                          '60분 이상',
                                        ],
                                        selected: time,
                                        horizontalPadding: sectionPaddingH,
                                        verticalPadding: sectionPaddingV,
                                        bottomGap: sectionBottomGap,
                                        numberSize: numberSize,
                                        sectionIconSize: sectionIconSize,
                                        titleWidth: sectionTitleWidth,
                                        titleSize: sectionTitleSize,
                                        dividerHeight: dividerHeight,
                                        optionGap: optionGap,
                                        optionIconSize: optionIconSize,
                                        optionTextSize: optionTextSize,
                                        difficultyTextSize: difficultyTextSize,
                                        onSelected: (value) {
                                          setState(() => time = value);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: actionTopGap),
                                    SizedBox(
                                      width: actionButtonWidth,
                                      height: actionButtonHeight,
                                      child: ElevatedButton.icon(
                                        onPressed: isReady
                                            ? _findRecommendGames
                                            : null,
                                        icon: Icon(
                                          Icons.search_rounded,
                                          size: actionButtonIconSize,
                                        ),
                                        label: Text(
                                          '추천게임 찾기',
                                          style: TextStyle(
                                            fontSize: actionButtonTextSize,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF7E45D6,
                                          ),
                                          disabledBackgroundColor: const Color(
                                            0xFFB9A6D8,
                                          ),
                                          foregroundColor: Colors.white,
                                          disabledForegroundColor:
                                              Colors.white70,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              screenW * 0.014,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendQuestionSection extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final bool isRequired;
  final List<String> options;
  final String? selected;
  final double horizontalPadding;
  final double verticalPadding;
  final double bottomGap;
  final double numberSize;
  final double sectionIconSize;
  final double titleWidth;
  final double titleSize;
  final double dividerHeight;
  final double optionGap;
  final double optionIconSize;
  final double optionTextSize;
  final double difficultyTextSize;
  final ValueChanged<String> onSelected;

  const RecommendQuestionSection({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.isRequired,
    required this.options,
    required this.selected,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.bottomGap,
    required this.numberSize,
    required this.sectionIconSize,
    required this.titleWidth,
    required this.titleSize,
    required this.dividerHeight,
    required this.optionGap,
    required this.optionIconSize,
    required this.optionTextSize,
    required this.difficultyTextSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: bottomGap),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: numberSize,
            height: numberSize,
            decoration: const BoxDecoration(
              color: Color(0xFF8F62D8),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isRequired ? '필수' : '선택',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  number,
                  style: TextStyle(
                    fontSize: numberSize * 0.38,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: horizontalPadding * 0.7),
          Icon(icon, size: sectionIconSize, color: const Color(0xFF6B4A2E)),
          SizedBox(width: horizontalPadding * 0.6),
          SizedBox(
            width: titleWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3A2415),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 2,
            height: dividerHeight,
            color: const Color(0xFFEAD8BB),
          ),
          SizedBox(width: horizontalPadding * 0.9),
          Expanded(
            child: Row(
              children: [
                for (var index = 0; index < options.length; index++) ...[
                  Expanded(
                    child: RecommendOptionButton(
                      text: options[index],
                      icon: _optionIcon(options[index]),
                      showIcon: !_isDifficultyOption(options[index]),
                      selected: selected == options[index],
                      iconSize: optionIconSize,
                      textSize: optionTextSize,
                      difficultyTextSize: difficultyTextSize,
                      onTap: () => onSelected(options[index]),
                    ),
                  ),
                  if (index != options.length - 1) SizedBox(width: optionGap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _optionIcon(String option) {
    switch (option) {
      case '2인':
        return Icons.person_rounded;
      case '3인':
        return Icons.group_rounded;
      case '4인':
        return Icons.groups_rounded;
      case '5~6인':
        return Icons.diversity_2_rounded;
      case '7인+':
        return Icons.diversity_3_rounded;
      case '신나는 파티':
        return Icons.celebration_rounded;
      case '전략적인':
        return Icons.account_tree_rounded;
      case '추리/몰입형':
        return Icons.search_rounded;
      case '협동/팀워크':
        return Icons.handshake_rounded;
      case '순발력':
        return Icons.bolt_rounded;
      case '10분 이하':
        return Icons.schedule_rounded;
      case '10분~20분':
      case '20분~40분':
      case '40분~60분':
        return Icons.schedule_rounded;
      case '60분 이상':
        return Icons.more_time_rounded;
    }
    return Icons.star_rounded;
  }

  bool _isDifficultyOption(String option) {
    return option == '★' ||
        option == '★★' ||
        option == '★★★' ||
        option == '★★★★' ||
        option == '★★★★★';
  }
}

class RecommendOptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool showIcon;
  final bool selected;
  final double iconSize;
  final double textSize;
  final double difficultyTextSize;
  final VoidCallback onTap;

  const RecommendOptionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.showIcon,
    required this.selected,
    required this.iconSize,
    required this.textSize,
    required this.difficultyTextSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF2E7FF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF8F62D8) : const Color(0xFFE8D2AE),
            width: selected ? 3 : 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ...[
              Icon(
                icon,
                size: iconSize,
                color: selected
                    ? const Color(0xFF7E45D6)
                    : const Color(0xFF7A5636),
              ),
              SizedBox(height: iconSize * 0.08),
            ],
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: showIcon ? textSize : difficultyTextSize,
                height: 1,
                fontWeight: FontWeight.w900,
                color: selected
                    ? const Color(0xFF7E45D6)
                    : const Color(0xFF5A3218),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double textSize;
  final VoidCallback onTap;

  const _TopButton({
    required this.icon,
    required this.label,
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.textSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE0C8A3), width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF5B371B), size: iconSize),
            SizedBox(width: horizontalPadding * 0.2),
            Text(
              label,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5B371B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
