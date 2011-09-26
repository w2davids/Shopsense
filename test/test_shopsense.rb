require 'rubygems'
require 'Shopsense'

shopsense= Shopsense::ShopsenseAPI.new('uid9316-2194146-60');
yml= shopsense.load_config();
#puts shopsense.do_search({:format => 'json', :term =>'red dress', :min=> 0, :count => 10 });
#puts shopsense.get_trends( :category => 109)
#puts shopsense.get_look( :look => 548347 )
#puts shopsense.get_looks(:type => "Celebrities")
#puts shopsense.get_stylebook( {:handle => 'FabSugar'} )
#puts shopsense.get_brands({})
#puts shopsense.get_retailers({})
#puts shopsense.get_category_histogram({:term => 'red dress'})
puts shopsense.get_filter_histogram({:filter_type => 'Retailer', :term => 'red dress'})