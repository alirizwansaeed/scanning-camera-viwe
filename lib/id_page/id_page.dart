import 'package:camera/camera.dart';
import 'package:custom_camera_view/main.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

class IdPage extends StatefulWidget {
  const IdPage({Key? key}) : super(key: key);

  @override
  _IdPageState createState() => _IdPageState();
}

class _IdPageState extends State<IdPage> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  //this is controller for the wave animation
  late AnimationController _waveAnimationController;
  //this tween used for making wave.
  late Animation<Alignment> _alignmentTween;

  @override
  void initState() {
    super.initState();
    cameraInitilization();
    animaitonInitilization();
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

  void animaitonInitilization() {
    //if you want to change the duration of wave animation, change both duration and reverse duration with same value
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 2),
    );

    _alignmentTween =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(CurvedAnimation(
                parent: _waveAnimationController,
                curve: Curves.easeInOut,
                reverseCurve: Curves.easeInOut));
    //
    //it will allow animation to repeat with infinity time
    _waveAnimationController.repeat(reverse: true);
    _waveAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_cameraController!.value.isInitialized
          ? Container()
          : DefaultTabController(
              length: 2,
              child: SizedBox.expand(
                child: CameraPreview(
                  _cameraController!,
                  child: Stack(
                    children: [
                      const BlackMashWithCardHole(),
                      WaveAnimationOnCardHole(alignmentTween: _alignmentTween),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DelayedDisplay(
                                slidingBeginOffset: const Offset(-.35, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFF848685).withOpacity(.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              const DelayedDisplay(
                                slidingBeginOffset: Offset(.35, 0),
                                delay: Duration(milliseconds: 200),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'Place your ID on a flat surface, then take, a clear photo from above',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const DelayedDisplay(
                                slidingBeginOffset: Offset(0, -.35),
                                delay: Duration(milliseconds: 400),
                                child: Center(
                                  child: TabBar(
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorColor: Color(0xFFFDD401),
                                    tabs: [
                                      Tab(text: 'Recto'),
                                      Tab(text: 'Verso'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              DelayedDisplay(
                                delay: const Duration(milliseconds: 600),
                                slidingBeginOffset: const Offset(0.0, 1),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 70,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color(0xFFFDD401),
                                              width: 3,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF83B000),
                                          ),
                                          child: const Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class WaveAnimationOnCardHole extends StatelessWidget {
  const WaveAnimationOnCardHole({
    Key? key,
    required Animation<Alignment> alignmentTween,
  })  : _alignmentTween = alignmentTween,
        super(key: key);

  final Animation<Alignment> _alignmentTween;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, minWidth: 200),
        child: AspectRatio(
          aspectRatio: 1.586,
          child: Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
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
    );
  }
}

class BlackMashWithCardHole extends StatelessWidget {
  const BlackMashWithCardHole({
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
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ), // This one  will handle background + difference out
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500, minWidth: 200),
              child: AspectRatio(
                aspectRatio: 1.586,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
