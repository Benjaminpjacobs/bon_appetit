require 'pry'
class Pantry
  attr_reader :stock, :shopping_list, :cookbook

  def initialize
    @stock = {}
    @shopping_list = {}
    @cookbook = []
  end

  def stock_check(item)
    if @stock[item].nil?
      0
    else
      @stock[item]
    end
  end

  def restock(item, amount)
    if @stock[item]
      @stock[item] += amount
    else
      @stock[item] = amount
    end
  end

  def add_to_shopping_list(recipe)
    to_add = recipe.ingredients
    add_or_update(to_add)
  end

  def update_shopping_list(to_add)
    to_add.each do |item, qty|
      new_item_or_update(item, qty)
    end
  end

  def print_shopping_list
    list = @shopping_list.map do |k, v|
      "* #{k}: #{v}\n"
    end
    list.join
  end
  
  def add_to_cookbook(recipe)
    @cookbook << recipe
  end

  def what_can_i_make
    possibilities = find_recipies
    possibilities.map{|recipe| recipe.name}
  end

  def find_recipies
    @cookbook.select do |recipe|
      have_all_ingredients_and_quantities?(recipe)
    end
  end

  def have_all_ingredients_and_quantities?(recipe)
    recipe.ingredients.all? do |k, v|
      @stock.keys.include?(k) && @stock[k] >= v
    end
  end

  def how_many_can_i_make
    possibilities = find_recipies
    per = possibilities.map do |recipe|
      how_many_per(recipe)
    end
    possibilities.map{|recipe|recipe.name}.zip(per).to_h
  end

  def how_many_per(recipe)
    recipe.ingredients.map do |k, v|
      @stock[k]/v
    end.min
  end
  
  private

  def new_item_or_update(item, qty)
    if @shopping_list.keys.include?(item)
      @shopping_list[item] += qty
    else
      @shopping_list[item] = qty
    end
  end

  def add_or_update(to_add)
    if @shopping_list.empty?
      @shopping_list.merge!(to_add)
    else
      update_shopping_list(to_add)
    end
  end
  



end
