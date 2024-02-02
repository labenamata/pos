import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;
import 'package:line_icons/line_icons.dart';
import 'package:pos_app/bloc/image_bloc.dart';
import 'package:pos_app/constant.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({
    Key? key,
    required this.picFrom,
  }) : super(key: key);

  final String picFrom;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();
  late ImageBloc imageBloc;
  bool isFinish = false;

  ImageProvider provider = const ExtendedExactAssetImageProvider(
    'assets/noimage.jpg',
    cacheRawData: true,
  );

  // File? _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        provider = ExtendedFileImageProvider(File(pickedFile.path),
            cacheRawData: true);
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        provider = ExtendedFileImageProvider(File(pickedFile.path),
            cacheRawData: true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //Future.delayed(const Duration(seconds: 2), () {
    imageBloc = BlocProvider.of<ImageBloc>(context);
    if (widget.picFrom == 'gal') {
      getImageFromGallery();
    } else {
      getImageFromCamera();
    }
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        title: const Text(
          'Preview Page',
          style: TextStyle(color: textColor),
        ),
        actions: <Widget>[
          IconButton(
            color: textColor,
            icon: isFinish
                ? const CircularProgressIndicator()
                : const Icon(LineIcons.check),
            onPressed: () async {
              await crop();
              setState(() {
                isFinish = true;
              });
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.pop(context);
              });
            },
          ),
        ],
        leading: // Ensure Scaffold is in context
            IconButton(
                icon: const Icon(
                  LineIcons.angleLeft,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: buildImage(),
            ),
            const Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildFunctions(),
    );
  }

  Widget buildImage() {
    return ExtendedImage(
      image: provider,
      height: 400,
      width: 400,
      extendedImageEditorKey: editorKey,
      mode: ExtendedImageMode.editor,
      fit: BoxFit.contain,
      initEditorConfigHandler: (_) => EditorConfig(
        maxScale: 8.0,
        cropRectPadding: const EdgeInsets.all(20.0),
        hitTestSize: 20.0,
        cropAspectRatio: 1 / 1,
      ),
    );
  }

  Widget _buildFunctions() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.flip),
          label: 'Flip',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_left),
          label: 'Rotate left',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_right),
          label: 'Rotate right',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            flip();
            break;
          case 1:
            rotate(false);
            break;
          case 2:
            rotate(true);
            break;
        }
      },
      currentIndex: 0,
      selectedItemColor: primaryColor,
      unselectedItemColor: textColor,
    );
  }

  Future<void> crop([bool test = false]) async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) {
      return;
    }
    final Rect? rect = state.getCropRect();
    if (rect == null) {
      Fluttertoast.showToast(msg: 'The crop rect is null.');
      return;
    }
    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;

    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    // final img = await getImageFromEditorKey(editorKey);
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.outputFormat = const OutputFormat.png(88);

    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    if (result == null) return;

    imageBloc.add(GetImage(result));

    //showPreviewDialog(result);
  }

  void flip() {
    editorKey.currentState?.flip();
  }

  void rotate(bool right) {
    editorKey.currentState?.rotate(right: right);
  }
}
