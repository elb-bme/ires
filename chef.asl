// chef.asl

// Define the initial belief base of the chef agent
+chef : true.

// Define the initial goal of the chef agent
+!take_order : true.

// Define the action or plan for taking an order
+!take_order : true <-
    .print("Received order: " + order);
    // If the order is for a pizza
    ?order_received(pizza, prepTime) : true <- 
        // Invoke the appropriate action for processing the pizza order
        !receive_order(pizza, prepTime).
    // If the order is for a burger
    ?order_received(burger, prepTime) : true <- 
        // Invoke the appropriate action for processing the burger order
        !receive_order(burger, prepTime).

// Define the action or plan for processing a pizza order
+!receive_order(pizza, prepTime) : true <-
    // Process the pizza order and perform necessary actions
    .print("Received order: pizza");
    // Convert the preparation time to milliseconds
    preparationTimeMillis = prepTime * 1000;
    // Wait for the specified preparation time
    .wait(preparationTimeMillis);
     // Send a message to inform the waiter that the order is ready
    .send(waiter, order_ready, pizza).

    // Return to take the next order
    !take_order.

// Define the action or plan for processing a burger order
+!receive_order(burger, prepTime) : true <-
    // Process the burger order and perform necessary actions
    .print("Received order: burger");

    // Convert the preparation time to milliseconds
    preparationTimeMillis = prepTime * 1000;

    // Wait for the specified preparation time
    .wait(preparationTimeMillis);

     // Send a message to inform the waiter that the order is ready
    .send(waiter, order_ready, burger).

    // Return to take the next order
    !take_order.

