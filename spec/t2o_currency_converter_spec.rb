require "spec_helper"

RSpec.describe T2oCurrencyConverter do
  before do
    @c = T2oCurrencyConverter::CurrencyConvert.new()
  end

  it "has a version number" do
    expect(T2oCurrencyConverter::VERSION).not_to be nil
  end

  it "should return the converted currency" do
    expect(@c.convert("USD/JPY")).to be_kind_of(Float)
  end
end
