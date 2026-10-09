import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../models/game_item.dart';

class GameDetailScreen extends StatefulWidget {
  final GameItem game;

  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  YoutubePlayerController? _controller;

  String get _youtubeVideoId {
    final youtubeId = widget.game.youtubeId.trim();
    if (youtubeId.isEmpty) {
      return '';
    }

    final uri = Uri.tryParse(youtubeId);
    final videoId = uri?.queryParameters['v'];
    if (videoId != null && videoId.trim().isNotEmpty) {
      return videoId.trim();
    }

    return youtubeId.split(RegExp(r'[?&]')).first.trim();
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final videoId = _youtubeVideoId;

    if (videoId.isNotEmpty) {
      _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
      _controller?.cueVideoById(videoId: videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenW = screenSize.width;
    final screenH = screenSize.height;

    // 보드게임 상세 화면 크기 조정 값.
    final pagePaddingH = screenW * 0.03;
    final pagePaddingTop = screenH * 0.014;
    final pagePaddingBottom = screenH * 0.024;
    final topButtonHeight = screenH * 0.068;
    final topButtonHPadding = screenW * 0.016;
    final topButtonIconSize = screenH * 0.036;
    final topButtonTextSize = screenW * 0.016;
    final titleSize = screenW * 0.038;
    final headerToBodyGap = screenH * 0.014;
    final contentPadding = screenW * 0.018;
    final leftPanelWidth = screenW * 0.25;
    final sideGap = screenW * 0.024;
    final imageToInfoGap = screenH * 0.014;
    final sideInfoGap = screenH * 0.01;
    final gameTitleSize = screenW * 0.033;
    final titleToInfoGap = screenH * 0.024;
    final infoCardGap = screenW * 0.01;
    final infoToVideoGap = screenH * 0.018;
    final videoTitleSize = screenW * 0.018;
    final videoTitleGap = screenH * 0.01;
    final emptyVideoTextSize = screenW * 0.022;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1650),
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
                          _TopButton(
                            icon: Icons.arrow_back_rounded,
                            text: '뒤로',
                            height: topButtonHeight,
                            horizontalPadding: topButtonHPadding,
                            iconSize: topButtonIconSize,
                            textSize: topButtonTextSize,
                            onTap: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              // Text(
                              //   '🌿',
                              //   style: TextStyle(fontSize: titleSize * 0.55),
                              // ),
                              SizedBox(width: screenW * 0.006),
                              Text(
                                '보드게임 상세',
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF3A2415),
                                ),
                              ),
                              SizedBox(width: screenW * 0.006),
                              // Text(
                              //   '🌿',
                              //   style: TextStyle(fontSize: titleSize * 0.55),
                              // ),
                            ],
                          ),
                          const Spacer(),
                          _TopButton(
                            icon: Icons.home_rounded,
                            text: '홈',
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
                      SizedBox(height: headerToBodyGap),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(contentPadding),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.93),
                            borderRadius: BorderRadius.circular(34),
                            border: Border.all(
                              color: const Color(0xFFE8D2AE),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: leftPanelWidth,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(28),
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: Image.asset(
                                            widget.game.imagePath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: imageToInfoGap),
                                    _SideInfoBox(
                                      title: '장르',
                                      icon: Icons.category_rounded,
                                      value: widget.game.genre,
                                    ),
                                    SizedBox(height: sideInfoGap),
                                    _LocationBox(game: widget.game),
                                  ],
                                ),
                              ),

                              SizedBox(width: sideGap),
                              Container(
                                width: 2,
                                color: const Color(0xFFE8D2AE),
                              ),
                              SizedBox(width: sideGap),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.game.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: gameTitleSize,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF3A2415),
                                      ),
                                    ),
                                    SizedBox(height: screenH * 0.003),
                                    // Text(
                                    //   game.name,
                                    //   style: const TextStyle(
                                    //     fontSize: 22,
                                    //     fontWeight: FontWeight.w600,
                                    //     color: Color(0xFF9A8A78),
                                    //   ),
                                    // ),
                                    SizedBox(height: titleToInfoGap),

                                    Row(
                                      children: [
                                        _InfoCard(
                                          icon: Icons.groups_rounded,
                                          title: '인원',
                                          value: widget.game.players,
                                          horizontal: true,
                                        ),
                                        SizedBox(width: infoCardGap),
                                        _InfoCard(
                                          icon: Icons.schedule_rounded,
                                          title: '시간',
                                          value: '${widget.game.time}분',
                                          horizontal: true,
                                        ),
                                        SizedBox(width: infoCardGap),
                                        _InfoCard(
                                          icon: Icons.bar_chart_rounded,
                                          title: '난이도',
                                          valueWidget: _StarDifficulty(
                                            count: widget.game.difficulty,
                                          ),
                                        ),
                                        // tags는 JSON/model에는 유지하지만 화면에는 표시하지 않는다.
                                        // const SizedBox(width: 14),
                                        // _TagCard(
                                        //   genre: widget.game.genre,
                                        //   tags: widget.game.tags,
                                        // ),
                                      ],
                                    ),

                                    SizedBox(height: infoToVideoGap),

                                    // description은 JSON/model에는 유지하지만 화면에는 표시하지 않는다.
                                    // Container(
                                    //   width: double.infinity,
                                    //   padding: const EdgeInsets.symmetric(
                                    //     horizontal: 22,
                                    //     vertical: 18,
                                    //   ),
                                    //   decoration: BoxDecoration(
                                    //     color: const Color(0xFFFFF3D6),
                                    //     borderRadius: BorderRadius.circular(18),
                                    //     border: Border.all(
                                    //       color: const Color(0xFFE8D2AE),
                                    //     ),
                                    //   ),
                                    //   child: Text(
                                    //     widget.game.description,
                                    //     style: const TextStyle(
                                    //       fontSize: 24,
                                    //       fontWeight: FontWeight.w800,
                                    //       color: Color(0xFF5A3218),
                                    //     ),
                                    //   ),
                                    // ),
                                    //
                                    // const SizedBox(height: 22),
                                    Text(
                                      '게임 소개 영상',
                                      style: TextStyle(
                                        fontSize: videoTitleSize,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF3A2415),
                                      ),
                                    ),
                                    SizedBox(height: videoTitleGap),

                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(22),
                                        child: _controller == null
                                            ? Container(
                                                color: const Color(0xFFFFF3D6),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '게임 설명 영상을 준비중이에요',
                                                  style: TextStyle(
                                                    fontSize:
                                                        emptyVideoTextSize,
                                                    fontWeight: FontWeight.w900,
                                                    color: const Color(
                                                      0xFF5A3218,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : YoutubePlayer(
                                                controller: _controller!,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

class _TopButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double textSize;
  final VoidCallback onTap;

  const _TopButton({
    required this.icon,
    required this.text,
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
            Icon(icon, size: iconSize, color: const Color(0xFF5B371B)),
            SizedBox(width: horizontalPadding * 0.25),
            Text(
              text,
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Widget? valueWidget;
  final bool horizontal;

  const _InfoCard({
    required this.icon,
    required this.title,
    this.value,
    this.valueWidget,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 상세 상단 정보 카드 크기 조정 값.
    final cardHeight = screenH * 0.1;
    final paddingH = screenW * 0.008;
    final paddingV = screenH * 0.008;
    final iconSize = screenH * 0.032;
    final titleSize = screenW * 0.0155;
    final valueSize = screenW * 0.0185;

    return Expanded(
      child: Container(
        height: cardHeight,
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAF0),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8D2AE)),
        ),
        child: horizontal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: iconSize, color: const Color(0xFF6C8D36)),
                  SizedBox(width: screenW * 0.005),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF6B4A2E),
                    ),
                  ),
                  SizedBox(width: screenW * 0.01),
                  Text(
                    value ?? '',
                    style: TextStyle(
                      fontSize: valueSize,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF222222),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: iconSize,
                        color: const Color(0xFF6C8D36),
                      ),
                      SizedBox(width: screenW * 0.005),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF6B4A2E),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  valueWidget ??
                      Text(
                        value ?? '',
                        style: TextStyle(
                          fontSize: valueSize,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF222222),
                        ),
                      ),
                ],
              ),
      ),
    );
  }
}

