// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SleepRecord _$SleepRecordFromJson(Map<String, dynamic> json) {
  return _SleepRecord.fromJson(json);
}

/// @nodoc
mixin _$SleepRecord {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  DateTime get bedtime => throw _privateConstructorUsedError;
  DateTime get wakeTime => throw _privateConstructorUsedError;
  int? get durationMinutes => throw _privateConstructorUsedError;
  int? get sleepQuality => throw _privateConstructorUsedError;
  int get deepSleepMinutes => throw _privateConstructorUsedError;
  int get lightSleepMinutes => throw _privateConstructorUsedError;
  int get remSleepMinutes => throw _privateConstructorUsedError;
  int get awakeMinutes => throw _privateConstructorUsedError;
  int? get avgHeartRate => throw _privateConstructorUsedError;
  int? get minHeartRate => throw _privateConstructorUsedError;
  double? get avgSpo2 => throw _privateConstructorUsedError;
  int get snoringMinutes => throw _privateConstructorUsedError;
  double? get roomTemperature => throw _privateConstructorUsedError;
  int? get roomHumidity => throw _privateConstructorUsedError;
  int? get noiseLevel => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get moodBeforeSleep => throw _privateConstructorUsedError;
  int? get moodAfterWake => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SleepRecordCopyWith<SleepRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepRecordCopyWith<$Res> {
  factory $SleepRecordCopyWith(
          SleepRecord value, $Res Function(SleepRecord) then) =
      _$SleepRecordCopyWithImpl<$Res, SleepRecord>;
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime date,
      DateTime bedtime,
      DateTime wakeTime,
      int? durationMinutes,
      int? sleepQuality,
      int deepSleepMinutes,
      int lightSleepMinutes,
      int remSleepMinutes,
      int awakeMinutes,
      int? avgHeartRate,
      int? minHeartRate,
      double? avgSpo2,
      int snoringMinutes,
      double? roomTemperature,
      int? roomHumidity,
      int? noiseLevel,
      String? notes,
      int? moodBeforeSleep,
      int? moodAfterWake,
      List<String>? tags,
      DateTime? createdAt});
}

/// @nodoc
class _$SleepRecordCopyWithImpl<$Res, $Val extends SleepRecord>
    implements $SleepRecordCopyWith<$Res> {
  _$SleepRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? bedtime = null,
    Object? wakeTime = null,
    Object? durationMinutes = freezed,
    Object? sleepQuality = freezed,
    Object? deepSleepMinutes = null,
    Object? lightSleepMinutes = null,
    Object? remSleepMinutes = null,
    Object? awakeMinutes = null,
    Object? avgHeartRate = freezed,
    Object? minHeartRate = freezed,
    Object? avgSpo2 = freezed,
    Object? snoringMinutes = null,
    Object? roomTemperature = freezed,
    Object? roomHumidity = freezed,
    Object? noiseLevel = freezed,
    Object? notes = freezed,
    Object? moodBeforeSleep = freezed,
    Object? moodAfterWake = freezed,
    Object? tags = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bedtime: null == bedtime
          ? _value.bedtime
          : bedtime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      wakeTime: null == wakeTime
          ? _value.wakeTime
          : wakeTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as int?,
      deepSleepMinutes: null == deepSleepMinutes
          ? _value.deepSleepMinutes
          : deepSleepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lightSleepMinutes: null == lightSleepMinutes
          ? _value.lightSleepMinutes
          : lightSleepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      remSleepMinutes: null == remSleepMinutes
          ? _value.remSleepMinutes
          : remSleepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      awakeMinutes: null == awakeMinutes
          ? _value.awakeMinutes
          : awakeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      avgHeartRate: freezed == avgHeartRate
          ? _value.avgHeartRate
          : avgHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      minHeartRate: freezed == minHeartRate
          ? _value.minHeartRate
          : minHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      avgSpo2: freezed == avgSpo2
          ? _value.avgSpo2
          : avgSpo2 // ignore: cast_nullable_to_non_nullable
              as double?,
      snoringMinutes: null == snoringMinutes
          ? _value.snoringMinutes
          : snoringMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      roomTemperature: freezed == roomTemperature
          ? _value.roomTemperature
          : roomTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      roomHumidity: freezed == roomHumidity
          ? _value.roomHumidity
          : roomHumidity // ignore: cast_nullable_to_non_nullable
              as int?,
      noiseLevel: freezed == noiseLevel
          ? _value.noiseLevel
          : noiseLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      moodBeforeSleep: freezed == moodBeforeSleep
          ? _value.moodBeforeSleep
          : moodBeforeSleep // ignore: cast_nullable_to_non_nullable
              as int?,
      moodAfterWake: freezed == moodAfterWake
          ? _value.moodAfterWake
          : moodAfterWake // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SleepRecordImplCopyWith<$Res>
    implements $SleepRecordCopyWith<$Res> {
  factory _$$SleepRecordImplCopyWith(
          _$SleepRecordImpl value, $Res Function(_$SleepRecordImpl) then) =
      __$$SleepRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime date,
      DateTime bedtime,
      DateTime wakeTime,
      int? durationMinutes,
      int? sleepQuality,
      int deepSleepMinutes,
      int lightSleepMinutes,
      int remSleepMinutes,
      int awakeMinutes,
      int? avgHeartRate,
      int? minHeartRate,
      double? avgSpo2,
      int snoringMinutes,
      double? roomTemperature,
      int? roomHumidity,
      int? noiseLevel,
      String? notes,
      int? moodBeforeSleep,
      int? moodAfterWake,
      List<String>? tags,
      DateTime? createdAt});
}

