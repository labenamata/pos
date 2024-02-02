import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/bahan_model.dart';

part 'bahan_event.dart';
part 'bahan_repo.dart';
part 'bahan_state.dart';

class BahanBloc extends Bloc<BahanEvent, BahanState> {
  BahanBloc(BahanState initialState) : super(initialState) {
    on<GetBahan>(_getBahan);
    on<SearchBahan>(_searchBahan);
    on<TambahBahan>(_tambahBahan);
    on<HapusBahan>(_hapusBahan);
  }
}
