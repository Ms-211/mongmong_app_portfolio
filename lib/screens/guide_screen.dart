import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenW = screenSize.width;
    final screenH = screenSize.height;

    // 이용 안내 화면 전체 크기 조정 값.
    final pagePaddingH = screenW * 0.03;
    final pagePaddingTop = screenH * 0.012;
    final pagePaddingBottom = screenH * 0.018;
    final headerToContentGap = screenH * 0.012;
    final rowGap = screenH * 0.014;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.18)),
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
                      _GuideHeader(
                        onBack: () => Navigator.pop(context),
                        onHome: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                      SizedBox(height: headerToContentGap),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 13,
                              child: Row(
                                children: const [
                                  Expanded(flex: 7, child: _PricePanel()),
                                  _ResponsiveGap(horizontal: true),
                                  Expanded(
                                    flex: 6,
                                    child: _BoardGameGuidePanel(),
                                  ),
                                  _ResponsiveGap(horizontal: true),
                                  Expanded(
                                    flex: 6,
                                    child: _NintendoGuidePanel(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: rowGap),
                            Expanded(
                              flex: 7,
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 12,
                                    child: _CleanUpGuidePanel(),
                                  ),
                                  _ResponsiveGap(horizontal: true),
                                  Expanded(flex: 7, child: _NoticePanel()),
                                ],
                              ),
                            ),
                          ],
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

