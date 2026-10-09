import 'package:flutter/material.dart';
import 'screens/event_screen.dart';
import 'screens/game_recommend_screen.dart';
import 'screens/game_search_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/sns_wifi_screen.dart';

void main() {
  runApp(const MongmongApp());
}

class MongmongApp extends StatelessWidget {
  const MongmongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '몽몽플레이 DEMO',
      theme: ThemeData(fontFamily: null),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget mainButton({
    required String title,
    required String iconPath,
    required Color color,
    required double width,
    required double height,
    required double textSize,
    required double radius,
    required double borderWidth,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: borderWidth * 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Center(
                child: Image.asset(
                  iconPath,
                  height: height * 0.70,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 3),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget subButton({
    required String title,
    required IconData icon,
    required Color borderColor,
    required double width,
    required double height,
    required double textSize,
    required double iconSize,
    required double radius,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: 3),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: LayoutBuilder(
            builder: (context, size) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: borderColor, size: iconSize),
                  SizedBox(width: size.maxWidth * 0.045),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: textSize,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3A281C),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
            child: LayoutBuilder(
              builder: (context, size) {
                final screenW = size.maxWidth;
                final screenH = size.maxHeight;

                // 메인화면 크기 조정 값.
                // 숫자를 키우면 해당 요소가 커지거나 간격이 넓어진다.
                final topGap = screenH * 0.022; // 화면 상단 -> 로고
                final logoHeight = screenH * 0.15; // 로고 높이
                final logoToTitleGap = screenH * 0.008; // 로고 -> 문구
                final titleToMainGap = screenH * 0.026; // 문구 -> 큰 버튼
                final mainToSubGap = screenH * 0.056; // 큰 버튼 -> 하단 버튼

                final mainButtonWidth = screenW * 0.26;
                final mainButtonHeight = screenH * 0.36;
                final mainButtonGap = screenW * 0.012;
                final mainButtonTextSize = screenW * 0.028;
                final mainButtonRadius = screenW * 0.018;
                final mainButtonBorderWidth = screenW * 0.0035;

                final subButtonWidth = screenW * 0.21;
                final subButtonHeight = screenH * 0.135;
                final subButtonGap = screenW * 0.015;
                final subButtonTextSize = screenW * 0.0196;
                final subButtonIconSize = subButtonHeight * 0.36;
                final subButtonRadius = screenW * 0.014;
                final subtitleSize = screenW * 0.018;

                return Column(
                  children: [
                    SizedBox(height: topGap),

                    Image.asset(
                      'assets/images/home_logo.png',
                      height: logoHeight,
                    ),

                    SizedBox(height: logoToTitleGap),

                    Text(
                      '보드게임과 함께, 즐거운 순간을 만들어요!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3D2A1D),
                      ),
                    ),

                    SizedBox(height: titleToMainGap),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mainButton(
                          title: '보드게임 찾기',
                          iconPath: 'assets/images/icon_find_game.png',
                          color: const Color(0xFF71C143),
                          width: mainButtonWidth,
                          height: mainButtonHeight,
                          textSize: mainButtonTextSize,
                          radius: mainButtonRadius,
                          borderWidth: mainButtonBorderWidth,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GameSearchScreen(),
                              ),
                            );
                          },
                        ),

                        SizedBox(width: mainButtonGap),

                        mainButton(
                          title: '메뉴 보기',
                          iconPath: 'assets/images/icon_view_menu.png',
                          color: const Color(0xFFFFA81D),
                          width: mainButtonWidth,
                          height: mainButtonHeight,
                          textSize: mainButtonTextSize,
                          radius: mainButtonRadius,
                          borderWidth: mainButtonBorderWidth,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MenuScreen(),
                              ),
                            );
                          },
                        ),

                        SizedBox(width: mainButtonGap),
                        mainButton(
                          title: '보드게임 추천',
                          iconPath: 'assets/images/icon_rec_game.png',
                          color: const Color(0xFF7C4BC4),
                          width: mainButtonWidth,
                          height: mainButtonHeight,
                          textSize: mainButtonTextSize,
                          radius: mainButtonRadius,
                          borderWidth: mainButtonBorderWidth,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GameRecommendScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: mainToSubGap),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        subButton(
                          title: '이용 안내',
                          icon: Icons.menu_book_outlined,
                          borderColor: const Color(0xFF56B7AA),
                          width: subButtonWidth,
                          height: subButtonHeight,
                          textSize: subButtonTextSize,
                          iconSize: subButtonIconSize,
                          radius: subButtonRadius,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GuideScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: subButtonGap),
                        subButton(
                          title: 'SNS & 와이파이',
                          icon: Icons.wifi,
                          borderColor: const Color(0xFF5DAAE5),
                          width: subButtonWidth,
                          height: subButtonHeight,
                          textSize: subButtonTextSize,
                          iconSize: subButtonIconSize,
                          radius: subButtonRadius,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SnsWifiScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: subButtonGap),
                        subButton(
                          title: '이벤트',
                          icon: Icons.card_giftcard,
                          borderColor: const Color(0xFFE77C7C),
                          width: subButtonWidth,
                          height: subButtonHeight,
                          textSize: subButtonTextSize,
                          iconSize: subButtonIconSize,
                          radius: subButtonRadius,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EventScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
