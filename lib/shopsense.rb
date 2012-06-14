require 'rubygems'
require 'yaml'
require 'net/http'
require 'cgi'

module Shopsense
  
  class ShopsenseAPI
  
    @has_load_config= false
  
    def initialize( api_key )
      @pid= "pid=" + api_key
    end


=begin
Loads the YAML configuration file
=end
    def load_config( yml_config_filename= nil )
      if yml_config_filename == nil
        @yml= YAML::load_file( '../config/shopsense.yml' )
      else
        @yml= YAML::load_file( yml_config_filename )
      end
      
    end
  
=begin
apiSearch
This method returns a set of products that match a query, specified using the product query parameters and those listed below.
http://api.shopstyle.com/action/apiSearch?pid=uid9316-2194146-60&fts=red+dress&min=0&count=10
min	The index of the first product to return, or 0 (zero) if not specified. A client can use this to implement paging through large result sets.
count	The maximum number of results to return, or 20 if not specified. The maximum value is 250. Combine with the min parameter to implement paging.
Response
A list of Product objects. Each Product has an id, name, description, price, retailer, brand name, categories, images in small/medium/large, and a URL that forwards to the retailer's site.
Note: To view the response xml or json, copy an API link and paste it in your browser after replacing YOUR_API_KEY with the api key assigned to you.


The format of the response. Supported values are:
xml - The response is in XML format with UTF-8 encoding. This is the default if the parameter is absent.
json - The response is in JSON format with UTF-8 encoding.
json2 - Same as json, but numbers and booleans are returned as JSON numbers and booleans instead of strings.
jsonvar - The response is in JSON format with UTF-8 encoding and includes a JavaScript assignment statement. This is useful when the API URL is the src attribute of a script tag, as the result is stored in a variable that can be used by subsequent JavaScript code.
jsonvar2 - Same as jsonvar, but numbers and booleans are returned as JSON numbers and booleans instead of strings.
jsonp - The response is in JSON format with UTF-8 encoding wrapped in a JavaScript method called padding. The padding must be specified with the query parameter 'callback'. Only single expressions (function reference, or object property function reference) are accepted as valid paddings.
rss - The response is an RSS feed (beta).


fts	Text search terms, as a user would enter in a Search: field.
cat	A product category. Only products within the category will be returned. The easiest way to find values for this parameter is to browse to a category on the ShopStyle website and take the last element of the URL path, e.g., from http://www.shopstyle.com/browse/dresses, use "dresses." Another way is to look at the categories of the products returned by the apiSearch or to look at the list of categories from apiGetCategoryHistogram.
fl	
Specify one or more filters on the query for brand, retailer, price, discount, and/or size. Each filter value has an initial letter and a numeric id. The easiest way to construct a filter list is to do a search on ShopStyle, select one or more filters in the UI, and copy the resulting URL. To convert brand or retailer names to ids, use the apiGetBrands and apiGetRetailers calls. Here is a sample URL showing sale clothing from two brands and one retailer:

http://www.shopstyle.com/browse/womens-clothes?fl=d0&fl=b3510&fl=b689&fl=r21

Filter prefixes are:

b - brand
r - retailer
p - price
d - sale
s - size
c - color
pdd	A "price drop date" expressed as a number of milliseconds since Jan 1, 1970. If present, limits the results to products whose price has dropped since the given date.
prodid	The id of a specific product to return. This may be specified multiple times to get many products in one response.

