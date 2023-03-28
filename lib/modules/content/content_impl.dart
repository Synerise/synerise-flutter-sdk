import '../../model/content/documents_api_query.dart';
import '../../model/content/recommendation_options.dart';
import '../../model/content/recommendation_response.dart';
import '../../model/content/screen_view_response.dart';
import '../base/base_module.dart';
import 'content_methods.dart';

class ContentImpl extends BaseModule {
  final ContentMethods _methods = ContentMethods();
  ContentImpl();

  Future<Map<String, Object>> getDocument(String slugName) async {
    return _methods.getDocument(slugName);
  }

  Future<List<Map<String, Object>>> getDocuments(DocumentsApiQuery documentsApiQueryModel) async {
    return _methods.getDocuments(documentsApiQueryModel);
  }

  Future<RecommendationResponse> getRecommendations(RecommendationOptions recommendationOptions) async {
    return _methods.getRecommendations(recommendationOptions);
  }

  Future<ScreenViewResponse> getScreenView() async {
    return _methods.getScreenView();
  }
}
