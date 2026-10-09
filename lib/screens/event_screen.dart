import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 이벤트 화면 전체 크기 조정 값.
    final pagePaddingH = screenW * 0.033;
    final pagePaddingTop = screenH * 0.01;
    final pagePaddingBottom = screenH * 0.018;
    final headerGap = screenH * 0.008;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.16)),
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
                      _EventHeader(
                        onBack: () => Navigator.pop(context),
                        onHome: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                      SizedBox(height: headerGap),
                      const Expanded(child: _EventContent()),
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

class _EventHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHome;

  const _EventHeader({required this.onBack, required this.onHome});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 이벤트 헤더 크기 조정 값.
    final headerHeight = screenH * 0.13;
    final titleIconSize = screenH * 0.045;
    final titleSize = screenW * 0.034;
    final subtitleSize = screenW * 0.016;

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
                    Icons.celebration_rounded,
                    size: titleIconSize,
                    color: const Color(0xFFFF7A45),
                  ),
                  SizedBox(width: screenW * 0.01),
                  Text(
                    '이벤트 안내',
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
              SizedBox(height: screenH * 0.006),
              Text(
                '몽몽플레이 DEMO에서 준비한 즐거운 혜택을 확인해보세요!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

    // 이벤트 상단 버튼 크기 조정 값.
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

class _EventContent extends StatelessWidget {
  const _EventContent();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final gap = screenW * 0.014;

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.86,
        heightFactor: 0.84,
        child: Row(
          children: [
            const Expanded(child: _ReceiptReviewCard()),
            SizedBox(width: gap),
            const Expanded(child: _BlogReviewCard()),
            SizedBox(width: gap),
            const Expanded(child: _BirthdayEventCard()),
          ],
        ),
      ),
    );
  }
}

class _ReceiptReviewCard extends StatelessWidget {
  const _ReceiptReviewCard();

