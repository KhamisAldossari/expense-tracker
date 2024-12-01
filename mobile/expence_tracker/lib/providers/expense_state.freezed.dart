// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseFilterState {
  String? get category => throw _privateConstructorUsedError;
  String? get sortBy => throw _privateConstructorUsedError;
  String? get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseFilterStateCopyWith<ExpenseFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseFilterStateCopyWith<$Res> {
  factory $ExpenseFilterStateCopyWith(
          ExpenseFilterState value, $Res Function(ExpenseFilterState) then) =
      _$ExpenseFilterStateCopyWithImpl<$Res, ExpenseFilterState>;
  @useResult
  $Res call({String? category, String? sortBy, String? sortOrder});
}

/// @nodoc
class _$ExpenseFilterStateCopyWithImpl<$Res, $Val extends ExpenseFilterState>
    implements $ExpenseFilterStateCopyWith<$Res> {
  _$ExpenseFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? sortBy = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseFilterStateImplCopyWith<$Res>
    implements $ExpenseFilterStateCopyWith<$Res> {
  factory _$$ExpenseFilterStateImplCopyWith(_$ExpenseFilterStateImpl value,
          $Res Function(_$ExpenseFilterStateImpl) then) =
      __$$ExpenseFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? category, String? sortBy, String? sortOrder});
}

/// @nodoc
class __$$ExpenseFilterStateImplCopyWithImpl<$Res>
    extends _$ExpenseFilterStateCopyWithImpl<$Res, _$ExpenseFilterStateImpl>
    implements _$$ExpenseFilterStateImplCopyWith<$Res> {
  __$$ExpenseFilterStateImplCopyWithImpl(_$ExpenseFilterStateImpl _value,
      $Res Function(_$ExpenseFilterStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? sortBy = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$ExpenseFilterStateImpl(
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ExpenseFilterStateImpl extends _ExpenseFilterState {
  const _$ExpenseFilterStateImpl({this.category, this.sortBy, this.sortOrder})
      : super._();

  @override
  final String? category;
  @override
  final String? sortBy;
  @override
  final String? sortOrder;

  @override
  String toString() {
    return 'ExpenseFilterState(category: $category, sortBy: $sortBy, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseFilterStateImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, sortBy, sortOrder);

  /// Create a copy of ExpenseFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseFilterStateImplCopyWith<_$ExpenseFilterStateImpl> get copyWith =>
      __$$ExpenseFilterStateImplCopyWithImpl<_$ExpenseFilterStateImpl>(
          this, _$identity);
}

abstract class _ExpenseFilterState extends ExpenseFilterState {
  const factory _ExpenseFilterState(
      {final String? category,
      final String? sortBy,
      final String? sortOrder}) = _$ExpenseFilterStateImpl;
  const _ExpenseFilterState._() : super._();

  @override
  String? get category;
  @override
  String? get sortBy;
  @override
  String? get sortOrder;

  /// Create a copy of ExpenseFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseFilterStateImplCopyWith<_$ExpenseFilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
