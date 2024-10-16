import 'package:demoadmin/model/userModel.dart';
import 'package:demoadmin/model/workerModel.dart';
import 'package:demoadmin/screens/appointmentScreen/appCityList.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/service/workerService.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/screens/appointmentScreen/showAppointmentByUidPage.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/service/assign_workers.dart';
import 'package:demoadmin/model/assign_task_model.dart';
import 'package:demoadmin/model/task_model.dart';
import 'package:demoadmin/service/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demoadmin/screens/worker/worker_atten_page.dart';

class UpdateWorkerPage extends StatefulWidget {
  final userDetails; //QueryDocumentSnapshot

  const UpdateWorkerPage({Key? key, this.userDetails}) : super(key: key);
  @override
  _UpdateWorkerPageState createState() => _UpdateWorkerPageState();
}

class _UpdateWorkerPageState extends State<UpdateWorkerPage> {
  bool _isLoading = false;
  String _imageUrl = "";
  // List<Asset> _images = <Asset>[];
  String _selectedGender = "";
  bool _isEnableBtn = true;
  var _dropdownValues;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _uIdController = TextEditingController();
  TextEditingController _cratedDateController = TextEditingController();
  TextEditingController _updatedDateController = TextEditingController();
  TextEditingController _taskTitleController = TextEditingController();
  ScrollController scrolCont=ScrollController();
  List<TaskModel> allTask=[];
  String clinicId="";
  String selctedAssignId="";



  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      _lastNameController.text = widget.userDetails.lastName;
      _firstNameController.text = widget.userDetails.firstName;
      _phoneNumberController.text = widget.userDetails.phone;
      _imageUrl = widget.userDetails.imageUrl;
      _uIdController.text = widget.userDetails.workerId;
      _cratedDateController.text = widget.userDetails.createdTimeStamp;
      _updatedDateController.text = widget.userDetails.updateTimeStamp;
      _selectedGender = widget.userDetails.gender;
    });
    getAllTask();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _uIdController.dispose();
    _cratedDateController.dispose();
    _updatedDateController.dispose();
    super.dispose();
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Update",
        "Are you sure you want to update profile details",
        _handleUpdate); //take a confirmation form the user
  }
  _takeConfirmationNewTask() {
    DialogBoxes.confirmationBox(
        context,
        "Assign",
        "Are you sure you want to assign new task",
        _handleAssignNewTask); //take a confirmation form the user
  }
  _takeConfirmationDeAssignTask() {
    DialogBoxes.confirmationBox(
        context,
        "Assign",
        "Are you sure you want to de-assign task",
        _handleAssignDeAssignTask); //take a confirmation form the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          onPressed: _takeConfirmation, // _handleUpdate,
          title: "Update",
        ),
        appBar: IAppBars.commonAppBar(context, "Edit Profile"),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
               Card(
                 child: ExpansionTile(title: const Text("Edit Profile",
                     style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.bold
                     )
                 ),
                 children: [
                   // if (_imageUrl == "")
                   //   if (_images.length == 0)
                   //     _circularIcon()
                   //   else
                   //     _profileImage()
                   // else
                   //   _profileImage(),
                   _inputField(
                       "First Name", "Enter first name", _firstNameController),
                   _inputField(
                       "Last Name", "Enter last name", _lastNameController),
                   _genderDropDown(),
                   _phnNumInputField(),
                   _readOnlyInputField("User Id", _uIdController),
                   _readOnlyInputField("Created at", _cratedDateController),
                   _readOnlyInputField("Last updated", _updatedDateController),
                 ],),
               ),
                Card(
                 child: ListTile(
                  title: const Text("Attendance History",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  trailing: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkerAttPage(
                            workerId: widget.userDetails.workerId,
                              workerName: _firstNameController.text+" "+_lastNameController.text,
                              clinciId: clinicId,

                            )),
                      );
                    },
                    icon: Icon(Icons.arrow_right),

              ),
               ),
                ),
              const Card(
                child: Padding(padding: EdgeInsets.all(20),
                child:   Text("Assign Task",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                ),
              ),
              Padding(padding: EdgeInsets.all(10),
              child:
                  Row(
                  children: [
                    taskDropDown(),
                    IconButton(onPressed: (){
                      addNewTask();
                    }, icon: Icon(Icons.add,color: Colors.green,))
                  ],
                  )
             ),

              FutureBuilder(
                  future: AssignService.getData(widget.userDetails.workerId,clinicId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.length == 0
                          ?
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("No Task Assign"),
                      )
                          : _buildUserList(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("");
                    } else {
                      return LoadingIndicatorWidget();
                    }
                  }),
            ],
          ),
        ));
  }

  _handleUpdate() {
    // if (_formKey.currentState!.validate()) {
    //   if (_selectedGender == "" || _selectedGender == "null") {
    //     ToastMsg.showToastMsg("Please select gender");
    //   } else {
    //     setState(() {
    //       _isEnableBtn = false;
    //       _isLoading = true;
    //     });
    //     if (_imageUrl == "" && _images.length == 0) {
    //       _updateDetails("");
    //     } else if (_imageUrl != "") {
    //       _updateDetails(_imageUrl);
    //     } else if (_imageUrl == "" && _images.length > 0) {
    //       _handleUploadImage();
    //     }
    //   } // _images.length > 0 ? _uploadImg() : _uploadNameAndDesc("");
    // }
  }
  _handleAssignNewTask() async{
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    //  print(">>>>>>>>>>>>>>>>>>>>>>${userModel.toUpdateJson()}");
    final res = await AssignService.assignTask(_dropdownValues,widget.userDetails.workerId);
    if(res=="already exists") {
      ToastMsg.showToastMsg("Task Already Assign");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }
  _handleAssignDeAssignTask() async{
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    print(">>>>>>>>>>>>>>>>>>>>>>$selctedAssignId");
    final res = await AssignService.deleteData(selctedAssignId);
    if(res=="already exists") {
      ToastMsg.showToastMsg("Task Already Assign");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }
  _handleAddNewTask(title) async{
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    final res = await TaskService.addData(_taskTitleController.text,clinicId);
    if(res=="already exists") {
      ToastMsg.showToastMsg("Task Already added");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      getAllTask();
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });

  }

  _updateDetails(imageDownloadUrl) async {
    final userModel = WorkerModel(
      workerId: widget.userDetails.workerId,
        imageUrl: imageDownloadUrl,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        gender: _selectedGender,
        phone: _phoneNumberController.text);
    //  print(">>>>>>>>>>>>>>>>>>>>>>${userModel.toUpdateJson()}");
    final res = await WorkerService.updateData(userModel);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/WorkerListPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  void _handleUploadImage() async {
    // final res = await UploadImageService.uploadImages(_images[0]);
    // if (res == "0") {
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // } else if (res == "1") {
    //   ToastMsg.showToastMsg("Image size must be less the 1MB");
    // } else if (res == "2") {
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // } else if (res == "3" || res == "error") {
    //   ToastMsg.showToastMsg("Something went wrong");
    // } else if (res == "" || res == "null") {
    //   ToastMsg.showToastMsg("Something went wrong");
    // } else {
    //   await _updateDetails(res);
    // }
    //
    // setState(() {
    //   _isEnableBtn = true;
    //   _isLoading = false;
    // });
  }



  Widget _readOnlyInputField(String labelText, controller) {
    return InputFields.readableInputField(controller, labelText, 1);
  }

  Widget _ageInputField(String labelText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      if (item.length > 0 && item.length <= 3) {
        return null;
      } else if (item.length > 3) {
        return "Enter valid age";
      } else {
        return "Enter age";
      }
    }, TextInputType.number, 1);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
  }

  Widget _phnNumInputField() {
    return InputFields.readableInputField(
        _phoneNumberController, "Mobile Number", 1);
  }

  Widget _profileImage() {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            // ClipOval(
            //     child: _imageUrl == ""
            //         ? AssetThumb(
            //       asset: _images[0],
            //       height: 150,
            //       width: 150,
            //     )
            //     //:Container()
            //         : ImageBoxFillWidget(imageUrl: _imageUrl)),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: _removeImage,
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );

    //   ClipRRect(
    //     borderRadius: //BorderRadius.circular(8.0),
    //     child:  Image.network( )
    // );
  }

  Widget _circularIcon() {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        child: GestureDetector(
          onTap: _handleImagePicker,
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.camera_enhance_rounded,
                size: 50, color: primaryColor),
          ),
        ),
      ),
    );
  }

  void _handleImagePicker() async {
    // final res = await ImagePicker.loadAssets(_images, mounted, 1);
    // // print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS" + "$res");
    //
    // setState(() {
    //   _images = res;
    // });
  }

  void _removeImage() {
    // setState(() {
    //   _images.clear();
    //   _imageUrl = "";
    // });
  }

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Male',
          'Female',
          'Other',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(
          "Gender",
        ),
        onChanged: (String? value) {
          setState(() {
            print(value);
            _selectedGender = value!;
          });
        },
      ),
    );
  }

  _buildUserList(data) {

    return ListView.builder(
      controller: scrolCont,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context,index){
        AssignTaskModel assignTaskModel=data[index];
        return
          Card(
            child: ListTile(
            title:   Text(assignTaskModel.title),
              trailing: IconButton(onPressed: (){
                selctedAssignId=assignTaskModel.id;
                _takeConfirmationDeAssignTask();
              }, icon: Icon(Icons.delete)),
        ),
          )

        ;});
  }

  taskDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: Colors.black.withOpacity(0.1),
            style: BorderStyle.solid,
            width: 0.80),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text("Select Task"),
          value: _dropdownValues,
          items: allTask
              .map((item) =>
              DropdownMenuItem(
                child: Text(item.title),
                value: item.id,
              ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _dropdownValues= value;
            });
            _takeConfirmationNewTask();



          },

        ),
      ),
    );
  }

  void getAllTask()async {
    setState(() {
      _isLoading=true;
    });
    SharedPreferences preferences=await SharedPreferences.getInstance();
    clinicId= preferences.getString("fdClinicId")??"";
    final res=await TaskService.getData(clinicId);
    if(res.isNotEmpty){
      allTask=res;
    }
    setState(() {
      _isLoading=false;
    });
  }

   addNewTask() {

    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Text("Add New Task"),
          content:   _inputField(
              "Task Title", "Enter task name", _taskTitleController),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text("OK"),
                onPressed: () {
                  if(_taskTitleController.text=='')
                    ToastMsg.showToastMsg("Please Enter Title");
                 else {
                    Navigator.of(context).pop();
                    _handleAddNewTask(_taskTitleController.text);
                  }
                }),
             ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: Text("Cancle"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }
}
