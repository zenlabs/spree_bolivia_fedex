class Spree::Calculator::CanadaPostExpedited < Spree::Calculator
  require 'net/http'
  require 'rexml/document'
  require 'builder'

  # preference :min_price, :decimal, :default => 10
  
  preference :merchantCPCID, :string, :default => "CPC_DEMO"
  preference :fromPostalCode, :string, :default => "H2L1H4"
  
  attr_accessible :preferred_merchantCPCID, :preferred_fromPostalCode
  
  def self.description
    "Canada Post (Expedited)"
  end
    
  def self.register
    super
  end
  
  def addItem(item)
    @items << item;
  end
  
  # as order_or_line_items we always get line items, as calculable we have Coupon, ShippingMethod or ShippingRate
  def compute(order)
    
    @items = []
    
    merchant = {
      :merchantCPCID => self.preferred_merchantCPCID,
      :fromPostalCode => self.preferred_fromPostalCode,
      :turnAroundTime => 24,
      :itemsPrice => order.total
    }
    
    customerInfo = {
      :city => order.ship_address.city,
      :provOrState => order.ship_address.state_name,
      :country => 'CA',        
      :postalCode => order.ship_address.zipcode   
    }
    
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
    
    url = URI.parse 'http://sellonline.canadapost.ca:30000/'
    request = Net::HTTP::Post.new(url.path)
    request.content_type = 'application/x-www-form-urlencoded'
    request.body = prepareXML(merchant, customerInfo)
    response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
    xml = REXML::Document.new(response.body).root
    if error = xml.elements['error']
      error = error.elements['statusMessage'].text
      raise StandardError.new(error)
    end
    xml = xml.elements['ratesAndServicesResponse']
    result = {}
    result[:products] = []
    xml.elements.each('product') do |p|
      product = {}
      p.elements.each do |t|
        product[t.name.to_sym] = t.text
      end
      result[:products] << product
    end
    # result[:options] = {}
    # xml.elements['shippingOptions'].elements.each do |t|
    #   result[:options][t.name.to_sym] = t.text
    # end
    return result[:products][0][:rate]
  end
  
  private 
  
  def prepareXML(merchant, customerInfo)
    xml = ::Builder::XmlMarkup.new
    xml.instruct!
    xml.eparcel do
      xml.language 'en'
      xml.ratesAndServicesRequest do
        buildTags(xml, [:merchantCPCID, :fromPostalCode, :turnAroundTime, :itemsPrice], merchant)
        xml.lineItems do
          @items.each do |item|
            xml.item do
              buildTags(xml, [:quantity, :weight, :length, :width, :height, :description], item)
            end
            xml.readyToShip if item[:readyToShip]
          end
        end
        buildTags(xml, [:city, :provOrState, :country, :postalCode], customerInfo)
      end
    end
    return xml.target!
  end
  
  def buildTags(xml, tags, hash)
    tags.each do |t|
      text = hash[t]
      xml.method_missing t, text if text
    end
  end
end