import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final Object tag;
  final String url;

  const ImageViewer({
    super.key,
    required this.tag,
    required this.url,
  });

  @override
  State<StatefulWidget> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Center(
                child: Hero(
                  tag: widget.tag,
                  child: Image.network(
                    widget.url,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            /// CLOSE BUTTON
            Row(children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                        child: Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
                  ))
            ]),
          ]),
        ));
  }
}
