import 'dart:convert';

import 'package:dakna/core/cache/cache_helper.dart';
import 'package:dakna/core/cache/chache_keys.dart';
import 'package:dakna/features/location/data/models/address_model.dart';
import 'package:dakna/features/location/presentation/cubit/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  void checkSavedLocation() {
    final address = CacheHelper.getData(key:CacheKeys.deliveryLocationKey);
    if (address == null) {
      emit(LocationNotSelected());
    } else {
      emit(LocationSelected(AddressModel.fromJson(json.decode(address))));
    }
  }

  void selectLocation(AddressModel address) {
    CacheHelper.saveData(value:json.encode(address.toJson()) , key: CacheKeys.deliveryLocationKey);
    emit(LocationSelected(address));
  }
}
