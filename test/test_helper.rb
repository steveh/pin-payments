require "rubygems"
require 'debugger'
require 'test/unit'
require 'webmock/test_unit'
require 'active_support/inflector'

require File.dirname(__FILE__) + '/../lib/pin-payments.rb'

module TestHelper
  
  SECRET_KEY = ENV["PIN_SECRET_KEY"] || "fake_key"
  PIN_ENV = ENV["PIN_ENV"] || :test

  Pin::Base.setup SECRET_KEY, PIN_ENV

  def get_file(filename)
    File.new(File.dirname(__FILE__) + "/stub_responses/" + filename)
  end
  
  def get_record_json(type, token = nil)
    if token.nil?
      get_file("#{type}.json")
    else
      get_file("records/#{type}-#{token}.json")
    end
  end
  
  def mock_get(model_name, do_each = true)
    stub_request(:get, /#{model_name.downcase}$/).to_return(body: get_record_json(model_name.downcase.pluralize), status: 200, headers: {'Content-Type' => 'application/json; charset=utf-8'})
    if do_each
      Pin.const_get(model_name.singularize).all.each do |record|
        stub_request(:get, /#{model_name.downcase}\/#{record.token}$/).to_return(body: get_record_json(model_name.downcase.singularize, record.token), status: 200, headers: {'Content-Type' => 'application/json; charset=utf-8'})
      end
    end
  end

  def mock_post(model_name, do_each = true)
    stub_request(:post, /#{model_name.downcase}$/).to_return(body: get_record_json(model_name.downcase.pluralize), status: 201, headers: {'Content-Type' => 'application/json; charset=utf-8'})
    if do_each
      Pin.const_get(model_name.singularize).all.each do |record|
        stub_request(:post, /#{model_name.downcase}\/#{record.token}$/).to_return(body: get_record_json(model_name.downcase.singularize, record.token), status: 201, headers: {'Content-Type' => 'application/json; charset=utf-8'})
      end
    end
  end

  def mock_api(model_name)
    mock_get(model_name)
    mock_post(model_name)
  end
end