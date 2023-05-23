// chef.asl

// Define the initial belief base of the chef agent
+chef : true.

// Define the initial goal of the chef agent
+!take_order : true.

// Define the action or plan for taking an order
+!take_order : true <-
    // Check if an order is received
    ?order_received(OrderItem) : true <-
        .print("Received order: " + OrderItem);
        // Invoke the appropriate action for processing the order
        !process_order(OrderItem).

+!process_order(OrderItem) : true <-
    .print("Received order: " + OrderItem);

    // Calculate the preparation time based on the item type
    ?(OrderItem == "burger") : true <-
        ?(random(101) < 40) : true <-
            prepTime = 3;  // 3 minutes
        else
            prepTime = 10; // 10 minutes
    ;
    ?(OrderItem == "pizza") : true <-
        ?(random(101) < 70) : true <-
            prepTime = 10; // 10 minutes
        else
            prepTime = 25; // 25 minutes
    ;

    preparationTimeMillis = prepTime * 1000;
	.print("Preparing " + OrderItem);
    .wait(preparationTimeMillis);
    // Send a message to inform the waiter that the order is ready
    .send(waiter, order_ready(OrderItem)).
    .print(OrderItem + " ready");

    // Return to take the next order
    !take_order.
