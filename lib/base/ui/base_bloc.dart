import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/instance_provider.dart';
import '../utils/logger.dart';

abstract class BaseBloc<Event, State, T, P> extends Bloc<Event, State> {
  String get tag;

  T? remoteRepository;
  P? localRepository;

  @Deprecated('this getter is for consistence with older versions')
  T? get repository => remoteRepository;

//  /// Returns the [state] before any `events` have been [add]ed.
//  State get initialState;

  BaseBloc(State initialState) : super(initialState) {
    remoteRepository = InstanceProvider.getInstance()?.provideRepository();
    localRepository = InstanceProvider.getInstance()?.provideLocalRepository();
  }

  @override
  void onTransition(Transition<Event, State> transition) {
    Log.i("New transition", "$tag");
    Log.i("${transition.currentState}", "$tag currentState");
    Log.i("${transition.event}", "$tag event");
    Log.i("${transition.nextState}", "$tag nextState");
  }
}
