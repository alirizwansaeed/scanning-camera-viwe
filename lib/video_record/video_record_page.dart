// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:custom_camera_view/main.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VideoRecordPage extends StatefulWidget {
  const VideoRecordPage({Key? key}) : super(key: key);

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
//this animation is user for timer value from 1 to 10
  late AnimationController _timerAnimationController;
//this animation used for oval shape
  late AnimationController _waveAnimationController;
  //this animation is used for scaling the timer widget
  late AnimationController _scaleAnimationController;

  late Animation<Alignment> _alignmentTween;

  @override
  void initState() {
    super.initState();
    animationInitilization();
    cameraInitilization();
  }

  void cameraInitilization() {
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    _cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void animationInitilization() {
    _scaleAnimationController = AnimationController(
        vsync: this,
        lowerBound: 1,
        upperBound: 1.2,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200));
    _timerAnimationController = AnimationController(
      lowerBound: 0,
      upperBound: 10,
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 2),
    );

    _alignmentTween =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(
      CurvedAnimation(
        parent: _waveAnimationController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );
    //repeat wave animaiton
    _waveAnimationController.repeat(reverse: true);
    animationListners();
  }

  void animationListners() {
    _scaleAnimationController.addListener(() {
      setState(() {});
    });
    _timerAnimationController.addListener(() {
      setState(() {});
    });
    _waveAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _timerAnimationController.dispose();
    _scaleAnimationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

//here you can write the code for when you tap the button
  void onPanStart() {
    _timerAnimationController.forward();
    _scaleAnimationController.forward();
  }

//here you write the code when you left finger from button
  void onPanEnd() {
    _timerAnimationController.reset();
    _scaleAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_cameraController!.value.isInitialized
          ? Container()
          : SizedBox.expand(
              child: CameraPreview(
                _cameraController!,
                child: Stack(
                  children: [
                    BlackMaskWithOvalShape(),
                    WaveAnimaitonOnOvalShape(alignmentTween: _alignmentTween),
                    DelayedDisplay(
                      slidingBeginOffset: const Offset(0.0, 1),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onPanStart: (details) => onPanStart(),
                          onPanEnd: (details) => onPanEnd(),
                          child: Transform.scale(
                            scale: _scaleAnimationController.value,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: CircularPercentIndicator(
                                radius: 70,
                                percent: _timerAnimationController.value * .10,
                                progressColor: Color(0xFFFDD400),
                                backgroundColor: Colors.white,
                                center: Text(
                                  "${_timerAnimationController.value.toInt()}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class WaveAnimaitonOnOvalShape extends StatelessWidget {
  const WaveAnimaitonOnOvalShape({
    Key? key,
    required Animation<Alignment> alignmentTween,
  })  : _alignmentTween = alignmentTween,
        super(key: key);

  final Animation<Alignment> _alignmentTween;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400, minHeight: 250),
                child: AspectRatio(
                  aspectRatio: .8,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(800, 1000)),
                        border: Border.all(color: Color(0xFFFDD400), width: 2)),
                    child: Stack(
                      alignment: _alignmentTween.value,
                      children: [
                        Container(
                          height: 8,
                          clipBehavior: Clip.hardEdge,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade400.withOpacity(.01),
                                Colors.yellow.shade400,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlackMaskWithOvalShape extends StatelessWidget {
  const BlackMaskWithOvalShape({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.srcOut,
      ), // This one will create the magic
      child: Stack(
        //  fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ), // This one  will handle background + difference out
          ),
          SafeArea(
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 400, minHeight: 250),
                      child: AspectRatio(
                        aspectRatio: .8,
                        child: ClipOval(
                          child: Container(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
