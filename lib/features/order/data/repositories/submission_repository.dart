import '../../../../core/utils/formatters.dart';
import '../models/order_request_model.dart';

class SubmissionResult {
  final bool success;
  final String referenceId;
  final DateTime timestamp;
  final String message;

  const SubmissionResult({
    required this.success,
    required this.referenceId,
    required this.timestamp,
    required this.message,
  });
}

class SubmissionRepository {
  /// Submits the order to a local mock service with realistic latency.
  Future<SubmissionResult> submitOrder(OrderRequestModel order) async {
    // Artificial latency for authentic local submission experience
    await Future.delayed(const Duration(milliseconds: 1400));

    // Final integrity verification
    if (!order.isStep1Valid) {
      throw Exception('Contact details are incomplete or invalid.');
    }
    if (!order.isStep2Valid) {
      throw Exception('Order details or geographic locations are incomplete.');
    }
    if (!order.isStep3Valid) {
      throw Exception(
        'Both mandatory verification PDF documents must be attached.',
      );
    }

    final referenceId = Formatters.generateReferenceId();
    final timestamp = DateTime.now();

    return SubmissionResult(
      success: true,
      referenceId: referenceId,
      timestamp: timestamp,
      message:
          'Order request registered successfully in local demonstration mode.',
    );
  }
}
