import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageTile extends StatefulWidget {
  final int index;
  final String url;
  final int likes;
  final int views;
  final VoidCallback onTap;

  const ImageTile({
    Key? key,
    required this.index,
    required this.url,
    required this.likes,
    required this.views,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile>
    with AutomaticKeepAliveClientMixin {
  Widget _getRow({
    required String imagePath,
    required String value,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          imagePath,
          width: 24.0,
          height: 24.0,
        ),
        const SizedBox(width: 2.5),
        Text(
          widget.views.toString(),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final networkImage = Container(
        color: Colors.black12,
        child: Image.network(
          widget.url,
          width: double.infinity,
          fit: BoxFit.cover,
        ));

    return Hero(
      tag: widget.index,
      child: GestureDetector(
        onTap: () => widget.onTap(),
        child: Column(children: [
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: networkImage,
          )),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _getRow(
              imagePath: 'assets/icons/ic_hearth.svg',
              value: widget.likes.toString(),
            ),
            _getRow(
              imagePath: 'assets/icons/ic_eye.svg',
              value: widget.views.toString(),
            )
          ]),
        ]),
      ),
    );
  }
}
