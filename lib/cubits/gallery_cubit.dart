import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixabay_test_app/entities/response/pixabay_response.dart';
import 'package:pixabay_test_app/entities/response/status_response.dart';
import 'package:pixabay_test_app/repositories/gallery_repository.dart';
import 'package:pixabay_test_app/utils/pagination.dart';
part 'gallery_state.dart';
part 'gallery_cubit.freezed.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final List<Hit> _hits = [];
  Pagination _pagination = Pagination(
    offset: 1,
    size: 30,
  );

  GalleryCubit() : super(const GalleryState.initial());

  Future<void> resetPagination() async => _pagination = Pagination(
        offset: 1,
        size: 30,
      );

  Future getHits({
    required bool isSearching,
    required String searchText,
  }) async {
    if (isSearching == true) {
      _hits.clear();
      emit(GalleryState.loaded(true, true, _hits, null));
    } else {
      emit(GalleryState.loaded(false, true, _hits, null));
    }

    await GalleryRepository()
        .fetchHits(
          pagination: _pagination,
          search: searchText,
        )
        .then((response) => {
              if (response is PixabayResponse)
                {
                  if (response.hits.isNotEmpty)
                    {
                      _pagination.offset += 1,
                      _hits.addAll(response.hits),
                      emit(GalleryState.loaded(false, false, _hits, null))
                    }
                  else
                    emit(const GalleryState.loaded(
                        false, false, [], 'No results'))
                }
              else if (response is StatusResponse)
                emit(GalleryState.loaded(false, false, [], response.message))
            });
  }
}
