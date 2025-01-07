import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_spacing.dart';

class IOSButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isSecondary;

  const IOSButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isDestructive = false,
    this.isSecondary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: isSecondary ? null : CupertinoColors.systemBlue,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isDestructive
              ? CupertinoColors.systemRed
              : isSecondary
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.white,
        ),
      ),
    );
  }
}
