import 'package:anonymy/constant/constant.dart';
import 'package:anonymy/screens/loading.dart';
import 'package:anonymy/screens/onboarding/onBoarding_items.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {


  final controller = OnBoardingItems();
  final pageController = PageController();
  bool isLastPage = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage ? getStarted(context) : Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: (){
                  pageController.jumpToPage(controller.items.length-1);
                },
                child: Text('skip')
            ),

            SmoothPageIndicator(
              controller: pageController,
              count: controller.items.length,
              onDotClicked: (index) => pageController.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut),
              effect: const WormEffect(dotWidth: 10,dotHeight: 10,activeDotColor: Color.fromRGBO(255, 114, 222, 1)),),

            TextButton(
                onPressed: (){
                  pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                },
                child: Text('Next')
            )
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          itemCount: controller.items.length,
          onPageChanged: (index)=> setState(()=> isLastPage = controller.items.length-1 == index),
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Spacer(), // Push the image to the center
                Image.asset(controller.items[index].images),
                Spacer(), // Push the text to the bottom
                Text(
                  controller.items[index].title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.items[index].description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 150), // Adjust this value to add more space at the bottom if needed
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget getStarted(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: primaryColor
    ),
    width: MediaQuery.of(context).size.width * .9,
    height: 55,
    child: TextButton(
        onPressed: ()async{
          final pres = await SharedPreferences.getInstance();
          pres.setBool("onboarding", true);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loading()));
        },
        child: const Text("Get started",style: TextStyle(color: Colors.white),)),
  );
}


