
import 'package:flutter/material.dart';

void main() => runApp(const HospitalApp());

// ───────────────────────── Theme ─────────────────────────

class AppColors {
  static final Color primary = Colors.blue.shade900;
  static final Color primarySoft = Colors.blue.shade50;
  static const Color accent = Colors.amber;
  static const Color danger = Colors.red;
  static final Color body = Colors.blueGrey.shade700;
}

class HospitalApp extends StatelessWidget {
  const HospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityCare Hospital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900)
            .copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          error: AppColors.danger,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LandingPage(),
    );
  }
}

// ───────────────────────── Responsive helpers ─────────────────────────

bool isMobile(BuildContext c) => MediaQuery.sizeOf(c).width < 900;

/// Centers content, caps width at 1200 and adds responsive padding.
class Constrained extends StatelessWidget {
  const Constrained({super.key, required this.child, this.vertical = 72});
  final Widget child;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile(context) ? 20 : 32,
            vertical: isMobile(context) ? vertical * 0.7 : vertical,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Lays children out in as many equal columns as fit.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 280,
    this.spacing = 24,
  });
  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = ((c.maxWidth + spacing) / (minItemWidth + spacing))
          .floor()
          .clamp(1, children.length)
          .toInt();
      final w = (c.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [for (final ch in children) SizedBox(width: w, child: ch)],
      );
    });
  }
}

ButtonStyle amberButton() => FilledButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );

// ───────────────────────── Sections ─────────────────────────

enum Section { home, services, doctors, about, contact }

extension SectionLabel on Section {
  String get label => switch (this) {
        Section.home => 'Home',
        Section.services => 'Services',
        Section.doctors => 'Doctors',
        Section.about => 'About',
        Section.contact => 'Contact',
      };
}

// ───────────────────────── Page ─────────────────────────

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _keys = {for (final s in Section.values) s: GlobalKey()};

  void _goTo(Section s) {
    final ctx = _keys[s]!.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  AppBar _navBar(bool mobile) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      toolbarHeight: 68,
      titleSpacing: mobile ? 0 : 32,
      title: const Row(
        children: [
          Icon(Icons.local_hospital_rounded, color: AppColors.accent, size: 30),
          SizedBox(width: 8),
          Text('CityCare Hospital',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        ],
      ),
      actions: mobile
          ? null
          : [
              for (final s in Section.values)
                TextButton(
                  onPressed: () => _goTo(s),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: Text(s.label),
                ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: () => _goTo(Section.contact),
                style: amberButton(),
                child: const Text('Book Appointment'),
              ),
              const SizedBox(width: 32),
            ],
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(color: AppColors.primary),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Icon(Icons.local_hospital_rounded,
                      color: AppColors.accent, size: 36),
                  SizedBox(width: 10),
                  Text('CityCare',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
          for (final s in Section.values)
            ListTile(
              title: Text(s.label),
              onTap: () {
                Navigator.pop(context);
                _goTo(s);
              },
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _goTo(Section.contact);
              },
              style: amberButton(),
              child: const Text('Book Appointment'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    return Scaffold(
      appBar: _navBar(mobile),
      drawer: mobile ? _drawer() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const EmergencyBar(),
            KeyedSubtree(
              key: _keys[Section.home],
              child: HeroSection(
                onBook: () => _goTo(Section.contact),
                onServices: () => _goTo(Section.services),
              ),
            ),
            const StatsSection(),
            KeyedSubtree(
                key: _keys[Section.services], child: const ServicesSection()),
            KeyedSubtree(
                key: _keys[Section.doctors], child: const DoctorsSection()),
            KeyedSubtree(
                key: _keys[Section.about], child: const AboutSection()),
            AppointmentBanner(onBook: () => _goTo(Section.contact)),
            KeyedSubtree(
                key: _keys[Section.contact],
                child: Footer(onNavigate: _goTo)),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Emergency bar ─────────────────────────

class EmergencyBar extends StatelessWidget {
  const EmergencyBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.danger,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Icon(Icons.emergency, color: Colors.white, size: 18),
          Text('24/7 Emergency Line: +1 (555) 010-0199',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ───────────────────────── Hero ─────────────────────────

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onBook, required this.onServices});
  final VoidCallback onBook;
  final VoidCallback onServices;

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text('Trusted care since 1998',
              style: TextStyle(
                  color: AppColors.accent, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            text: 'Your health,\nour ',
            children: const [
              TextSpan(
                  text: 'priority.', style: TextStyle(color: AppColors.accent)),
            ],
          ),
          style: TextStyle(
            fontSize: mobile ? 38 : 58,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'World-class specialists, modern facilities and compassionate '
          'nurses, all under one roof. Book a visit in minutes.',
          style: TextStyle(
              fontSize: mobile ? 16 : 18,
              height: 1.6,
              color: Colors.white.withValues(alpha: 0.85)),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: onBook,
              style: amberButton(),
              icon: const Icon(Icons.calendar_month),
              label: const Text('Book Appointment'),
            ),
            OutlinedButton(
              onPressed: onServices,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              ),
              child: const Text('Our Services'),
            ),
          ],
        ),
      ],
    );

    final visual = Container(
      height: mobile ? 240 : 380,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.local_hospital_rounded,
              size: mobile ? 110 : 180,
              color: Colors.white.withValues(alpha: 0.9)),
          const Positioned(
            top: 20,
            right: 20,
            child: _FloatingBadge(Icons.favorite, 'Cardiology', Colors.red),
          ),
          const Positioned(
            bottom: 20,
            left: 20,
            child: _FloatingBadge(Icons.verified, 'Accredited', Colors.amber),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Constrained(
        vertical: 88,
        child: mobile
            ? Column(children: [text, const SizedBox(height: 40), visual])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: text),
                  const SizedBox(width: 56),
                  Expanded(flex: 5, child: visual),
                ],
              ),
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }
}