=end
    def do_search( params= {} )
      url= @yml[ 'base_url'].to_s
      search_url= @yml['search_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
      min_result= "min=" + ( params.include?(:min ) ? params[:min].to_s : 0.to_s )
      count="count=" + ( params.include?(:count) ? params[:count].to_s : 10.to_s)
    
      if params.include?(:term)
        search_term= "fts=" +  params[:term].split().join('+').to_s
        uri= URI.parse(URI.escape( url + search_url + [@pid, format, search_term, min_result, count].join('&')) )
        return Net::HTTP.get_response(  uri )
      else
        raise "No search term provided!"
      end
      
    end
    
=begin
find_product_by_id 
This method gets a single product matching the specified ID.
http://www.shopstyle.com/action/apiSearch?pid=uid9316-2194146-60&prodid=348703188

id The unique product ID for the product.

params The optional parameters. For this method, only :format is the only applicable parameter, with default value of "json". Supported values are:
xml - The response is in XML format with UTF-8 encoding. This is the default if the parameter is absent.
json - The response is in JSON format with UTF-8 encoding.
json2 - Same as json, but numbers and booleans are returned as JSON numbers and booleans instead of strings.
jsonvar - The response is in JSON format with UTF-8 encoding and includes a JavaScript assignment statement. This is useful when the API URL is the src attribute of a script tag, as the result is stored in a variable that can be used by subsequent JavaScript code.
jsonvar2 - Same as jsonvar, but numbers and booleans are returned as JSON numbers and booleans instead of strings.
jsonp - The response is in JSON format with UTF-8 encoding wrapped in a JavaScript method called padding. The padding must be specified with the query parameter 'callback'. Only single expressions (function reference, or object property function reference) are accepted as valid paddings.
rss - The response is an RSS feed (beta).

Response
A search result containing 0 or 1 items in 'products'.
=end
    def find_product_by_id(id, params = {})
      url= @yml[ 'base_url'].to_s
      search_url= @yml['search_url'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
      
      prod_id = "prodid=" + id.to_s
      uri= URI.parse( url + search_url + [@pid, format, prod_id].join('&') )
      return Net::HTTP.get_response(uri)
    end 
    
=begin
apiGetTrends
This method returns the popular brands for a given category along with a sample product for the brand-category combination.
http://www.shopstyle.com/action/apiGetTrends?pid=uid9316-2194146-60&cat=109
cat	Category you want to restrict the popularity search for. This is an optional parameter. If category is not supplied, all the popular brands regardless of category will be returned.
products	To skip sample products, just pass value 0 for this attribute. This is an optional attribute as well.
Response
A list of trends in the given category. Each trend has a brand, category, url, and optionally the top-ranked product for each brand/category.ÏÍ
=end
    def get_trends( params= {})
      url= @yml[ 'base_url'].to_s
      trends_url= @yml['trends_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      
      format= "format=" + (params.include?( :format) ? params[:format] : "json")
      
      uri=""
      if params.include?( :category)
        category_id= "cat=" +params[:category].to_s 
        uri= URI.parse( url + trends_url + [pid, format, category_id].join('&') )
      end
      
      if params.include?( :products)
        product_id= "products=" +params[:products].to_s 
        uri= URI.parse( url + trends_url + [@pid, format, product_id].join('&') )
      end
    
      return Net::HTTP.get_response( uri )
    end
  
    
=begin
This method does not return a reponse of XML or JSON data like the other elements of the API. Instead, it forwards the user to the retailer's product page for a given product. It is the typical behavior to offer when the user clicks on a product. The apiSearch method returns URLs that call this method for each of the products it returns.
http://www.shopstyle.com/action/apiVisitRetailer?pid=uid9316-2194146-60&id=27500798
id	The ID number of the product. An easy way to get a product's ID is to find the product somewhere in the ShopStyle UI and right-click on the product image. From the popup menu, select "Copy Link" ("Copy link location" or "Copy shortcut" depending on your browser) and paste that into any text editor. The "id" query parameter of that URL is the value to use for this API method.
=end
    def visit_retailer( params= {} )
      url= @yml[ 'base_url'].to_s
      visit_retailers_url= @yml['visit_retailers_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
      retailer_id= params[:retailer_id].to_s
    
      uri= URI.parse( url + visit_retailers_url + [@id, format, retailer_id].join('&') )
      return Net::HTTP.get_response(  uri )
    end
    
    
=begin
This method returns information about a particular look and its products.
http://api.shopstyle.com/action/apiGetLook?pid=uid9316-2194146-60&look=548347
look	The ID number of the look. An easy way to get a look's ID is to go to the Stylebook page that contains the look at the ShopStyle website and right-click on the button that you use to edit the look. From the popup menu, select "Copy Link" and paste that into any text editor. The "lookId" query parameter of that URL is the value to use for this API method.
Response
A single look, with title, description, a set of tags, and a list of products. The products have the fields listed above (see apiSearch).
=end
    def get_look( params= {} )
      url= @yml[ 'base_url'].to_s
      look_url= @yml['look_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
     
      if params.include?( :look )
        look= "look=" + params[ :look].to_s
        uri= URI.parse( url + look_url + [@pid, format, look].join( '&') )
        return Net::HTTP.get_response(  uri )
      else
        raise "No look type provided!"
      end
    end
    
=begin
This method returns information about looks that match different kinds of searches.
http://api.shopstyle.com/action/apiGetLooks?pid=uid9316-2194146-60&type=New&min=0&count=2
type	The type of search to perform. Supported values are:
New - Recently created looks.
TopRated - Recently created looks that are highly rated.
Celebrities - Looks owned by celebrity users.
Featured - Looks from featured stylebooks.
min	The index of the first product to return, or 0 (zero) if not specified. A client can use this to implement paging through large result sets.
count	The maximum number of results to return, or 10 if not specified. The maximum value is 50. Combine with the min parameter to implement paging.
Response
A list of looks of the given type. Each look has the fields listed above (see apiGetLook).
=end
    def get_looks( params= {})
      url= @yml[ 'base_url'].to_s
      looks_url= @yml['looks_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
      min_result= "min=" + ( params.include?(:min ) ? params[:min].to_s : 0.to_s )
      count="count=" + ( params.include?(:count) ? params[:count].to_s : 10.to_s)
  
      if params.include?( :type )
        look_type= "type=" + params[ :type].to_s
        uri= URI.parse( url + looks_url + [@pid, format, look_type, min_result, count].join('&') )
        return Net::HTTP.get_response(  uri )
      else
        raise "No look type provided!"
      end
    end


=begin
This method returns information about a particular user's Stylebook, the looks within that Stylebook, and the title and description associated with each look.
http://api.shopstyle.com/action/apiGetStylebook?pid=uid9316-2194146-60&handle=FabSugar
handle	The username of the Stylebook owner.
min	The index of the first look to return, or 0 (zero) if not specified. A client can use this to implement paging through large result sets.
count	The maximum number of results to return, or 20 if not specified. Requesting too many results may impact performance. Combine with the min parameter to implement paging.
Response
A look id of the user's Stylebook, the look id of each individual look within that Stylebook, and the title and description associated with each look.
=end
    def get_stylebook( params= {} )
      url= @yml[ 'base_url'].to_s
      stylebook_url= @yml['stylebook_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
      min_result= "min=" + ( params.include?(:min ) ? params[:min].to_s : 0.to_s )
      count="count=" + ( params.include?(:count) ? params[:count].to_s : 10.to_s)
      
      if params.include?( :handle)
        handle= "handle=" + params[:handle].to_s
        uri= URI.parse( url + stylebook_url + [@pid, format, handle].join('&') )
        return Net::HTTP.get_response(  uri )
      else
        raise "No handle provided!"
      end
    end

=begin
This method returns a list of brands that have live products. Brands that have very few products will be omitted.
http://api.shopstyle.com/action/apiGetBrands?pid=uid9316-2194146-60
Response
A list of all Brands, with id, name, url, and synonyms of each.
=end
    def get_brands(params= {})
      url= @yml[ 'base_url'].to_s
      brands_url= @yml[ 'brands_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
      uri= URI.parse( url + brands_url  + [@pid, format].join('&') )
      return Net::HTTP.get_response(  uri )
    end

    
=begin
This method returns a list of retailers that have live products.
http://api.shopstyle.com/action/apiGetRetailers?pid=uid9316-2194146-60
Response
A list of all Retailers, with id, name, and url of each.
=end
    def get_retailers( params= {} )
      url= @yml[ 'base_url'].to_s
      retailers_url= @yml['retailers_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")

      uri= URI.parse( url + retailers_url  + [@pid, format].join('&') )
      return Net::HTTP.get_response(  uri )
    end
    
    
=begin
This method returns a list of categories and product counts that describe the results of a given product query. The query is specified using the product query parameters.
http://api.shopstyle.com/action/apiGetCategoryHistogram?pid=uid9316-2194146-60&fts=tunic
Response
A list of Category objects. Each Category has an id, name, and count of the number of query results in that category.
=end
    def get_category_histogram( params= {})
      url= @yml[ 'base_url'].to_s
      category_histogram_url= @yml['category_histogram_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
    
            
      if params.include?( :term)
        search_term= "fts=" +  params[:term].split().join('+').to_s
        uri= URI.parse( url + category_histogram_url + [@pid, format,search_term].join('&') )
      end
      
      if params.include?( :cat)
        category_id= "cat=" +params[:category].to_s 
        uri= URI.parse( url + category_histogram_url + [@pid, format, category_id].join('&') )
      end
    
      if params.include?( :filter)
        filter=  "fl=" + params[:filter].to_s 
        uri= URI.parse( url + category_histogram_url + [@pid, format, filter].join('&') )
      end
      
      if params.include?( :price_drop_date)
        price_drop_date= "pdd=" + params[:price_drop_date].to_s 
        uri= URI.parse( url + category_histogram_url + [@pid, format,price_drop_date].join('&') )
      end
      
      
      if params.include?( :product_id )
        product_id= "prodic" + params[:product_id].to_s 
        uri= URI.parse( url + category_histogram_url + [@pid, format,product_id].join('&') )
      end
      
     
      return Net::HTTP.get_response(  uri )
    end

    
=begin
This method returns a list of filters and product counts that describe the results of a given product query. The query is specified using the product query parameters.
http://api.shopstyle.com/action/apiGetFilterHistogram?pid=2254&filterType=Retailer&fts=red+dress
filterType	The type of filter data to return. Possible values are Brand, Retailer, Price, Discount, Size and Color.
Response
A list of Filter objects of the given type. Each Filter has an id, name, and count of the number of results that apply to that filter.
=end    
    def get_filter_histogram( params= {})
      url= @yml[ 'base_url'].to_s
      filter_histogram_url= @yml['filter_histogram_url'].to_s
      #pid= "pid=" + @yml['pid'].to_s
      format= "format=" + ( params.include?( :format) ? params[:format].to_s : "json")
      
      if params.include?(:filter_type )
        filter_type="filterType=" + params[:filter_type].to_s
      else
        raise "No filter type provided"
      end
    
            
      if params.include?( :term)
        search_term= "fts=" +  params[:term].split().join('+').to_s
        uri= URI.parse( url + filter_histogram_url + [@pid, format,filter_type,search_term].join('&') )
      end
      
      if params.include?( :cat)
        category_id= "cat=" +params[:category].to_s 
        uri= URI.parse( url + filter_histogram_url + [@pid, format, filter_type,category_id].join('&') )
      end
    
      if params.include?( :filter)
        filter=  "fl=" + params[:filter].to_s 
        uri= URI.parse( url + filter_histogram_url + [@pid, format, filter_type ,filter].join('&') )
      end
      
      if params.include?( :price_drop_date)
        price_drop_date= "pdd=" + params[:price_drop_date].to_s 
        uri= URI.parse( url + filter_histogram_url + [@pid, format,filter_type, price_drop_date].join('&') )
      end
      
      
      if params.include?( :product_id )
        product_id= "prodic" + params[:product_id].to_s 
        uri= URI.parse( url + filter_histogram_url + [@pid, format,filter_type, product_id].join('&') )
      end
      
      return Net::HTTP.get_response(  uri )
    end

  end #class
end #module




   
