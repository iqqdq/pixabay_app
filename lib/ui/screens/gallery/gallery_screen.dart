import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay_test_app/cubits/gallery_cubit.dart';
import 'package:pixabay_test_app/ui/screens/gallery/views/image_tile.dart';
import 'package:pixabay_test_app/ui/screens/image_viewer/image_viewer.dart';
import 'package:pixabay_test_app/utils/transparent_route.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:easy_debounce/easy_debounce.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GalleryCubit _galleryCubit = GalleryCubit();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _galleryCubit.getHits(search: null);
      }
    });

    super.initState();

    _galleryCubit.getHits(search: '');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget indicator = const Center(child: CircularProgressIndicator());

    return Scaffold(
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
              decoration: const InputDecoration(hintText: 'Search'),
              onChanged: (value) => EasyDebounce.debounce(
                  'search_debouncer', const Duration(milliseconds: 500),
                  () async {
                _galleryCubit.resetPagination().whenComplete(() =>
                    _galleryCubit.getHits(search: _textEditingController.text));
              }),
            ),
          ),
        ),
        body: BlocConsumer<GalleryCubit, GalleryState>(
            bloc: _galleryCubit,
            listener: (context, state) {},
            builder: (context, state) {
              return state.when(
                initial: () => indicator,
                loaded: (
                  isLoading,
                  hits,
                  error,
                ) =>
                    SizedBox.expand(
                  child: Stack(children: [
                    /// GRID LIST
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ResponsiveGridList(
                        controller: _scrollController,
                        desiredItemWidth: 160.0,
                        minSpacing: 12.0,
                        squareCells: true,
                        children: List.generate(
                          hits.length,
                          (index) => index,
                        ).map((i) {
                          return hits[i].largeImageUrl == null
                              ? Container()
                              : ImageTile(
                                  key: ValueKey(i),
                                  index: i,
                                  url: hits[i].largeImageUrl!,
                                  likes: hits[i].likes ?? 0,
                                  views: hits[i].views ?? 0,
                                  onTap: () => Navigator.push(
                                      context,
                                      TransparentRoute(
                                        builder: (context) => ImageViewer(
                                          tag: i,
                                          url: hits[i].largeImageUrl!,
                                        ),
                                      )),
                                );
                        }).toList(),
                      ),
                    ),

                    /// ERROR MESSAGE
                    error == null
                        ? Container()
                        : Center(
                            child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                              error,
                              textAlign: TextAlign.center,
                            ),
                          )),

                    isLoading ? indicator : Container(),
                  ]),
                ),
              );
            }));
  }
}
