require 'pry'

class HomeController < ApplicationController

  @@cache = ActiveSupport::Cache::MemoryStore.new

  @@rate = 0
  @@convertedAmount = 0
  @@from = "USD"
  @@to = "EUR"
  @@amount = 0

  def index
    @previous_amount = @@amount
    @amount = @@convertedAmount
    @from = @@from
    @to = @@to
  end

  def create
    @@amount = params["amount"].to_i
    @@from = params["currency_from"]
    @@to = params["currency_to"]
    conversion = @@from+'_'+@@to

    if @@from === @@to
      @@rate = 1
    elsif @@cache.read(conversion.to_sym)
      @@rate = @@cache.read(conversion.to_sym)
      print "This was cached"
    else
      @@rate = getCurrencyRate(@@from, @@to)
      insertRateCache(conversion, @@rate)
      print "This is from the API"
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

  def insertRateCache(conversion, rate)
    @@cache.write(conversion, rate, expires_in: 60)
  end






end
