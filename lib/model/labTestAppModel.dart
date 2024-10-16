class LabTestAppModel{
  var id;
  var uid;
  var status;
  var labTestId;
  var paymentId;
  var paymentAmount;
  var createdTimeStamp;
  var deleted;
  var testName;
  var subTitle;
  var pName;
  var pPhn;
  var pEmail;
  var pAge;
  var pCity;
  var pDesc;
  var pGender;
  var serviceName;
  var pymentStatus;
  var clinicID;
  var clinicName;

  LabTestAppModel({
    this.paymentId,
    this.uid,
    this.id,
    this.status,
    this.paymentAmount,
    this.createdTimeStamp,
    this.deleted,
    this.labTestId,
    this.subTitle,
    this.testName,
    this.pAge,
    this.pCity,
    this.pDesc,
    this.pEmail,
    this.pGender,
    this.pName,
    this.pPhn,
    this.pymentStatus,
    this.serviceName,
    this.clinicID,
    this.clinicName
  });

  factory LabTestAppModel.fromJson(Map<String,dynamic> json){
    return LabTestAppModel(
        uid:json['uid'],
        id:json['id'].toString(),
        status: json['status'],
        labTestId: json['lab_test_id'].toString(),
        createdTimeStamp:json['created_time_stamp'],
        paymentId: json['payment_id'],
        paymentAmount: json['payment_amount'],
        subTitle: json['subTitle'],
        testName: json['test_name'],
        pymentStatus:json['pStatus'] ,
        pAge: json['pAge'],
        pCity: json['pCity'],
        pDesc: json['pDesc'],
        pEmail: "",
        pGender: json['pGender'],
        pName: json['pName'],
        pPhn:json['pPhn'],
        serviceName: json['test_name'],
        clinicID: json['clinic_id'].toString(),
      clinicName: json['title']

    );
  }
  Map<String,dynamic> toJsonUpdate(){
    return {
      "id":this.id.toString(),
      "status":this.status
    };
  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "uid":this.uid,
      "status":this.status,
      "lab_test_id":this.labTestId,
      "pName":this.pName,
      "pPhn":this.pPhn,
      "pAge":this.pAge,
      "pGender":this.pGender,
      "pCity":this.pCity,
      "pDesc":this.pDesc,
      "pStatus":this.pymentStatus,
      "payment_id":this.paymentId,
      "payment_amount":this.paymentAmount,
    };

  }
}