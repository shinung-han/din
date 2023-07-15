import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int index;

  const ProjectDetailScreen({
    required this.index,
    super.key,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.width);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Hero(
            tag: '${widget.index}',
            child: Container(
              width: size.width,
              height: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/${widget.index}.jpg',
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set project name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v10,
                Text(
                    'Hello-! Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!Hello-!')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
