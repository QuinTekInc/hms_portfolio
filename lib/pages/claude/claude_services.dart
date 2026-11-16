import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/constants.dart'; // generalServices, specialServicesList
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';

// ---------------------------------------------------------------------------
// Theme: blue.shade900 + amber + red
//   navy  -> structure, headings, backgrounds
//   amber -> highlights, primary buttons, icons on navy
//   red   -> urgency and emphasis (emergency band, specialist accents)
// ---------------------------------------------------------------------------

final Color _navy = Colors.blue.shade900;
const Color _amber = Colors.amber;
final Color _red = Colors.red.shade700;
const Color _ink = Color(0xFF0D2A4A);
const Color _muted = Color(0xFF5B7480);
const Color _surface = Color(0xFFF4F8FB);

// TODO: replace with the hospital's real emergency number.
const String kEmergencyPhone = '+233 00 000 0000';

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class OurServicesPage extends StatefulWidget {
  const OurServicesPage({
    super.key,
    this.onServiceTap,
    this.onBookAppointment,
    this.onEmergencyTap,
  });

  /// Called with the service name when a specialized service tile is tapped.
  final ValueChanged<String>? onServiceTap;

  /// Defaults to pushing '/appointments'.
  final VoidCallback? onBookAppointment;

  /// Called by the emergency band button (e.g. launch a phone call).
  final VoidCallback? onEmergencyTap;

  @override
  State<OurServicesPage> createState() => _OurServicesPageState();
}

