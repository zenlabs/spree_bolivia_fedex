class Spree::Calculator::BoliviaFedexRegular < Spree::Calculator
  
  def self.description
    "Fedex Bolivia (Normal)"
  end
    
  def self.register
    super
  end
  
  def addItem(item)
    @items << item;
  end
  
  def compute(order)
    case order
      when Spree::Shipment
        order = Spree::Order.find(order[:order_id])
        getRate(order)
      when Spree::Order
        if order.item_total != 0
          getRate(order)
        end
    end
  end
  
  private 
  
  def getRate(order)
    
    @items = []
    
    order.line_items.each do |i|
      item = {
        :quantity => i.quantity,
        :weight => i.variant.weight,
        :length => i.variant.depth,
        :width => i.variant.width,
        :height => i.variant.height,
        :description => ' '
      }
      addItem(item)
    end
    
    
  
    
    # result = result[:products].group_by { |i| i[:name] }
    # rate = result['Regular'][0][:rate].to_f + self.preferred_handlingFee.to_f
    return 20.0
  end
  
  def getState(order)
   if order.ship_address.state_name
     return order.ship_address.state_name
   else
     return order.ship_address.state.name
   end
  end
end