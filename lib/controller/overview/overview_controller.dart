part of overview;

class OverviewController extends GetxController {
  final running = const TaskItemModel('taksname', 'nextrun').obs;
  final pendings = <TaskItemModel>[
    const TaskItemModel('pandings1', 'nextrun'),
    const TaskItemModel('pandings2', 'nextrun'),
    const TaskItemModel('pandings3', 'nextrun'),
    const TaskItemModel('pandings4', 'nextrun')
  ].obs;
  final waitings = const <TaskItemModel>[
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('Restart', '2020-01-01 00:00:00'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings3', 'nextrun'),
    TaskItemModel('waitings4', 'nextrun')
  ].obs;
}
