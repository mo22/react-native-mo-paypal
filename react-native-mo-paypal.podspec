require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |spec|
  name = package['name']
  spec.name = name
  spec.version = package['version']
  spec.summary = package['description'] or "none"
  spec.homepage = package['homepage'] or "none"
  spec.license = package['license']
  spec.authors = package['author']
  spec.source = { :git => package['repository']['url'], :tag => 'main' }

  spec.platform = :ios, "9.0"
  spec.source_files = "ios/**/*.{h,m}"
  spec.dependency "React-Core"
  spec.dependency "PayPalCheckout"
end
