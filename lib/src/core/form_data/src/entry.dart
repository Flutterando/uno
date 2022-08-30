///class [Entry] receives the variables in its constructor [name] and [value]
class Entry {
  /// The variable [name] it's the type list of integer
  final List<int> name;

  ///The variable [value] it's the type [Value]
  final Value value;

  ///[Entry] constructor class
  const Entry(
    this.name,
    this.value,
  );

  ///The factory of class [Entry] .value
  ///recives the params [name] and [bytes]
  factory Entry.value(
    List<int> name,
    List<int> bytes,
  ) =>
      Entry(
        name,
        Value(
          bytes,
        ),
      );

  ///The factory of class [Entry] .file
  ///recives the params [name], [bytes], [filename] and [contentType]
  factory Entry.file(
    List<int> name,
    List<int> bytes, {
    List<int>? filename,
    List<int>? contentType,
  }) =>
      Entry(name, File(bytes, filename: filename, contentType: contentType));
}

///Class [Value] recive variable [bytes] in its constructor
class Value {
  ///The variable  [bytes] it's the type integer
  final List<int> bytes;

  /// [Value] constructor class
  const Value(this.bytes);
}

///Class [File] recive variable [filename] and  [contentType] in its constructor
class File extends Value {
  ///The variable  [filename] it's the type list of integer
  final List<int>? filename;

  ///The variable [contentType] it's the type list of integer
  final List<int>? contentType;

  /// [File] constructor class
  const File(List<int> bytes, {this.filename, this.contentType}) : super(bytes);
}
