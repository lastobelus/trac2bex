require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "trac2bex"
    gem.summary = %Q{utilities for pulling tickets from trac+agilo into Billings 3}
    gem.email = "lastobelus@mac.com"
    gem.homepage = "http://github.com/lastobelus/trac2bex"
    gem.authors = ["Michael Johnston"]
    gem.description = %Q{utilities for pulling tickets from trac+agilo into Billings 3.}
    gem.files = %w{
      lib/trac2bex/billings/billings.rb
      lib/trac2bex/billings/timeslip.rb
      lib/trac2bex/billings/timeslip_array.rb
      lib/trac2bex/trac/agilo/repository.rb
      lib/trac2bex/trac/repository.rb
      lib/trac2bex/translator.rb
      lib/trac2bex.rb
    }
    gem.add_dependency 'plist', '~> 3.0.0'
    gem.add_dependency 'fastercsv', '~> 1.4.0'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "trac2bex #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

