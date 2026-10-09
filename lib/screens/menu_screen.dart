import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../repositories/menu_repository.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const String allMenuCategory = '전체 메뉴';
  static const List<String> categories = [
    '눈꽃빙수',
    '간식',
    '볶음밥',
    '한강라면',
    '논커피',
    '커피',
    '에이드',
    '티',
    '스무디',
    '캔음료',
  ];

  final MenuRepository _menuRepository = MenuRepository();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    for (final category in categories) category: GlobalKey(),
  };

  List<MenuItem> menus = [];
  bool isLoading = true;
  String selectedCategory = allMenuCategory;

  @override
  void initState() {
    super.initState();
    _loadMenus();
    _scrollController.addListener(_updateSelectedCategory);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateSelectedCategory);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMenus() async {
    final loadedMenus = await _menuRepository.loadMenus();

    if (!mounted) {
      return;
    }

    setState(() {
      menus = loadedMenus;
      isLoading = false;
      selectedCategory = allMenuCategory;
    });
  }

  List<String> get activeCategories {
    return categories.where((category) {
      return menus.any((menu) => menu.displayCategory == category);
    }).toList();
  }

  List<MenuItem> _menusByCategory(String category) {
    return menus.where((menu) => menu.displayCategory == category).toList();
  }

  void _scrollToCategory(String category) {
    if (category == allMenuCategory) {
      setState(() {
        selectedCategory = allMenuCategory;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    final context = _sectionKeys[category]?.currentContext;
    if (context == null) {
      return;
    }

    setState(() {
      selectedCategory = category;
    });

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  void _updateSelectedCategory() {
    final visibleCategories = activeCategories;
    if (visibleCategories.isEmpty) {
      return;
    }

    if (_scrollController.hasClients &&
        _scrollController.position.extentAfter < 24) {
      final lastCategory = visibleCategories.last;
      if (lastCategory != selectedCategory) {
        setState(() {
          selectedCategory = lastCategory;
        });
      }
      return;
    }

    var nextCategory = selectedCategory;
    var closestDistance = double.infinity;

    if (_scrollController.hasClients && _scrollController.offset < 80) {
      nextCategory = allMenuCategory;
    }

    for (final category in visibleCategories) {
      final context = _sectionKeys[category]?.currentContext;
      if (context == null) {
        continue;
      }

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) {
        continue;
      }

      final offset = renderBox.localToGlobal(Offset.zero);
      final distance = (offset.dy - 160).abs();
      if (offset.dy < 260 && distance < closestDistance) {
        closestDistance = distance;
        nextCategory = category;
      }
    }

    if (nextCategory != selectedCategory) {
      setState(() {
        selectedCategory = nextCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7E45D6)),
                  )
                : Column(
                    children: [
                      _MenuHeader(),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MenuCategorySideBar(
                              categories: activeCategories,
                              selectedCategory: selectedCategory,
                              onTap: _scrollToCategory,
                            ),
                            Expanded(
                              child: CustomScrollView(
                                controller: _scrollController,
                                slivers: [
                                  if (activeCategories.isEmpty)
                                    const SliverFillRemaining(
                                      child: Center(
                                        child: Text(
                                          '등록된 메뉴가 없어요',
                                          style: TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF3A2415),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    for (final category in activeCategories)
                                      SliverToBoxAdapter(
                                        child: MenuSection(
                                          key: _sectionKeys[category],
                                          category: category,
                                          menus: _menusByCategory(category),
                                        ),
                                      ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: 42),
                                  ),
                                ],
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

class _MenuHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 메뉴 화면 헤더 크기 조정 값.
    final horizontalPadding = screenW * 0.028;
    final topPadding = screenH * 0.018;
    final bottomPadding = screenH * 0.01;
    final headerHeight = screenH * 0.09;
    final titleIconSize = screenH * 0.052;
    final titleSize = screenW * 0.033;
    final noticeHPadding = screenW * 0.014;
    final noticeVPadding = screenH * 0.011;
    final noticeTextSize = screenW * 0.016;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        bottomPadding,
      ),
      child: SizedBox(
        height: headerHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _NavButton(
                icon: Icons.arrow_back_rounded,
                label: '뒤로',
                onTap: () => Navigator.pop(context),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  size: titleIconSize,
                  color: const Color(0xFF5A3215),
                ),
                SizedBox(width: screenW * 0.012),
                Text(
                  '몽몽 간식창고',
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: noticeHPadding,
                      vertical: noticeVPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE8D2AE),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '주문은 카운터에서 도와드릴게요!',
                      style: TextStyle(
                        fontSize: noticeTextSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B4A2E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 메뉴 화면 상단 버튼 크기 조정 값.
    final buttonHeight = screenH * 0.07;
    final horizontalPadding = screenW * 0.016;
    final iconSize = screenH * 0.036;
    final textSize = screenW * 0.016;

    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: buttonHeight,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: const Color(0xFF5B371B)),
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
      ),
    );
  }
}

class MenuCategorySideBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onTap;

  const MenuCategorySideBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 메뉴 사이드바 크기 조정 값.
    final sidebarWidth = screenW * 0.14;
    final sidebarLeftMargin = screenW * 0.024;
    final sidebarTopMargin = screenH * 0.014;
    final sidebarBottomMargin = screenH * 0.03;
    final sidebarPadding = screenW * 0.009;
    final logoSize = screenH * 0.135;
    final logoGap = screenH * 0.014;

    return Container(
      width: sidebarWidth,
      margin: EdgeInsets.fromLTRB(
        sidebarLeftMargin,
        sidebarTopMargin,
        0,
        sidebarBottomMargin,
      ),
      padding: EdgeInsets.all(sidebarPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EA).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Transform.scale(
              scale: 1.0,
              child: Image.asset(
                'assets/images/mongmong_round_logo.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          SizedBox(height: logoGap),
          _SideCategoryButton(
            category: _MenuScreenState.allMenuCategory,
            icon: Icons.restaurant_menu_rounded,
            selected: selectedCategory == _MenuScreenState.allMenuCategory,
            onTap: onTap,
          ),
          SizedBox(height: screenH * 0.008),
          Expanded(
            child: ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: Color(0xFFEAD7B9)),
              itemBuilder: (context, index) {
                final category = categories[index];

                return _SideCategoryButton(
                  category: category,
                  icon: _categoryIcon(category),
                  selected: category == selectedCategory,
                  onTap: onTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SideCategoryButton extends StatelessWidget {
  final String category;
  final IconData icon;
  final bool selected;
  final ValueChanged<String> onTap;

  const _SideCategoryButton({
    required this.category,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 메뉴 사이드바 버튼 크기 조정 값.
    final buttonHeight = screenH * 0.058;
    final horizontalPadding = screenW * 0.008;
    final iconSize = screenH * 0.027;
    final iconGap = screenW * 0.006;
    final textSize = screenW * 0.0155;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onTap(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: buttonHeight,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF6F9236) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: iconSize,
                color: selected ? Colors.white : const Color(0xFF7A4B20),
              ),
              SizedBox(width: iconGap),
              Expanded(
                child: Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: textSize,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : const Color(0xFF4A2C17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuSection extends StatelessWidget {
  final String category;
  final List<MenuItem> menus;

  const MenuSection({super.key, required this.category, required this.menus});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 메뉴 섹션 크기 조정 값.
    final marginLeft = screenW * 0.018;
    final marginTop = screenH * 0.014;
    final marginRight = screenW * 0.028;
    final paddingH = screenW * 0.018;
    final paddingV = screenH * 0.02;
    final sectionIconSize = screenH * 0.04;
    final sectionTitleSize = screenW * 0.026;
    final countTextSize = screenW * 0.014;
    final headerBottomGap = screenH * 0.018;
    final gridGap = screenW * 0.011;

    return Container(
      margin: EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, 0),
      padding: EdgeInsets.fromLTRB(paddingH, paddingV, paddingH, paddingV),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CategoryIcon(category: category, size: sectionIconSize),
              SizedBox(width: screenW * 0.008),
              Text(
                category,
                style: TextStyle(
                  fontSize: sectionTitleSize,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF3A2415),
                ),
              ),
              SizedBox(width: screenW * 0.01),
              Expanded(
                child: Container(height: 2, color: const Color(0xFFE8D2AE)),
              ),
              SizedBox(width: screenW * 0.01),
              Text(
                '${menus.length}개',
                style: TextStyle(
                  fontSize: countTextSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7A5A3A),
                ),
              ),
            ],
          ),
          SizedBox(height: headerBottomGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1280
                  ? 5
                  : constraints.maxWidth >= 860
                  ? 4
                  : constraints.maxWidth >= 620
                  ? 3
                  : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menus.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: gridGap,
                  crossAxisSpacing: gridGap,
                  childAspectRatio: 0.96,
                ),
                itemBuilder: (context, index) {
                  return MenuCard(menu: menus[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final MenuItem menu;

  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;

    // 메뉴 카드 크기 조정 값.
    final imagePadding = screenW * 0.008;
    final textPaddingH = screenW * 0.009;
    final textPaddingV = screenH * 0.012;
    final priceTextSize = screenW * 0.018;
    final nameFontSize = menu.name.length >= 12
        ? screenW * 0.0135
        : menu.name.length >= 9
        ? screenW * 0.015
        : screenW * 0.017;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D2AE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: menu.hasImage
                  ? Colors.white
                  : _categoryColor(
                      menu.displayCategory,
                    ).withValues(alpha: 0.16),
              child: menu.hasImage
                  ? Padding(
                      padding: EdgeInsets.all(imagePadding),
                      child: Image.asset(
                        menu.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return _MenuFallbackVisual(
                            category: menu.displayCategory,
                          );
                        },
                      ),
                    )
                  : _MenuFallbackVisual(category: menu.displayCategory),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              textPaddingH,
              textPaddingV,
              textPaddingH,
              textPaddingV,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7EF),
              border: Border(top: BorderSide(color: Color(0xFFD0E7D6))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  menu.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: nameFontSize,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF24170F),
                  ),
                ),
                SizedBox(height: screenH * 0.006),
                Text(
                  menu.priceText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: priceTextSize,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF53752B),
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

class _MenuFallbackVisual extends StatelessWidget {
  final String category;

  const _MenuFallbackVisual({required this.category});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final visualSize = screenW * 0.06;
    final iconSize = screenW * 0.032;

    return Center(
      child: Container(
        width: visualSize,
        height: visualSize,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(color: _categoryColor(category), width: 3),
        ),
        child: _CategoryIcon(category: category, size: iconSize),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String category;
  final double size;

  const _CategoryIcon({required this.category, required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      _categoryIcon(category),
      size: size,
      color: _categoryColor(category),
    );
  }
}

IconData _categoryIcon(String category) {
  switch (category) {
    case '눈꽃빙수':
      return Icons.ac_unit_rounded;
    case '간식':
      return Icons.cookie_rounded;
    case '볶음밥':
      return Icons.rice_bowl_rounded;
    case '한강라면':
      return Icons.ramen_dining_rounded;
    case '논커피':
      return Icons.local_drink_rounded;
    case '커피':
      return Icons.coffee_rounded;
    case '에이드':
      return Icons.local_bar_rounded;
    case '티':
      return Icons.emoji_food_beverage_rounded;
    case '스무디':
      return Icons.blender_rounded;
    case '캔음료':
      return Icons.local_drink_rounded;
    default:
      return Icons.restaurant_rounded;
  }
}

Color _categoryColor(String category) {
  switch (category) {
    case '눈꽃빙수':
      return const Color(0xFF5FA8D3);
    case '간식':
      return const Color(0xFFD3902F);
    case '볶음밥':
      return const Color(0xFF8A9A38);
    case '한강라면':
      return const Color(0xFFE05F35);
    case '논커피':
      return const Color(0xFFAF6FA7);
    case '커피':
      return const Color(0xFF8B5A2B);
    case '에이드':
      return const Color(0xFF56B7AA);
    case '티':
      return const Color(0xFF789D4A);
    case '스무디':
      return const Color(0xFFE9858F);
    case '캔음료':
      return const Color(0xFF6D7DA8);
    default:
      return const Color(0xFF6F9236);
  }
}
