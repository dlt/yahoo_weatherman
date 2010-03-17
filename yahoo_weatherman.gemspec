Gem::Specification.new do |gem|
  gem.name = "yahoo_weatherman"
  gem.version = "0.3"
  gem.authors = ["Dalto Curvelano Junior"]
  gem.description = "A ruby wrapper to the Yahoo! Weather feed with i18n support."
  gem.summary = "A ruby wrapper to the Yahoo! Weather feed with i18n support."
  gem.files = [
    "yahoo_weatherman.gemspec",
    "lib/yahoo_weatherman/image.rb", "lib/yahoo_weatherman/response.rb", "lib/yahoo_weatherman.rb",
    "i18n/pt-br.yml", "spec/files/belo_horizonte.rss", "spec/spec_helper.rb",
    "spec/yahoo_weatherman/response_spec.rb", "spec/yahoo_weatherman/yahoo_weatherman_spec.rb"
  ]
  gem.homepage = "http://github.com/dlt/yahoo_weatherman"
end
