import '../../model/base/mappings.dart';
import '../base/base_module_method_channel.dart';

import '../../model/content/document_api_query.dart';
import '../../model/content/screen_view_api_query.dart';
import '../../model/content/brickworks_api_query.dart';

import '../../model/content/document.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view.dart';


class ContentMethods extends BaseMethodChannel {
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

    Future<SyneriseResult<Map<String, dynamic>>> generateBrickworks(BrickworksApiQuery brickworksApiQuery) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<Map<String, dynamic>>("Content/generateBrickworks",
        parameters: brickworksApiQuery.asMap(), isMappable: true, genericTypeKey: GenericTypeKey.mapStringDynamic);
  }
}