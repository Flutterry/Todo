import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/src/application.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = context.watch<HomeProvider>();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: provider.selectedScreen,
                  fontSize: 35,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomSelectableTab(HomeProvider.today,
                            rotated: true,
                            onPressed: provider.onTabClicked,
                            isTabSelected:
                                provider.selectedScreen == HomeProvider.today),
                        CustomSelectableTab(HomeProvider.tomorrow,
                            rotated: true,
                            onPressed: provider.onTabClicked,
                            isTabSelected: provider.selectedScreen ==
                                HomeProvider.tomorrow),
                        CustomSelectableTab(HomeProvider.thisWeek,
                            rotated: true,
                            onPressed: provider.onTabClicked,
                            isTabSelected: provider.selectedScreen ==
                                HomeProvider.thisWeek),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomSelectableTab(HomeProvider.pending,
                                  onPressed: provider.onTabClicked,
                                  isTabSelected: provider.selectedScreen ==
                                      HomeProvider.pending),
                              CustomSelectableTab(HomeProvider.completed,
                                  onPressed: provider.onTabClicked,
                                  isTabSelected: provider.selectedScreen ==
                                      HomeProvider.completed),
                              CustomSelectableTab(HomeProvider.all,
                                  onPressed: provider.onTabClicked,
                                  isTabSelected: provider.selectedScreen ==
                                      HomeProvider.all),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              color: backgroundGrey,
                              child: provider.isLoading
                                  ? const Center(
                                      child: SpinKitCircle(color: pink),
                                    )
                                  : provider.shownTasks.isEmpty
                                      ? const Center(
                                          child: CustomText(
                                            text: 'THERE IS NO TASKS',
                                            fontSize: 20,
                                            color: Colors.black54,
                                          ),
                                        )
                                      : ListView.builder(
                                          physics: const BouncingScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics(),
                                          ),
                                          itemBuilder: (_, i) {
                                            return CustomTaskTile(
                                              provider.shownTasks[i],
                                            );
                                          },
                                          itemCount: provider.shownTasks.length,
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Positioned(bottom: 0, right: 0, child: CustomAddTaskButton()),
        ],
      ),
    );
  }
}
