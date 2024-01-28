import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';

class CongratulationPage extends StatefulWidget {
  final int correctAnswers;
  const CongratulationPage({required this.correctAnswers});

  @override
  _CongratulationPageState createState() => _CongratulationPageState();
}

class _CongratulationPageState extends State<CongratulationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ConfettiController _confettiController;

  // Remove this getter, as it is unnecessary
  // get correctAnswers => null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    _animationController.repeat(reverse: true);

    // Trigger confetti when the widget is initialized
    _confettiController.play();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConfettiWidget(
                confettiController: _confettiController,
                emissionFrequency: 0.15,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 20,
                maxBlastForce: 50,
                minBlastForce: 20,
                gravity: 0.5,
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: const Icon(
                      Icons.star,
                      size: 100,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                '!نهاية الاختبار',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Text(
                ' حصلت على  '
                '${widget.correctAnswers}'
                '/3',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontFamily: 'Almarai',
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                textAlign: TextAlign.center,
                'ننتظرك غدًا في اختبار آخر',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontFamily: 'Almarai',
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xff72b2ff),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(328, 45), // Adjust the button width and height
                  ),
                ),
                onPressed: () {
                  // Navigate to another page or perform any desired action
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BottomNavBar()));
                },
                child: const Text(
                  'عودة للصفحة الرئيسية',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
