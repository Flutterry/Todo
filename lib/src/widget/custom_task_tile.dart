import 'package:easy_localization/easy_localization.dart';
import 'package:todo/backend/model/task.dart';
import 'package:todo/src/application.dart';

class CustomTaskTile extends StatelessWidget {
  final Task task;
  const CustomTaskTile(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeProvider>();
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) => provider.checkTask(value, task),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        activeColor: pink,
      ),
      title: Text(
        task.title.toString(),
        style: TextStyle(
          decorationThickness: 2,
          decorationStyle: TextDecorationStyle.wavy,
          decorationColor: pink,
          decoration: task.isCompleted == true
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        DateFormat.yMMMd().format(
          DateTime.fromMillisecondsSinceEpoch(
            task.date!.millisecondsSinceEpoch,
          ),
        ),
      ),
      trailing: GestureDetector(
        onTap: () => provider.deleteTask(task),
        child: const Icon(Icons.delete),
      ),
    );
  }
}
