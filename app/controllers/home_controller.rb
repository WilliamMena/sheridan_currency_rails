require 'pry'
require 'Home.rb'
class HomeController < ApplicationController

  # @rates = {
  #   "USD_EUR": 0,
  #   "USD_SGD": 0,
  #   "EUR_USD": 0,
  #   "EUR_SGD": 0,
  #   "SGD_EUR": 0,
  #   "SGD_USD": 0,
  # }
  #
  @@rate = 0
  @@convertedAmount = 0
  @@conversion = ""

  def index
    @amount = @@convertedAmount
  end

  def create
    amount = params["amount"].to_i
    from = params["currency_from"]
    to = params["currency_to"]
    @@conversion = from+'_'+to

    # if Rails.cache.exist?(conversion)
    #   @@rate = Rails.cache.read(conversion)
    #   print "This was cached"
    # else
    #   @@rate = getCurrencyRate(from, to)
    #   Rails.cache.write(conversion, rate, expires_in: 1.minute)
    #   print "This is from the API"
    # end
    @@rate = getCurrencyRate(from, to)
    @@convertedAmount = amount * @@rate
    redirect_to :root


  end

  def show
  end

  private

  def getCurrencyRate(from, to)
    url = "https://free.currencyconverterapi.com/api/v6/convert?q=#{from}_#{to}&compact=y"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response).first.last["val"]
  end






end
