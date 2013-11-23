require 'spec_helper'

describe "places/show" do
  before(:each) do
    @place = assign(:place, stub_model(Place,
      :name => "Name",
      :hours => "Hours",
      :info => "Info",
      :address => "Address",
      :latitude => "Latitude",
      :longitude => "Longitude",
      :type => "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Hours/)
    rendered.should match(/Info/)
    rendered.should match(/Address/)
    rendered.should match(/Latitude/)
    rendered.should match(/Longitude/)
    rendered.should match(/Type/)
  end
end
