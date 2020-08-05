import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/instance_provider.dart';
import '../utils/logger.dart';

abstract class BaseBlock<Event, State, T, P> extends Bloc<Event, State> {
  String get tag;

  T remoteRepository;
  P localRepository;

  ///this getter is for consistence with older versions
  T get repository => remoteRepository;

//  /// Returns the [state] before any `events` have been [add]ed.
//  State get initialState;

  BaseBlock(State initialState) : super(initialState) {
    remoteRepository = InstanceProvider.getInstance().provideRepository();
    localRepository = InstanceProvider.getInstance().provideLocalRepository();
  }

  @override
  void onTransition(Transition<Event, State> transition) {
    Log.i("$transition", "$tag transition");
    super.onTransition(transition);
  }
}