class _GuideHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHome;

  const _GuideHeader({required this.onBack, required this.onHome});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 이용 안내 헤더 크기 조정 값.
    final headerHeight = screenH * 0.08;
    final titleIconSize = screenH * 0.039;
    final titleSize = screenW * 0.034;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _GuideTopButton(
              icon: Icons.arrow_back_rounded,
              label: '뒤로',
              onTap: onBack,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.casino_rounded,
                size: titleIconSize,
                color: const Color(0xFF5A3215),
              ),
              SizedBox(width: screenW * 0.01),
              Text(
                '이용 안내',
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
          Align(
            alignment: Alignment.centerRight,
            child: _GuideTopButton(
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

class _GuideTopButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GuideTopButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 이용 안내 상단 버튼 크기 조정 값.
    final buttonHeight = screenH * 0.065;
    final horizontalPadding = screenW * 0.016;
    final iconSize = screenH * 0.034;
    final textSize = screenW * 0.016;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: buttonHeight,
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
            SizedBox(width: screenW * 0.004),
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

class _GuidePanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;
  final bool centerTitle;

  const _GuidePanel({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 이용 안내 공통 패널 크기 조정 값.
    final paddingH = screenW * 0.01;
    final paddingV = screenH * 0.01;
    final iconSize = screenH * 0.032;
    final titleSize = screenW * 0.021;
    final titleGap = screenH * 0.008;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(
        paddingV,
      ).copyWith(left: paddingH, right: paddingH),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: centerTitle
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(icon, size: iconSize, color: color),
              SizedBox(width: screenW * 0.006),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3A2415),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: titleGap),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _PricePanel extends StatelessWidget {
  const _PricePanel();

  @override
  Widget build(BuildContext context) {
    return _GuidePanel(
      icon: Icons.paid_rounded,
      title: '요금제',
      color: const Color(0xFFD69A21),
      child: Column(
        children: const [
          Expanded(
            flex: 6,
            child: _PriceCard(
              title: '평일 요금',
              color: Color(0xFF78B957),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PriceLine(label: '청소년', time: '1시간', price: '2,000원'),
                  SizedBox(height: 2),
                  _PriceLine(label: '성인', time: '1시간', price: '2,500원'),
                  SizedBox(height: 2),
                  _SaleBox(
                    title: '3시간 요금제',
                    child: Column(
                      children: [
                        _SaleLine(
                          label: '청소년',
                          before: '6,000원',
                          after: '5,000원',
                        ),
                        SizedBox(height: 2),
                        _SaleLine(
                          label: '성인',
                          before: '7,500원',
                          after: '6,000원',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '중학생부터 1인 1주문',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3A2415),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            flex: 4,
            child: _PriceCard(
              title: '주말 요금',
              color: Color(0xFFFF8456),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PriceLine(label: '청소년', time: '1시간', price: '2,400원'),
                  SizedBox(height: 2),
                  _PriceLine(label: '성인', time: '1시간', price: '3,000원'),
                  SizedBox(height: 2),
                  Text(
                    '초등학생부터 1인 1주문',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3A2415),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const _PriceCard({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 요금 카드 크기 조정 값.
    final sideWidth = screenW * 0.055;
    final sideFontSize = screenW * 0.018;
    final contentPaddingH = screenW * 0.006;
    final contentPaddingV = screenH * 0.005;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: sideWidth,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenW * 0.004),
            color: color,
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: sideFontSize,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: contentPaddingH,
                vertical: contentPaddingV,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final String time;
  final String price;

  const _PriceLine({
    required this.label,
    required this.time,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 요금 라인 크기 조정 값.
    final iconSize = screenH * 0.022;
    final labelSize = screenW * 0.016;
    final timeSize = screenW * 0.0135;
    final priceSize = screenW * 0.016;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_rounded,
              size: iconSize,
              color: const Color(0xFF3A2415),
            ),
            SizedBox(width: screenW * 0.004),
            Text(
              label,
              style: TextStyle(
                fontSize: labelSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3A2415),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: timeSize,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3A2415),
              ),
            ),
            SizedBox(width: screenW * 0.006),
            Text(
              price,
              maxLines: 1,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: priceSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3A2415),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SaleBox extends StatelessWidget {
  final String title;
  final Widget child;

  const _SaleBox({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    final titleSize = screenW * 0.012;
    final titlePaddingH = screenW * 0.008;
    final titlePaddingV = screenH * 0.002;
    final titleBottomGap = screenH * 0.003;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: titlePaddingH,
              vertical: titlePaddingV,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9A2D),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: titleBottomGap),
          child,
        ],
      ),
    );
  }
}

class _SaleLine extends StatelessWidget {
  final String label;
  final String before;
  final String after;

  const _SaleLine({
    required this.label,
    required this.before,
    required this.after,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final labelSize = screenW * 0.0155;
    final beforeSize = screenW * 0.011;
    final afterSize = screenW * 0.015;
    final arrowSize = screenW * 0.015;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF3A2415),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              before,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: beforeSize,
                decoration: TextDecoration.lineThrough,
                color: const Color(0xFF8A6A45),
              ),
            ),
            SizedBox(width: screenW * 0.004),
            Icon(
              Icons.arrow_forward_rounded,
              size: arrowSize,
              color: const Color(0xFF5B8E32),
            ),
            SizedBox(width: screenW * 0.004),
            Text(
              after,
              style: TextStyle(
                fontSize: afterSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFD2322D),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ignore: unused_element
class _OrderRuleBox extends StatelessWidget {
  const _OrderRuleBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4CE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECC065), width: 2),
      ),
      child: Row(
        children: const [
          Icon(Icons.fastfood_rounded, size: 40, color: Color(0xFFD69A21)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '1인 1주문 필수\n음료 or 음식',
              style: TextStyle(
                fontSize: 20,
                height: 1.2,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3A2415),
              ),
            ),
          ),
          VerticalDivider(width: 22, thickness: 2, color: Color(0xFFECC065)),
          Icon(Icons.icecream_rounded, size: 42, color: Color(0xFFE77C7C)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '빙수는 최대 2인까지\n1메뉴로 인정',
              style: TextStyle(
                fontSize: 20,
                height: 1.2,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3A2415),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallGuideBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SmallGuideBox({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 하단 작은 안내 박스 크기 조정 값.
    final paddingH = screenW * 0.008;
    final paddingV = screenH * 0.008;
    final iconSize = screenH * 0.033;
    final textSize = screenW * 0.0145;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D2AE)),
      ),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: const Color(0xFF7A5636)),
          SizedBox(width: screenW * 0.006),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                height: 1.06,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3A2415),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardGameGuidePanel extends StatelessWidget {
  const _BoardGameGuidePanel();

  @override
  Widget build(BuildContext context) {
    return _GuidePanel(
      icon: Icons.extension_rounded,
      title: '보드게임 이용 안내',
      color: const Color(0xFF6C8D36),
      child: Column(
        children: const [
          Expanded(
            child: _LargeGuideItem(
              icon: Icons.inventory_2_rounded,
              text: '게임은 한 번에\n한 개씩만 이용해주세요.',
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _LargeGuideItem(
              icon: Icons.keyboard_return_rounded,
              text: '다 사용한 게임은\n반납 선반에 올려주세요.',
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _LargeGuideItem(
              icon: Icons.widgets_rounded,
              text: '구성품이 부족하면\n직원에게 알려주세요.',
            ),
          ),
          // SizedBox(height: 8),
          // _MessageBox(
          //   icon: Icons.notifications_rounded,
          //   text: '즐거운 게임 문화는 서로 배려할 때 유지됩니다.',
          //   color: Color(0xFF6C8D36),
          // ),
        ],
      ),
    );
  }
}

class _NintendoGuidePanel extends StatelessWidget {
  const _NintendoGuidePanel();

  @override
  Widget build(BuildContext context) {
    return _GuidePanel(
      icon: Icons.sports_esports_rounded,
      title: '닌텐도 이용 안내',
      color: const Color(0xFF5DAAE5),
      child: Column(
        children: const [
          _CompactGuideItem(
            icon: Icons.meeting_room_rounded,
            text: '방이 비어있으면 자유롭게 이용 가능합니다.',
          ),
          _CompactGuideItem(
            icon: Icons.help_rounded,
            text: '게임 설정이 어려우면 직원에게 문의해주세요.',
          ),
          _CompactGuideItem(
            icon: Icons.no_food_rounded,
            text: '닌텐도 방에서는 취식 불가입니다.',
          ),
          _CompactGuideItem(
            icon: Icons.videogame_asset_rounded,
            text: '게임 칩이 거꾸로 꽂히지 않도록 주의해주세요.',
          ),
          _CompactGuideItem(
            icon: Icons.storefront_rounded,
            text: '카운터에서 게임을 받아 이용해주세요.',
          ),
        ],
      ),
    );
  }
}

class _CleanUpGuidePanel extends StatelessWidget {
  const _CleanUpGuidePanel();

  @override
  Widget build(BuildContext context) {
    return _GuidePanel(
      icon: Icons.cleaning_services_rounded,
      title: '퇴실 및 정리 안내',
      color: const Color(0xFF56B7AA),
      child: Column(
        children: const [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _SmallGuideBox(
                    icon: Icons.inventory_rounded,
                    text: '게임 선반에 꽂지 말고\n반납 선반에 올려주세요.',
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _SmallGuideBox(
                    icon: Icons.local_drink_rounded,
                    text: '다 드신 음료와 음식은\n카운터 앞으로 가져다 주세요.',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.5),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _SmallGuideBox(
                    icon: Icons.schedule_rounded,
                    text: '최초 1시간 이후\n30분 단위로 계산됩니다.',
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _SmallGuideBox(
                    icon: Icons.receipt_long_rounded,
                    text: '이용시간은 영수증 용지에\n시작시간이 적혀있습니다.',
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

class _NoticePanel extends StatelessWidget {
  const _NoticePanel();

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;

    return _GuidePanel(
      icon: Icons.warning_rounded,
      title: '이용 시 참고해 주세요',
      color: const Color(0xFF8F62D8),
      centerTitle: true,
      child: Column(
        children: [
          SizedBox(height: screenH * 0.006),
          Expanded(
            child: Column(
              children: const [
                Expanded(
                  child: _NoticeLine(text: '다른 손님에게 불편한 소음은 삼가주세요.'),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: _NoticeLine(text: '게임 구성품과 시설물을 아껴주세요.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeGuideItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LargeGuideItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 큰 안내 카드 크기 조정 값.
    final paddingH = screenW * 0.006;
    final paddingV = screenH * 0.005;
    final iconBoxSize = screenH * 0.048;
    final iconSize = screenH * 0.028;
    final textSize = screenW * 0.017;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D2AE)),
      ),
      child: Row(
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2D9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: iconSize, color: const Color(0xFF7A5636)),
          ),
          SizedBox(width: screenW * 0.006),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                height: 1.04,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3A2415),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactGuideItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CompactGuideItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 닌텐도 안내 카드 크기 조정 값.
    final marginBottom = screenH * 0.004;
    final paddingH = screenW * 0.006;
    final paddingV = screenH * 0.004;
    final iconSize = screenH * 0.026;
    final textSize = screenW * 0.0135;

    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: marginBottom),
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCF5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8D2AE)),
        ),
        child: Row(
          children: [
            Icon(icon, size: iconSize, color: const Color(0xFF5DAAE5)),
            SizedBox(width: screenW * 0.004),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: textSize,
                    height: 1.04,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3A2415),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoticeLine extends StatelessWidget {
  final String text;

  const _NoticeLine({required this.text});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    final iconSize = screenH * 0.024;
    final textSize = screenW * 0.016;

    return SizedBox(
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: iconSize,
            color: const Color(0xFF8F62D8),
          ),
          SizedBox(width: screenW * 0.005),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: textSize,
                height: 1.08,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3A2415),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveGap extends StatelessWidget {
  final bool horizontal;

  const _ResponsiveGap({this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: horizontal ? size.width * 0.012 : 0,
      height: horizontal ? 0 : size.height * 0.012,
    );
  }
}
