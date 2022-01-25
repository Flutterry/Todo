import 'package:todo/src/application.dart';

class CustomSelectableTab extends StatelessWidget {
  final bool rotated;
  final String label;
  final void Function(String) onPressed;
  final bool isTabSelected;

  const CustomSelectableTab(
    this.label, {
    Key? key,
    this.rotated = false,
    required this.onPressed,
    required this.isTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotated ? 3 : 0,
      child: TextButton(
        onPressed: () => onPressed(label),
        child: CustomText(
          text: label,
          color: isTabSelected ? pink : Colors.black54,
        ),
      ),
    );
  }
}
