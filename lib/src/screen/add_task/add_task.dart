import 'package:todo/src/application.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late AddTaskProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = context.watch<AddTaskProvider>();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(text: 'ADD NEW', fontSize: 35),
                ),
                SizedBox(
                  width: getWidth(85),
                  child: Form(
                    key: provider.formKey,
                    child: TextFormField(
                      controller: provider.taskTextController,
                      style: const TextStyle(fontSize: 25),
                      validator: (value) => value != null && value.isNotEmpty ? null: 'Please Write Something',
                      decoration: const InputDecoration(
                        hintText: 'Enter Task',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      CustomSelectableTab(
                        AddTaskProvider.today,
                        onPressed: provider.selectDate,
                        isTabSelected:
                            provider.selectedDate == AddTaskProvider.today,
                      ),
                      CustomSelectableTab(
                        AddTaskProvider.tomorrow,
                        onPressed: provider.selectDate,
                        isTabSelected:
                            provider.selectedDate == AddTaskProvider.tomorrow,
                      ),
                      CustomSelectableTab(
                        AddTaskProvider.pickDate,
                        onPressed: provider.selectDate,
                        isTabSelected:
                            provider.selectedDate == AddTaskProvider.pickDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: provider.addNewTask,
            child: Container(
              width: getWidth(100),
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: pink,
              child: const Center(
                child: CustomText(
                  text: 'Add Task',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
