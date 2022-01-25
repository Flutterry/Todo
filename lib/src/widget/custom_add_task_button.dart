import 'package:todo/src/application.dart';

class CustomAddTaskButton extends StatelessWidget {
  const CustomAddTaskButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(20),
      height: getWidth(18),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
        color: pink,
      ),
      child: GestureDetector(
        onTap: () {
          push(const AddTaskScreen(), AddTaskProvider()).then(
            (value) => context.read<HomeProvider>().loadAllTasks(),
          );
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: getWidth(8),
              color: pink,
            ),
          ),
        ),
      ),
    );
  }
}
