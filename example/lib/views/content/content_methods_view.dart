import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'package:synerise_flutter_sdk_example/classes/utils.dart';

class ContentMethodsView extends StatefulWidget {
  const ContentMethodsView({super.key});

  @override
  State<ContentMethodsView> createState() => _ContentMethodsViewState();
}

class _ContentMethodsViewState extends State<ContentMethodsView> with AutomaticKeepAliveClientMixin {
  final slugController = TextEditingController();
  final getDocumentForm = GlobalKey<FormState>();

  final getDocumentsForm = GlobalKey<FormState>();
  final typeController = TextEditingController();
  final typeValueController = TextEditingController();
  final versionController = TextEditingController();

  final getRecommendationsForm = GlobalKey<FormState>();
  final slugRecoController = TextEditingController();
  final productIDController = TextEditingController();

  _tempFormBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //getDocument
            Form(
                key: getDocumentForm,
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(15), child: Text("getDocument Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: slugController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "slug"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getDocumentCall(slugController.text),
                        icon: const Icon(Icons.file_copy_outlined),
                        label: const Text('getDocument')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            //getDocuments
            Form(
                key: getDocumentsForm,
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(15), child: Text("getDocuments Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          enabled: false,
                          controller: typeController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "type"),
                          keyboardType: TextInputType.text,
                        )),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: typeValueController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "typeValue"),
                          keyboardType: TextInputType.text,
                        )),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: versionController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "version"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getDocumentsCall(typeValueController.text, versionController.text),
                        icon: const Icon(Icons.list_alt),
                        label: const Text('getDocuments')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            //getRecommendations
            Form(
                key: getRecommendationsForm,
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(15), child: Text("getRecommendations Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: slugRecoController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "slug"),
                          keyboardType: TextInputType.text,
                        )),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: productIDController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "productID"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getRecommendationsCall(slugRecoController.text, productIDController.text),
                        icon: const Icon(Icons.recommend_outlined),
                        label: const Text('getRecommendations')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            //getScreenView
            const Padding(padding: EdgeInsets.all(15), child: Text("getScreenView Test")),
            ElevatedButton.icon(
                onPressed: () => _getScreenViewCall(), icon: const Icon(Icons.fit_screen), label: const Text('getScreenView')),
          ],
        ));
  }

  Future<void> _getDocumentCall(String slug) async {
    String slugName = slug;

    Map<String, Object> documentMap = await Synerise.content.getDocument(slugName).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
              'Document Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(documentMap.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getDocumentsCall(String typeValue, String? version) async {
    DocumentsApiQueryType documentsApiQueryType = DocumentsApiQueryType.schema;
    DocumentsApiQuery documentsApiQuery =
        DocumentsApiQuery(typeValue: typeValue, version: version != "" ? version : null, type: documentsApiQueryType);
    List<Map<String, Object>> documentsList = await Synerise.content.getDocuments(documentsApiQuery).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
              'Documents Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(documentsList.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getRecommendationsCall(String slugReco, String productRecoID) async {
    String productID = productRecoID;
    String slug = slugReco;
    RecommendationOptions recommendationOptions = RecommendationOptions(slug: slug, productID: productID);

    RecommendationResponse recommendationResponse = await Synerise.content.getRecommendations(recommendationOptions).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(recommendationResponse.asMap().toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getScreenViewCall() async {
    ScreenViewResponse screenViewResponse = await Synerise.content.getScreenView().catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
              'ScreenView Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(screenViewResponse.asMap().toString(), textScaleFactor: 0.5))
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
