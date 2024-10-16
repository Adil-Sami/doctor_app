import 'dart:convert';
import 'dart:io' as File;
import 'package:demoadmin/screens/blogScreen/blogPostPage.dart';
import 'package:demoadmin/screens/blogScreen/editTitleThumbPage.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;
import 'package:light_html_editor/editor.dart';
import 'package:light_html_editor/html_editor_controller.dart';
import 'package:light_html_editor/placeholder.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../config.dart';
import '../../model/blogPostModel.dart';
import '../../service/blogPostService.dart';
import '../../utilities/colors.dart';
import '../../utilities/imagePicker.dart';
import '../../utilities/inputField.dart';
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
//total file modify due to depreacated package;
class EditBlogPostPage extends StatefulWidget {
  final blogPost;
  EditBlogPostPage({this.blogPost});

  @override
  _EditBlogPostPageState createState() => _EditBlogPostPageState();
}

class _EditBlogPostPageState extends State<EditBlogPostPage> {
  bool _isLoading = false;
  bool _isEnableBtn = true;
  // QuillController _controller = QuillController.basic();

  @override
  void initState() {


    // TODO: implement initState
    // _getDoc();
    super.initState();
    _controller.text = widget.blogPost.body;
    title.text = widget.blogPost.title.toString();
    // _controller.text = widget.blogPost.title.toString();
  }

  HtmlEditorController _controller = HtmlEditorController();

  TextEditingController title = TextEditingController();

  final List<String> items = [
    'Publish',
    'Draft',
  ];
  String? selectedValue;

  // List<Asset> _images = <Asset>[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Edit post"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          onPressed: () {
            // print(12);
            // print(widget.blogPost.id);
            // print(title.text);
            // print(widget.blogPost.thumbImageUrl);
            // print(selectedValue);
            // print(_controller.text);
            // print(DateTime.now());

            // _takeConfirmation(context);

            BlogPostModel model = BlogPostModel(
                id: widget.blogPost.id,
                title:title.text,
                thumbImageUrl: widget.blogPost.thumbImageUrl,
                status: selectedValue,
                body: _controller.text,
                updatedTimeStamp:DateTime.now(),
                createdTimeStamp: DateTime.now(),
                fileName: "no file name need at this time and change backend body filed value",
            );
            BlogPostService.updateData(model);
            Get.to(BlogPostPage());

          },
          title: "Next",
        ),
        body: _isLoading == true
            ? LoadingIndicatorWidget()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          // _onImagePickCallback();
                          _handleImagePicker();
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Image.network(widget.blogPost.thumbImageUrl.toString(),width: 180,height: 180,fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      InputFields.commonInputField(title, "Title",
                              (item) {
                            return null;
                          }, TextInputType.text, 1),
                      SizedBox(height: 10,),

                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: const [
                              Icon(
                                Icons.list,
                                size: 16,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            // print(selectedValue);
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Colors.grey[700],
                            ),
                            elevation: 2,
                          ),
                          iconStyleData:  IconStyleData(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: Colors.grey[100],
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: double.infinity,
                              padding: null,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.grey[500],
                              ),
                              elevation: 8,
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility: MaterialStateProperty.all(true),
                              )),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RichTextEditor(
                          autofocus: true,
                          showPreview: false,
                          controller: _controller,
                          initialValue: 'Enter Text of BlogPost ',
                          onChanged: (String html) {
                            html = _controller.text;
                            // do something with the richtext
                          },
                        ),
                      ),

                      /*QuillToolbar.basic(
                          controller: _controller,
                        embedButtons: FlutterQuillEmbeds.buttons(),
                      ),
                      Expanded(
                        child: Container(
                          child: QuillEditor.basic(
                            embedBuilders: FlutterQuillEmbeds.builders(),
                            controller: _controller,
                            readOnly: false, // true for view only mode
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ));
  }

  _takeConfirmation(context) {
    // if (_controller.document.length > 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => EditTitleThumbPage(
    //               document: _controller.document,
    //               blogPost: widget.blogPost,
    //             )),
    //   );
    // } else {
    //   ToastMsg.showToastMsg("Please write something");
    // }
  }

  void _getDoc() async {
    // print(widget.blogPost.body);

    setState(() {
      _isLoading = true;
    });
    final _viewUrl = widget.blogPost.body;
    final response = await http.get(Uri.parse(_viewUrl));

    // print(widget.blogPost.body);
    // print(response.body.toString());
    // print(response.statusCode.toString());
    if (response.statusCode == 200) {
      var myJSON = jsonDecode(response.body);
      setState(() {
        // _controller = QuillController(
        //     document: Document.fromJson(myJSON),
        //     selection: TextSelection.collapsed(offset: 0));
        _isLoading = false;
      });
    }
   // print("Data ${res[0].body}");
  }

  Future<String?> _onImagePickCallback(File.File file) async {
    setState(() {
      _isLoading = true;
    });
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    final imageUrl = await _uploadImg(copiedFile.path.toString());
    setState(() {
      _isLoading = false;
    });
    return imageUrl;
  }

  Future<String?> _uploadImg(imagePath) async {
    final res = await UploadImageService.uploadImagesPath(
        imagePath); //upload image in the database
    //all this error we have sated in the the php files
    if (res == "0") {
      ToastMsg.showToastMsg(
          "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
      return null;
    } else if (res == "1") {
      ToastMsg.showToastMsg("Image size must be less the 1MB");
      return null;
    } else if (res == "2") {
      ToastMsg.showToastMsg(
          "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
      return null;
    } else if (res == "3" || res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
      return null;
    } else if (res == "" || res == "null") {
      ToastMsg.showToastMsg("Something went wrong");
      return null;
    } else
      return res;
  }


  void _handleImagePicker() async {
    // print('asd');
    // final res = await ImagePicker.loadAssets(
    //     _images, mounted, 1);
    // _images = res;
    // final respone = await UploadImageService.uploadImages(_images[0]);
    // if (respone == "0")
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (respone == "1")
    //   ToastMsg.showToastMsg("Image size must be less the 1MB");
    // else if (respone == "2")
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (respone == "3" || respone == "error")
    //   ToastMsg.showToastMsg("Picture upload error");
    // else if (respone == "" || respone == "null")
    //   ToastMsg.showToastMsg("Picture upload error");
    // else {
    //   // await _updateDetails(res);
    //   await respone;
    //   widget.blogPost.thumbImageUrl = respone;
    // }
    // setState(() {
    //
    // });
    // // print("hassan");
    // // print(widget.blogPost.thumbImageUrl);
    // // print(respone);

  }
}
