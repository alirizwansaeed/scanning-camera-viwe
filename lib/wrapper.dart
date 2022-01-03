import 'package:custom_camera_view/id_page/id_page.dart';
import 'package:custom_camera_view/video_record/video_record_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IdPage(),
                    ));
              },
              child: const Text('Id page')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoRecordPage(),
                    ));
              },
              child: const Text('video record page'))
        ],
      ),
    ));
  }
}
