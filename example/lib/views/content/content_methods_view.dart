import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/model/content/brickworks_api_query.dart';
import 'package:synerise_flutter_sdk/model/content/screen_view_api_query.dart';
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
  final generateDocumentWithApiQueryForm = GlobalKey<FormState>();

  final getRecommendationsV2Form = GlobalKey<FormState>();
  final slugRecoController = TextEditingController();
  final productIDController = TextEditingController();

  final feedSlugController = TextEditingController();
  final generateScreenViewForm = GlobalKey<FormState>();
  final generateScreenViewWithApiQueryForm = GlobalKey<FormState>();

  final generateBrickworksForm = GlobalKey<FormState>();
  final schemaSlugController = TextEditingController();
  final recordSlugController = TextEditingController();

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
                        label: const Text('generateDocument')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            //generateDocument
            Form(
                key: generateDocumentWithApiQueryForm,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("generateDocumentWithApiQuery Test")),
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
                            _generateDocumentWithApiQueryCall(
                                slugController.text),
                        icon: const Icon(Icons.file_copy_outlined),
                        label: const Text('generateDocumentWithApiQuery')),
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
                        onPressed: () =>
                            _getRecommendationsV2Call(
                                slugRecoController.text,
                                productIDController.text),
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
            Form(
                key: generateScreenViewWithApiQueryForm,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("generateScreenViewWithApiQuery Test")),
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
                            _generateScreenViewWithApiQueryCall(
                                feedSlugController.text),
                        icon: const Icon(Icons.fit_screen),
                        label: const Text('generateScreenView'))
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Form(
                key: generateBrickworksForm,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("generateBrickworks Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: schemaSlugController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "schemaSlug"),
                          keyboardType: TextInputType.text,
                        )),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: recordSlugController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "recordSlug"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () =>
                            _generateBrickworksCall(schemaSlugController.text,
                                recordSlugController.text),
                        icon: const Icon(Icons.fit_screen),
                        label: const Text('generateBrickworks')),
                  ],
                ))
          ],

        ));
  }

  Future<void> _generateDocumentCall(String slug) async {
    String slugName = slug;

    await Synerise.content.generateDocument(slugName,
        onSuccess: (Document document) {
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
                                  border: Border.all(width: 0.5, color: Colors
                                      .black)),
                              child: Text(document.uuid.toString(),
                                  textScaleFactor: 0.5))
                        ])));
              });
        }, onError: (SyneriseError error) {
          Utils.displaySimpleAlert(error.message, context);
        });
  }

  Future<void> _generateDocumentWithApiQueryCall(String slug) async {
    DocumentApiQuery apiQuery = DocumentApiQuery(slug: slug);
    final map = <String, String>{};
    map['test'] = 'value';
    apiQuery.params = map;

    await Synerise.content.generateDocumentWithApiQuery(apiQuery,
        onSuccess: (Document document) {
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
                                  border: Border.all(width: 0.5, color: Colors
                                      .black)),
                              child: Text(document.uuid.toString(),
                                  textScaleFactor: 0.5))
                        ])));
              });
        }, onError: (SyneriseError error) {
          Utils.displaySimpleAlert(error.message, context);
        });
  }

  Future<void> _getRecommendationsV2Call(String slugReco,
      String productID) async {
    String productId = productID;
    String slug = slugReco;
    RecommendationOptions recommendationOptions =
    RecommendationOptions(slug: slug, productID: productId);

    await Synerise.content.getRecommendationsV2(recommendationOptions,
        onSuccess: (RecommendationResponse recommendationResponse) {
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
                                  border: Border.all(width: 0.5, color: Colors
                                      .black)),
                              child: Text(
                                  recommendationResponse.items.toString(),
                                  textScaleFactor: 0.5))
                        ])));
              });
        }, onError: (SyneriseError error) {
          Utils.displaySimpleAlert(error.message, context);
        });
  }

  Future<void> _generateScreenViewCall(String feedSlug) async {
    String slug = feedSlug;
    await Synerise.content.generateScreenView(slug,
        onSuccess: (ScreenView screenViewResponse) {
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
                                  border: Border.all(width: 0.5, color: Colors
                                      .black)),
                              child: Text(screenViewResponse.data.toString(),
                                  textScaleFactor: 0.5))
                        ])));
              });
        }, onError: (SyneriseError error) {
          Utils.displaySimpleAlert(error.message, context);
        });
  }


  Future<void> _generateScreenViewWithApiQueryCall(String feedSlug) async {
    ScreenViewApiQuery apiQuery = ScreenViewApiQuery(feedSlug: feedSlug);
    apiQuery.productId = "0000208094061-L";
    final map = <String, String>{};
    map['test'] = 'value';
    apiQuery.params = map;

    await Synerise.content.generateScreenViewWithApiQuery(apiQuery,
        onSuccess: (ScreenView screenViewResponse) {
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
                                  border: Border.all(width: 0.5, color: Colors
                                      .black)),
                              child: Text(screenViewResponse.data.toString(),
                                  textScaleFactor: 0.5))
                        ])));
              });
        }, onError: (SyneriseError error) {
          Utils.displaySimpleAlert(error.message, context);
        });
  }

  Future<void> _generateBrickworksCall(String schemaSlug,
      String recordSlug) async {
    BrickworksApiQuery apiQuery = BrickworksApiQuery.byRecordSlug(
        schemaSlug: "konradTestuje",
        recordSlug: "testfieldcontext",
        context: {'param': '123'},
        fieldContext: {"similarProducts": {
          "itemId": 'c8a42eb1-2582-403e-8497-976f28b479ee',
          "additionalFilter": 'brand == TEST',
        }});

    await Synerise.content.generateBrickworks(apiQuery,
        onSuccess: (Object response) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    content: SingleChildScrollView(
                        child: Column(children: [
                          const Text(
                            'Brickworks Data',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors
                                      .black)),
                              child: Text(response.toString(),
                                  textScaleFactor: 0.5))
                        ])));
              });
        }, onError: (SyneriseError error) {
          Utils.displaySimpleAlert(error.message, context);
        });
  }

  @override
  void dispose() {
    slugController.dispose();
    slugRecoController.dispose();
    productIDController.dispose();
    feedSlugController.dispose();
    schemaSlugController.dispose();
    recordSlugController.dispose();
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