/// @nodoc
class __$$SleepRecordImplCopyWithImpl<$Res>
    extends _$SleepRecordCopyWithImpl<$Res, _$SleepRecordImpl>
    implements _$$SleepRecordImplCopyWith<$Res> {
  __$$SleepRecordImplCopyWithImpl(
      _$SleepRecordImpl _value, $Res Function(_$SleepRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? bedtime = null,
    Object? wakeTime = null,
    Object? durationMinutes = freezed,
    Object? sleepQuality = freezed,
    Object? deepSleepMinutes = null,
    Object? lightSleepMinutes = null,
    Object? remSleepMinutes = null,
    Object? awakeMinutes = null,
    Object? avgHeartRate = freezed,
    Object? minHeartRate = freezed,
    Object? avgSpo2 = freezed,
    Object? snoringMinutes = null,
    Object? roomTemperature = freezed,
    Object? roomHumidity = freezed,
    Object? noiseLevel = freezed,
    Object? notes = freezed,
    Object? moodBeforeSleep = freezed,
    Object? moodAfterWake = freezed,
    Object? tags = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SleepRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bedtime: null == bedtime
          ? _value.bedtime
          : bedtime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      wakeTime: null == wakeTime
          ? _value.wakeTime
          : wakeTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as int?,
      deepSleepMinutes: null == deepSleepMinutes
          ? _value.deepSleepMinutes
          : deepSleepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lightSleepMinutes: null == lightSleepMinutes
          ? _value.lightSleepMinutes
          : lightSleepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      remSleepMinutes: null == remSleepMinutes
          ? _value.remSleepMinutes
          : remSleepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      awakeMinutes: null == awakeMinutes
          ? _value.awakeMinutes
          : awakeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      avgHeartRate: freezed == avgHeartRate
          ? _value.avgHeartRate
          : avgHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      minHeartRate: freezed == minHeartRate
          ? _value.minHeartRate
          : minHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      avgSpo2: freezed == avgSpo2
          ? _value.avgSpo2
          : avgSpo2 // ignore: cast_nullable_to_non_nullable
              as double?,
      snoringMinutes: null == snoringMinutes
          ? _value.snoringMinutes
          : snoringMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      roomTemperature: freezed == roomTemperature
          ? _value.roomTemperature
          : roomTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      roomHumidity: freezed == roomHumidity
          ? _value.roomHumidity
          : roomHumidity // ignore: cast_nullable_to_non_nullable
              as int?,
      noiseLevel: freezed == noiseLevel
          ? _value.noiseLevel
          : noiseLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      moodBeforeSleep: freezed == moodBeforeSleep
          ? _value.moodBeforeSleep
          : moodBeforeSleep // ignore: cast_nullable_to_non_nullable
              as int?,
      moodAfterWake: freezed == moodAfterWake
          ? _value.moodAfterWake
          : moodAfterWake // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SleepRecordImpl extends _SleepRecord {
  const _$SleepRecordImpl(
      {required this.id,
      required this.userId,
      required this.date,
      required this.bedtime,
      required this.wakeTime,
      this.durationMinutes,
      this.sleepQuality,
      this.deepSleepMinutes = 0,
      this.lightSleepMinutes = 0,
      this.remSleepMinutes = 0,
      this.awakeMinutes = 0,
      this.avgHeartRate,
      this.minHeartRate,
      this.avgSpo2,
      this.snoringMinutes = 0,
      this.roomTemperature,
      this.roomHumidity,
      this.noiseLevel,
      this.notes,
      this.moodBeforeSleep,
      this.moodAfterWake,
      final List<String>? tags,
      this.createdAt})
      : _tags = tags,
        super._();

  factory _$SleepRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$SleepRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime date;
  @override
  final DateTime bedtime;
  @override
  final DateTime wakeTime;
  @override
  final int? durationMinutes;
  @override
  final int? sleepQuality;
  @override
  @JsonKey()
  final int deepSleepMinutes;
  @override
  @JsonKey()
  final int lightSleepMinutes;
  @override
  @JsonKey()
  final int remSleepMinutes;
  @override
  @JsonKey()
  final int awakeMinutes;
  @override
  final int? avgHeartRate;
  @override
  final int? minHeartRate;
  @override
  final double? avgSpo2;
  @override
  @JsonKey()
  final int snoringMinutes;
  @override
  final double? roomTemperature;
  @override
  final int? roomHumidity;
  @override
  final int? noiseLevel;
  @override
  final String? notes;
  @override
  final int? moodBeforeSleep;
  @override
  final int? moodAfterWake;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SleepRecord(id: $id, userId: $userId, date: $date, bedtime: $bedtime, wakeTime: $wakeTime, durationMinutes: $durationMinutes, sleepQuality: $sleepQuality, deepSleepMinutes: $deepSleepMinutes, lightSleepMinutes: $lightSleepMinutes, remSleepMinutes: $remSleepMinutes, awakeMinutes: $awakeMinutes, avgHeartRate: $avgHeartRate, minHeartRate: $minHeartRate, avgSpo2: $avgSpo2, snoringMinutes: $snoringMinutes, roomTemperature: $roomTemperature, roomHumidity: $roomHumidity, noiseLevel: $noiseLevel, notes: $notes, moodBeforeSleep: $moodBeforeSleep, moodAfterWake: $moodAfterWake, tags: $tags, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.bedtime, bedtime) || other.bedtime == bedtime) &&
            (identical(other.wakeTime, wakeTime) ||
                other.wakeTime == wakeTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.deepSleepMinutes, deepSleepMinutes) ||
                other.deepSleepMinutes == deepSleepMinutes) &&
            (identical(other.lightSleepMinutes, lightSleepMinutes) ||
                other.lightSleepMinutes == lightSleepMinutes) &&
            (identical(other.remSleepMinutes, remSleepMinutes) ||
                other.remSleepMinutes == remSleepMinutes) &&
            (identical(other.awakeMinutes, awakeMinutes) ||
                other.awakeMinutes == awakeMinutes) &&
            (identical(other.avgHeartRate, avgHeartRate) ||
                other.avgHeartRate == avgHeartRate) &&
            (identical(other.minHeartRate, minHeartRate) ||
                other.minHeartRate == minHeartRate) &&
            (identical(other.avgSpo2, avgSpo2) || other.avgSpo2 == avgSpo2) &&
            (identical(other.snoringMinutes, snoringMinutes) ||
                other.snoringMinutes == snoringMinutes) &&
            (identical(other.roomTemperature, roomTemperature) ||
                other.roomTemperature == roomTemperature) &&
            (identical(other.roomHumidity, roomHumidity) ||
                other.roomHumidity == roomHumidity) &&
            (identical(other.noiseLevel, noiseLevel) ||
                other.noiseLevel == noiseLevel) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.moodBeforeSleep, moodBeforeSleep) ||
                other.moodBeforeSleep == moodBeforeSleep) &&
            (identical(other.moodAfterWake, moodAfterWake) ||
                other.moodAfterWake == moodAfterWake) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        date,
        bedtime,
        wakeTime,
        durationMinutes,
        sleepQuality,
        deepSleepMinutes,
        lightSleepMinutes,
        remSleepMinutes,
        awakeMinutes,
        avgHeartRate,
        minHeartRate,
        avgSpo2,
        snoringMinutes,
        roomTemperature,
        roomHumidity,
        noiseLevel,
        notes,
        moodBeforeSleep,
        moodAfterWake,
        const DeepCollectionEquality().hash(_tags),
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepRecordImplCopyWith<_$SleepRecordImpl> get copyWith =>
      __$$SleepRecordImplCopyWithImpl<_$SleepRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepRecordImplToJson(
      this,
    );
  }
}

