# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sprockets}
  s.version = "2.0.0.beta.2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Sam Stephenson}, %q{Joshua Peek}]
  s.date = %q{2011-05-02}
  s.description = %q{Sprockets is a Rack-based asset packaging system that concatenates and serves JavaScript, CoffeeScript, CSS, LESS, Sass, and SCSS.}
  s.email = %q{sstephenson@gmail.com}
  s.homepage = %q{http://getsprockets.org/}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{sprockets}
  s.rubygems_version = %q{1.8.3}
  s.summary = %q{Rack-based asset packaging system}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hike>, ["~> 1.0"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.0"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.0"])
      s.add_development_dependency(%q<coffee-script-source>, ["~> 1.0"])
    else
      s.add_dependency(%q<hike>, ["~> 1.0"])
      s.add_dependency(%q<rack>, ["~> 1.0"])
      s.add_dependency(%q<tilt>, ["~> 1.0"])
      s.add_dependency(%q<coffee-script-source>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<hike>, ["~> 1.0"])
    s.add_dependency(%q<rack>, ["~> 1.0"])
    s.add_dependency(%q<tilt>, ["~> 1.0"])
    s.add_dependency(%q<coffee-script-source>, ["~> 1.0"])
  end
end