// ───────────────────────── Stats ─────────────────────────

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      (Icons.groups, '50K+', 'Patients treated'),
      (Icons.medical_information, '120+', 'Specialist doctors'),
      (Icons.apartment, '25', 'Departments'),
      (Icons.workspace_premium, '25 yrs', 'Of excellence'),
    ];
    return Container(
      color: AppColors.primarySoft,
      child: Constrained(
        vertical: 48,
        child: ResponsiveGrid(
          minItemWidth: 220,
          children: [
            for (final s in stats)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                      bottom: BorderSide(color: AppColors.accent, width: 4)),
                ),
                child: Column(
                  children: [
                    Icon(s.$1, color: AppColors.primary, size: 32),
                    const SizedBox(height: 8),
                    Text(s.$2,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                    Text(s.$3, style: TextStyle(color: AppColors.body)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Section header ─────────────────────────

class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {super.key, required this.eyebrow, required this.title, this.subtitle});
  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(eyebrow.toUpperCase(),
            style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                fontSize: 13)),
        const SizedBox(height: 8),
        Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: isMobile(context) ? 28 : 38,
                fontWeight: FontWeight.w800,
                color: AppColors.primary)),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(subtitle!,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16, height: 1.5, color: AppColors.body)),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}

// ───────────────────────── Services ─────────────────────────

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      (Icons.favorite, 'Cardiology', 'Advanced heart care, from screening to surgery.', AppColors.primary),
      (Icons.child_care, 'Pediatrics', 'Gentle, specialised care for infants and children.', AppColors.primary),
      (Icons.pregnant_woman, 'Maternity', 'Support for mothers before, during and after birth.', AppColors.primary),
      (Icons.biotech, 'Laboratory', 'Fast, accurate diagnostics with digital results.', AppColors.primary),
      (Icons.psychology, 'Neurology', 'Expert care for brain, spine and nerve conditions.', AppColors.primary),
      (Icons.emergency, 'Emergency', 'Round-the-clock trauma and urgent care, every day.', AppColors.danger),
    ];

    return Constrained(
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'What we do',
            title: 'Our Services',
            subtitle: 'Comprehensive medical services delivered by people who care.',
          ),
          ResponsiveGrid(
            children: [
              for (final s in services)
                _ServiceCard(icon: s.$1, title: s.$2, text: s.$3, color: s.$4),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard(
      {required this.icon,
      required this.title,
      required this.text,
      required this.color});
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 8),
          Text(text, style: TextStyle(height: 1.5, color: AppColors.body)),
          const SizedBox(height: 12),
          Text('Learn more →',
              style: TextStyle(
                  color: Colors.amber.shade800, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ───────────────────────── Doctors ─────────────────────────

class DoctorsSection extends StatelessWidget {
  const DoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const doctors = [
      ('Amelia Hart', 'Cardiologist'),
      ('Daniel Okoye', 'Neurologist'),
      ('Sofia Marin', 'Pediatrician'),
      ('James Whitfield', 'General Surgeon'),
    ];

    return Container(
      color: AppColors.primarySoft,
      child: Constrained(
        child: Column(
          children: [
            const SectionHeader(
              eyebrow: 'Our team',
              title: 'Meet Our Specialists',
              subtitle: 'Experienced, board-certified doctors you can trust.',
            ),
            ResponsiveGrid(
              minItemWidth: 240,
              children: [
                for (final d in doctors)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            d.$1.split(' ').map((p) => p[0]).take(2).join(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Dr. ${d.$1}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(d.$2, style: TextStyle(color: AppColors.body)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < 5; i++)
                              Icon(Icons.star, color: AppColors.accent, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── About ─────────────────────────

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    const points = [
      'Modern, fully equipped diagnostic centre',
      'Short waiting times and online booking',
      'Compassionate, multilingual care teams',
      'Transparent pricing and insurance support',
    ];

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('WHY CHOOSE US',
            style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                fontSize: 13)),
        const SizedBox(height: 8),
        Text('Care that puts you first',
            style: TextStyle(
                fontSize: mobile ? 28 : 38,
                fontWeight: FontWeight.w800,
                color: AppColors.primary)),
        const SizedBox(height: 16),
        Text(
          'For over two decades CityCare has combined clinical excellence '
          'with a human touch, so every patient feels heard and safe.',
          style: TextStyle(fontSize: 16, height: 1.6, color: AppColors.body),
        ),
        const SizedBox(height: 24),
        for (final p in points)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(p,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary))),
              ],
            ),
          ),
      ],
    );

    final card = Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.emergency, color: AppColors.danger, size: 44),
          const SizedBox(height: 16),
          const Text('Need urgent care?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Our emergency team is available day and night.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85), height: 1.5)),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
            icon: const Icon(Icons.phone),
            label: const Text('Call +1 (555) 010-0199'),
          ),
        ],
      ),
    );

    return Constrained(
      child: mobile
          ? Column(children: [left, const SizedBox(height: 32), card])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: left),
                const SizedBox(width: 56),
                Expanded(flex: 5, child: card),
              ],
            ),
    );
  }
}

