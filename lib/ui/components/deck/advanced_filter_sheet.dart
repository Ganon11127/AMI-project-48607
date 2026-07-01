import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/viewmodel/deck_profile_viewmodel.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

class AdvancedFilterSheet extends StatefulWidget {
  final DeckProfileViewModel viewModel;

  const AdvancedFilterSheet({super.key, required this.viewModel});

  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FilterOptions _tempFilters = FilterOptions();
  final TextEditingController _minLevelController = TextEditingController();
  final TextEditingController _maxLevelController = TextEditingController();
  final TextEditingController _minScaleController = TextEditingController();
  final TextEditingController _maxScaleController = TextEditingController();
  final TextEditingController _minAtkController = TextEditingController();
  final TextEditingController _maxAtkController = TextEditingController();
  final TextEditingController _minDefController = TextEditingController();
  final TextEditingController _maxDefController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final current = widget.viewModel.advancedFilters;
    _tempFilters.monsterTypes = Set.from(current.monsterTypes);
    _tempFilters.attributes = Set.from(current.attributes);
    _tempFilters.races = Set.from(current.races);
    _tempFilters.spellTrapTypes = Set.from(current.spellTrapTypes);
    _tempFilters.minLevel = current.minLevel;
    _tempFilters.maxLevel = current.maxLevel;
    _tempFilters.minPendulumScale = current.minPendulumScale;
    _tempFilters.maxPendulumScale = current.maxPendulumScale;
    _tempFilters.minAtk = current.minAtk;
    _tempFilters.maxAtk = current.maxAtk;
    _tempFilters.includeUnknownAtk = current.includeUnknownAtk;
    _tempFilters.minDef = current.minDef;
    _tempFilters.maxDef = current.maxDef;
    _tempFilters.includeUnknownDef = current.includeUnknownDef;
    _tempFilters.banlistStatus = Set.from(current.banlistStatus);

    _minLevelController.text = current.minLevel?.toString() ?? '';
    _maxLevelController.text = current.maxLevel?.toString() ?? '';
    _minScaleController.text = current.minPendulumScale?.toString() ?? '';
    _maxScaleController.text = current.maxPendulumScale?.toString() ?? '';
    _minAtkController.text = current.minAtk?.toString() ?? '';
    _maxAtkController.text = current.maxAtk?.toString() ?? '';
    _minDefController.text = current.minDef?.toString() ?? '';
    _maxDefController.text = current.maxDef?.toString() ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _minLevelController.dispose();
    _maxLevelController.dispose();
    _minScaleController.dispose();
    _maxScaleController.dispose();
    _minAtkController.dispose();
    _maxAtkController.dispose();
    _minDefController.dispose();
    _maxDefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(l10n.advancedFiltersTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: _clearAll,
                  child: Text(l10n.clearAll),
                ),
                TextButton(
                  onPressed: _applyFilters,
                  child: Text(l10n.apply),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Monster'), Tab(text: 'Spell / Trap')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMonsterFilters(l10n),
                _buildSpellTrapFilters(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonsterFilters(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChipSection(
            label: 'Monster Types',
            options: const ['Normal', 'Effect', 'Ritual', 'Fusion', 'Synchro', 'Xyz', 'Pendulum', 'Link'],
            selected: _tempFilters.monsterTypes,
            onToggle: (v) => _toggleSet(_tempFilters.monsterTypes, v),
          ),
          const SizedBox(height: 12),
          _buildChipSection(
            label: 'Attributes',
            options: const ['Light', 'Dark', 'Water', 'Fire', 'Earth', 'Wind', 'Divine'],
            selected: _tempFilters.attributes,
            onToggle: (v) => _toggleSet(_tempFilters.attributes, v),
          ),
          const SizedBox(height: 12),
          _buildChipSection(
            label: 'Race',
            options: const [
              'Aqua', 'Beast', 'Beast-Warrior', 'Creator God', 'Cyberse',
              'Dinosaur', 'Divine-Beast', 'Dragon', 'Fairy', 'Fiend',
              'Fish', 'Illusion', 'Insect', 'Machine', 'Plant',
              'Psychic', 'Pyro', 'Reptile', 'Rock', 'Sea Serpent',
              'Spellcaster', 'Thunder', 'Warrior', 'Winged Beast', 'Wyrm', 'Zombie'
            ],
            selected: _tempFilters.races,
            onToggle: (v) => _toggleSet(_tempFilters.races, v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minLevelController,
                  decoration: const InputDecoration(labelText: 'Min Level'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.minLevel = int.tryParse(val),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _maxLevelController,
                  decoration: const InputDecoration(labelText: 'Max Level'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.maxLevel = int.tryParse(val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minScaleController,
                  decoration: const InputDecoration(labelText: 'Min Scale'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.minPendulumScale = int.tryParse(val),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _maxScaleController,
                  decoration: const InputDecoration(labelText: 'Max Scale'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.maxPendulumScale = int.tryParse(val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minAtkController,
                  decoration: const InputDecoration(labelText: 'Min ATK'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.minAtk = int.tryParse(val),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _maxAtkController,
                  decoration: const InputDecoration(labelText: 'Max ATK'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.maxAtk = int.tryParse(val),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _tempFilters.includeUnknownAtk,
                onChanged: (val) => setState(() => _tempFilters.includeUnknownAtk = val ?? false),
              ),
              const Text('Include "?" values'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minDefController,
                  decoration: const InputDecoration(labelText: 'Min DEF'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.minDef = int.tryParse(val),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _maxDefController,
                  decoration: const InputDecoration(labelText: 'Max DEF'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _tempFilters.maxDef = int.tryParse(val),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _tempFilters.includeUnknownDef,
                onChanged: (val) => setState(() => _tempFilters.includeUnknownDef = val ?? false),
              ),
              const Text('Include "?" values'),
            ],
          ),
          const SizedBox(height: 12),
          _buildChipSection(
            label: 'Banlist Status',
            options: const ['Forbidden', 'Limited', 'Semi-Limited', 'Unrestricted'],
            selected: _tempFilters.banlistStatus,
            onToggle: (v) => _toggleSet(_tempFilters.banlistStatus, v),
          ),
        ],
      ),
    );
  }

  Widget _buildSpellTrapFilters(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChipSection(
            label: 'Spell/Trap Types',
            options: const [
              'Normal Spell', 'Continuous Spell', 'Quick-Play Spell', 'Ritual Spell', 'Field Spell', 'Equip Spell',
              'Normal Trap', 'Continuous Trap', 'Counter Trap'
            ],
            selected: _tempFilters.spellTrapTypes,
            onToggle: (v) => _toggleSet(_tempFilters.spellTrapTypes, v),
          ),
        ],
      ),
    );
  }

  Widget _buildChipSection({
    required String label,
    required List<String> options,
    required Set<String> selected,
    required void Function(String) onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: selected.contains(option),
              onSelected: (_) => onToggle(option),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _toggleSet(Set<String> set, String value) {
    setState(() {
      if (set.contains(value)) {
        set.remove(value);
      } else {
        set.add(value);
      }
    });
  }

  void _clearAll() {
    _tempFilters.clear();
    _minLevelController.clear();
    _maxLevelController.clear();
    _minScaleController.clear();
    _maxScaleController.clear();
    _minAtkController.clear();
    _maxAtkController.clear();
    _minDefController.clear();
    _maxDefController.clear();
    setState(() {});
  }

  void _applyFilters() {
    widget.viewModel.setAdvancedFilters(_tempFilters);
    Navigator.pop(context);
  }
}