import 'package:synerise_flutter_sdk/model/content/documents_api_query.dart';
import 'package:synerise_flutter_sdk/model/content/recommendation_options.dart';

import '../base/base_module.dart';
import 'content_methods.dart';

class ContentImpl extends BaseModule {
  final ContentMethods _methods = ContentMethods();
  ContentImpl();

  Future<dynamic> getDocument(String slugName) async {
    return _methods.getDocument(slugName);
  }

  Future<dynamic> getDocuments(DocumentsApiQuery documentsApiQueryModel) async {
    return _methods.getDocuments(documentsApiQueryModel);
  }

  Future<dynamic> getRecommendations(RecommendationOptions recommendationOptions) async {
    return _methods.getRecommendations(recommendationOptions);
  }

  Future<dynamic> getScreenView() async {
    return _methods.getScreenView();
  }
}
