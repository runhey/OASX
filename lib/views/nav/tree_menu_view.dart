part of nav;

class TreeMenuView extends StatelessWidget {
  TreeMenuView({Key? key}) : super(key: key);

  // final test1 = [
  //   TreeNode(content: Text("test1")),
  //   TreeNode(content: Text("test1")),
  //   TreeNode(content: Text("test1")),
  //   TreeNode(content: Text("test1")),
  //   TreeNode(content: Text("test1")),
  //   TreeNode(content: Text("test1")),
  //   TreeNode(
  //     content: Text("root2"),
  //     children: [
  //       TreeNode(content: Text("child21")),
  //       TreeNode(content: Text("child22")),
  //       TreeNode(
  //         content: Text("root23"),
  //         children: [
  //           TreeNode(content: Text("child231")),
  //         ],
  //       ),
  //     ],
  //   ),
  // ];

  // final test2 = [
  //   TreeNode(content: Text("test2")),
  //   TreeNode(
  //     content: Text("root2"),
  //     children: [
  //       TreeNode(content: Text("child21")),
  //       TreeNode(content: Text("child22")),
  //       TreeNode(
  //         content: Text("root23"),
  //         children: [
  //           TreeNode(content: Text("child231")),
  //         ],
  //       ),
  //     ],
  //   ),
  // ];
  final Map<String, List<String>> test3 = {'Home': [], 'Updater': []};
  final Map<String, List<String>> test4 = {
    'Overview': ['Script', 'Restart']
  };

  @override
  Widget build(BuildContext context) {
    return GetX<NavCtrl>(builder: (controller) {
      var data = controller.testTree.value ? test3 : test4;
      printError(info: controller.testTree.value.toString());
      return TreeView(
              data: data,
              onTap: (e) {
                printInfo(info: e.toString());
              })
          .constrained(width: 180)
          .alignment(Alignment.topLeft)
          .card(margin: const EdgeInsets.all(0))
          .padding(bottom: 10);
    });
  }
}
