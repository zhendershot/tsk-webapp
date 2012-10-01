# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dispatcher}
  s.version = "0.0.1"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ian MacLeod}]
  s.autorequire = %q{dispatcher}
  s.cert_chain = nil
  s.date = %q{2006-10-07}
  s.description = %q{Dispatcher provides a simple and consistent interface between Ruby and most webserver configurations. It is typically used in conjunction with a request-building system, such as the Responder gem.}
  s.email = %q{imacleod@gmail.com}
  s.extra_rdoc_files = [%q{LICENSE.txt}, %q{README.txt}, %q{TODO.txt}]
  s.files = [%q{LICENSE.txt}, %q{README.txt}, %q{TODO.txt}]
  s.homepage = %q{http://dispatcher.rubyforge.org/}
  s.rdoc_options = [%q{--title}, %q{Dispatcher}, %q{--main}, %q{README.txt}]
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{dispatcher}
  s.rubygems_version = %q{1.8.3}
  s.summary = %q{A lightweight HTTP dispatch interface between Ruby and most webserver configurations.}

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
