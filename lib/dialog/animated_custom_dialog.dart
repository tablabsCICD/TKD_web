import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

/// RESPONSIVE ANIMATED DIALOG
showAnimatedDialog(
    BuildContext context,
    Widget dialog, {
      bool isFlip = false,
      bool dismissible = true,
    }) {
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.45),
    transitionDuration: const Duration(milliseconds: 450),

    /// WRAP PAGEBUILDER FOR RESPONSIVE WIDTH
    pageBuilder: (dialogContext, animation1, animation2) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: kIsWeb ? 450 : double.infinity,  // WEB = SMALL WIDTH
          ),
          child: Material(
            color: Colors.transparent,
            child: dialog,
          ),
        ),
      );
    },

    /// ENTRY ANIMATION
    transitionBuilder: (context, anim, _, child) {
      if (isFlip) {
        /// 3D Flip Animation
        final double angle = (1 - anim.value) * math.pi;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: Opacity(
            opacity: anim.value,
            child: child,
          ),
        );
      } else {
        /// Scale + Fade Animation
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(opacity: anim.value, child: child),
        );
      }
    },
  );
}
