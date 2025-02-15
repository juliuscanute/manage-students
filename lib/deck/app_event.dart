import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends AppEvent {
  final String parentPath;

  const LoadCategories(this.parentPath);

  @override
  List<Object> get props => [parentPath];
}

class RefreshCategories extends AppEvent {
  final String parentPath;

  const RefreshCategories(this.parentPath);

  @override
  List<Object> get props => [parentPath];
}
