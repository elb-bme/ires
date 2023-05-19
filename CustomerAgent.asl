// Import necessary modules or libraries
include "message_content.asl";
include "Order.java";

// Define the customer agent
agent customer {
      // Beliefs
        menu = [burger, pizza, salad, pasta]; // List of available menu items
        placedOrder = false; // Flag to track if an order has been placed

    // Define goals
    +placeOrder(Item) : string(Item); // Goal to place an order

    // Define plans
    !placeOrder
    :   // Check if the customer desires to place an order
        ?desires(placeOrder)
        & believes(menu(Menu))
        <- // Select an item from the menu (for simplicity, we select the first item)
            Item = Menu[1];
            // Send an order message to the waiter agent
            !sendOrder(waiter, Item);
            // Remove the placeOrder desire
            -desires(placeOrder).

    // Internal action to send an order message to the waiter
    !sendOrder(waiter, Item)
    :   // Check if the waiter agent is known
        ?known(waiter)
        & believes(menu(Menu))
        & believes(orderId(OrderId))
        <- // Update the order ID
            NewOrderId = OrderId + 1;
            !updateBelief(orderId(NewOrderId));
            // Create the order content
            OrderContent = [order(Item), orderId(NewOrderId)];
            // Send an inform message to the waiter agent with the order content
            .send(waiter, inform, OrderContent).

    // Internal action to update a belief
    !updateBelief(Belief)
    :   // Check if the belief is known
        ?known(Belief)
        <- // Remove the old belief
            -believes(Belief);
            // Add the updated belief
            +believes(Belief).

    // Internal action to receive a message
    +receive(Message)
    :   // Check if the message is an inform message
        ?messageContent(Message, inform, Content)
        <- // Handle the inform message based on its content
            !handleInform(Content).

    // Internal action to handle an inform message
    !handleInform(Content)
    :   // Check if the content is an order served message
        ?Content[0] = orderServed
        & ?Content[1] = orderId(OrderId)
        <- // Print the order served message
            .print("Order ", OrderId, " served. Enjoy your meal!").
    +!placeOrder(Item)[source(self), target(waiter), performatives([inform])]: {
        .getBelief(orderId, OrderId); // Get the current order ID
        .getBelief(menu, Menu); // Get the menu
        
    // Define agent's desires
    desire
        // Desire to place an order
        +!placeOrder;
        // Create the order object
        .create(OrderId, self, Item, Order);
        
        // Send an "inform" message to the waiter with the order
        .send(waiter, inform(order(Order)));
        
        !orderPlaced(Item); // Achieve the orderPlaced event
    // Define agent's intentions
    +!placeOrder : true;

    // Define rules
    // Rule to handle receiving an "inform" message from the waiter
    +!inform(order(Item)) : true <- addOrder(Item);

    // Internal action to create an order object
    +create(OrderId, Customer, Item, Order) : 
        .createNewObject(Order, "Order", OrderId, Customer, Item);

    // Internal action to send a message to the waiter
    +tell(waiter, inform(order(Order))) :
        .send(waiter, inform, order(Order)); // Send an "inform" message to the waiter with the order

    // Internal action to send a message to the waiter indicating order placed
    +orderPlaced(Item) :
        .send(waiter, inform, orderPlaced(Item)); // Send an "inform" message to the waiter indicating order placed
}
