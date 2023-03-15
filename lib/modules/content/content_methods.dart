import 'package:synerise_flutter_sdk/model/content/documents_api_query.dart';
import 'package:synerise_flutter_sdk/model/content/recommendation_options.dart';

import '../base/base_module_method_channel.dart';

class ContentMethods extends BaseMethodChannel {
  Future<dynamic> getDocument(String slugName) async {
    var documentJson = await methodChannel.invokeMethod("Content/getDocument", slugName);
    return documentJson;
  }

  Future<dynamic> getDocuments(DocumentsApiQuery documentsApiQueryModel) async {
    var documentsJson = await methodChannel.invokeMethod("Content/getDocuments", documentsApiQueryModel.asMap());
    return documentsJson;
  }

  Future<dynamic> getRecommendations(RecommendationOptions recommendationOptions) async {
    var recommendationsJson = await methodChannel.invokeMethod("Content/getRecommendations", recommendationOptions.asMap());
    return recommendationsJson;
  }

  Future<dynamic> getScreenView() async {
    final screenViewJson = await methodChannel.invokeMethod("Content/getScreenView");
    return screenViewJson;
  }
}
