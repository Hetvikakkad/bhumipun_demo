import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/document_file_model.dart';
import '../../data/models/order_request_model.dart';
import 'document_upload_card.dart';

class DocumentUploadsStep extends StatelessWidget {
  final OrderRequestModel order;
  final void Function(DocumentType, DocumentFileModel) onDocumentSelected;
  final void Function(DocumentType) onDocumentRemoved;
  final bool hasInaccessibleFiles;

  const DocumentUploadsStep({
    super.key,
    required this.order,
    required this.onDocumentSelected,
    required this.onDocumentRemoved,
    this.hasInaccessibleFiles = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.forestGreenSubtle,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.forestGreen.withValues(alpha: 0.2),
            ),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.file_copy_outlined,
                color: AppColors.forestGreen,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.step3Title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      AppStrings.step3Subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.charcoalMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Guidelines Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceWarm,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.forestGreen,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Upload Guidelines',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                '• Accepted file type: PDF (.pdf) only.\n'
                '• Maximum allowed file size: 2.0 MB per document.\n'
                '• Documents are validated locally and never transmitted to external cloud servers.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.charcoalMuted,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 1. Aadhaar Card Card
        DocumentUploadCard(
          title: AppStrings.aadhaarDoc,
          subtitle: AppStrings.aadhaarDocDescription,
          type: DocumentType.aadhaar,
          document: order.aadhaarDoc,
          hasAccessibilityError:
              order.aadhaarDoc != null && !order.aadhaarDoc!.isAccessible,
          onDocumentSelected: (doc) =>
              onDocumentSelected(DocumentType.aadhaar, doc),
          onDocumentRemoved: () => onDocumentRemoved(DocumentType.aadhaar),
        ),

        const SizedBox(height: 16),

        // 2. Supporting Document Card
        DocumentUploadCard(
          title: AppStrings.supportingDoc,
          subtitle: AppStrings.supportingDocDescription,
          type: DocumentType.supporting,
          document: order.supportingDoc,
          hasAccessibilityError:
              order.supportingDoc != null && !order.supportingDoc!.isAccessible,
          onDocumentSelected: (doc) =>
              onDocumentSelected(DocumentType.supporting, doc),
          onDocumentRemoved: () => onDocumentRemoved(DocumentType.supporting),
        ),
      ],
    );
  }
}