  @override
  Widget build(BuildContext context) {
    return _EventCard(
      borderColor: const Color(0xFF4CAF42),
      titleColor: const Color(0xFF2F8E36),
      icon: Icons.receipt_long_rounded,
      title: '영수증 리뷰 이벤트',
      child: Column(
        children: const [
          Expanded(
            flex: 5,
            child: _UnifiedBenefitBox(
              icon: Icons.card_giftcard_rounded,
              title: '참여 혜택',
              lines: ['갈릭디핑 감자튀김', '또는', '팝콘 중 택1'],
              accentColor: Color(0xFF2F8E36),
              backgroundColor: Color(0xFFEAF8E3),
            ),
          ),
          Expanded(
            flex: 7,
            child: _QrSlot(
              imagePath: 'assets/images/sns_naver_map_qr.png',
              borderColor: Color(0xFF2FAD44),
            ),
          ),
          Expanded(
            flex: 8,
            child: _CardBottomSection(
              labelIcon: Icons.format_list_numbered_rounded,
              label: '참여 방법',
              color: Color(0xFF2F8E36),
              child: _SimpleSteps(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogReviewCard extends StatelessWidget {
  const _BlogReviewCard();

  @override
  Widget build(BuildContext context) {
    return _EventCard(
      borderColor: const Color(0xFF2FAFE8),
      titleColor: const Color(0xFF128DC8),
      icon: Icons.edit_note_rounded,
      title: '블로그 리뷰 이벤트',
      child: Column(
        children: const [
          Expanded(
            flex: 5,
            child: _UnifiedBenefitBox(
              icon: Icons.card_giftcard_rounded,
              title: '참여 혜택',
              lines: ['갈릭디핑 감자튀김', '+ 1시간 무료 쿠폰', '(최대 4인 사용 가능)'],
              accentColor: Color(0xFF128DC8),
              backgroundColor: Color(0xFFEAF8FF),
            ),
          ),
          Expanded(flex: 7, child: _BlogVisual()),
          Expanded(
            flex: 8,
            child: _CardBottomSection(
              labelIcon: Icons.checklist_rounded,
              label: '참여 조건',
              color: Color(0xFF128DC8),
              child: _BlogConditions(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BirthdayEventCard extends StatelessWidget {
  const _BirthdayEventCard();

  @override
  Widget build(BuildContext context) {
    return _EventCard(
      borderColor: const Color(0xFFFF674D),
      titleColor: const Color(0xFFE84B35),
      icon: Icons.cake_rounded,
      title: '생일자 이벤트',
      child: Column(
        children: const [
          Expanded(
            flex: 5,
            child: _UnifiedBenefitBox(
              icon: Icons.cake_rounded,
              title: '생일자 본인',
              lines: ['게임비 무료'],
              accentColor: Color(0xFFFF4F42),
              backgroundColor: Color(0xFFFFF0A8),
            ),
          ),
          Expanded(flex: 7, child: _BirthdayVisual()),
          Expanded(
            flex: 8,
            child: _CardBottomSection(
              labelIcon: Icons.info_rounded,
              label: '이용 안내',
              color: Color(0xFFE84B35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BodyText('생일 전후 7일내에\n이용 가능합니다'),
                  SizedBox(height: 14),
                  _BodyText('직원에게 생일 인증 화면을\n보여주세요.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Color borderColor;
  final Color titleColor;
  final IconData icon;
  final String title;
  final Widget child;

  const _EventCard({
    required this.borderColor,
    required this.titleColor,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 이벤트 카드 크기 조정 값.
    final paddingH = screenW * 0.013;
    final paddingV = screenH * 0.014;
    final radius = screenW * 0.016;
    final borderWidth = screenW * 0.002;
    final titleIconSize = screenH * 0.038;
    final titleSize = screenW * 0.02;
    final titleGap = screenH * 0.008;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
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
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(icon, size: titleIconSize, color: titleColor),
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w900,
                  color: titleColor,
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

class _QrSlot extends StatelessWidget {
  final String imagePath;
  final Color borderColor;

  const _QrSlot({required this.imagePath, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final padding = screenW * 0.004;
    final radius = screenW * 0.007;

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.62,
        heightFactor: 0.9,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;

  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenW * 0.017,
          height: 1.14,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF2B2119),
        ),
      ),
    );
  }
}

class _UnifiedBenefitBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  final Color accentColor;
  final Color backgroundColor;

  const _UnifiedBenefitBox({
    required this.icon,
    required this.title,
    required this.lines,
    required this.accentColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;
    final isSingleLineBenefit = lines.length == 1;
    final paddingH = screenW * 0.008;
    final paddingV = screenH * 0.004;
    final radius = screenW * 0.013;
    final iconSize = screenH * 0.032;
    final titleSize = isSingleLineBenefit ? screenW * 0.017 : screenW * 0.014;
    final lineSize = isSingleLineBenefit ? screenW * 0.024 : screenW * 0.0165;
    final noteSize = screenW * 0.0132;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.45),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: iconSize, color: accentColor),
              SizedBox(width: screenW * 0.004),
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: isSingleLineBenefit ? screenH * 0.008 : 1),
          for (final line in lines)
            Text(
              line,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: line.startsWith('(') ? noteSize : lineSize,
                height: 1.02,
                fontWeight: FontWeight.w900,
                color: line.startsWith('(')
                    ? accentColor
                    : const Color(0xFF2B2119),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _SectionLabel({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    return Row(
      children: [
        Icon(icon, size: screenH * 0.034, color: color),
        SizedBox(width: screenW * 0.006),
        Text(
          text,
          style: TextStyle(
            fontSize: screenW * 0.018,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _CardBottomSection extends StatelessWidget {
  final IconData labelIcon;
  final String label;
  final Color color;
  final Widget child;

  const _CardBottomSection({
    required this.labelIcon,
    required this.label,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.only(top: screenH * 0.004),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(icon: labelIcon, text: label, color: color),
          SizedBox(height: screenH * 0.003),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _StepData {
  final IconData icon;
  final String label;

  const _StepData(this.icon, this.label);
}

class _SimpleSteps extends StatelessWidget {
  const _SimpleSteps();

  @override
  Widget build(BuildContext context) {
    const steps = [
      _StepData(Icons.looks_one_rounded, '영수증 요청'),
      _StepData(Icons.looks_two_rounded, '사진과 함께 리뷰 작성'),
      _StepData(Icons.looks_3_rounded, '직원에게 리뷰 화면 보여주기'),
    ];

    return Column(
      children: [
        for (final step in steps)
          Expanded(
            child: _InfoLine(
              icon: step.icon,
              text: step.label,
              color: const Color(0xFF2F8E36),
            ),
          ),
      ],
    );
  }
}

class _BlogConditions extends StatelessWidget {
  const _BlogConditions();

  @override
  Widget build(BuildContext context) {
    const conditions = [
      _StepData(Icons.photo_library_rounded, '사진 5장 이상'),
      _StepData(Icons.edit_rounded, '글 300자 이상'),
      _StepData(Icons.sell_rounded, '"몽몽플레이 DEMO" 키워드 포함'),
    ];

    return Column(
      children: [
        for (final condition in conditions)
          Expanded(
            child: _InfoLine(
              icon: condition.icon,
              text: condition.label,
              color: const Color(0xFF128DC8),
            ),
          ),
      ],
    );
  }
}

class _BlogVisual extends StatelessWidget {
  const _BlogVisual();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.95,
        heightFactor: 0.95,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenW * 0.018),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/blog_mong.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _BirthdayVisual extends StatelessWidget {
  const _BirthdayVisual();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.95,
        heightFactor: 0.95,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenW * 0.018),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/birthday_mong.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenH * 0.003),
      child: Row(
        children: [
          Icon(icon, size: screenH * 0.034, color: color),
          SizedBox(width: screenW * 0.007),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenW * 0.0165,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF2B2119),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
