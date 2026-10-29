import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/document_file_model.dart';

class DocumentUploadCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final DocumentType type;
  final DocumentFileModel? document;
  final void Function(DocumentFileModel) onDocumentSelected;
  final VoidCallback onDocumentRemoved;
  final bool hasAccessibilityError;

  const DocumentUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
    this.document,
    required this.onDocumentSelected,
    required this.onDocumentRemoved,
    this.hasAccessibilityError = false,
  });

  @override
  State<DocumentUploadCard> createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState extends State<DocumentUploadCard> {
  String? _localError;
  bool _isLoading = false;

  Future<void> _pickDocument() async {
    setState(() {
      _localError = null;
      _isLoading = true;
    });

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (files.isNotEmpty) {
        final platformFile = files.first;
        final fileName = platformFile.name;
        final fileSize =
            await platformFile.length() ?? platformFile.lengthSync() ?? 0;

        // Perform rigorous validation
        final validationError = Validators.validatePdfFile(
          fileName: fileName,
          fileSizeBytes: fileSize,
        );

        if (validationError != null) {
          setState(() {
            _localError = validationError;
          });
          return;
        }

        final docModel = DocumentFileModel(
          name: fileName,
          path: platformFile.path,
          sizeBytes: fileSize,
          mimeType: 'application/pdf',
          isAccessible: true,
        );

        widget.onDocumentSelected(docModel);
      }
    } catch (e) {
      setState(() {
        _localError = 'Failed to select document: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;
    final isAttached = doc != null;
    final isInaccessible =
        widget.hasAccessibilityError || (doc != null && !doc.isAccessible);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _localError != null || isInaccessible
              ? AppColors.errorRed
              : isAttached
              ? AppColors.forestGreen
              : AppColors.borderLight,
          width: isAttached || _localError != null || isInaccessible ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isAttached
                      ? AppColors.forestGreenLight
                      : AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isAttached
                        ? AppColors.forestGreen.withValues(alpha: 0.3)
                        : AppColors.borderLight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isAttached
                        ? Icons.picture_as_pdf_rounded
                        : Icons.upload_file_rounded,
                    color: isAttached
                        ? AppColors.forestGreen
                        : AppColors.charcoalMuted,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: widget.title,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                            ),
                            children: const [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: AppColors.errorRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isAttached
                                ? AppColors.forestGreenLight
                                : AppColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isAttached ? 'PDF ATTACHED' : 'PDF (MAX 2 MB)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isAttached
                                  ? AppColors.forestGreenDark
                                  : AppColors.charcoalMuted,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.charcoalMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Inaccessible Document Warning Notice
          if (isInaccessible)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.errorRedLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.errorRed.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.errorRed,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.documentInaccessibleError,
                      style: TextStyle(
                        color: AppColors.errorRed,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Attached file preview box OR Empty pick box
          if (isAttached)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.description_rounded,
                    color: AppColors.forestGreen,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${doc.formattedSize} • Verified PDF',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.forestGreenDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Replace action
                  TextButton.icon(
                    onPressed: _isLoading ? null : _pickDocument,
                    icon: const Icon(Icons.sync_rounded, size: 16),
                    label: const Text('Replace'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.forestGreen,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  // Remove action
                  IconButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _localError = null;
                            });
                            widget.onDocumentRemoved();
                          },
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: AppColors.errorRed,
                    tooltip: 'Remove document',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            )
          else
            OutlinedButton(
              onPressed: _isLoading ? null : _pickDocument,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppColors.forestGreen,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
                backgroundColor: AppColors.forestGreenSubtle,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.forestGreen,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            color: AppColors.forestGreen,
                          ),
                          SizedBox(width: 8),
                          Text(
                            AppStrings.selectFile,
                            style: TextStyle(
                              color: AppColors.forestGreen,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

          // Inline error message
          if (_localError != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.errorRed,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _localError!,
                    style: const TextStyle(
                      color: AppColors.errorRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
