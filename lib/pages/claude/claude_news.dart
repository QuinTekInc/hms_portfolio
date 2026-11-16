
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';

// ---------------------------------------------------------------------------
// Theme: blue.shade900 + amber
// ---------------------------------------------------------------------------

final Color _navy = Colors.blue.shade900;
const Color _amber = Colors.amber;
const Color _ink = Color(0xFF0D2A4A);
const Color _muted = Color(0xFF5B7480);
const Color _surface = Color(0xFFF4F8FB);

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

enum NewsCategory { announcement, healthTip, research, award, community }

extension NewsCategoryX on NewsCategory {
  String get label => switch (this) {
        NewsCategory.announcement => 'Announcements',
        NewsCategory.healthTip => 'Health Tips',
        NewsCategory.research => 'Research',
        NewsCategory.award => 'Awards',
        NewsCategory.community => 'Community',
      };

  IconData get icon => switch (this) {
        NewsCategory.announcement => Icons.campaign_rounded,
        NewsCategory.healthTip => Icons.favorite_rounded,
        NewsCategory.research => Icons.science_rounded,
        NewsCategory.award => Icons.emoji_events_rounded,
        NewsCategory.community => Icons.groups_rounded,
      };

  Color get color => switch (this) {
        NewsCategory.announcement => Colors.blue.shade900,
        NewsCategory.healthTip => Colors.teal.shade700,
        NewsCategory.research => Colors.indigo.shade600,
        NewsCategory.award => Colors.amber.shade800,
        NewsCategory.community => Colors.deepOrange.shade400,
      };
}

class NewsArticle {
  final String title;
  final String excerpt;
  final DateTime date;
  final NewsCategory category;
  final int readMinutes;

  /// Optional. If null (or it fails to load) a themed placeholder is shown.
  final String? imageUrl;

  const NewsArticle({
    required this.title,
    required this.excerpt,
    required this.date,
    required this.category,
    this.readMinutes = 3,
    this.imageUrl,
  });
}

