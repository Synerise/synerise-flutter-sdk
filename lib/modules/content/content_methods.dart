import 'package:synerise_flutter_sdk/model/base/mappings.dart';
import 'package:synerise_flutter_sdk/model/content/document_api_query.dart';
import 'package:synerise_flutter_sdk/model/content/screen_view_api_query.dart';

import '../../model/content/document.dart';
import '../../model/content/documents_api_query.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view.dart';
import '../../model/content/screen_view_response.dart';
import '../base/base_module_method_channel.dart';

class ContentMethods extends BaseMethodChannel {
  Future<SyneriseResult<Map<String, Object>>> getDocument(
      String slugName) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<Map<String, Object>>("Content/getDocument",
            parameters: slugName,
            isMappable: true,
            genericTypeKey: GenericTypeKey.mapStringObject);
  }

  Future<SyneriseResult<Document>> generateDocument(String slug) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<Document>(
        "Content/generateDocument",
        parameters: slug,
        isMappable: true);
  }

  Future<SyneriseResult<Document>> generateDocumentWithApiQuery(DocumentApiQuery documentApiQuery) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<Document>(
        "Content/generateDocumentWithApiQuery",
        parameters: documentApiQuery.asMap(),
        isMappable: true);
  }

  Future<SyneriseResult<List<Map<String, Object>>>> getDocuments(
      DocumentsApiQuery documentsApiQueryModel) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<List<Map<String, Object>>>("Content/getDocuments",
            parameters: documentsApiQueryModel.asMap(),
            isMappable: true,
            genericTypeKey: GenericTypeKey.listMapStringDynamic);
  }

  Future<SyneriseResult<RecommendationResponse>> getRecommendations(
      RecommendationOptions recommendationOptions) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<RecommendationResponse>(
            "Content/getRecommendations",
            parameters: recommendationOptions.asMap(),
            isMappable: true);
  }

  Future<SyneriseResult<RecommendationResponse>> getRecommendationsV2(
      RecommendationOptions recommendationOptions) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<RecommendationResponse>(
            "Content/getRecommendationsV2",
            parameters: recommendationOptions.asMap(),
            isMappable: true);
  }

  Future<SyneriseResult<ScreenViewResponse>> getScreenView() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<ScreenViewResponse>("Content/getScreenView",
            isMappable: true);
  }

  Future<SyneriseResult<ScreenView>> generateScreenView(String feedSlug) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<ScreenView>("Content/generateScreenView",
            parameters: feedSlug, isMappable: true);
  }

  Future<SyneriseResult<ScreenView>> generateScreenViewWithApiQuery(ScreenViewApiQuery screenViewApiQuery) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<ScreenView>("Content/generateScreenViewWithApiQuery",
        parameters: screenViewApiQuery.asMap(), isMappable: true);
  }
}
