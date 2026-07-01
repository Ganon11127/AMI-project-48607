import 'package:flutter/material.dart';

/// A reusable settings icon button.
/// [onTap] callback is executed when the button is pressed 
/// and make it go to the settings screen.
class SettingsButton extends StatelessWidget {
  final VoidCallback? onTap;
  const SettingsButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,                  // The callback to execute when tapped.
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.settings,
          color: Theme.of(context).primaryColor,
          size: 42,
        ),
      ),
    );
  }
}