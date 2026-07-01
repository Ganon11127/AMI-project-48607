import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';
import 'package:yu_gi_oh_app/data/models/card_model.dart';
import 'package:yu_gi_oh_app/viewmodel/translation_viewmodel.dart';

class TranslationCardInfo extends StatelessWidget {
  final CardModel card;
  final TranslationViewModel viewModel;

  const TranslationCardInfo({super.key, required this.card, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final lines = <Widget>[];

    if (card.archetype != null) {
      lines.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(l10n.cardArchetype(card.archetype!), style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
      ));
    }

    if (card.type.contains('Monster')) {
      if (card.attribute != null) {
        lines.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(l10n.cardAttribute(card.attribute!), style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
        ));
      }
      if (card.race != null) {
        lines.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(l10n.cardType(card.race!), style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
        ));
      }
      final pendEffect = viewModel.pendulumEffectText;
      if (pendEffect != null && pendEffect.isNotEmpty) {
        lines.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text('${l10n.pendulumEffectLabel}\n$pendEffect', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
        ));
      }
    }

    final effect = viewModel.cardEffectText;
    if (effect != null && effect.isNotEmpty) {
      lines.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(effect, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
      ));
    }

    return Column(children: lines);
  }
}