import 'package:demoadmin/model/videoModel.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/service/videoService.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';

class AddVideoPage extends StatefulWidget {
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // List<Asset> _images = <Asset>[];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _videoUrlController = TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add Video"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? Center(child: LoadingIndicatorWidget())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    // _images.length == 0
                    //     ? CircularCameraIconWidget(onTap: _handleImagePicker)
                    //     : CircularImageWidget(
                    //         images: _images,
                    //         onPressed: _removeImage,
                    //       ),
                    _titleInputField(),
                    _videoUrlInputField(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _titleInputField() {
    return InputFields.commonInputField(_titleController, "Title*", (item) {
      return item.length > 0 ? null : "Enter video name";
    }, TextInputType.text, 1);
  }

  Widget _videoUrlInputField() {
    return InputFields.commonInputField(_videoUrlController, "Video Url*",
        (item) {
      return item.length > 0 ? null : "Enter video url";
    }, TextInputType.text, 1);
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Add Video",
          "Are you sure want to add new video",
          _handleUpload); //take a confirmation from the user
    }
  }

  void _handleImagePicker() async {
    // final res = await ImagePicker.loadAssets(
    //     _images, mounted, 1); //pick image with one limit
    // setState(() {
    //   _images = res;
    // });
  }

  _handleUpload() {
    // setState(() {
    //   _isEnableBtn = false;
    //   _isLoading = true;
    // });
    // _images.length > 0
    //     ? _uploadImg()
    //     : _uploadData(""); //check user selected image or not
  }

  void _removeImage() {
    // setState(() {
    //   _images.clear(); //clean array
    // });
  }

  _uploadData(imageDownloadUrl) async {
    final videoModel = VideoModel(
      title: _titleController.text,
      videoUrl: _videoUrlController.text,
      imageUrl: imageDownloadUrl,
    );
    final res = await VideoService.addData(
        videoModel); //upload data with all required details
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Uploaded");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/VideoListPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      ToastMsg.showToastMsg('Something went wrong');
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _uploadImg() async {
    // final res = await UploadImageService.uploadImages(
    //     _images[0]); //upload image in the database
    // //all this error we have sated in the the php files
    // if (res == "0")
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (res == "1")
    //   ToastMsg.showToastMsg("Image size must be less the 1MB");
    // else if (res == "2")
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (res == "3" || res == "error")
    //   ToastMsg.showToastMsg("Something went wrong");
    // else if (res == "" || res == "null")
    //   ToastMsg.showToastMsg("Something went wrong");
    // else
    //   await _uploadData(res);
    //
    // setState(() {
    //   setState(() {
    //     _isEnableBtn = true;
    //     _isLoading = false;
    //   });
    // });
  }
}
