import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import  'text.dart';

class BannerSlide {
  const BannerSlide({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final String title;
  final String subtitle;
}

class BannerSlideShow extends StatefulWidget {
  const BannerSlideShow({
    super.key,
    required this.slides,
    this.holdDuration = const Duration(seconds: 3),
  });

  final List<BannerSlide> slides;

  /// How long to stay on a slide AFTER its typewriter text has finished.
  final Duration holdDuration;

  @override
  State<BannerSlideShow> createState() => _BannerSlideShowState();
}

class _BannerSlideShowState extends State<BannerSlideShow> {
  final _controller = PageController();
  Timer? _holdTimer;
  int _page = 0; // raw page number (keeps increasing)

  int get _slideIndex => _page % widget.slides.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final s in widget.slides) {
      precacheImage(AssetImage(s.image), context);
    }
  }

  void _onTypingFinished(int page) {
    if (page != _page) return; // ignore a slide that's no longer showing
    _holdTimer?.cancel();
    _holdTimer = Timer(widget.holdDuration, _goNext);
  }

  void _goNext() {
    if (!mounted || !_controller.hasClients) return;
    
    _controller.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [

        PageView.builder(
          controller: _controller,
          // no itemCount = endless loop, so last -> first slides forward smoothly
          onPageChanged: (page) {
            _holdTimer?.cancel(); // covers manual swipes too
            setState(() => _page = page);
          },
          itemBuilder: (context, page) {
            final slide = widget.slides[page % widget.slides.length];
            return _SlideView(
              key: ValueKey(page),
              slide: slide,
              onTypingFinished: () => _onTypingFinished(page),
            );
          },
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.slides.length, (i) {
              final active = i == _slideIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({
    super.key,
    required this.slide,
    required this.onTypingFinished,
  });

  final BannerSlide slide;
  final VoidCallback onTypingFinished;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(slide.image, fit: BoxFit.cover, cacheWidth: 1600),
        ColoredBox(color: Colors.blue.shade900.withValues(alpha: 0.6)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  slide.title,
                  fontSize: ResponsiveUtil.isDesktop(context) ? 32 : 24,
                  softwrap: true,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 6),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      slide.subtitle,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins'
                      ),
                      speed: const Duration(milliseconds: 50),
                      cursor: '|',
                    ),
                  ],
                  totalRepeatCount: 1,
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: true,
                  onFinished: onTypingFinished,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}