abstract class _SleepRecord extends SleepRecord {
  const factory _SleepRecord(
      {required final String id,
      required final String userId,
      required final DateTime date,
      required final DateTime bedtime,
      required final DateTime wakeTime,
      final int? durationMinutes,
      final int? sleepQuality,
      final int deepSleepMinutes,
      final int lightSleepMinutes,
      final int remSleepMinutes,
      final int awakeMinutes,
      final int? avgHeartRate,
      final int? minHeartRate,
      final double? avgSpo2,
      final int snoringMinutes,
      final double? roomTemperature,
      final int? roomHumidity,
      final int? noiseLevel,
      final String? notes,
      final int? moodBeforeSleep,
      final int? moodAfterWake,
      final List<String>? tags,
      final DateTime? createdAt}) = _$SleepRecordImpl;
  const _SleepRecord._() : super._();

  factory _SleepRecord.fromJson(Map<String, dynamic> json) =
      _$SleepRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get date;
  @override
  DateTime get bedtime;
  @override
  DateTime get wakeTime;
  @override
  int? get durationMinutes;
  @override
  int? get sleepQuality;
  @override
  int get deepSleepMinutes;
  @override
  int get lightSleepMinutes;
  @override
  int get remSleepMinutes;
  @override
  int get awakeMinutes;
  @override
  int? get avgHeartRate;
  @override
  int? get minHeartRate;
  @override
  double? get avgSpo2;
  @override
  int get snoringMinutes;
  @override
  double? get roomTemperature;
  @override
  int? get roomHumidity;
  @override
  int? get noiseLevel;
  @override
  String? get notes;
  @override
  int? get moodBeforeSleep;
  @override
  int? get moodAfterWake;
  @override
  List<String>? get tags;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SleepRecordImplCopyWith<_$SleepRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SleepStage _$SleepStageFromJson(Map<String, dynamic> json) {
  return _SleepStage.fromJson(json);
}

/// @nodoc
mixin _$SleepStage {
  String get id => throw _privateConstructorUsedError;
  String get sleepRecordId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get stage =>
      throw _privateConstructorUsedError; // awake, light, deep, rem
  int? get heartRate => throw _privateConstructorUsedError;
  double? get spo2 => throw _privateConstructorUsedError;
  int? get movementScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SleepStageCopyWith<SleepStage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepStageCopyWith<$Res> {
  factory $SleepStageCopyWith(
          SleepStage value, $Res Function(SleepStage) then) =
      _$SleepStageCopyWithImpl<$Res, SleepStage>;
  @useResult
  $Res call(
      {String id,
      String sleepRecordId,
      String userId,
      DateTime timestamp,
      String stage,
      int? heartRate,
      double? spo2,
      int? movementScore});
}

/// @nodoc
class _$SleepStageCopyWithImpl<$Res, $Val extends SleepStage>
    implements $SleepStageCopyWith<$Res> {
  _$SleepStageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sleepRecordId = null,
    Object? userId = null,
    Object? timestamp = null,
    Object? stage = null,
    Object? heartRate = freezed,
    Object? spo2 = freezed,
    Object? movementScore = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sleepRecordId: null == sleepRecordId
          ? _value.sleepRecordId
          : sleepRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      heartRate: freezed == heartRate
          ? _value.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      spo2: freezed == spo2
          ? _value.spo2
          : spo2 // ignore: cast_nullable_to_non_nullable
              as double?,
      movementScore: freezed == movementScore
          ? _value.movementScore
          : movementScore // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SleepStageImplCopyWith<$Res>
    implements $SleepStageCopyWith<$Res> {
  factory _$$SleepStageImplCopyWith(
          _$SleepStageImpl value, $Res Function(_$SleepStageImpl) then) =
      __$$SleepStageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sleepRecordId,
      String userId,
      DateTime timestamp,
      String stage,
      int? heartRate,
      double? spo2,
      int? movementScore});
}

/// @nodoc
class __$$SleepStageImplCopyWithImpl<$Res>
    extends _$SleepStageCopyWithImpl<$Res, _$SleepStageImpl>
    implements _$$SleepStageImplCopyWith<$Res> {
  __$$SleepStageImplCopyWithImpl(
      _$SleepStageImpl _value, $Res Function(_$SleepStageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sleepRecordId = null,
    Object? userId = null,
    Object? timestamp = null,
    Object? stage = null,
    Object? heartRate = freezed,
    Object? spo2 = freezed,
    Object? movementScore = freezed,
  }) {
    return _then(_$SleepStageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sleepRecordId: null == sleepRecordId
          ? _value.sleepRecordId
          : sleepRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      heartRate: freezed == heartRate
          ? _value.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      spo2: freezed == spo2
          ? _value.spo2
          : spo2 // ignore: cast_nullable_to_non_nullable
              as double?,
      movementScore: freezed == movementScore
          ? _value.movementScore
          : movementScore // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SleepStageImpl implements _SleepStage {
  const _$SleepStageImpl(
      {required this.id,
      required this.sleepRecordId,
      required this.userId,
      required this.timestamp,
      required this.stage,
      this.heartRate,
      this.spo2,
      this.movementScore});

  factory _$SleepStageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SleepStageImplFromJson(json);

  @override
  final String id;
  @override
  final String sleepRecordId;
  @override
  final String userId;
  @override
  final DateTime timestamp;
  @override
  final String stage;
// awake, light, deep, rem
  @override
  final int? heartRate;
  @override
  final double? spo2;
  @override
  final int? movementScore;

  @override
  String toString() {
    return 'SleepStage(id: $id, sleepRecordId: $sleepRecordId, userId: $userId, timestamp: $timestamp, stage: $stage, heartRate: $heartRate, spo2: $spo2, movementScore: $movementScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepStageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sleepRecordId, sleepRecordId) ||
                other.sleepRecordId == sleepRecordId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.spo2, spo2) || other.spo2 == spo2) &&
            (identical(other.movementScore, movementScore) ||
                other.movementScore == movementScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, sleepRecordId, userId,
      timestamp, stage, heartRate, spo2, movementScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepStageImplCopyWith<_$SleepStageImpl> get copyWith =>
      __$$SleepStageImplCopyWithImpl<_$SleepStageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepStageImplToJson(
      this,
    );
  }
}

abstract class _SleepStage implements SleepStage {
  const factory _SleepStage(
      {required final String id,
      required final String sleepRecordId,
      required final String userId,
      required final DateTime timestamp,
      required final String stage,
      final int? heartRate,
      final double? spo2,
      final int? movementScore}) = _$SleepStageImpl;

  factory _SleepStage.fromJson(Map<String, dynamic> json) =
      _$SleepStageImpl.fromJson;

  @override
  String get id;
  @override
  String get sleepRecordId;
  @override
  String get userId;
  @override
  DateTime get timestamp;
  @override
  String get stage;
  @override // awake, light, deep, rem
  int? get heartRate;
  @override
  double? get spo2;
  @override
  int? get movementScore;
  @override
  @JsonKey(ignore: true)
  _$$SleepStageImplCopyWith<_$SleepStageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SleepInsight _$SleepInsightFromJson(Map<String, dynamic> json) {
  return _SleepInsight.fromJson(json);
}

/// @nodoc
mixin _$SleepInsight {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get insightType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SleepInsightCopyWith<SleepInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepInsightCopyWith<$Res> {
  factory $SleepInsightCopyWith(
          SleepInsight value, $Res Function(SleepInsight) then) =
      _$SleepInsightCopyWithImpl<$Res, SleepInsight>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String insightType,
      String title,
      String content,
      Map<String, dynamic>? data,
      bool isRead,
      DateTime generatedAt});
}

/// @nodoc
class _$SleepInsightCopyWithImpl<$Res, $Val extends SleepInsight>
    implements $SleepInsightCopyWith<$Res> {
  _$SleepInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? insightType = null,
    Object? title = null,
    Object? content = null,
    Object? data = freezed,
    Object? isRead = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      insightType: null == insightType
          ? _value.insightType
          : insightType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SleepInsightImplCopyWith<$Res>
    implements $SleepInsightCopyWith<$Res> {
  factory _$$SleepInsightImplCopyWith(
          _$SleepInsightImpl value, $Res Function(_$SleepInsightImpl) then) =
      __$$SleepInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String insightType,
      String title,
      String content,
      Map<String, dynamic>? data,
      bool isRead,
      DateTime generatedAt});
}

/// @nodoc
class __$$SleepInsightImplCopyWithImpl<$Res>
    extends _$SleepInsightCopyWithImpl<$Res, _$SleepInsightImpl>
    implements _$$SleepInsightImplCopyWith<$Res> {
  __$$SleepInsightImplCopyWithImpl(
      _$SleepInsightImpl _value, $Res Function(_$SleepInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? insightType = null,
    Object? title = null,
    Object? content = null,
    Object? data = freezed,
    Object? isRead = null,
    Object? generatedAt = null,
  }) {
    return _then(_$SleepInsightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      insightType: null == insightType
          ? _value.insightType
          : insightType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SleepInsightImpl implements _SleepInsight {
  const _$SleepInsightImpl(
      {required this.id,
      required this.userId,
      required this.insightType,
      required this.title,
      required this.content,
      final Map<String, dynamic>? data,
      this.isRead = false,
      required this.generatedAt})
      : _data = data;

  factory _$SleepInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$SleepInsightImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String insightType;
  @override
  final String title;
  @override
  final String content;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'SleepInsight(id: $id, userId: $userId, insightType: $insightType, title: $title, content: $content, data: $data, isRead: $isRead, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.insightType, insightType) ||
                other.insightType == insightType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, insightType, title,
      content, const DeepCollectionEquality().hash(_data), isRead, generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepInsightImplCopyWith<_$SleepInsightImpl> get copyWith =>
      __$$SleepInsightImplCopyWithImpl<_$SleepInsightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepInsightImplToJson(
      this,
    );
  }
}

abstract class _SleepInsight implements SleepInsight {
  const factory _SleepInsight(
      {required final String id,
      required final String userId,
      required final String insightType,
      required final String title,
      required final String content,
      final Map<String, dynamic>? data,
      final bool isRead,
      required final DateTime generatedAt}) = _$SleepInsightImpl;

  factory _SleepInsight.fromJson(Map<String, dynamic> json) =
      _$SleepInsightImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get insightType;
  @override
  String get title;
  @override
  String get content;
  @override
  Map<String, dynamic>? get data;
  @override
  bool get isRead;
  @override
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SleepInsightImplCopyWith<_$SleepInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklySleepStats _$WeeklySleepStatsFromJson(Map<String, dynamic> json) {
  return _WeeklySleepStats.fromJson(json);
}

/// @nodoc
mixin _$WeeklySleepStats {
  String get userId => throw _privateConstructorUsedError;
  DateTime get weekStart => throw _privateConstructorUsedError;
  int get nightsTracked => throw _privateConstructorUsedError;
  double get avgHours => throw _privateConstructorUsedError;
  double get avgQuality => throw _privateConstructorUsedError;
  double get avgDeepSleepMin => throw _privateConstructorUsedError;
  double get avgRemMin => throw _privateConstructorUsedError;
  int? get avgHeartRate => throw _privateConstructorUsedError;
  double? get avgSpo2 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklySleepStatsCopyWith<WeeklySleepStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklySleepStatsCopyWith<$Res> {
  factory $WeeklySleepStatsCopyWith(
          WeeklySleepStats value, $Res Function(WeeklySleepStats) then) =
      _$WeeklySleepStatsCopyWithImpl<$Res, WeeklySleepStats>;
  @useResult
  $Res call(
      {String userId,
      DateTime weekStart,
      int nightsTracked,
      double avgHours,
      double avgQuality,
      double avgDeepSleepMin,
      double avgRemMin,
      int? avgHeartRate,
      double? avgSpo2});
}

/// @nodoc
class _$WeeklySleepStatsCopyWithImpl<$Res, $Val extends WeeklySleepStats>
    implements $WeeklySleepStatsCopyWith<$Res> {
  _$WeeklySleepStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? weekStart = null,
    Object? nightsTracked = null,
    Object? avgHours = null,
    Object? avgQuality = null,
    Object? avgDeepSleepMin = null,
    Object? avgRemMin = null,
    Object? avgHeartRate = freezed,
    Object? avgSpo2 = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nightsTracked: null == nightsTracked
          ? _value.nightsTracked
          : nightsTracked // ignore: cast_nullable_to_non_nullable
              as int,
      avgHours: null == avgHours
          ? _value.avgHours
          : avgHours // ignore: cast_nullable_to_non_nullable
              as double,
      avgQuality: null == avgQuality
          ? _value.avgQuality
          : avgQuality // ignore: cast_nullable_to_non_nullable
              as double,
      avgDeepSleepMin: null == avgDeepSleepMin
          ? _value.avgDeepSleepMin
          : avgDeepSleepMin // ignore: cast_nullable_to_non_nullable
              as double,
      avgRemMin: null == avgRemMin
          ? _value.avgRemMin
          : avgRemMin // ignore: cast_nullable_to_non_nullable
              as double,
      avgHeartRate: freezed == avgHeartRate
          ? _value.avgHeartRate
          : avgHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      avgSpo2: freezed == avgSpo2
          ? _value.avgSpo2
          : avgSpo2 // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklySleepStatsImplCopyWith<$Res>
    implements $WeeklySleepStatsCopyWith<$Res> {
  factory _$$WeeklySleepStatsImplCopyWith(_$WeeklySleepStatsImpl value,
          $Res Function(_$WeeklySleepStatsImpl) then) =
      __$$WeeklySleepStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      DateTime weekStart,
      int nightsTracked,
      double avgHours,
      double avgQuality,
      double avgDeepSleepMin,
      double avgRemMin,
      int? avgHeartRate,
      double? avgSpo2});
}

/// @nodoc
class __$$WeeklySleepStatsImplCopyWithImpl<$Res>
    extends _$WeeklySleepStatsCopyWithImpl<$Res, _$WeeklySleepStatsImpl>
    implements _$$WeeklySleepStatsImplCopyWith<$Res> {
  __$$WeeklySleepStatsImplCopyWithImpl(_$WeeklySleepStatsImpl _value,
      $Res Function(_$WeeklySleepStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? weekStart = null,
    Object? nightsTracked = null,
    Object? avgHours = null,
    Object? avgQuality = null,
    Object? avgDeepSleepMin = null,
    Object? avgRemMin = null,
    Object? avgHeartRate = freezed,
    Object? avgSpo2 = freezed,
  }) {
    return _then(_$WeeklySleepStatsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nightsTracked: null == nightsTracked
          ? _value.nightsTracked
          : nightsTracked // ignore: cast_nullable_to_non_nullable
              as int,
      avgHours: null == avgHours
          ? _value.avgHours
          : avgHours // ignore: cast_nullable_to_non_nullable
              as double,
      avgQuality: null == avgQuality
          ? _value.avgQuality
          : avgQuality // ignore: cast_nullable_to_non_nullable
              as double,
      avgDeepSleepMin: null == avgDeepSleepMin
          ? _value.avgDeepSleepMin
          : avgDeepSleepMin // ignore: cast_nullable_to_non_nullable
              as double,
      avgRemMin: null == avgRemMin
          ? _value.avgRemMin
          : avgRemMin // ignore: cast_nullable_to_non_nullable
              as double,
      avgHeartRate: freezed == avgHeartRate
          ? _value.avgHeartRate
          : avgHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      avgSpo2: freezed == avgSpo2
          ? _value.avgSpo2
          : avgSpo2 // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklySleepStatsImpl implements _WeeklySleepStats {
  const _$WeeklySleepStatsImpl(
      {required this.userId,
      required this.weekStart,
      required this.nightsTracked,
      required this.avgHours,
      required this.avgQuality,
      required this.avgDeepSleepMin,
      required this.avgRemMin,
      this.avgHeartRate,
      this.avgSpo2});

  factory _$WeeklySleepStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklySleepStatsImplFromJson(json);

  @override
  final String userId;
  @override
  final DateTime weekStart;
  @override
  final int nightsTracked;
  @override
  final double avgHours;
  @override
  final double avgQuality;
  @override
  final double avgDeepSleepMin;
  @override
  final double avgRemMin;
  @override
  final int? avgHeartRate;
  @override
  final double? avgSpo2;

  @override
  String toString() {
    return 'WeeklySleepStats(userId: $userId, weekStart: $weekStart, nightsTracked: $nightsTracked, avgHours: $avgHours, avgQuality: $avgQuality, avgDeepSleepMin: $avgDeepSleepMin, avgRemMin: $avgRemMin, avgHeartRate: $avgHeartRate, avgSpo2: $avgSpo2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklySleepStatsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.nightsTracked, nightsTracked) ||
                other.nightsTracked == nightsTracked) &&
            (identical(other.avgHours, avgHours) ||
                other.avgHours == avgHours) &&
            (identical(other.avgQuality, avgQuality) ||
                other.avgQuality == avgQuality) &&
            (identical(other.avgDeepSleepMin, avgDeepSleepMin) ||
                other.avgDeepSleepMin == avgDeepSleepMin) &&
            (identical(other.avgRemMin, avgRemMin) ||
                other.avgRemMin == avgRemMin) &&
            (identical(other.avgHeartRate, avgHeartRate) ||
                other.avgHeartRate == avgHeartRate) &&
            (identical(other.avgSpo2, avgSpo2) || other.avgSpo2 == avgSpo2));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, weekStart, nightsTracked,
      avgHours, avgQuality, avgDeepSleepMin, avgRemMin, avgHeartRate, avgSpo2);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklySleepStatsImplCopyWith<_$WeeklySleepStatsImpl> get copyWith =>
      __$$WeeklySleepStatsImplCopyWithImpl<_$WeeklySleepStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklySleepStatsImplToJson(
      this,
    );
  }
}

abstract class _WeeklySleepStats implements WeeklySleepStats {
  const factory _WeeklySleepStats(
      {required final String userId,
      required final DateTime weekStart,
      required final int nightsTracked,
      required final double avgHours,
      required final double avgQuality,
      required final double avgDeepSleepMin,
      required final double avgRemMin,
      final int? avgHeartRate,
      final double? avgSpo2}) = _$WeeklySleepStatsImpl;

  factory _WeeklySleepStats.fromJson(Map<String, dynamic> json) =
      _$WeeklySleepStatsImpl.fromJson;

  @override
  String get userId;
  @override
  DateTime get weekStart;
  @override
  int get nightsTracked;
  @override
  double get avgHours;
  @override
  double get avgQuality;
  @override
  double get avgDeepSleepMin;
  @override
  double get avgRemMin;
  @override
  int? get avgHeartRate;
  @override
  double? get avgSpo2;
  @override
  @JsonKey(ignore: true)
  _$$WeeklySleepStatsImplCopyWith<_$WeeklySleepStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
