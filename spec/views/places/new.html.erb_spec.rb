require 'spec_helper'

describe "places/new" do
  before(:each) do
    assign(:place, stub_model(Place,
      :name => "MyString",
      :hours => "MyString",
      :info => "MyString",
      :address => "MyString",
      :latitude => "MyString",
      :longitude => "MyString",
      :type => ""
    ).as_new_record)
  end

  it "renders new place form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", places_path, "post" do
      assert_select "input#place_name[name=?]", "place[name]"
      assert_select "input#place_hours[name=?]", "place[hours]"
      assert_select "input#place_info[name=?]", "place[info]"
      assert_select "input#place_address[name=?]", "place[address]"
      assert_select "input#place_latitude[name=?]", "place[latitude]"
      assert_select "input#place_longitude[name=?]", "place[longitude]"
      assert_select "input#place_type[name=?]", "place[type]"
    end
  end
end
