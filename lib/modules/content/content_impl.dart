import '../../model/content/document.dart';
import '../../model/content/documents_api_query.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view.dart';
import '../../model/content/screen_view_response.dart';
import '../base/base_module.dart';
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
  Future<Map<String, Object>> getDocument(String slugName) async {
    return _methods.getDocument(slugName);
  }

  /// This function generates a document based on a given slug.
  ///
  /// Args:
  ///   slug (String): The parameter "slug" represents a unique identifier
  /// for a specific document.
  Future<Document> generateDocument(String slug) async {
    return _methods.generateDocument(slug);
  }

  /// (DEPRECATED) Please use generateDocument instead.
  /// This method generates documents that are defined for parameters provided in the query object.
  ///
  /// Args:
  ///   documentsApiQueryModel (DocumentsApiQuery): An object for configuration of the query parameters
  @Deprecated('Deprecated in version 0.6.0')
  Future<List<Map<String, Object>>> getDocuments(DocumentsApiQuery documentsApiQueryModel) async {
    return _methods.getDocuments(documentsApiQueryModel);
  }

  /// (DEPRECATED) Please use getRecommendationsV2 instead.
  /// This method generates recommendations that are defined for the options provided.
  ///
  /// Args:
  ///   recommendationOptions (RecommendationOptions): Object for configuration of the options parameters.
  @Deprecated('Deprecated in version 0.6.0')
  Future<RecommendationResponse> getRecommendations(RecommendationOptions recommendationOptions) async {
    return _methods.getRecommendations(recommendationOptions);
  }

  /// This method generates recommendations that are defined for the options provided.
  ///
  /// Args:
  ///   recommendationOptions (RecommendationOptions): Object for configuration of the options parameters.
  Future<RecommendationResponse> getRecommendationsV2(RecommendationOptions recommendationOptions) async {
    return _methods.getRecommendationsV2(recommendationOptions);
  }

  /// (DEPRECATED) Please use generateScreenView instead.
  /// This method generates the customer’s highest-priority screen view campaign.
  @Deprecated('Deprecated in version 0.6.0')
  Future<ScreenViewResponse> getScreenView() async {
    return _methods.getScreenView();
  }

  /// This function generates a screen view for a given feed slug.
  Future<ScreenView> generateScreenView(String feedSlug) async {
    return _methods.generateScreenView(feedSlug);
  }
}
