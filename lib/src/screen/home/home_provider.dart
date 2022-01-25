import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/backend/controller_manager.dart';
import 'package:todo/backend/model/task.dart';
import 'package:todo/src/application.dart';

class HomeProvider extends ChangeNotifier {
  static const String today = 'TODAY';
  static const String tomorrow = 'TOMORROW';
  static const String thisWeek = 'THIS WEEK';
  static const String completed = 'COMPLETED';
  static const String pending = 'PENDING';
  static const String all = 'ALL';

  String selectedScreen = today;
  final tasks = <Task>[];
  final shownTasks = <Task>[];

  final taskController = Controller<Task>(Task.collectionName);
  bool isLoading = true;

  HomeProvider() {
    loadAllTasks();
  }

  Future<void> loadAllTasks() async {
    tasks.clear();
    isLoading = true;
    notifyListeners();
    final result = await taskController.get(orderBy: 'date');
    isLoading = false;
    if (result == null) return notifyListeners();
    for (final doc in result.docs) {
      tasks.add(Task.fromSnapshot(doc));
    }
    fillShownTasks();
  }

  final date = DateTime.now();
  late final currentDay = DateTime(date.year, date.month, date.day);
  late final nextDay = currentDay.add(const Duration(days: 1));
  late final firstDayOfWeek = currentDay.subtract(
    Duration(days: currentDay.weekday + 1),
  );

  void fillShownTasks() {
    shownTasks.clear();
    switch (selectedScreen) {
      case today:
        shownTasks.addAll(
          tasks.where(
            (t) => t.date!.compareTo(Timestamp.fromDate(currentDay)) == 0,
          ),
        );
        break;
      case tomorrow:
        shownTasks.addAll(
          tasks.where(
              (t) => t.date!.compareTo(Timestamp.fromDate(nextDay)) == 0),
        );
        break;
      case thisWeek:
        shownTasks.addAll(
          tasks.where(
            (t) => DateTime.fromMillisecondsSinceEpoch(
                    t.date!.millisecondsSinceEpoch)
                .isBefore(
              firstDayOfWeek.add(const Duration(days: 7)),
            ),
          ),
        );
        break;
      case pending:
        shownTasks.addAll(tasks.where((t) => t.isCompleted == false));
        break;
      case completed:
        shownTasks.addAll(tasks.where((t) => t.isCompleted == true));
        break;
      case all:
        shownTasks.addAll(tasks);
        break;
    }
    notifyListeners();
  }

  void onTabClicked(String label) {
    selectedScreen = label;
    fillShownTasks();
  }

  bool isTabSelected(String label) {
    return label == selectedScreen;
  }

  Future<void> checkTask(bool? value, Task task) async {
    BotToast.showLoading();
    final result = await taskController.update(
      task.copyWith(isCompleted: value ?? false),
    );
    BotToast.closeAllLoading();
    if (result == null || !result) return;
    task.isCompleted = value;
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    BotToast.showLoading();
    final result = await taskController.remove(task);
    BotToast.closeAllLoading();
    if (result == null || !result) return;
    tasks.remove(task);
    shownTasks.remove(task);
    notifyListeners();
  }
}
