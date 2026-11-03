
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'constants.dart';
import '../models/models.dart';
import 'text.dart';


final _muted = Color(0xFF5B7480);
  final Color _navy = Colors.blue.shade900;
  final Color _ink = Color(0xFF0D2A4A);

//===========================================================
//NEWS CARD 
//===========================================================
class NewsCard extends StatefulWidget {

  final NewsArticle article;
  final ValueChanged<NewsArticle> onTap;

  const NewsCard({
    super.key, 
    required this.article, 
    required this.onTap
  });


  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {

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
              color: _hover ? Colors.amber : const Color(0xFFE3ECEF),
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

                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14, 
                          color: _muted
                        ),

                        const SizedBox(width: 6),

                        CustomText(
                          formatDate(a.date),
                          fontSize: 13,
                          fontWeight: .w600,
                          textColor: _muted,
                        ),
                        const SizedBox(width: 10),

                        CustomText(
                          '•', 
                          textColor: _muted
                        ),
                        const SizedBox(width: 10),

                        CustomText(
                          '${a.readMinutes} min read',
                          fontSize: 13,
                          textColor: _muted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    CustomText(
                      a.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      height: 1.3,
                      textColor: _ink,
                    ),

                    const SizedBox(height: 8),


                    CustomText(
                      a.excerpt,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14.5,
                      height: 1.55,
                      textColor: _muted,
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

//===============================================================
//SHOWS THE IMAGE OR PLACEHOLDER FOR A NEWS ITEM
//===============================================================
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
          Icon(article.category.icon, size: 52, color: Colors.amber),
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
        errorBuilder: (_, _, _) => placeholder,
        loadingBuilder: (context, child, progress) => progress == null ? child : placeholder,
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



class FeaturedNewsCard extends StatefulWidget {
  const FeaturedNewsCard({super.key, required this.article, required this.onTap});

  final NewsArticle article;
  final ValueChanged<NewsArticle> onTap;

  @override
  State<FeaturedNewsCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedNewsCard> {
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
              background: Colors.amber,
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
            fontSize: fluidInterpolation(context, 22, 32),
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
          '${formatDate(a.date)}  •  ${a.readMinutes} min read',
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
            backgroundColor: Colors.amber,
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
            color: _hover ? Colors.amber : Colors.white.withAlpha(60),
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
                  padding: EdgeInsets.all(fluidInterpolation(context, 20, 28)),
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

