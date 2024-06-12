/// The `SchoolClass` class encapsulates school class data including school class ID and class number.
class SchoolClass {
  /// The unique identifier for the school class.
  final int schoolClassId;

  /// The number of the class.
  final int classNumber;

  /// Constructs a new instance of the `SchoolClass` class.
  ///
  /// All parameters are required.
  ///
  /// - Parameters:
  ///   - schoolClassId: The unique identifier for the school class.
  ///   - classNumber: The number of the class.
  SchoolClass({
    required this.schoolClassId,
    required this.classNumber,
  });

  /// Constructs a `SchoolClass` instance from a JSON map.
  ///
  /// This factory method creates a `SchoolClass` object by parsing a JSON map.
  /// It expects the JSON map to have keys corresponding to school class properties.
  ///
  /// - Parameters:
  ///   - json: A JSON map containing the school class data.
  /// - Returns: A `SchoolClass` instance populated with the data from the JSON map.
  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      schoolClassId: json['schoolClassId'],
      classNumber: json['classNumber'],
    );
  }

  /// Converts the `SchoolClass` object to a JSON map.
  ///
  /// This method converts the `SchoolClass` object into a JSON map representation.
  /// It returns a map with keys corresponding to school class properties.
  ///
  /// - Returns: A JSON map containing the school class data.
  Map<String, dynamic> toJson() {
    return {
      'schoolClassId': schoolClassId,
      'classNumber': classNumber,
    };
  }
}
