// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'model.dart';

class BlogRecordMapper extends ClassMapperBase<BlogRecord> {
  BlogRecordMapper._();

  static BlogRecordMapper? _instance;
  static BlogRecordMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BlogRecordMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BlogRecord';

  static String _$id(BlogRecord v) => v.id;
  static const Field<BlogRecord, String> _f$id = Field('id', _$id);
  static String _$authorName(BlogRecord v) => v.authorName;
  static const Field<BlogRecord, String> _f$authorName =
      Field('authorName', _$authorName);
  static String _$title(BlogRecord v) => v.title;
  static const Field<BlogRecord, String> _f$title = Field('title', _$title);
  static String _$content(BlogRecord v) => v.content;
  static const Field<BlogRecord, String> _f$content =
      Field('content', _$content);
  static DateTime _$created(BlogRecord v) => v.created;
  static const Field<BlogRecord, DateTime> _f$created =
      Field('created', _$created);
  static DateTime? _$updated(BlogRecord v) => v.updated;
  static const Field<BlogRecord, DateTime> _f$updated =
      Field('updated', _$updated);

  @override
  final MappableFields<BlogRecord> fields = const {
    #id: _f$id,
    #authorName: _f$authorName,
    #title: _f$title,
    #content: _f$content,
    #created: _f$created,
    #updated: _f$updated,
  };

  static BlogRecord _instantiate(DecodingData data) {
    return BlogRecord(
        id: data.dec(_f$id),
        authorName: data.dec(_f$authorName),
        title: data.dec(_f$title),
        content: data.dec(_f$content),
        created: data.dec(_f$created),
        updated: data.dec(_f$updated));
  }

  @override
  final Function instantiate = _instantiate;

  static BlogRecord fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BlogRecord>(map);
  }

  static BlogRecord fromJson(String json) {
    return ensureInitialized().decodeJson<BlogRecord>(json);
  }
}

mixin BlogRecordMappable {
  String toJson() {
    return BlogRecordMapper.ensureInitialized()
        .encodeJson<BlogRecord>(this as BlogRecord);
  }

  Map<String, dynamic> toMap() {
    return BlogRecordMapper.ensureInitialized()
        .encodeMap<BlogRecord>(this as BlogRecord);
  }

  BlogRecordCopyWith<BlogRecord, BlogRecord, BlogRecord> get copyWith =>
      _BlogRecordCopyWithImpl<BlogRecord, BlogRecord>(
          this as BlogRecord, $identity, $identity);
  @override
  String toString() {
    return BlogRecordMapper.ensureInitialized()
        .stringifyValue(this as BlogRecord);
  }

  @override
  bool operator ==(Object other) {
    return BlogRecordMapper.ensureInitialized()
        .equalsValue(this as BlogRecord, other);
  }

  @override
  int get hashCode {
    return BlogRecordMapper.ensureInitialized().hashValue(this as BlogRecord);
  }
}

extension BlogRecordValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BlogRecord, $Out> {
  BlogRecordCopyWith<$R, BlogRecord, $Out> get $asBlogRecord =>
      $base.as((v, t, t2) => _BlogRecordCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BlogRecordCopyWith<$R, $In extends BlogRecord, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? authorName,
      String? title,
      String? content,
      DateTime? created,
      DateTime? updated});
  BlogRecordCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BlogRecordCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BlogRecord, $Out>
    implements BlogRecordCopyWith<$R, BlogRecord, $Out> {
  _BlogRecordCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BlogRecord> $mapper =
      BlogRecordMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? authorName,
          String? title,
          String? content,
          DateTime? created,
          Object? updated = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (authorName != null) #authorName: authorName,
        if (title != null) #title: title,
        if (content != null) #content: content,
        if (created != null) #created: created,
        if (updated != $none) #updated: updated
      }));
  @override
  BlogRecord $make(CopyWithData data) => BlogRecord(
      id: data.get(#id, or: $value.id),
      authorName: data.get(#authorName, or: $value.authorName),
      title: data.get(#title, or: $value.title),
      content: data.get(#content, or: $value.content),
      created: data.get(#created, or: $value.created),
      updated: data.get(#updated, or: $value.updated));

  @override
  BlogRecordCopyWith<$R2, BlogRecord, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _BlogRecordCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
