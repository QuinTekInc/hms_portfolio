import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/page_header.dart';

/// Brand colour. Swap for your site's theme colour.
const Color kBrand = Color(0xFF0E7C86);

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

enum EventCategory { healthTalk, screening, training, community }

extension EventCategoryX on EventCategory {
  String get label => switch (this) {
        EventCategory.healthTalk => 'Health Talk',
        EventCategory.screening => 'Free Screening',
        EventCategory.training => 'Training',
        EventCategory.community => 'Community',
      };

  Color get color => switch (this) {
        EventCategory.healthTalk => const Color(0xFF0E7C86),
        EventCategory.screening => const Color(0xFFD9534F),
        EventCategory.training => const Color(0xFF6C5CE7),
        EventCategory.community => const Color(0xFFEF8F2D),
      };

  IconData get icon => switch (this) {
        EventCategory.healthTalk => Icons.record_voice_over_rounded,
        EventCategory.screening => Icons.monitor_heart_rounded,
        EventCategory.training => Icons.school_rounded,
        EventCategory.community => Icons.groups_rounded,
      };
}

class HospitalEvent {
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String location;
  final EventCategory category;

  const HospitalEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
  });
}

/// Sample data. Replace with data from your API / Firestore.
final List<HospitalEvent> sampleEvents = [
  HospitalEvent(
    title: 'Diabetes Awareness Talk',
    description:
        'Learn how to recognise early signs, manage blood sugar and eat well with our endocrinology team.',
    date: DateTime(2026, 11, 7),
    time: '10:00 AM',
    location: 'Main Auditorium',
    category: EventCategory.healthTalk,
  ),
  HospitalEvent(
    title: 'Free Blood Pressure Screening',
    description:
        'Walk in for a quick, free check-up with our nurses. No appointment needed.',
    date: DateTime(2026, 11, 12),
    time: '8:00 AM',
    location: 'Outpatient Lobby',
    category: EventCategory.screening,
  ),
  HospitalEvent(
    title: 'First Aid & CPR Workshop',
    description:
        'Hands-on training in life-saving skills for schools, workplaces and families.',
    date: DateTime(2026, 11, 19),
    time: '2:00 PM',
    location: 'Training Room B',
    category: EventCategory.training,
  ),
  HospitalEvent(
    title: 'Community Health Walk',
    description:
        'Join staff and neighbours for a friendly 5 km walk promoting an active lifestyle.',
    date: DateTime(2026, 11, 28),
    time: '6:30 AM',
    location: 'Hospital Gate',
    category: EventCategory.community,
  ),
  HospitalEvent(
    title: "Maternal & Child Health Day",
    description:
        'Talks on antenatal care, nutrition and immunisation, with free baby weighing.',
    date: DateTime(2026, 12, 3),
    time: '9:00 AM',
    location: 'Maternity Wing',
    category: EventCategory.healthTalk,
  ),
  HospitalEvent(
    title: 'Free Eye & Vision Screening',
    description:
        'Get your eyes checked by our ophthalmology team and learn how to protect your sight.',
    date: DateTime(2026, 12, 10),
    time: '9:00 AM',
    location: 'Eye Clinic',
    category: EventCategory.screening,
  ),
];

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class EventsPage extends StatefulWidget {
  const EventsPage({super.key, List<HospitalEvent>? events})
      : _events = events;

  final List<HospitalEvent>? _events;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  EventCategory? _selected; // null = All

  List<HospitalEvent> get _filtered {
    final all = [...(widget._events ?? sampleEvents)]
      ..sort((a, b) => a.date.compareTo(b.date));
    if (_selected == null) return all;
    return all.where((e) => e.category == _selected).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: PageHeader(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 16 : 32,
                vertical: compact ? 32 : 56,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(compact: compact),
                  const SizedBox(height: 28),
                  _FilterBar(
                    selected: _selected,
                    onChanged: (c) => setState(() => _selected = c),
                  ),
                  const SizedBox(height: 28),
                  _EventsGrid(events: _filtered, filterKey: _selected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _FadeSlideIn(
      index: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kBrand.withAlpha(25),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'WHAT\'S ON',
              style: TextStyle(
                color: kBrand,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Events & Community Programmes',
            style: TextStyle(
              fontSize: compact ? 28 : 40,
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: const Color(0xFF12303A),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Join our talks, screenings and workshops, and take charge of your health.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5B7480),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filters
// ---------------------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final EventCategory? selected;
  final ValueChanged<EventCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _chip(label: 'All', active: selected == null, onTap: () => onChanged(null)),
        for (final c in EventCategory.values)
          _chip(
            label: c.label,
            icon: c.icon,
            color: c.color,
            active: selected == c,
            onTap: () => onChanged(c),
          ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool active,
    required VoidCallback onTap,
    IconData? icon,
    Color color = kBrand,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: active ? color : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: active ? color : const Color(0xFFD5E2E6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: active ? Colors.white : color),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : const Color(0xFF12303A),
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
// Grid
// ---------------------------------------------------------------------------

class _EventsGrid extends StatelessWidget {
  const _EventsGrid({required this.events, required this.filterKey});

  final List<HospitalEvent> events;
  final EventCategory? filterKey;

  static const double _spacing = 20;
  static const double _minItemWidth = 320;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No events in this category right now. Please check back soon.',
            style: TextStyle(color: Color(0xFF5B7480), fontSize: 16),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ((constraints.maxWidth + _spacing) /
                (_minItemWidth + _spacing))
            .floor()
            .clamp(1, 3);
        final itemWidth =
            (constraints.maxWidth - _spacing * (columns - 1)) / columns;

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Wrap(
            spacing: _spacing,
            runSpacing: _spacing,
            children: [
              for (var i = 0; i < events.length; i++)
                SizedBox(
                  width: itemWidth,
                  // The key includes the filter so cards re-animate on change.
                  child: _FadeSlideIn(
                    key: ValueKey('${events[i].title}-$filterKey'),
                    index: i,
                    child: _EventCard(event: events[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card
// ---------------------------------------------------------------------------

const _months = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

class _EventCard extends StatefulWidget {
  const _EventCard({required this.event});
  final HospitalEvent event;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final color = e.category.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hover ? color.withAlpha(120) : const Color(0xFFE3ECEF),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_hover ? 30 : 12),
              blurRadius: _hover ? 24 : 12,
              offset: Offset(0, _hover ? 12 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date badge
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withAlpha(28),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${e.date.day}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: color,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _months[e.date.month - 1],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Category tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withAlpha(28),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(e.category.icon, size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        e.category.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              e.title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: Color(0xFF12303A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              e.description,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: Color(0xFF5B7480),
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.schedule_rounded, text: e.time),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.place_rounded, text: e.location),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: navigate to a registration form or booking page.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration for "${e.title}" coming soon')),
                  );
                },
                child: const Text('Register interest'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF7D93A0)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF365564),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Entrance animation
// ---------------------------------------------------------------------------

class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}