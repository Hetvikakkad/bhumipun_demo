import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../core/utils/formatters.dart';

enum DocumentType { aadhaar, supporting }

class DocumentFileModel extends Equatable {
  final String name;
  final String? path;
  final int sizeBytes;
  final String? mimeType;
  final bool isAccessible;
  final Uint8List? bytes;

  const DocumentFileModel({
    required this.name,
    this.path,
    required this.sizeBytes,
    this.mimeType,
    this.isAccessible = true,
    this.bytes,
  });

  String get formattedSize => Formatters.formatFileSize(sizeBytes);

  bool get isPdf => name.toLowerCase().endsWith('.pdf');

  DocumentFileModel copyWith({
    String? name,
    String? path,
    int? sizeBytes,
    String? mimeType,
    bool? isAccessible,
    Uint8List? bytes,
  }) {
    return DocumentFileModel(
      name: name ?? this.name,
      path: path ?? this.path,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      mimeType: mimeType ?? this.mimeType,
      isAccessible: isAccessible ?? this.isAccessible,
      bytes: bytes ?? this.bytes,
    );
  }

  /// Serializes only metadata - binary contents are intentionally NOT persisted.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'sizeBytes': sizeBytes,
      'mimeType': mimeType,
    };
  }

  factory DocumentFileModel.fromJson(Map<String, dynamic> json) {
    return DocumentFileModel(
      name: json['name'] as String? ?? '',
      path: json['path'] as String?,
      sizeBytes: json['sizeBytes'] as int? ?? 0,
      mimeType: json['mimeType'] as String?,
      isAccessible:
          true, // Will be verified against local filesystem by repository
    );
  }

  @override
  List<Object?> get props => [name, path, sizeBytes, mimeType, isAccessible];
}
