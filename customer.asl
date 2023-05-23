//customer.asl

+customer : true.

+!place_order : true.

+!place_order : true <-
    // Generate the order item
    randomNum = random(100) / 100.0;		
		
	// If the random number is less than 0.5, generate a pizza order; otherwise, generate a burger order
    ?(randomNum < 0.5) : true <-
        OrderItem = "pizza";
    else
        OrderItem = "burger";
    ;

    .print("I ordered: " + OrderItem),
    .send(waiter, order(OrderItem)).

		
+order_served(OrderItem) : true <-
	.print("Got my order: " + OrderItem).
	!finish_meal.
	
+finish_meal : true <-
    .print("Finished my meal").
	!place_order.
