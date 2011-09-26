# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Shopsense}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Wagied Davids}]
  s.date = %q{2011-09-26}
  s.email = %q{w2davids@gmail.com}
  s.extra_rdoc_files = [%q{README}]
  s.files = [%q{LICENSE}, %q{README}, %q{ShopSense-API.README}, %q{test/test_shopsense.rb}, %q{lib/main.rb}, %q{lib/shopsense.rb}, %q{lib/shopsense.yml}, %q{lib/ShopsenseAPI.rb}]
  s.homepage = %q{http://yoursite.example.com}
  s.rdoc_options = [%q{--main}, %q{README}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Shopsense ruby API}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