// ───────────────────────── Appointment banner ─────────────────────────

class AppointmentBanner extends StatelessWidget {
  const AppointmentBanner({super.key, required this.onBook});
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final text = Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text('Ready to see a doctor?',
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
                fontSize: mobile ? 26 : 32,
                fontWeight: FontWeight.w800,
                color: AppColors.primary)),
        const SizedBox(height: 8),
        Text('Book an appointment online in under two minutes.',
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(fontSize: 16, color: Colors.blue.shade900)),
      ],
    );
    final button = FilledButton(
      onPressed: onBook,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      child: const Text('Book Appointment'),
    );

    return Container(
      width: double.infinity,
      color: AppColors.accent,
      child: Constrained(
        vertical: 48,
        child: mobile
            ? Column(children: [text, const SizedBox(height: 24), button])
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Expanded(child: text), button],
              ),
      ),
    );
  }
}

// ───────────────────────── Footer ─────────────────────────

class Footer extends StatelessWidget {
  const Footer({super.key, required this.onNavigate});
  final void Function(Section) onNavigate;

  @override
  Widget build(BuildContext context) {
    final muted = TextStyle(color: Colors.white.withValues(alpha: 0.75), height: 1.6);
    const heading = TextStyle(
        color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 16);

    Widget infoRow(IconData icon, String text) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: AppColors.accent),
              const SizedBox(width: 10),
              Expanded(child: Text(text, style: muted)),
            ],
          ),
        );

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      child: Constrained(
        vertical: 56,
        child: Column(
          children: [
            ResponsiveGrid(
              minItemWidth: 220,
              spacing: 32,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.local_hospital_rounded,
                          color: AppColors.accent, size: 28),
                      SizedBox(width: 8),
                      Text('CityCare Hospital',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18)),
                    ]),
                    const SizedBox(height: 12),
                    Text('Compassionate, world-class care for you and your family.',
                        style: muted),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick links', style: heading),
                    const SizedBox(height: 12),
                    for (final s in Section.values)
                      InkWell(
                        onTap: () => onNavigate(s),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(s.label, style: muted),
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contact', style: heading),
                    const SizedBox(height: 12),
                    infoRow(Icons.phone, '+1 (555) 010-0199'),
                    infoRow(Icons.email, 'hello@citycare.example'),
                    infoRow(Icons.location_on, '12 Health Avenue, Your City'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Opening hours', style: heading),
                    const SizedBox(height: 12),
                    infoRow(Icons.schedule, 'Mon–Fri: 8:00 – 18:00'),
                    infoRow(Icons.schedule, 'Sat: 9:00 – 14:00'),
                    infoRow(Icons.emergency, 'Emergency: 24/7'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text('© 2026 CityCare Hospital. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}