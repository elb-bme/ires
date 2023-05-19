// Import necessary modules and libraries
// ...

// Define agent
agent chefAgent {
    // Define beliefs
    beliefs:
        // Order queue as a list of Order objects
        orderQueue([]),
        // Current order being prepared
        currentOrder(none),
        // Flag to indicate if the chef is currently cooking an order
        cooking(false),
        // Slider value for prep time
        prepTimeSlider(5),
        // Chef agent's name
        chefName("ChefAgent");

    // Define goals
    goals:
        // Goal to receive orders and prepare food
        +!receiveOrder;

    // Define plans
    plans:
        // Plan for receiving orders
        +!receiveOrder : true
            <- .getPercept("order", Order);
               .print("Received order: ", Order);
               // Add the order to the order queue
               .beliefs.orderQueue.add(Order);
               // Check if the chef is currently cooking an order
               <- !cooking
                   & .beliefs.orderQueue.size() > 0
                   & .beliefs.currentOrder = none
                   & .send("waiterAgent", inform, orderReady);

        // Plan for cooking an order
        +!cookOrder : true
            <- // Check if there is an order to cook
               .beliefs.orderQueue.size() > 0
               & .beliefs.currentOrder = none
               // Get the first order from the queue
               & .beliefs.orderQueue.get(0, Order);
               // Set the current order
               .beliefs.currentOrder = Order;
               // Start cooking the order
               .cooking = true;
               // Wait for the prep time
               !waitForPrepTime;

        // Plan for waiting for the prep time
        +!waitForPrepTime : true
            <- .wait(.beliefs.prepTimeSlider * 1000);
               // Set the current order as cooked
               .beliefs.currentOrder.status = "Cooked";
               // Send a message to the waiter agent that the order is ready
               .send("waiterAgent", inform, orderReady);
               // Remove the cooked order from the queue
               .beliefs.orderQueue.remove(0);
               // Reset the current order and cooking flag
               .beliefs.currentOrder = none;
               .cooking = false;
               // Check if there are more orders in the queue
               <- .beliefs.orderQueue.size() > 0
                   <- !cooking;

    // Define actions
    actions:
        // Action to handle receiving a message
        +!handleMessage(M) : true
            <- .print("Received message: ", M);
               // Handle different message performatives
               +inform("orderReady")
                   <- // Check if there are more orders in the queue
                      .beliefs.orderQueue.size() > 0
                      <- !cooking;
               +_
                   <- .print("Unsupported message performative");

        // Action to handle slider value change
        +!handleSliderValueChange(V) : true
            <- .print("Slider value changed: ", V);
               // Update the prep time slider value
               .beliefs.prepTimeSlider = V;
               .print("New prep time: ", V);

    // Initialize the agent
    +!init : true
        <- // Print agent information
           .print("Initializing ChefAgent: ", chefName);
           // Subscribe to messages from the waiter agent
           .subscribe("waiterAgent");

}	