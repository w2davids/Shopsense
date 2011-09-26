#!/usr/bin/env ruby

require 'Shopsense'
yml_config_filename= 'shopsense.yml'

shopsense= Shopsense::ShopsenseAPI.new;

#shopsense.load_config(yml_config_filename);
#puts shopsense.do_search({:format => 'json', :term =>'red dress', :min=> 0, :count => 10 });
#puts shopsense.get_trends( { :format => 'json',:category => 109} )
#puts shopsense.visit_retailer( {:retailer_id => 27500798})
#puts shopsense.get_looks( { :type=> "New", :min => 0, :count => 10 } )
#puts shopsense.get_stylebook({:handle => "FabSugar"})
#puts shopsense.get_brands( {:format => "json"})
#puts  shopsense.get_look( { :look => 548347})
#puts  shopsense.get_retailers( :format => "json")
#puts shopsense.get_category_histogram({:format => "json", :term => "tunic"})
#puts shopsense.get_filter_histogram({:format => "json", :filter_type=> "Brand", :term => "tunic"})