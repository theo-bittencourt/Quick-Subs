# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mechanize}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson", "Mike Dalessio"]
  s.date = %q{2010-02-08}
  s.description = %q{The Mechanize library is used for automating interaction with websites. 
Mechanize automatically stores and sends cookies, follows redirects,
can follow links, and submit forms.  Form fields can be populated and
submitted.  Mechanize also keeps track of the sites that you have visited as
a history.}
  s.email = ["aaronp@rubyforge.org", "mike.dalessio@gmail.com"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "EXAMPLES.rdoc", "FAQ.rdoc", "GUIDE.rdoc", "LICENSE.rdoc", "README.rdoc"]
  s.files = ["Manifest.txt", "CHANGELOG.rdoc", "EXAMPLES.rdoc", "FAQ.rdoc", "GUIDE.rdoc", "LICENSE.rdoc", "README.rdoc"]
  s.homepage = %q{http://mechanize.rubyforge.org}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mechanize}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{The Mechanize library is used for automating interaction with websites}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.2.1"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.2.1"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.2.1"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
