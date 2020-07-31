require 'spec_helper'

describe Conekta::List do

  include_context "API 2.0.0"

  let(:list) do
    response = JSON.parse(File.read("spec/support/fixtures/orders.json"))
    order_list = Conekta::List.new("Order",response)
    order_list.load_from(response)
    order_list
  end

  context "with global api_key" do
    context "moving cursor" do
      it "moves cursor forward" do
        window = Conekta::Order.where({"limit" => 5, "next" => list[9].id})
        expect(window.first.id).to eq(list[10].id)
        window.next(limit: 1)
        expect(window.first.id).to eq(list[15].id)
      end

      it "moves cursor backwards" do
        window = Conekta::Order.where({"limit" => 5, "next" => list[14].id})
        expect(window.first.id).to eq(list[15].id)
        window.previous(limit: 1)
        expect(window.first.id).to eq(list[14].id)
      end
    end
  end

  context "with local api_key" do
    include_context "local api_key"

    let(:list) do
      response = JSON.parse(File.read("spec/support/fixtures/orders.json"))
      order_list = Conekta::List.new("Order", response)
      order_list.set_api_key(global_api_key)
      order_list.load_from(response)
      order_list
    end

    context "moving cursor" do
      it "moves cursor forward" do
        window = Conekta::Order.where({"limit" => 5, "next" => list[9].id}, global_api_key)
        expect(window.first.id).to eq(list[10].id)
        window.next(limit: 1)
        expect(window.first.id).to eq(list[15].id)
      end

      it "moves cursor backwards" do
        window = Conekta::Order.where({"limit" => 5, "next" => list[14].id}, global_api_key)
        expect(window.first.id).to eq(list[15].id)
        window.previous(limit: 1)
        expect(window.first.id).to eq(list[14].id)
      end
    end
  end
end
