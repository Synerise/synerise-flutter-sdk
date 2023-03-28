import '../../model/content/documents_api_query.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view_response.dart';
import '../base/base_module_method_channel.dart';

class ContentMethods extends BaseMethodChannel {
  Future<Map<String, Object>> getDocument(String slugName) async {
    var documentRsponse = await methodChannel.invokeMethod("Content/getDocument", slugName);
    Map<String, Object> documentMap = Map<String, Object>.from(documentRsponse);
    return documentMap;
  }

  Future<List<Map<String, Object>>> getDocuments(DocumentsApiQuery documentsApiQueryModel) async {
    var documentsResponse = await methodChannel.invokeMethod("Content/getDocuments", documentsApiQueryModel.asMap());
    List<Map<Object?, Object?>> documentsRawList = List<Map<Object?, Object?>>.from(documentsResponse);
    List<Map<String, Object>> recommendationList = [];
    for (var documentObjectMap in documentsRawList) {
      Map<String, Object> documentStringMap = Map<String, Object>.from(documentObjectMap);
      recommendationList.add(documentStringMap);
    }
    return recommendationList;
  }

  Future<RecommendationResponse> getRecommendations(RecommendationOptions recommendationOptions) async {
    var recommendationsResponse = await methodChannel.invokeMethod("Content/getRecommendations", recommendationOptions.asMap());
    RecommendationResponse recommendationsMap = RecommendationResponse.fromMap(recommendationsResponse);
    return recommendationsMap;
  }

  Future<ScreenViewResponse> getScreenView() async {
    var screenViewResponse = await methodChannel.invokeMethod("Content/getScreenView");
    ScreenViewResponse screenViewMap = ScreenViewResponse.fromMap(screenViewResponse);
    return screenViewMap;
  }
}
