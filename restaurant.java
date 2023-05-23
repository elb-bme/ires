public class Classroom extends Environment {
	 static Logger logger = Logger.getLogger(Restaurant.class.getName());
	 
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

private int generatePreparationTime(String item) {
    int prepTime = 0;
    
    // Generate a random number to determine the preparation time
    int randNum = random.nextInt(101);
    
    if (item.equals("burger")) {
        if (randNum < 40) {
            prepTime = 3;  // 3 minutes
        } else {
            prepTime = 10; // 10 minutes
        }
    } else if (item.equals("pizza")) {
        if (randNum < 70) {
            prepTime = 10; // 10 minutes
        } else {
            prepTime = 25; // 25 minutes
        }
    }
    
    return prepTime;
}


}
