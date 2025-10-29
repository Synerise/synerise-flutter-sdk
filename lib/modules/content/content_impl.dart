// ignore_for_file: unnecessary_null_comparison

import '../../model/content/document.dart';
import '../../model/content/document_api_query.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view.dart';
import '../../model/content/screen_view_api_query.dart';
import '../../model/content/brickworks_api_query.dart';
import '../base/base_module.dart';
import '../base/base_module_method_channel.dart';
import './content_methods.dart';

class ContentImpl extends BaseModule {
  final ContentMethods _methods = ContentMethods();
  ContentImpl();

  /// This function generates a document based on a given slug.
  ///
  /// Args:
  ///   slug (String): The parameter "slug" represents a unique identifier
  /// for a specific document.
  Future<void> generateDocument(String slug,
      {required void Function(Document) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<Document> result = await _methods.generateDocument(slug);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function generates a document based on a given slug and context.
  ///
  /// Args:
  ///   slug (DocumentApiQuery): The parameter "documentApiQuery" is an Object for configuration of the query parameters
  /// for a specific document.
  Future<void> generateDocumentWithApiQuery(DocumentApiQuery documentApiQuery,
      {required void Function(Document) onSuccess,
        required void Function(SyneriseError error) onError}) async {
    SyneriseResult<Document> result = await _methods.generateDocumentWithApiQuery(documentApiQuery);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This method generates recommendations that are defined for the options provided.
  ///
  /// Args:
  ///   recommendationOptions (RecommendationOptions): Object for configuration of the options parameters.
  Future<void> getRecommendationsV2(RecommendationOptions recommendationOptions,
      {required void Function(RecommendationResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<RecommendationResponse> result =
        await _methods.getRecommendationsV2(recommendationOptions);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function generates a screen view for a given feed slug.
  Future<void> generateScreenView(String feedSlug,
      {required void Function(ScreenView) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<ScreenView> result =
        await _methods.generateScreenView(feedSlug);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function generates a screen view that is defined for parameters provided in the query object.
  Future<void> generateScreenViewWithApiQuery(ScreenViewApiQuery screenViewApiQuery,
      {required void Function(ScreenView) onSuccess,
        required void Function(SyneriseError error) onError}) async {
    SyneriseResult<ScreenView> result =
    await _methods.generateScreenViewWithApiQuery(screenViewApiQuery);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This method generates Brickworks record that is defined for parameters provided in the query object.
  Future<void> generateBrickworks(BrickworksApiQuery brickworksApiQuery,
      {required void Function(Map<String, dynamic>) onSuccess,
        required void Function(SyneriseError error) onError}) async {
    SyneriseResult<Map<String, dynamic>> result =
    await _methods.generateBrickworks(brickworksApiQuery);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }
}
