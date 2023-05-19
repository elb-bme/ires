import java.util.ArrayList;
import java.util.List;

public class Order {
    private int orderId;
    private String customerId;
    private List<String> items;

    public Order(int orderId, String customerId) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.items = new ArrayList<>();
    }

    public int getOrderId() {
        return orderId;
    }

    public String getcustomerId() {
        return customerId;
    }

    public List<String> getItems() {
        return items;
    }

    public void addItem(String item) {
        items.add(item);
    }

    public void removeItem(String item) {
        items.remove(item);
    }
}