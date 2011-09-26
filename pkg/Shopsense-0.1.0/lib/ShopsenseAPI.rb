class ShopsenseAPI
  
  @has_load_config= false
  
  def initialize
    
  end


=begin
Loads the YAML configuration file
=end
  def load_config( yml_config_filename )
    @yml= YAML::load_file( yml_config_filename )
    
    return @yml.nil ? 'shopsense.yml not loaded' : @yml
  end
  
  def do_search( yml, term, mres, mcount )
    url= yml[ 'base_url'].to_s
    search_url= yml['search_url'].to_s
    pid= "pid=" + yml['pid'].to_s
    format= "format=" + "json"
    search_term= "fts=" + term.split().join('+').to_s
    min_result= "min=" + mres.to_s
    count="count=" + mcount.to_s
    
    uri= URI.parse ( url + search_url + [pid, format, search_term, min_result, count].join('&') )
    return Net::HTTP.get_response(  uri )
  end
end