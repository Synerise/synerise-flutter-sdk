import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'package:synerise_flutter_sdk_example/classes/utils.dart';

class ContentMethodsView extends StatefulWidget {
  const ContentMethodsView({super.key});

  @override
  State<ContentMethodsView> createState() => _ContentMethodsViewState();
}

class _ContentMethodsViewState extends State<ContentMethodsView>
    with AutomaticKeepAliveClientMixin {
  final slugController = TextEditingController();
  final generateDocumentForm = GlobalKey<FormState>();

  final getRecommendationsV2Form = GlobalKey<FormState>();
  final slugRecoController = TextEditingController();
  final productIDController = TextEditingController();

  final feedSlugController = TextEditingController();
  final generateScreenViewForm = GlobalKey<FormState>();

  _tempFormBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //generateDocument
            Form(
                key: generateDocumentForm,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("generateDocument Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: slugController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "slug"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () =>
                            _generateDocumentCall(slugController.text),
                        icon: const Icon(Icons.file_copy_outlined),
                        label: const Text('getDocument')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            //getRecommendations
            Form(
                key: getRecommendationsV2Form,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("getRecommendationsV2 Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: slugRecoController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "slug"),
                          keyboardType: TextInputType.text,
                        )),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: productIDController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "productID"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getRecommendationsV2Call(
                            slugRecoController.text, productIDController.text),
                        icon: const Icon(Icons.recommend_outlined),
                        label: const Text('getRecommendationsV2')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            //generateScreenView
            Form(
                key: generateScreenViewForm,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("generateScreenView Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: feedSlugController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "feedSlug"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () =>
                            _generateScreenViewCall(feedSlugController.text),
                        icon: const Icon(Icons.fit_screen),
                        label: const Text('generateScreenView')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ));
  }

  Future<void> _generateDocumentCall(String slug) async {
    String slugName = slug;

    Document document =
        await Synerise.content.generateDocument(slugName).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert(
          "error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'Document Identifier',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black)),
                child:
                    Text(document.identifier.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getRecommendationsV2Call(
      String slugReco, String productID) async {
    String productId = productID;
    String slug = slugReco;
    RecommendationOptions recommendationOptions =
        RecommendationOptions(slug: slug, productID: productId);

    RecommendationResponse recommendationResponse = await Synerise.content
        .getRecommendationsV2(recommendationOptions)
        .catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert(
          "error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'Recommendation List',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(recommendationResponse.items.toString(),
                    textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _generateScreenViewCall(String feedSlug) async {
    String slug = feedSlug;
    ScreenView screenViewResponse =
        await Synerise.content.generateScreenView(slug).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert(
          "error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'ScreenView Data',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(screenViewResponse.data.toString(),
                    textScaleFactor: 0.5))
          ])));
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (Container(child: _tempFormBody()));
  }

  @override
  bool get wantKeepAlive => true;
}
