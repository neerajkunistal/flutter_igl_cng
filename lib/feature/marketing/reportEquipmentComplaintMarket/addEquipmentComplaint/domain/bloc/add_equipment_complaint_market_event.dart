part of 'add_equipment_complaint_market_bloc.dart';


abstract class AddEquipmentComplaintMarketEvent extends Equatable {
  const AddEquipmentComplaintMarketEvent();
}

class AddEquipmentComplaintMarketPageLoadEvent extends AddEquipmentComplaintMarketEvent {
  final BuildContext context;
  final EquipmentComplaintType equipmentComplaintType;

  const AddEquipmentComplaintMarketPageLoadEvent({required this.context, required this.equipmentComplaintType});

  @override
  List<Object?> get props => [context, equipmentComplaintType];
}

class AddEquipmentComplaintMarketSelectComplaintDataEvent
    extends AddEquipmentComplaintMarketEvent {
  final ComplaintTypeModel complaintTypeData;

  const AddEquipmentComplaintMarketSelectComplaintDataEvent(
      {required this.complaintTypeData});

  @override
  List<Object?> get props => [complaintTypeData];
}

class AddEquipmentComplaintMarketSelectGeneralDataEvent
    extends AddEquipmentComplaintMarketEvent {
  final GeneralComplaintModel generalComplaintData;

  const AddEquipmentComplaintMarketSelectGeneralDataEvent(
      {required this.generalComplaintData});

  @override
  List<Object?> get props => [generalComplaintData];
}

class AddEquipmentComplaintMarketSelectDescriptionDataEvent
    extends AddEquipmentComplaintMarketEvent {
  final ComplaintDescriptionModel complaintDescriptionData;

  const AddEquipmentComplaintMarketSelectDescriptionDataEvent(
      {required this.complaintDescriptionData});

  @override
  List<Object?> get props => [complaintDescriptionData];
}

class AddEquipmentComplaintMarketSelectEquipmentTypeDataEvent
    extends AddEquipmentComplaintMarketEvent {
  final EquipmentTypeModel equipmentTypeData;

  const AddEquipmentComplaintMarketSelectEquipmentTypeDataEvent(
      {required this.equipmentTypeData});

  @override
  List<Object?> get props => [equipmentTypeData];
}

class AddEquipmentComplaintMarketSelectEquipmentDataEvent
    extends AddEquipmentComplaintMarketEvent {
  final EquipmentModel equipmentData;

  const AddEquipmentComplaintMarketSelectEquipmentDataEvent(
      {required this.equipmentData});

  @override
  List<Object?> get props => [equipmentData];
}

class AddEquipmentComplaintMarketAddImageEvent extends AddEquipmentComplaintMarketEvent {
  final BuildContext context;
  final int mediaType;
  final int index;

  const AddEquipmentComplaintMarketAddImageEvent(
      {required this.context, required this.mediaType, required this.index});

  @override
  List<Object?> get props => [context, mediaType, index];
}

class AddEquipmentComplaintMarketAddVideoEvent extends AddEquipmentComplaintMarketEvent {
  final BuildContext context;
  final int mediaType;
  final int index;

  const AddEquipmentComplaintMarketAddVideoEvent(
      {required this.context, required this.mediaType, required this.index});

  @override
  List<Object?> get props => [context, mediaType, index];
}

class AddEquipmentComplaintMarketRemoveImageEvent extends AddEquipmentComplaintMarketEvent {
  final int index;

  const AddEquipmentComplaintMarketRemoveImageEvent(
      { required this.index});

  @override
  List<Object?> get props => [index];
}

class AddEquipmentComplaintMarketRemoveVideoEvent extends AddEquipmentComplaintMarketEvent {
  final int index;

  const AddEquipmentComplaintMarketRemoveVideoEvent(
      { required this.index});

  @override
  List<Object?> get props => [index];
}

class AddEquipmentComplaintMarketSelectTimeData extends AddEquipmentComplaintMarketEvent {
  final BuildContext context;

  const AddEquipmentComplaintMarketSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddEquipmentComplaintMarketSelectDateData extends AddEquipmentComplaintMarketEvent {
  final BuildContext context;

  const AddEquipmentComplaintMarketSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddEquipmentComplaintMarketSubmitEvent extends AddEquipmentComplaintMarketEvent {
  final BuildContext context;

  const AddEquipmentComplaintMarketSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
class AddEquipmentComplaintMarketSelectFacilityDataEvent
    extends AddEquipmentComplaintMarketEvent {
  final FacilityModel facilityData;

  const AddEquipmentComplaintMarketSelectFacilityDataEvent(
      {required this.facilityData});

  @override
  List<Object?> get props => [facilityData];
}

class AddEquipmentComplaintMarketSelectCategoryDataEvent extends AddEquipmentComplaintMarketEvent {
  final MarketCategoryModel categoryData;

  const AddEquipmentComplaintMarketSelectCategoryDataEvent(
      {required this.categoryData});

  @override
  List<Object?> get props => [categoryData];
}

class AddEquipmentComplaintMarketSelectSubCategoryDataEvent extends AddEquipmentComplaintMarketEvent {
  final SubCategoryModel subCategoryData;

  const AddEquipmentComplaintMarketSelectSubCategoryDataEvent(
      {required this.subCategoryData});

  @override
  List<Object?> get props => [subCategoryData];
}