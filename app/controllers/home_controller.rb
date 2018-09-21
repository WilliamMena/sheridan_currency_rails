require 'pry'

class HomeController < ApplicationController

  @@rates = {
    "USD_EUR": 0,
    "USD_SGD": 0,
    "EUR_USD": 0,
    "EUR_SGD": 0,
    "SGD_EUR": 0,
    "SGD_USD": 0
  }

  @@rate = 0
  @@convertedAmount = 0
  @@from = "USD"
  @@to = "EUR"

  def index
    @amount = @@convertedAmount
    @from = @@from
    @to = @@to
  end

  def create
    amount = params["amount"].to_i
    @@from = params["currency_from"]
    @@to = params["currency_to"]
    conversion = @@from+'_'+@@to

    if @@rates[conversion.to_sym] > 0
      @@rate = @@rates[conversion.to_sym]
      # print "This was cached"
    else
      @@rate = getCurrencyRate(@@from, @@to)
      insertRate(conversion, @@rate)
      # print "This is from the API"
    end
    @@convertedAmount = amount * @@rate
    redirect_to :root

  end

  private

  def getCurrencyRate(from, to)
    url = "https://free.currencyconverterapi.com/api/v6/convert?q=#{from}_#{to}&compact=y"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response).first.last["val"]
  end

  def insertRate(conversion, rate)
    Thread.new { @@rates[conversion.to_sym] = rate; sleep(60); @@rates[conversion.to_sym] = 0; puts "now reset"}
  end






end
