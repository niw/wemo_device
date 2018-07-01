lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = "wemo_device"
  spec.version = "0.1.0"
  spec.authors = ["Yoshimasa Niwa"]
  spec.email = ["niw@niw.at"]
  spec.summary = spec.description = "Generate Sparkle appcast.xml"
  spec.homepage = "https://github.com/niw/wemo_device"
  spec.license = "MIT"
  spec.metadata = {
    "source_code_uri" => "https://github.com/niw/wemo_device"
  }

  spec.extra_rdoc_files = `git ls-files -z -- README* LICENSE`.split("\x0")
  example_files = `git ls-files -z -- examples/*`.split("\x0")
  spec.files = `git ls-files -z -- lib/*`.split("\x0") + spec.extra_rdoc_files + example_files

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
