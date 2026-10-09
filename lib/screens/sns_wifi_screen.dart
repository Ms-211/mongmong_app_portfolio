import 'package:flutter/material.dart';

class SnsWifiScreen extends StatelessWidget {
  const SnsWifiScreen({super.key});

  static const String wifiId = 'DEMO_WIFI';
  static const String wifiPassword = 'DEMO_ONLY';

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // SNS & Wi-Fi 화면 전체 크기 조정 값.
    final pagePaddingH = screenW * 0.033;
    final pagePaddingTop = screenH * 0.01;
    final pagePaddingBottom = screenH * 0.018;
    final headerGap = screenH * 0.012;
    final panelGap = screenW * 0.014;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.2)),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1720),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    pagePaddingH,
                    pagePaddingTop,
                    pagePaddingH,
                    pagePaddingBottom,
                  ),
                  child: Column(
                    children: [
                      _SnsWifiHeader(
                        onBack: () => Navigator.pop(context),
                        onHome: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                      SizedBox(height: headerGap),
                      Expanded(
                        child: Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.78,
                            heightFactor: 0.90,
                            child: Row(
                              children: [
                                const Expanded(child: _WifiPanel()),
                                SizedBox(width: panelGap),
                                const Expanded(child: _InstagramPanel()),
                                SizedBox(width: panelGap),
                                const Expanded(child: _NaverMapPanel()),
                              ],
                            ),
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

class _SnsWifiHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHome;

  const _SnsWifiHeader({required this.onBack, required this.onHome});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // SNS & Wi-Fi 헤더 크기 조정 값.
    final headerHeight = screenH * 0.14;
    final titleIconSize = screenH * 0.042;
    final titleSize = screenW * 0.031;
    final subtitleSize = screenW * 0.0145;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _TopButton(
              icon: Icons.arrow_back_rounded,
              label: '뒤로',
              onTap: onBack,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_rounded,
                    size: titleIconSize,
                    color: const Color(0xFF2F9D4B),
                  ),
                  SizedBox(width: screenW * 0.01),
                  Text(
                    'SNS & Wi-Fi 안내',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF3A2415),
                      shadows: const [
                        Shadow(
                          color: Color(0x552B160B),
                          offset: Offset(2, 3),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenH * 0.01),
              Text(
                '몽몽플레이 DEMO와 연결하고 더 많은 소식을 받아보세요!',
                maxLines: 1,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleSize,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B4A2E),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _TopButton(
              icon: Icons.home_rounded,
              label: '홈',
              onTap: onHome,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TopButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 상단 버튼 크기 조정 값.
    final buttonHeight = screenH * 0.072;
    final buttonPaddingH = screenW * 0.018;
    final iconSize = screenH * 0.036;
    final textSize = screenW * 0.018;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: buttonPaddingH),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: const Color(0xFF5B371B)),
            SizedBox(width: screenW * 0.005),
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

class _WifiPanel extends StatelessWidget {
  const _WifiPanel();

  @override
  Widget build(BuildContext context) {
    return _WifiCardPanel(
      title: 'Wi-Fi 안내',
      subtitle: 'QR코드로 간편하게 연결하세요',
      icon: Icons.wifi_rounded,
      child: Column(
        children: [
          const Expanded(
            flex: 4,
            child: _QrDisplay(
              child: _QrBox(
                imagePath: 'assets/images/sns_wifi_qr.png',
                borderColor: Color(0xFF2E9C45),
                padding: 10,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.006),
          const Expanded(
            flex: 6,
            child: Column(
              children: [
                _WifiInfoBox(
                  label: 'ID',
                  icon: Icons.wifi_rounded,
                  value: SnsWifiScreen.wifiId,
                ),
                SizedBox(height: 6),
                _WifiInfoBox(
                  label: 'PW',
                  icon: Icons.lock_rounded,
                  value: SnsWifiScreen.wifiPassword,
                ),
                SizedBox(height: 7),
                _WifiGuideBox(),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstagramPanel extends StatelessWidget {
  const _InstagramPanel();

  @override
  Widget build(BuildContext context) {
    return _SocialPanel(
      borderColor: const Color(0xFFF3A19B),
      title: '인스타그램',
      subtitle: '@demo_account',
      titleColor: const Color(0xFFE95555),
      icon: Icons.camera_alt_rounded,
      qrPath: 'assets/images/sns_instagram_qr.png',
      qrBorderColor: const Color(0xFFF3A19B),
      qrFit: BoxFit.cover,
      infoItems: const [
        _InfoChip(
          icon: Icons.casino_rounded,
          text: '신규 보드게임 입고 안내',
          color: Color(0xFFE95555),
          backgroundColor: Color(0xFFFFEFEF),
        ),
        _InfoChip(
          icon: Icons.card_giftcard_rounded,
          text: '이벤트 소식',
          color: Color(0xFFF28A2E),
          backgroundColor: Color(0xFFFFF2E5),
        ),
        _InfoChip(
          icon: Icons.favorite_rounded,
          text: '몽몽플레이 DEMO 소식',
          color: Color(0xFFE95555),
          backgroundColor: Color(0xFFFFEFEF),
        ),
      ],
      footerText: '팔로우하고\n몽몽플레이 DEMO의 새로운 소식을\n가장 먼저 만나보세요!',
      accentColor: const Color(0xFFE95555),
    );
  }
}

class _NaverMapPanel extends StatelessWidget {
  const _NaverMapPanel();

  @override
  Widget build(BuildContext context) {
    return _SocialPanel(
      borderColor: const Color(0xFF9CCD8E),
      title: '네이버 지도',
      subtitle: '운영 소식과 공지를 확인하세요',
      titleColor: const Color(0xFF258C3B),
      icon: Icons.location_on_rounded,
      qrPath: 'assets/images/sns_naver_map_qr.png',
      qrBorderColor: const Color(0xFF62B85A),
      infoItems: const [
        _InfoChip(
          icon: Icons.campaign_rounded,
          text: '가장 빠른 최신 소식',
          color: Color(0xFF258C3B),
          backgroundColor: Color(0xFFEAF7DC),
        ),
        _InfoChip(
          icon: Icons.storefront_rounded,
          text: '매장 운영상황 안내',
          color: Color(0xFF258C3B),
          backgroundColor: Color(0xFFEAF7DC),
        ),
        _InfoChip(
          icon: Icons.schedule_rounded,
          text: '운영시간 / 가게 공지',
          color: Color(0xFF258C3B),
          backgroundColor: Color(0xFFEAF7DC),
        ),
      ],
      footerText: '네이버 지도에서\n몽몽플레이 DEMO 공지를 확인해보세요!',
      accentColor: const Color(0xFF258C3B),
    );
  }
}

class _WifiCardPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _WifiCardPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // Wi-Fi 카드 크기 조정 값.
    final radius = screenW * 0.015;
    final borderWidth = screenW * 0.002;
    final headerPaddingH = screenW * 0.01;
    final headerPaddingTop = screenH * 0.01;
    final bodyPaddingH = screenW * 0.01;
    final bodyPaddingTop = screenH * 0.008;
    final bodyPaddingBottom = screenH * 0.01;
    final titleSize = screenW * 0.02;
    final subtitleSize = screenW * 0.0115;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFF40A94F), width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              headerPaddingH,
              headerPaddingTop,
              headerPaddingH,
              0,
            ),
            child: Row(
              children: [
                _SocialIcon(icon: icon, color: const Color(0xFF258C3B)),
                SizedBox(width: screenW * 0.007),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF258C3B),
                        ),
                      ),
                      SizedBox(height: screenH * 0.002),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2B2119),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                bodyPaddingH,
                bodyPaddingTop,
                bodyPaddingH,
                bodyPaddingBottom,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialPanel extends StatelessWidget {
  final Color borderColor;
  final Color titleColor;
  final Color accentColor;
  final String title;
  final String subtitle;
  final IconData icon;
  final String qrPath;
  final Color qrBorderColor;
  final List<Widget> infoItems;
  final String footerText;
  final BoxFit qrFit;

  const _SocialPanel({
    required this.borderColor,
    required this.titleColor,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.qrPath,
    required this.qrBorderColor,
    required this.infoItems,
    required this.footerText,
    this.qrFit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 소셜 카드 크기 조정 값.
    final cardPaddingH = screenW * 0.01;
    final cardPaddingV = screenH * 0.01;
    final radius = screenW * 0.015;
    final borderWidth = screenW * 0.002;
    final titleSize = screenW * 0.02;
    final subtitleSize = screenW * 0.0115;
    final sectionGap = screenH * 0.007;
    final infoGap = screenH * 0.004;
    final footerSize = screenW * 0.0145;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: cardPaddingH,
        vertical: cardPaddingV,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _SocialIcon(icon: icon, color: titleColor),
              SizedBox(width: screenW * 0.007),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w900,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: screenH * 0.002),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF2B2119),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sectionGap),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: _QrDisplay(
                    widthFactor: 0.94,
                    child: _QrBox(
                      imagePath: qrPath,
                      borderColor: qrBorderColor,
                      padding: 10,
                      fit: qrFit,
                    ),
                  ),
                ),
                SizedBox(height: screenH * 0.006),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      for (final item in infoItems) ...[
                        Expanded(child: item),
                        SizedBox(height: infoGap),
                      ],
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenW * 0.004,
                            vertical: screenH * 0.003,
                          ),
                          decoration:
                              BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                                borderRadius: BorderRadius.zero,
                              ).copyWith(
                                border: Border(
                                  bottom: BorderSide(
                                    color: accentColor.withValues(alpha: 0.4),
                                    width: 2,
                                  ),
                                ),
                              ),
                          child: Center(
                            child: Text(
                              footerText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: footerSize,
                                height: 1.08,
                                fontWeight: FontWeight.w900,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _QrBox extends StatelessWidget {
  final String imagePath;
  final Color borderColor;
  final double padding;
  final BoxFit fit;

  const _QrBox({
    required this.imagePath,
    required this.borderColor,
    required this.padding,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final scaledPadding = screenW * 0.006;
    final radius = screenW * 0.012;
    final borderWidth = screenW * 0.002;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(scaledPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Image.asset(
        imagePath,
        fit: fit,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}

class _QrDisplay extends StatelessWidget {
  final Widget child;
  final double widthFactor;

  const _QrDisplay({required this.child, this.widthFactor = 0.94});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = (constraints.maxWidth * widthFactor)
            .clamp(0.0, constraints.maxHeight)
            .toDouble();

        return Center(
          child: SizedBox.square(dimension: side, child: child),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color backgroundColor;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    final paddingH = screenW * 0.003;
    final paddingV = screenH * 0.004;
    final iconSize = screenH * 0.027;
    final gap = screenW * 0.008;
    final textSize = screenW * 0.015;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: color.withValues(alpha: 0.38), width: 2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: color),
          SizedBox(width: gap),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WifiInfoBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;

  const _WifiInfoBox({
    required this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    final paddingH = screenW * 0.007;
    final paddingV = screenH * 0.006;
    final badgePaddingH = screenW * 0.007;
    final badgePaddingV = screenH * 0.004;
    final labelSize = screenW * 0.0135;
    final iconSize = screenH * 0.024;
    final valueSize = screenW * 0.0185;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB7D99B), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: badgePaddingH,
              vertical: badgePaddingV,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF40A94F),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: labelSize,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: screenW * 0.005),
                Icon(icon, size: iconSize, color: Colors.white),
              ],
            ),
          ),
          SizedBox(width: screenW * 0.006),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1D1D1D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WifiGuideBox extends StatelessWidget {
  const _WifiGuideBox();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    final paddingH = screenW * 0.008;
    final paddingV = screenH * 0.006;
    final iconSize = screenH * 0.028;
    final gap = screenW * 0.008;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FAEA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB7D99B), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_rounded,
            size: iconSize,
            color: const Color(0xFF258C3B),
          ),
          SizedBox(width: gap),
          const Expanded(child: _WifiGuideText()),
        ],
      ),
    );
  }
}

class _WifiGuideText extends StatelessWidget {
  const _WifiGuideText();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    final titleSize = screenW * 0.015;
    final bodySize = screenW * 0.015;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wi-Fi 이용 안내',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF258C3B),
          ),
        ),
        SizedBox(height: screenH * 0.003),
        Text(
          '연결이 안 될 경우, 비밀번호를 직접 입력해주세요.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: bodySize,
            height: 1.12,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF2B2119),
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SocialIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final size = screenH * 0.063;
    final iconSize = screenH * 0.038;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