/// Sample data. Replace with data from your API / Firestore.
final List<NewsArticle> sampleNews = [
  NewsArticle(
    title: 'New Cardiac Care Centre Opens Its Doors',
    excerpt:
        'Our state-of-the-art cardiac centre now offers advanced diagnostics, '
        'catheterisation and rehabilitation under one roof.',
    date: DateTime(2026, 10, 27),
    category: NewsCategory.announcement,
    readMinutes: 4,
  ),
  NewsArticle(
    title: '5 Simple Habits for a Healthier Heart',
    excerpt:
        'Our cardiologists share everyday changes that lower your risk of '
        'heart disease, from diet to sleep.',
    date: DateTime(2026, 10, 24),
    category: NewsCategory.healthTip,
    readMinutes: 5,
  ),
  NewsArticle(
    title: 'Hospital Wins Patient Safety Excellence Award',
    excerpt:
        'We were recognised for outstanding infection control and patient '
        'safety standards at this year\'s national healthcare awards.',
    date: DateTime(2026, 10, 20),
    category: NewsCategory.award,
    readMinutes: 3,
  ),
  NewsArticle(
    title: 'Study on Early Diabetes Detection Published',
    excerpt:
        'Our research team has published findings that could help clinics '
        'detect type 2 diabetes years earlier.',
    date: DateTime(2026, 10, 15),
    category: NewsCategory.research,
    readMinutes: 6,
  ),
  NewsArticle(
    title: 'Free Community Screening Reaches 1,200 Residents',
    excerpt:
        'Volunteers and staff provided free blood pressure, sugar and eye '
        'checks across three neighbouring communities.',
    date: DateTime(2026, 10, 9),
    category: NewsCategory.community,
    readMinutes: 3,
  ),
  NewsArticle(
    title: 'Updated Visiting Hours for Inpatient Wards',
    excerpt:
        'To support patient recovery, visiting hours have been updated. '
        'See the new schedule for each ward.',
    date: DateTime(2026, 10, 3),
    category: NewsCategory.announcement,
    readMinutes: 2,
  ),
  NewsArticle(
    title: 'Staying Hydrated: What Your Body Really Needs',
    excerpt:
        'How much water is enough? Our dietitians separate the myths from '
        'the facts.',
    date: DateTime(2026, 9, 28),
    category: NewsCategory.healthTip,
    readMinutes: 4,
  ),
];

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class NewsPage extends StatefulWidget {

  final List<NewsArticle>? _articles;

  const NewsPage({
    super.key, 
    List<NewsArticle>? articles, 
    this.onArticleTap
  }) : _articles = articles;


  /// Called when an article is tapped. Defaults to a placeholder snackbar.
  final ValueChanged<NewsArticle>? onArticleTap;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  NewsCategory? _selected; // null = All

  List<NewsArticle> get _all {
    final list = [...(widget._articles ?? sampleNews)]
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first
    return list;
  }

  void _open(NewsArticle article) {
    if (widget.onArticleTap != null) {
      widget.onArticleTap!(article);
    } else {
      // TODO: navigate to a full article page.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening "${article.title}"...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final all = _all;
    final featured = all.isEmpty ? null : all.first;

    // On "All", the featured story lives in the banner, so skip it in the grid.
    final visible = _selected == null
        ? all.where((a) => a != featured).toList()
        : all.where((a) => a.category == _selected).toList();

    return Scaffold(
      backgroundColor: _surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: PageHeader(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _NewsHero(featured: featured, onTap: _open),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryBarDelegate(
              selected: _selected,
              onChanged: (c) => setState(() => _selected = c),
            ),
          ),
          SliverToBoxAdapter(
            child: _Constrained(
              verticalPadding: 40,
              child: _NewsGrid(
                articles: visible,
                filterKey: _selected,
                onTap: _open,
              ),
            ),
          ),
          // Pushes the footer to the bottom even when content is short.
          
          SliverToBoxAdapter(
            child: PageFooter()
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fluid helpers
// ---------------------------------------------------------------------------

/// Smoothly interpolates between [min] (at 360px wide) and [max] (at 1200px).
double _fluid(BuildContext context, double min, double max) {
  final w = MediaQuery.sizeOf(context).width;
  final t = ((w - 360) / (1200 - 360)).clamp(0.0, 1.0);
  return min + (max - min) * t;
}

/// Fades and slides [child] in the first time it scrolls into view.
Widget _reveal({required Widget child, Duration delay = Duration.zero}) {
  return _Reveal(
    delay: delay,
    builder: (context, visible) => AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.06),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    ),
  );
}

class _Reveal extends StatefulWidget {
  const _Reveal({required this.builder, this.delay = Duration.zero});

  final Widget Function(BuildContext context, bool visible) builder;
  final Duration delay;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  bool _visible = false;
  bool _triggered = false;
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pos = Scrollable.maybeOf(context)?.position;
    if (pos != _position) {
      _position?.removeListener(_check);
      _position = pos;
      _position?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    if (top < viewportHeight * 0.92) {
      _triggered = true;
      _position?.removeListener(_check);
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _visible);
}

class _Constrained extends StatelessWidget {
  const _Constrained({required this.child, this.verticalPadding = 64});

  final Widget child;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _fluid(context, 16, 32),
            vertical: _fluid(context, verticalPadding * 0.6, verticalPadding),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Banner (hero + featured story)
// ---------------------------------------------------------------------------

class _NewsHero extends StatelessWidget {
  const _NewsHero({required this.featured, required this.onTap});

  final NewsArticle? featured;
  final ValueChanged<NewsArticle> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_navy, Colors.blue.shade700],
        ),
      ),
      child: _Constrained(
        verticalPadding: 72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _reveal(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _amber.withAlpha(35),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _amber.withAlpha(140)),
                ),
                child: const Text(
                  'NEWS & UPDATES',
                  style: TextStyle(
                    color: _amber,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _reveal(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'The latest from our hospital',
                style: TextStyle(
                  fontSize: _fluid(context, 30, 50),
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _reveal(
              delay: const Duration(milliseconds: 200),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'Announcements, health advice, research and stories from our community.',
                  style: TextStyle(
                    fontSize: _fluid(context, 16, 18),
                    height: 1.6,
                    color: Colors.white.withAlpha(215),
                  ),
                ),
              ),
            ),
            if (featured != null) ...[
              const SizedBox(height: 32),
              _reveal(
                delay: const Duration(milliseconds: 320),
                child: _FeaturedCard(article: featured!, onTap: onTap),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatefulWidget {
  const _FeaturedCard({required this.article, required this.onTap});

  final NewsArticle article;
  final ValueChanged<NewsArticle> onTap;

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.article;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [

            _Pill(
              label: 'FEATURED',
              background: _amber,
              foreground: _navy,
              icon: Icons.star_rounded,
            ),

            _Pill(
              label: a.category.label,
              background: Colors.white.withAlpha(30),
              foreground: Colors.white,
              icon: a.category.icon,
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          a.title,
          style: TextStyle(
            fontSize: _fluid(context, 22, 32),
            fontWeight: FontWeight.w800,
            height: 1.2,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          a.excerpt,
          style: TextStyle(
            fontSize: 16,
            height: 1.55,
            color: Colors.white.withAlpha(215),
          ),
        ),

        const SizedBox(height: 14),

        Text(
          '${_formatDate(a.date)}  •  ${a.readMinutes} min read',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.white.withAlpha(180),
          ),
        ),

        const SizedBox(height: 20),

        FilledButton.icon(
          onPressed: () => widget.onTap(a),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('Read the story'),
          style: FilledButton.styleFrom(
            backgroundColor: _amber,
            foregroundColor: _navy,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(_hover ? 28 : 20),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hover ? _amber : Colors.white.withAlpha(60),
            width: _hover ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 800;
            final visual = _NewsVisual(
              article: a,
              height: wide ? double.infinity : 200,
            );

            if (wide) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: text,
                      ),
                    ),
                    Expanded(flex: 4, child: visual),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                visual,
                Padding(
                  padding: EdgeInsets.all(_fluid(context, 20, 28)),
                  child: text,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Categories (pinned bar)
// ---------------------------------------------------------------------------

class _CategoryBarDelegate extends SliverPersistentHeaderDelegate {
  _CategoryBarDelegate({required this.selected, required this.onChanged});

  final NewsCategory? selected;
  final ValueChanged<NewsCategory?> onChanged;

  @override
  double get minExtent => 68;

  @override
  double get maxExtent => 68;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final items = <(String, IconData?, Color, NewsCategory?)>[
      ('All', null, _navy, null),
      for (final c in NewsCategory.values) (c.label, c.icon, c.color, c),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _surface,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(28),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
            : const [],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: _fluid(context, 16, 32),
              vertical: 14,
            ),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final (label, icon, color, category) = items[i];
              return _CategoryChip(
                label: label,
                icon: icon,
                color: color,
                active: selected == category,
                onTap: () => onChanged(category),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CategoryBarDelegate oldDelegate) =>
      oldDelegate.selected != selected;
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? color : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? color : const Color(0xFFD5E2E6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: active ? _amber : color),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : _ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// News grid
// ---------------------------------------------------------------------------

class _NewsGrid extends StatelessWidget {
  const _NewsGrid({
    required this.articles,
    required this.filterKey,
    required this.onTap,
  });

  final List<NewsArticle> articles;
  final NewsCategory? filterKey;
  final ValueChanged<NewsArticle> onTap;

  static const double _spacing = 22;
  static const double _minItemWidth = 320;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No stories in this category yet. Please check back soon.',
            style: TextStyle(color: _muted, fontSize: 16),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ((constraints.maxWidth + _spacing) /
                (_minItemWidth + _spacing))
            .floor()
            .clamp(1, math.min(3, articles.length));
        final itemWidth =
            (constraints.maxWidth - _spacing * (columns - 1)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filterKey == null ? 'More stories' : filterKey!.label,
              style: TextStyle(
                fontSize: _fluid(context, 22, 28),
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${articles.length} ${articles.length == 1 ? 'story' : 'stories'}',
              style: const TextStyle(fontSize: 14, color: _muted),
            ),
            const SizedBox(height: 22),
            
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Wrap(
                spacing: _spacing,
                runSpacing: _spacing,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  for (var i = 0; i < articles.length; i++)
                    SizedBox(
                      // Key includes the filter so cards re-animate on change.
                      key: ValueKey('${articles[i].title}-$filterKey'),
                      width: itemWidth,
                      child: _reveal(
                        delay: Duration(milliseconds: ((i % columns) * 120).toInt()),
                        child: _NewsCard(article: articles[i], onTap: onTap),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// News card
// ---------------------------------------------------------------------------

class _NewsCard extends StatefulWidget {

  final NewsArticle article;
  final ValueChanged<NewsArticle> onTap;

  const _NewsCard({required this.article, required this.onTap});


  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.article;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => widget.onTap(a),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hover ? _amber : const Color(0xFFE3ECEF),
              width: _hover ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _navy.withAlpha(_hover ? 40 : 12),
                blurRadius: _hover ? 26 : 12,
                offset: Offset(0, _hover ? 12 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Subtle zoom on hover
                  ClipRect(
                    child: AnimatedScale(
                      scale: _hover ? 1.06 : 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      child: _NewsVisual(article: a, height: 170),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 14,
                    child: _Pill(
                      label: a.category.label,
                      background: Colors.white,
                      foreground: a.category.color,
                      icon: a.category.icon,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 14, color: _muted),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(a.date),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _muted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('•', style: TextStyle(color: _muted)),
                        const SizedBox(width: 10),
                        Text(
                          '${a.readMinutes} min read',
                          style: const TextStyle(fontSize: 13, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      a.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a.excerpt,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.55,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Read more',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: _navy,
                          ),
                        ),
                        AnimatedPadding(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.only(left: _hover ? 10 : 4),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: _hover ? Colors.amber.shade800 : _navy,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared visuals
// ---------------------------------------------------------------------------

/// Article image, or a themed placeholder when there is no image.
class _NewsVisual extends StatelessWidget {
  const _NewsVisual({required this.article, required this.height});

  final NewsArticle article;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height == double.infinity ? null : height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            article.category.color,
            Color.lerp(article.category.color, Colors.black, 0.35)!,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: -20,
            bottom: -24,
            child: Icon(
              article.category.icon,
              size: 120,
              color: Colors.white.withAlpha(30),
            ),
          ),
          Icon(article.category.icon, size: 52, color: _amber),
        ],
      ),
    );

    final url = article.imageUrl;
    if (url == null) return placeholder;

    return SizedBox(
      height: height == double.infinity ? null : height,
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : placeholder,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(icon, size: 14, color: foreground),

          const SizedBox(width: 6),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}