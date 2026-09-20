sealed class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderSubmitting extends OrderState {
  const OrderSubmitting();
}

class OrderCreated extends OrderState {
  const OrderCreated(this.orderId);
  final String orderId;
}

class OrderFailure extends OrderState {
  const OrderFailure(this.message);
  final String message;
}
