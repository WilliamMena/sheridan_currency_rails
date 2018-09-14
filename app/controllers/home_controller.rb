require 'pry'
class HomeController < ApplicationController

  def index
  end

  def create
    binding.pry
  end

  def show
  end
end

private

  def home_params
    binding.pry
  end
