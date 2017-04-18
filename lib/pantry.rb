class Pantry
  attr_reader :stock, :shopping_list, :cookbook

  def initialize
    @stock = {}
    @shopping_list = {}
    @cookbook = []
  end

  def stock_check(item)
    if no_stock?(item)
      0
    else
      @stock[item]
    end
  end

  def restock(item, amount)
    if already_stocked?(item)
      @stock[item] += amount
    else
      @stock[item] = amount
    end
  end

  def add_to_shopping_list(recipe)
    to_add = recipe.ingredients
    add_or_update(to_add)
  end

  def print_shopping_list
    @shopping_list.map do |k, v|
      format_list(k, v)
    end.join
  end

  def add_to_cookbook(recipe)
    @cookbook << recipe
  end

  def what_can_i_make
    recipes = find_recipes
    collect_recipe_names(recipes)
  end

  def how_many_can_i_make
    recipes = find_recipes
    how_many = how_many_per_recipe(recipes)
    display_results(recipes, how_many)
  end

  private

  def display_results(recipes, amounts)
    recipes.map{|recipe|recipe.name}.zip(amounts).to_h
  end

  def how_many_per_recipe(recipes)
    recipes.map do |recipe|
      how_many_per(recipe)
    end
  end

  def collect_recipe_names(recipes)
    recipes.map{|recipe| recipe.name}
  end

  def format_list(k, v)
    if last_item?(k)
      "* #{k}: #{v}"
    else
      "* #{k}: #{v}\n"
    end
  end

  def last_item?(k)
    k ==  @shopping_list.keys.last
  end

  def no_stock?(item)
    @stock[item].nil?
  end

  def already_stocked?(item)
    @stock[item]
  end

  def find_recipes
    @cookbook.select do |recipe|
      have_all_ingredients_and_quantities?(recipe)
    end
  end

  def have_all_ingredients_and_quantities?(recipe)
    recipe.ingredients.all? do |k, v|
      @stock.keys.include?(k) && @stock[k] >= v
    end
  end

  def how_many_per(recipe)
    recipe.ingredients.map do |k, v|
      @stock[k]/v
    end.min
  end

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

  def update_shopping_list(to_add)
    to_add.each do |item, qty|
      new_item_or_update(item, qty)
    end
  end

end