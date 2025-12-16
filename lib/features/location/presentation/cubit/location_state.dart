import 'package:dakna/features/location/data/models/address_model.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationNotSelected extends LocationState {}

class LocationSelected extends LocationState {
  final AddressModel address;
  LocationSelected(this.address);
}
