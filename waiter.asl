// waiter.asl

+waiter : true.

+!receive_order : true.

// Define the action or plan for receiving a read order
+!receive_order : true <-
    ?order(OrderItem) : true <-
        .print("Received order: " + OrderItem),
        .send(chef, order_received(OrderItem)),
        !deliver_order(CustomerID, OrderItem).
// Define the action or plan for taking the order from the customer
+order(OrderItem) : true <-
    .print("Received order: " + OrderItem),
    .send(chef, order_received(OrderItem)),

	
// Define the action or plan for receiving the readiness of the order from the chef
+order_ready(OrderItem) : true <-
    // Print a message indicating the readiness of the order
    .print("Order ready: " + OrderItem),
    // Notify the respective customer about the order readiness
    .send(customer, order_served(OrderItem)),
    // Return to the initial goal of serving the order
    !receive_order.

