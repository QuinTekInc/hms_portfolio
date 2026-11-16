import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/text.dart';

class PlaceholderMessage extends StatelessWidget {
  const PlaceholderMessage({
    super.key,
    this.icon = Icons.local_hospital_rounded,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this._maxWidth
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double? _maxWidth;

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _maxWidth ?? double.infinity
        ),

        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.symmetric(
            horizontal: fluidInterpolation(context, 24, 40),
            vertical: fluidInterpolation(context, 32, 48),
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.blue.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade900.withValues(alpha: .08),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon in a soft halo
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                  ),
                ),
                child: Icon(icon, size: 40, color: Colors.blue.shade900),
              ),

              const SizedBox(height: 24),

              HeaderText(
                title,
                textAlignment: TextAlign.center,
                fontSize: fluidInterpolation(context, 20, 24),
                textColor: Colors.blue.shade900,
              ),

              const SizedBox(height: 8),

              // Small amber accent line
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              CustomText(
                message,
                textAlignment: TextAlign.center,
                height: 1.6,
                textColor: Colors.blueGrey.shade600,
                fontSize: 15
              ),

              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  child: CustomText(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}