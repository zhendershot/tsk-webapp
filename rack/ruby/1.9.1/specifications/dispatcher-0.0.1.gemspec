# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dispatcher"
  s.version = "0.0.1"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian MacLeod"]
  s.autorequire = "dispatcher"
  s.cert_chain = nil
  s.date = "2006-10-08"
  s.description = "Dispatcher provides a simple and consistent interface between Ruby and most webserver configurations. It is typically used in conjunction with a request-building system, such as the Responder gem."
  s.email = "imacleod@gmail.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.txt", "TODO.txt"]
  s.files = ["LICENSE.txt", "README.txt", "TODO.txt"]
  s.homepage = "http://dispatcher.rubyforge.org/"
  s.rdoc_options = ["--title", "Dispatcher", "--main", "README.txt"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = "dispatcher"
  s.rubygems_version = "1.8.11"
  s.summary = "A lightweight HTTP dispatch interface between Ruby and most webserver configurations."

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
