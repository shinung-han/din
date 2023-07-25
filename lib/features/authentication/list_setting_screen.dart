import 'package:din/common/widgets/common_button.dart';
import 'package:flutter/material.dart';

class ListSettingScreen extends StatefulWidget {
  const ListSettingScreen({super.key});

  @override
  State<ListSettingScreen> createState() => _ListSettingScreenState();
}

class _ListSettingScreenState extends State<ListSettingScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey();

  late final TextEditingController _titleController = TextEditingController()
    ..addListener(() {
      setState(() {
        _title = _titleController.text;
      });
    });

  late String _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _globalKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CommonButton(
          text: 'Create',
          bgColor: Colors.black,
          color: Colors.white,
          onTap: () {
            Navigator.pop(context, _title);
          },
        ),
      ),
    );
  }
}
