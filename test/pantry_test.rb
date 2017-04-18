require './lib/pantry'
require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test
  def test_it_exists
    p = Pantry.new
    assert_instance_of Pantry, p
  end

  def test_it_initializes_empty
    p = Pantry.new
    actual = p.stock
    expected = {}
    assert_equal expected, actual
  end

  def test_it_can_check_stock
    p = Pantry.new
    actual = p.stock_check("Cheese")
    expected = 0
    assert_equal expected, actual
  end

  def test_it_can_restock
    p = Pantry.new
    p.restock("Cheese", 10)
    assert_equal 10, p.stock_check("Cheese")
  end

  def test_it_can_add_to_stock
    p = Pantry.new
    p.restock("Cheese", 10)
    assert_equal 10, p.stock_check("Cheese")
    p.restock("Cheese", 20)
    assert_equal 30, p.stock_check("Cheese")
  end

  def test_it_has_shopping_list
    p = Pantry.new
    actual = p.shopping_list
    expected = {}
    assert_equal expected, actual
  end

  def test_it_can_add_recipe_to_shopping_list
    # skip
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    p = Pantry.new
    p.add_to_shopping_list(r)
    actual = p.shopping_list
    expected = {"Cheese" => 20, "Flour" => 20}
    assert_equal expected, actual
  end

  def test_it_adds_to_shopping_list_from_new_recipe
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    p = Pantry.new
    p.add_to_shopping_list(r)
    r2 = Recipe.new("Spaghetti")
    r2.add_ingredient("Noodles", 10)
    r2.add_ingredient("Sauce", 10)
    r2.add_ingredient("Cheese", 5)
    p.add_to_shopping_list(r2)
    actual = p.shopping_list
    expected = {"Cheese" => 25, "Flour" => 20, "Noodles" => 10, "Sauce" => 10}
    assert_equal expected, actual
  end

  def test_it_prints_shopping_list
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    p = Pantry.new
    p.add_to_shopping_list(r)
    r2 = Recipe.new("Spaghetti")
    r2.add_ingredient("Noodles", 10)
    r2.add_ingredient("Sauce", 10)
    r2.add_ingredient("Cheese", 5)
    p.add_to_shopping_list(r2)
    actual = p.print_shopping_list
    expected = "* Cheese: 25\n* Flour: 20\n* Noodles: 10\n* Sauce: 10"
    assert_equal expected, actual
  end

  def test_it_has_cookbook
    p = Pantry.new
    actual = p.cookbook
    expected = []
    assert_equal expected, actual
  end

  def test_it_can_add_to_cookbook
    p = Pantry.new

    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    p.add_to_cookbook(r1)
    p.add_to_cookbook(r2)
    p.add_to_cookbook(r3)

    assert_equal 3, p.cookbook.count
  end

  def test_what_can_i_make
    p = Pantry.new

    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    p.add_to_cookbook(r1)
    p.add_to_cookbook(r2)
    p.add_to_cookbook(r3)

    p.restock("Cheese", 10)
    p.restock("Flour", 20)
    p.restock("Brine", 40)
    p.restock("Pickles", 40)
    p.restock("Raw nuts", 20)
    p.restock("Salt", 20)
    p.restock("Cucumbers", 30)

    actual = p.what_can_i_make
    expected = ["Pickles", "Peanuts"]

    assert_equal expected, actual
  end

  def test_how_many_can_i_make
    p = Pantry.new

    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    p.add_to_cookbook(r1)
    p.add_to_cookbook(r2)
    p.add_to_cookbook(r3)

    p.restock("Cheese", 10)
    p.restock("Flour", 20)
    p.restock("Brine", 40)
    p.restock("Pickles", 40)
    p.restock("Raw nuts", 20)
    p.restock("Salt", 20)
    p.restock("Cucumbers", 30)

    actual = p.how_many_can_i_make
    expected = {"Pickles" => 1, "Peanuts" => 2}

    assert_equal expected, actual
  end
  
end
