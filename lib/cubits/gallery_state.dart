part of 'gallery_cubit.dart';

@freezed
abstract class GalleryState with _$GalleryState {
  const factory GalleryState.initial() = _Initial;
  const factory GalleryState.loaded(
    bool isLoading,
    bool isUpdating,
    List<Hit> hits,
    String? error,
  ) = _Loaded;
}
