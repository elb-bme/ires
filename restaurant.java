import java.util.Queue;
import java.util.LinkedList;

public class Restaurant extends Environment {
	// Create an order queue to hold the pending orders
	private Queue<Order> orderQueue = new LinkedList<>();

	 static Logger logger = Logger.getLogger(Restaurant.class.getName());
	 // When a customer places an order, add it to the order queue
	public void placeOrder(String customerID, String item) {
		Order order = new Order(customerID, item);
		orderQueue.add(order);
	}
	 
	 @Override
public boolean executeAction(String ag, Structure action) {
    try {
        if (action.equals(tick)) {
            // Simulate the passage of time
            int randNum = random.nextInt(101);
            
            if (randNum < 30) {
                // Generate a burger order
                String order = "burger";
                int prepTime = generatePreparationTime("burger");
                
                // Communicate the order to the chef agent
                addPercept(ASSyntax.createLiteral("order_received", ASSyntax.createLiteral(order), ASSyntax.createNumber(prepTime)));
            } else if (randNum < 60) {
                // Generate a pizza order
                String order = "pizza";
                int prepTime = generatePreparationTime("pizza");
                
                // Communicate the order to the chef agent
                addPercept(ASSyntax.createLiteral("order_received", ASSyntax.createLiteral(order), ASSyntax.createNumber(prepTime)));
            } else {
                // No order received at this tick
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    updatePercepts();

    try {
        Thread.sleep(1);
    } catch (Exception e) {}
    informAgsEnvironmentChanged();
    return true;
}

}
