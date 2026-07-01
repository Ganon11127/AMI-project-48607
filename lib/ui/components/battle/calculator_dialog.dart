import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_gi_oh_app/viewmodel/battle_viewmodel.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class CalculatorDialog extends StatelessWidget {
  final int playerId;
  final BattleViewModel viewModel;

  const CalculatorDialog({super.key, required this.playerId, required this.viewModel});

  static void show(BuildContext context, int playerId, BattleViewModel viewModel) {
    viewModel.openCalculator(playerId);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ChangeNotifierProvider.value(
        value: viewModel,
        child: CalculatorDialog(playerId: playerId, viewModel: viewModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BattleViewModel>(
      builder: (context, vm, child) {
        final theme = Theme.of(context);
        final currentLP = vm.calculatorCurrentLP;
        final operation = vm.calculatorOperation;

        Widget calcButton(String text, VoidCallback onPressed, {bool isOperator = false, bool isNumber = false, String? logDetails}) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: MaterialButton(
                onPressed: () {
                  if (logDetails != null) {
                    DebugLogger().logTap(details: logDetails);
                  }
                  onPressed();
                },
                color: isOperator
                    ? theme.primaryColor.withValues(alpha: 0.3)
                    : isNumber
                        ? theme.cardColor
                        : theme.cardColor.withValues(alpha: 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: theme.dividerColor, width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface),
                ),
              ),
            ),
          );
        }

        return Dialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '$currentLP',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerRight,
                        child: Text(
                          operation.isEmpty ? '0' : operation,
                          style: TextStyle(fontSize: 20, color: theme.colorScheme.onSurface, overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                      onPressed: () {
                        DebugLogger().logTap(details: 'Calc Close');
                        vm.closeCalculator();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(children: [
                  calcButton('C', vm.clearCalculator, logDetails: 'Calc Clear'),
                  calcButton('⌫', vm.deleteLast, logDetails: 'Calc Backspace'),
                  calcButton('×2', vm.doubleLastNumber, logDetails: 'Calc Double'),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  calcButton('7', () => vm.addDigit('7'), isNumber: true, logDetails: 'Calc Digit 7'),
                  calcButton('8', () => vm.addDigit('8'), isNumber: true, logDetails: 'Calc Digit 8'),
                  calcButton('9', () => vm.addDigit('9'), isNumber: true, logDetails: 'Calc Digit 9'),
                  calcButton('÷2', vm.halfLastNumber, logDetails: 'Calc Half'),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  calcButton('4', () => vm.addDigit('4'), isNumber: true, logDetails: 'Calc Digit 4'),
                  calcButton('5', () => vm.addDigit('5'), isNumber: true, logDetails: 'Calc Digit 5'),
                  calcButton('6', () => vm.addDigit('6'), isNumber: true, logDetails: 'Calc Digit 6'),
                  calcButton('+', () => vm.addOperator('+'), isOperator: true, logDetails: 'Calc Operator +'),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  calcButton('1', () => vm.addDigit('1'), isNumber: true, logDetails: 'Calc Digit 1'),
                  calcButton('2', () => vm.addDigit('2'), isNumber: true, logDetails: 'Calc Digit 2'),
                  calcButton('3', () => vm.addDigit('3'), isNumber: true, logDetails: 'Calc Digit 3'),
                  calcButton('-', () => vm.addOperator('-'), isOperator: true, logDetails: 'Calc Operator -'),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  calcButton('0', () => vm.addDigit('0'), isNumber: true, logDetails: 'Calc Digit 0'),
                  calcButton('00', () => vm.addDigit('00'), isNumber: true, logDetails: 'Calc Digit 00'),
                  calcButton('000', () => vm.addDigit('000'), isNumber: true, logDetails: 'Calc Digit 000'),
                  calcButton('=', () {
                    DebugLogger().logTap(details: 'Calc Equals');
                    vm.applyCalculator();
                    Navigator.pop(context);
                  }, isOperator: true),
                ]),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}