
class DoctorTimeSlotModel{
  var tsId;
  var timeSlot;
  var dayCode;
  var doctId;
  var slotType;


  DoctorTimeSlotModel({
 this.dayCode,
    this.timeSlot,
    this.tsId,
    this.doctId,
    this.slotType

  });
  factory DoctorTimeSlotModel.fromJson(Map<String, dynamic> json){
    return DoctorTimeSlotModel(
      dayCode: json['day_code'],
      timeSlot: json['time_slot'],
      tsId: json['id'].toString(),
      doctId: json['doct_id'],
      slotType: json['slot_type']
    );
  }


}