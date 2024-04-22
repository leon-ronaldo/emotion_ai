import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => SizedBox(
            height: controller.screenHeight,
            width: controller.screenWidth,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: !controller.screenReady.value
                  ? const Column(
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Center(
                            child:
                                SpinKitFadingCircle(color: Colors.blueAccent),
                          ),
                        ),
                        Text('Getting All Modules Ready....'),
                      ],
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: controller.screenWidth * 0.6,
                            child: TextField(
                              controller: controller.requestFieldController,
                              onSubmitted: (text) async {
                                controller.responseText.value = await controller
                                    .speechRecognitionService
                                    .conversationGenerator
                                    .geminiAPI
                                    .getResponse(text);

                                await controller.speechRecognitionService
                                    .conversationGenerator.speechEngine
                                    .speak(controller.responseText.value);
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter question or prompt',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          controller.fetchingResponse.value
                              ? Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.all(10),
                                        width: 50,
                                        height: 50,
                                        child: const SpinKitFadingCircle(
                                            color: Colors.blueAccent)),
                                    const Text('Fetching response...'),
                                  ],
                                )
                              : Text(controller.responseText.value),
                        ],
                      ),
                    ),
            )),
      ),
    );
  }
}
