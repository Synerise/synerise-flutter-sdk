import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';
import 'package:synerise_flutter_sdk/model/content/documents_api_query.dart';
import 'package:synerise_flutter_sdk/model/content/recommendation_options.dart';

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
  final productIdController = TextEditingController();

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
                          controller: productIdController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "productId"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getRecommendationsCall(slugRecoController.text, productIdController.text),
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

    var documentJson = await Synerise.content.getDocument(slugName).catchError((error) {
      String errorMessage = Synerise.handlePlatformException(error);
      Synerise.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
              'Document JSON',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(documentJson.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getDocumentsCall(String typeValue, String? version) async {
    DocumentsApiQuery documentsApiQuery = DocumentsApiQuery(typeValue: typeValue, version: version != "" ? version : null);
    var documentsJson = await Synerise.content.getDocuments(documentsApiQuery).catchError((error) {
      String errorMessage = Synerise.handlePlatformException(error);
      Synerise.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
              'Documents JSON',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(documentsJson.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getRecommendationsCall(String slugReco, String productRecoId) async {
    String productId = productRecoId;
    String slug = slugReco;
    RecommendationOptions recommendationOptions =
        RecommendationOptions(slug: slug != "" ? slug : null, productId: productId != "" ? productId : null);

    var recommendationsJson = await Synerise.content.getRecommendations(recommendationOptions).catchError((error) {
      String errorMessage = Synerise.handlePlatformException(error);
      Synerise.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
              'Recommendation JSON',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(recommendationsJson.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getScreenViewCall() async {
    var screenViewJson = await Synerise.content.getScreenView().catchError((error) {
      String errorMessage = Synerise.handlePlatformException(error);
      Synerise.displaySimpleAlert("error on handling api call \n $errorMessage", context);
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
              'ScreenView JSON',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(screenViewJson.toString(), textScaleFactor: 0.5))
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
