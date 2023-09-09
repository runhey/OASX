part of args;

class GroupView extends StatelessWidget {
  final int index;
  const GroupView({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = _data;
    return <Widget>[
      Text(data.groupName),
      const Divider(),
      ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: _argBuilder,
      )
    ].toColumn().card(
        color: Get.theme.colorScheme.background,
        margin: const EdgeInsets.all(10));
  }

  GroupsModel get _data => Get.find<ArgsController>().groups.value[index];

  Widget _argBuilder(BuildContext context, int index) {
    return ArgView(
      index: index,
    );
  }
}

class ArgView extends StatelessWidget {
  final int index;
  const ArgView({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('ddd').constrained(height: 30);
  }
}
