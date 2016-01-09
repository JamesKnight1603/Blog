require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  test "get new category form and create category" do
    get new_category_path
    assert_template "categories/new"
    assert_difference "Category.count", 1 do
      post_via_redirect categories_path, category: {name: "sports"}
    end
    assert_template 'categories/index'
    assert_match "sports", response.body
  end


  test "invalid category submission results in failure" do
    get new_category_path
    assert_template "categories/new"
    assert_no_difference "Category.count" do
      post categories_path, category: {name: " "}
    end

    # This is checking that shared errors are working, if you look at the errors partial you will see a div with panel body and a h2 with panel title
    # We are checking that these exist.
    assert_template 'categories/new'
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end


end