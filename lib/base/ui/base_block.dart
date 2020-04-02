import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/instance_provider.dart';
import '../utils/logger.dart';

abstract class BaseBlock<Event, State, T> extends Bloc<Event, State> {
  String get tag;

  T repository;

  BaseBlock() : super() {
    repository = InstanceProvider.getInstance().provideRepository();
  }

  @override
  void onTransition(Transition<Event, State> transition) {
    Log.i("$transition", "$tag transition");
  }
}
