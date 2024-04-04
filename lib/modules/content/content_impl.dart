// ignore_for_file: unnecessary_null_comparison

import '../../model/content/document.dart';
import '../../model/content/documents_api_query.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view.dart';
import '../../model/content/screen_view_response.dart';
import '../base/base_module.dart';
import '../base/base_module_method_channel.dart';
import 'content_methods.dart';

class ContentImpl extends BaseModule {
  final ContentMethods _methods = ContentMethods();
  ContentImpl();

  /// (DEPRECATED) Please use generateDocument instead.
  /// This method generates the document that is defined for the provided slug.
  ///
  /// Args:
  ///   slugName (String): The parameter `slugName` is a string that represents the
  /// name of a document slug that is being requested.
  @Deprecated('Deprecated in version 0.6.0')
  Future<void> getDocument(String slugName,
      {required void Function(Map<String, Object>) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<Map<String, Object>> result =
        await _methods.getDocument(slugName);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

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

  /// (DEPRECATED) Please use generateDocument instead.
  /// This method generates documents that are defined for parameters provided in the query object.
  ///
  /// Args:
  ///   documentsApiQueryModel (DocumentsApiQuery): An object for configuration of the query parameters
  @Deprecated('Deprecated in version 0.6.0')
  Future<void> getDocuments(DocumentsApiQuery documentsApiQueryModel,
      {required void Function(List<Map<String, Object>>) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<List<Map<String, Object>>> result =
        await _methods.getDocuments(documentsApiQueryModel);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// (DEPRECATED) Please use getRecommendationsV2 instead.
  /// This method generates recommendations that are defined for the options provided.
  ///
  /// Args:
  ///   recommendationOptions (RecommendationOptions): Object for configuration of the options parameters.
  @Deprecated('Deprecated in version 0.6.0')
  Future<void> getRecommendations(RecommendationOptions recommendationOptions,
      {required void Function(RecommendationResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<RecommendationResponse> result =
        await _methods.getRecommendations(recommendationOptions);

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

  /// (DEPRECATED) Please use generateScreenView instead.
  /// This method generates the customer’s highest-priority screen view campaign.
  @Deprecated('Deprecated in version 0.6.0')
  Future<void> getScreenView(
      {required void Function(ScreenViewResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<ScreenViewResponse> result = await _methods.getScreenView();

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
}