// class _TagCard extends StatelessWidget {
//   final String genre;
//   final String? tags;
//
//   const _TagCard({required this.genre, required this.tags});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         height: 100,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFFFAF0),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: const Color(0xFFE8D2AE)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '태그',
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w900,
//                 color: Color(0xFF6B4A2E),
//               ),
//             ),
//             const Spacer(),
//             Wrap(
//               spacing: 6,
//               children: [
//                 _SmallTag(text: genre),
//                 if (tags != null && tags!.trim().isNotEmpty)
//                   _SmallTag(text: tags!),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SmallTag extends StatelessWidget {
//   final String text;
//
//   const _SmallTag({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//       decoration: BoxDecoration(
//         color: const Color(0xFF6C8D36),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 17,
//           fontWeight: FontWeight.w900,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

class _StarDifficulty extends StatelessWidget {
  final int count;

  const _StarDifficulty({required this.count});

  @override
  Widget build(BuildContext context) {
    final starSize = MediaQuery.sizeOf(context).width * 0.0165;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          Icons.star_rounded,
          size: starSize,
          color: index < count ? Colors.orange : const Color(0xFFD8D8D8),
        );
      }),
    );
  }
}

class _LocationBox extends StatelessWidget {
  final GameItem game;

  const _LocationBox({required this.game});

  @override
  Widget build(BuildContext context) {
    return _SideInfoBox(
      title: '위치',
      icon: Icons.location_on_rounded,
      value: game.locationText,
    );
  }
}

class _SideInfoBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;

  const _SideInfoBox({
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 상세 좌측 장르/위치 박스 크기 조정 값.
    final boxHeight = screenH * 0.105;
    final paddingH = screenW * 0.012;
    final paddingV = screenH * 0.01;
    final iconBoxSize = screenH * 0.044;
    final iconSize = screenH * 0.026;
    final iconGap = screenW * 0.012;
    final titleSize = screenW * 0.0145;
    final valueSize = screenW * 0.0185;
    final titleValueGap = screenH * 0.004;

    return Container(
      height: boxHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCF4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD6E4C4), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: const BoxDecoration(
              color: Color(0xFF6C8D36),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
          SizedBox(width: iconGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF6C8D36),
                  ),
                ),
                SizedBox(height: titleValueGap),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: valueSize,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4A2C17),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
