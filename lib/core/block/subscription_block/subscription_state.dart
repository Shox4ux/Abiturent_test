part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class OnScriptProgress extends SubscriptionState {}

class OnScriptMade extends SubscriptionState {
  final ScriptPreview preview;
  const OnScriptMade(this.preview);
  @override
  List<Object> get props => [preview];
}

class OnReceivedScript extends SubscriptionState {
  final List<SubscriptionModel> scriptList;

  const OnReceivedScript(this.scriptList);
  @override
  List<Object> get props => [scriptList];
}

class OnSubscriptionPreview extends SubscriptionState {
  final ScriptPreview preview;

  const OnSubscriptionPreview(this.preview);
  @override
  List<Object> get props => [preview];
}

class OnScriptError extends SubscriptionState {
  final String error;
  const OnScriptError(this.error);
  @override
  List<Object> get props => [error];
}
