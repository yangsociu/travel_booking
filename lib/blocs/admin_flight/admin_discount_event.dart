abstract class AdminDiscountEvent {}

class LoadDiscounts extends AdminDiscountEvent {}

class DeleteDiscount extends AdminDiscountEvent {
  final String documentId;

  DeleteDiscount(this.documentId);
}
