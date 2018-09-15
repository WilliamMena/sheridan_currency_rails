require 'net/http'
require 'json'

class Home

  def getCurrencyRate(from, to)
    url = "https://free.currencyconverterapi.com/api/v6/convert?q=#{from}_#{to}&compact=y"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response).first.last["val"]

  end

end
