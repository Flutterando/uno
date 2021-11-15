class Entry {
  final List<int> name;
  final Value value;

  const Entry(this.name, this.value);

  factory Entry.value(List<int> name, List<int> bytes) => Entry(name, Value(bytes));

  factory Entry.file(
    List<int> name,
    List<int> bytes, {
    List<int>? filename,
    List<int>? contentType,
  }) =>
      Entry(name, File(bytes, filename: filename, contentType: contentType));
}

class Value {
  final List<int> bytes;

  const Value(this.bytes);
}

class File extends Value {
  final List<int>? filename;
  final List<int>? contentType;

  const File(List<int> bytes, {this.filename, this.contentType}) : super(bytes);
}
