import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.textWidget,
    required this.icon
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Icon icon;
  final Widget textWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.primaryColor,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(30.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                icon,
                SizedBox(width: 3.0),
                textWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
