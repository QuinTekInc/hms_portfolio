

import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/models/models.dart';


class FlagshipEventCard extends StatefulWidget {

  final HospitalEvent hospitalEvent;
  final ValueChanged<HospitalEvent> onTap;

  const FlagshipEventCard({
    super.key, 
    required this.hospitalEvent, 
    required this.onTap
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
          onPressed: () => widget.onTap(e),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('View event details'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.blue.shade900,
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