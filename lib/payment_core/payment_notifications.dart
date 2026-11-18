import '../trippl_payments_mobile.dart';

class PaymentNotifications {
  static bool quiet(
    PaymentNotificationPreference preference,
    DateTime localTime,
  ) {
    PaymentGuard.record(preference.validate());
    final start = preference.quietStartHour,
        end = preference.quietEndHour,
        hour = localTime.hour;
    if (start == end) return false;
    return start < end
        ? hour >= start && hour < end
        : hour >= start || hour < end;
  }

  static List<PaymentNotificationEvent> eligible(
    List<PaymentNotificationEvent> events,
    PaymentNotificationPreference preference, {
    required String scope,
    required String environment,
    required DateTime now,
    required DateTime localTime,
    Set<String> alreadyPresented = const {},
  }) {
    PaymentGuard.record(preference.validate());
    PaymentGuard.scope(preference.scopeFingerprint, scope);
    if (preference.updatedAt.isAfter(now))
      throw StateError('Notification preference clock mismatch');
    PaymentGuard.distinct(events.map((e) => e.id));
    if (quiet(preference, localTime)) return const [];
    final result = <PaymentNotificationEvent>[];
    for (final event in events) {
      PaymentGuard.record(event.validate());
      PaymentAccountGuard.context(
        event.scopeFingerprint,
        event.environment,
        scope: scope,
        environment: environment,
      );
      if (!event.serverVerified ||
          !PaymentGuard.fresh(event.occurredAt, event.expiresAt, now) ||
          alreadyPresented.contains(event.id))
        continue;
      final enabled = switch (event.kind) {
        'payment' => preference.paymentUpdates,
        'refund' => preference.refundUpdates,
        'invoice' => preference.invoiceUpdates,
        'plan' => preference.planReminders,
        'dispute' => preference.disputeUpdates,
        _ => false,
      };
      if (enabled) result.add(event);
    }
    result.sort((a, b) {
      final t = b.occurredAt.compareTo(a.occurredAt);
      return t != 0 ? t : a.id.compareTo(b.id);
    });
    return List.unmodifiable(result);
  }

  static Map<String, Object?> presentation(PaymentNotificationEvent event) {
    PaymentGuard.record(event.validate());
    final title = switch (event.kind) {
      'refund' => 'Refund update',
      'invoice' => 'Invoice update',
      'plan' => 'Payment schedule update',
      'dispute' => 'Payment dispute update',
      _ => 'Payment update',
    };
    return Map.unmodifiable({
      'id': event.id,
      'orderId': event.orderId,
      'title': title,
      'status': event.status,
      'openAccountRequired': true,
      'paymentConfirmed': false,
      'notificationSent': false,
    });
  }
}
