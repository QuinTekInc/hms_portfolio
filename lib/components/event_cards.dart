

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/models/models.dart';


class FlagshipEventCard extends StatefulWidget {

  final HospitalEvent hospitalEvent;

  const FlagshipEventCard({
    super.key, 
    required this.hospitalEvent, 
  });  

  @override
  State<FlagshipEventCard> createState() => _FlagshipEventCardState();
}

class _FlagshipEventCardState extends State<FlagshipEventCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.hospitalEvent;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [

            Pill(
              label: 'FLAGSHIP EVENT',
              background: Colors.amber,
              foreground: Colors.blue.shade900,
              icon: Icons.workspace_premium_rounded,
            ),

            Pill(
              label: e.category.label,
              background: Colors.white.withAlpha(30),
              foreground: Colors.white,
              icon: Icons.event_rounded,
            ),
          ],
        ),

        const SizedBox(height: 16),

        CustomText(
          e.name,
          fontSize: fluidInterpolation(context, 22, 32),
          height: 1.2,
          textColor: Colors.black87,
          fontWeight: FontWeight.w800,
        ),

        const SizedBox(height: 10),


        CustomText(
          e.description,
          fontSize: 16,
          height: 1.55,
          textColor: Constants.ink,

        ),

        const SizedBox(height: 14),


        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [

            _EventMeta(
              icon: Icons.calendar_month_rounded,
              label: formatDate(e.startDate),
            ),

            _EventMeta(
              icon: Icons.location_on_rounded,
              label: e.location,
            ),
          ],
        ),

        const SizedBox(height: 20),


        FilledButton.icon(
          onPressed: _viewFeaturedEventDetails,
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const CustomText(
            'View event details', 
            fontSize: 15,
            fontWeight: .w800,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.blue.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
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
          color: Constants.surface.withAlpha(_hover ? 40 : 30),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hover ? Colors.amber : Constants.greyBorder,
            width: _hover ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,

        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 800;

            final visual = _EventVisual(
              imageUrl: widget.hospitalEvent.coverImage,
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



  void _viewFeaturedEventDetails() async => context.go('events/${widget.hospitalEvent.id}');
}

//for showing stuff like date, time and location
class _EventMeta extends StatelessWidget {
  const _EventMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.amber),
        const SizedBox(width: 6),
        Flexible(
          child: CustomText(
            label,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            textColor: Constants.muted,
          ),
        ),
      ],
    );
  }
}

class _EventVisual extends StatelessWidget {

  final String? imageUrl;

  const _EventVisual({required this.imageUrl, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [

          if(imageUrl != null) Image.network(
            imageUrl!, 
            fit: BoxFit.cover, 
            height: 350,
          )
          else Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade700, Colors.blue.shade900],
              ),
            ),
            child: Icon(
              Icons.event_rounded,
              size: 72,
              color: Colors.white.withAlpha(90),
            ),
          ),

          // Soft blend into the card
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.blue.shade900.withAlpha(120),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



//==============================================================================
//REGULAR EVENTS CARD
//==============================================================================
class EventCard extends StatefulWidget {

  final HospitalEvent event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
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

                      CustomText(
                        '${e.startDate.day}',
                        fontSize: 22,
                        fontWeight: .w800, 
                        textColor: color,
                        height: 1,
                      ),

                      const SizedBox(height: 4),

                      CustomText(
                        months[e.startDate.month - 1],
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        textColor: color,
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                // Category tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                  decoration: BoxDecoration(
                    color: color.withAlpha(28),
                    borderRadius: BorderRadius.circular(999),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(e.category.icon, size: 14, color: color),

                      const SizedBox(width: 6),

                      CustomText(
                        e.category.label,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        textColor: color,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),


            CustomText(
              e.name,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.25,
              textColor: Color(0xFF12303A), 
            ),

            const SizedBox(height: 8),

            CustomText(
              e.description,
              fontSize: 14.5,
              height: 1.5,
              textColor: Color(0xFF5B7480),
              
            ),

            const SizedBox(height: 16),

            _InfoRow(icon: Icons.schedule_rounded, text: e.startTime),

            const SizedBox(height: 6),

            _InfoRow(icon: Icons.place_rounded, text: e.location),

            const SizedBox(height: 18),

            Spacer(),
            
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
                onPressed: navigateToRegistrationPage,
                child: const CustomText('Register interest'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  //mainly to open a new tab to the next website
  void navigateToRegistrationPage() async {
    // TODO: navigate to a registration form or booking page.
    context.push('events/${widget.event.id}/');
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

        Icon(
          icon, 
          size: 18, 
          color: const Color(0xFF7D93A0)
        ),

        const SizedBox(width: 8),

        Expanded(
          child: CustomText(
            text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: Color(0xFF365564),
            
          ),
        ),
      ],
    );
  }
}