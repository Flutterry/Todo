import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/backend/controller_manager.dart';
import 'package:todo/backend/model/task.dart';
import 'package:todo/src/application.dart';

class AddTaskProvider extends ChangeNotifier {
  static const today = 'Today';
  static const tomorrow = 'Tomorrow';
  static const pickDate = 'Select Date';

  final formKey = GlobalKey<FormState>();
  final taskTextController = TextEditingController();

  String selectedDate = today;
  late Timestamp timestamp = Timestamp.fromDate(currentDay);

  final date = DateTime.now();
  late final currentDay = DateTime(date.year, date.month, date.day);
  late final nextDay = currentDay.add(const Duration(days: 1));

  final taskController = Controller<Task>(Task.collectionName);

  Future<void> selectDate(String label) async {
    switch (label) {
      case today:
        timestamp = Timestamp.fromDate(currentDay);
        break;
      case tomorrow:
        timestamp = Timestamp.fromDate(nextDay);
        break;
      case pickDate:
        final date = await showDatePicker(
          context: ContextService.context,
          initialDate: currentDay,
          firstDate: currentDay.subtract(const Duration(days: 365)),
          lastDate: currentDay.add(const Duration(days: 365 * 5)),
        );
        if (date == null) return;
        timestamp = Timestamp.fromDate(date);
        break;
    }
    selectedDate = label;
    notifyListeners();
  }

  Future<void> addNewTask() async {
    if (formKey.currentState!.validate() == false) return;
    final task = Task()
      ..date = timestamp
      ..isCompleted = false
      ..title = taskTextController.text.trim();

    BotToast.showLoading();
    final result = await taskController.insert(task);
    BotToast.closeAllLoading();
    if (result == null) return;
    pop();
  }
}
