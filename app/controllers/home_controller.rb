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
  @@amount = 0

  def index
    if session[:current_user_id]
      @previous_amount = @@amount
      @amount = @@convertedAmount
      @from = @@from
      @to = @@to
    else
      @previous_amount = 0
      @amount = 0
      @from = "USD"
      @to = "EUR"
    end
  end

  def create
    session[:current_user_id] = 1
    @@amount = params["amount"].to_i
    @@from = params["currency_from"]
    @@to = params["currency_to"]
    conversion = @@from+'_'+@@to


    if @@from === @@to
      @@rate = 1
    elsif @@rates[conversion.to_sym] > 0
      @@rate = @@rates[conversion.to_sym]
      # print "This was cached"
    else
      @@rate = getCurrencyRate(@@from, @@to)
      insertRate(conversion, @@rate)
      # print "This is from the API"
    end
    @@convertedAmount = @@amount * @@rate
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
