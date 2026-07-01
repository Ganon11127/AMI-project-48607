import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(l10n.battleHelpTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHelpRow(Icon(Icons.refresh), l10n.battleHelpReset, theme),
          _buildHelpRow(Icon(Icons.sync), l10n.battleHelpRotate, theme),
          _buildHelpRow(Icon(Icons.settings), l10n.battleHelpSettings, theme),
          _buildHelpRow(Icon(Icons.expand_more), l10n.battleHelpToggleNav, theme,),
          _buildHelpRow(FaIcon(FontAwesomeIcons.language), l10n.battleHelpTranslate, theme),
          _buildHelpRow(FaIcon(FontAwesomeIcons.mobileVibrate), l10n.battleHelpSensor, theme),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.battleHelpClose),
        ),
      ],
    );
  }

  Widget _buildHelpRow(Widget icon, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          IconTheme(
            data: IconThemeData(color: theme.primaryColor, size: 24),
            child: icon,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
