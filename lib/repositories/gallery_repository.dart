import 'package:pixabay_test_app/api/keys.dart';
import 'package:pixabay_test_app/api/urls.dart';
import 'package:pixabay_test_app/entities/response/pixabay_response.dart';
import 'package:pixabay_test_app/entities/response/status_response.dart';
import 'package:pixabay_test_app/services/web_service.dart';
import 'package:pixabay_test_app/utils/pagination.dart';

class GalleryRepository {
  Future<dynamic> fetchHits({
    required Pagination pagination,
    required String? search,
  }) async {
    dynamic json = await WebService().get(
      {
        "key": pixabayApiKey,
        "q": search,
        "per_page": "${pagination.size}",
        "page": "${pagination.offset}",
      },
      url: baseUrl,
    );

    try {
      return PixabayResponse.fromJson(json);
    } catch (e) {
      try {
        return StatusResponse(
          status: 'Server error',
          message: json,
        );
      } catch (e) {
        return StatusResponse(
          status: 'Error',
          message: e.toString(),
        );
      }
    }
  }
}
