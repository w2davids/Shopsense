require 'rubygems'
require 'Shopsense'

yml_config_filename='../lib/shopsense.yml'
shopsense= Shopsense::ShopsenseAPI.new;
yml= shopsense.load_config(yml_config_filename);
puts shopsense.do_search({:format => 'json', :term =>'red dress', :min=> 0, :count => 10 });