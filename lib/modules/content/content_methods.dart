import '../../model/content/document.dart';
import '../../model/content/documents_api_query.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view.dart';
import '../../model/content/screen_view_response.dart';
import '../base/base_module_method_channel.dart';

class ContentMethods extends BaseMethodChannel {
  Future<Map<String, Object>> getDocument(String slugName) async {
    var documentResponseMap = await methodChannel.invokeMethod("Content/getDocument", slugName);
    Map<String, Object> documentMap = Map<String, Object>.from(documentResponseMap);
    return documentMap;
  }

  Future<Document> generateDocument(String slug) async {
    var documentResponseMap = await methodChannel.invokeMethod("Content/generateDocument", slug);
    Document document = Document.fromMap(documentResponseMap);
    return document;
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
    var recommendationsResponseMap = await methodChannel.invokeMethod("Content/getRecommendations", recommendationOptions.asMap());
    RecommendationResponse recommendationResponse = RecommendationResponse.fromMap(recommendationsResponseMap);
    return recommendationResponse;
  }

  Future<RecommendationResponse> getRecommendationsV2(RecommendationOptions recommendationOptions) async {
    var recommendationResponseMap = await methodChannel.invokeMethod("Content/getRecommendationsV2", recommendationOptions.asMap());
    RecommendationResponse recommendationResponse = RecommendationResponse.fromMap(recommendationResponseMap);
    return recommendationResponse;
  }

  Future<ScreenViewResponse> getScreenView() async {
    var screenViewResponseMap = await methodChannel.invokeMethod("Content/getScreenView");
    ScreenViewResponse screenViewResponse = ScreenViewResponse.fromMap(screenViewResponseMap);
    return screenViewResponse;
  }

  Future<ScreenView> generateScreenView(String feedSlug) async {
    var screenViewMap = await methodChannel.invokeMethod("Content/generateScreenView", feedSlug);
    ScreenView screenViewResponse = ScreenView.fromMap(screenViewMap);
    return screenViewResponse;
  }
}