class _OurServicesPageState extends State<OurServicesPage> {
  final _generalKey = GlobalKey();
  final _specialKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  void _emergency() {
    if (widget.onEmergencyTap != null) {
      widget.onEmergencyTap!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency line: $kEmergencyPhone')),
      );
    }
  }

  void _openService(String name) {
    if (widget.onServiceTap != null) {
      widget.onServiceTap!(name);
    }
    // TODO: navigate to a detail page for this service.
  }

  @override
  Widget build(BuildContext context) {
    final side = _sidePadding(context);

    return Scaffold(
      backgroundColor: _surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: PageHeader(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Hero(
              generalCount: generalServices.length,
              specialCount: specialServicesList.length,
              onGeneral: () => _scrollTo(_generalKey),
              onSpecial: () => _scrollTo(_specialKey),
            ),
          ),
          SliverToBoxAdapter(child: _EmergencyBand(onPressed: _emergency)),

          // ---------------- General services ----------------
          SliverToBoxAdapter(
            child: Container(
              key: _generalKey,
              width: double.infinity,
              color: Colors.white,
              child: _Constrained(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(
                      eyebrow: 'Everyday care',
                      title: 'General Services',
                      subtitle:
                          'Routine and preventive care for you and your family, available throughout the week.',
                    ),
                    const SizedBox(height: 28),
                    _ResponsiveWrap(
                      minItemWidth: 260,
                      maxColumns: 3,
                      spacing: 14,
                      children: [
                        for (final name in generalServices)
                          _GeneralItem(name: name),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------------- Specialized services ----------------
          SliverToBoxAdapter(
            child: Padding(
              key: _specialKey,
              padding: EdgeInsets.fromLTRB(side, _fluid(context, 40, 64), side, 0),
              child: const _SectionTitle(
                eyebrow: 'Expert care',
                title: 'Specialized Services',
                subtitle:
                    'Led by experienced specialists using modern equipment for more complex conditions.',
                accentRed: true,
              ),
            ),
          ),
          
          SliverPadding(
            padding: EdgeInsets.fromLTRB(side, 28, side, _fluid(context, 40, 64)),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 290,
                mainAxisExtent: 260,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
              ),
              itemCount: specialServicesList.length,
              itemBuilder: (context, i) {
                final (text, imagePath) = specialServicesList[i];
                return _reveal(
                  delay: Duration(milliseconds: (i % 4) * 90),
                  child: _SpecialTile(
                    text: text,
                    imagePath: imagePath,
                    onTap: () => _openService(text),
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: _CallToAction(
              onPressed: widget.onBookAppointment ??
                  () => Navigator.of(context).pushNamed('/appointments'),
            ),
          ),

          // Pushes the footer to the bottom even when content is short.
          const SliverToBoxAdapter(
            child: PageFooter(),
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

/// Side padding that matches [_Constrained] so sliver sections line up with it.
double _sidePadding(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  return math.max(0.0, (w - 1100) / 2) + _fluid(context, 16, 32);
}

/// Fades and slides [child] into view when it is inserted into the widget tree.
///
/// This deliberately does not inspect scroll positions or RenderObjects. The
/// previous implementation attached a listener to ScrollPosition and called
/// localToGlobal while scrolling, which could cause rendering/semantics updates
/// to overlap with layout. Sliver children are still animated as they are built.
Widget _reveal({required Widget child, Duration delay = Duration.zero}) {
  return _Reveal(delay: delay, child: child);
}

class _Reveal extends StatefulWidget {
  const _Reveal({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.06),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
  );

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.delay <= Duration.zero) {
      _controller.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Layout helpers
// ---------------------------------------------------------------------------

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

class _ResponsiveWrap extends StatelessWidget {
  const _ResponsiveWrap({
    required this.children,
    this.minItemWidth = 260,
    this.maxColumns = 4,
    this.spacing = 20,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ((constraints.maxWidth + spacing) /
                (minItemWidth + spacing))
            .floor()
            .clamp(1, math.min(maxColumns, children.length));
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < children.length; i++)
              SizedBox(
                width: itemWidth,
                child: _reveal(
                  delay: Duration(milliseconds: ((i % columns) * 100).toInt()),
                  child: children[i],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool accentRed;

  const _SectionTitle({
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.accentRed = false,
  });

  

  @override
  Widget build(BuildContext context) {
    return _reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 4,
                decoration: BoxDecoration(
                  color: accentRed ? _red : _amber,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                eyebrow.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: accentRed ? _red : _navy,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: _fluid(context, 26, 36),
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: _ink,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                subtitle!,
                style: const TextStyle(fontSize: 16, height: 1.55, color: _muted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero
// ---------------------------------------------------------------------------

class _Hero extends StatefulWidget {
  const _Hero({
    required this.generalCount,
    required this.specialCount,
    required this.onGeneral,
    required this.onSpecial,
  });

  final int generalCount;
  final int specialCount;
  final VoidCallback onGeneral;
  final VoidCallback onSpecial;

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> with SingleTickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  Widget _bubble(double size, Color color, double travel) {
    return AnimatedBuilder(
      animation: _drift,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_drift.value) * 2 - 1;
        return Transform.translate(
          offset: Offset(travel * t * 0.5, travel * t),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        );
      },
    );
  }

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
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              right: -80,
              top: -60,
              child: _bubble(280, _amber.withAlpha(28), 24),
            ),
            Positioned(
              right: 140,
              bottom: -90,
              child: _bubble(180, _red.withAlpha(60), -18),
            ),
            Positioned(
              left: -70,
              bottom: -50,
              child: _bubble(150, _amber.withAlpha(16), 16),
            ),
            _Constrained(
              verticalPadding: 88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _reveal(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _amber.withAlpha(35),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: _amber.withAlpha(140)),
                      ),
                      child: const Text(
                        'OUR SERVICES',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: _amber,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _reveal(
                    delay: const Duration(milliseconds: 120),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Text(
                        'Complete care, from check-ups to complex treatment.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: _fluid(context, 30, 52),
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _reveal(
                    delay: const Duration(milliseconds: 240),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _CountPill(
                          label: '${widget.generalCount} general services',
                          color: _amber,
                        ),
                        _CountPill(
                          label: '${widget.specialCount} specialized services',
                          color: Colors.red.shade300,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _reveal(
                    delay: const Duration(milliseconds: 360),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: widget.onGeneral,
                          icon: const Icon(Icons.medical_services_rounded),
                          label: const Text(
                            'General services', 
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: _amber,
                            foregroundColor: _navy,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 16),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: widget.onSpecial,
                          icon: const Icon(Icons.biotech_rounded),
                          label: const Text(
                            'Specialised services', 
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.white70, width: 1.5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 16),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Emergency band (red)
// ---------------------------------------------------------------------------

class _EmergencyBand extends StatelessWidget {
  const _EmergencyBand({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _red,
      child: _Constrained(
        verticalPadding: 28,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medical emergency?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Our emergency unit is open 24/7  •  $kEmergencyPhone',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white.withAlpha(220),
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.call_rounded),
              label: const Text('Call emergency line'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// General service item
// ---------------------------------------------------------------------------

class _GeneralItem extends StatefulWidget {
  const _GeneralItem({required this.name});

  final String name;

  @override
  State<_GeneralItem> createState() => _GeneralItemState();
}

class _GeneralItemState extends State<_GeneralItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _hover ? Colors.white : _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover ? _amber : const Color(0xFFE3ECEF),
            width: _hover ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _navy.withAlpha(_hover ? 34 : 0),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _hover ? _amber : _navy,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 14,
                color: _hover ? _navy : _amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: _ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Specialized service tile
// ---------------------------------------------------------------------------

class _SpecialTile extends StatefulWidget {
  const _SpecialTile({
    required this.text,
    required this.imagePath,
    required this.onTap,
  });

  final String text;
  final String imagePath;
  final VoidCallback onTap;

  @override
  State<_SpecialTile> createState() => _SpecialTileState();
}

class _SpecialTileState extends State<_SpecialTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_navy, Colors.blue.shade600],
        ),
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _navy.withAlpha(_hover ? 70 : 24),
                  blurRadius: _hover ? 26 : 12,
                  offset: Offset(0, _hover ? 12 : 4),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Only the photo zooms, so the text stays put.
                AnimatedScale(
                  scale: _hover ? 1.08 : 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    cacheWidth: 600, // decode near tile size, not full size
                    filterQuality: FilterQuality.low,
                    excludeFromSemantics: true,
                    errorBuilder: (_, __, ___) => fallback,
                  ),
                ),

                // Darken only the bottom so the photo stays lively.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _navy.withAlpha(120),
                        Colors.black.withAlpha(215),
                      ],
                      stops: const [0.35, 0.65, 1],
                    ),
                  ),
                ),

                // Red arrow badge appears on hover.
                Positioned(
                  top: 14,
                  right: 14,
                  child: AnimatedOpacity(
                    opacity: _hover ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: AnimatedSlide(
                      offset: _hover ? Offset.zero : const Offset(0, -0.4),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration:
                            BoxDecoration(color: _red, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_outward_rounded,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        width: _hover ? 56 : 28,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _hover ? _amber : _red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
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
    );
  }
}

// ---------------------------------------------------------------------------
// Call to action
// ---------------------------------------------------------------------------

class _CallToAction extends StatelessWidget {
  const _CallToAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _Constrained(
      verticalPadding: 48,
      child: _reveal(
        child: Container(
          padding: EdgeInsets.all(_fluid(context, 24, 40)),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_navy, Colors.blue.shade700]),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 20,
            spacing: 24,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Not sure which service you need?',
                      style: TextStyle(
                        fontSize: _fluid(context, 22, 30),
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Book an appointment and our team will guide you to the right department.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white.withAlpha(210),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text('Book an Appointment'),
                style: FilledButton.styleFrom(
                  backgroundColor: _amber,
                  foregroundColor: _navy,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                  textStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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