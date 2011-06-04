# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{activeresource}
  s.version = "3.1.0.beta1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.date = %q{2011-05-04}
  s.description = %q{REST on Rails. Wrap your RESTful web app with Ruby classes and work with them like Active Record models.}
  s.email = %q{david@loudthinking.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = %q{http://www.rubyonrails.org}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = %q{activeresource}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{REST modeling framework (part of Rails).}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 3.1.0.beta1"])
      s.add_runtime_dependency(%q<activemodel>, ["= 3.1.0.beta1"])
    else
      s.add_dependency(%q<activesupport>, ["= 3.1.0.beta1"])
      s.add_dependency(%q<activemodel>, ["= 3.1.0.beta1"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 3.1.0.beta1"])
    s.add_dependency(%q<activemodel>, ["= 3.1.0.beta1"])
  end
end