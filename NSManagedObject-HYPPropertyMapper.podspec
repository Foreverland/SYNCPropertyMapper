Pod::Spec.new do |s|
  s.name = "NSManagedObject-HYPPropertyMapper"
  s.version = "4.1.3"
  s.summary = "Mapping your Core Data objects with your JSON providing backend has never been this easy"
  s.description = <<-DESC
                   * Mapping your Core Data objects with your JSON providing backend has never been this easy
                   DESC
  s.homepage = "https://github.com/SyncDB/NSManagedObject-HYPPropertyMapper"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author           = { "SyncDB" => "syncdb.contact@gmail.com" }
  s.social_media_url = "https://twitter.com/Sync_DB"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.source           = { :git => "https://github.com/SyncDB/NSManagedObject-HYPPropertyMapper.git", :tag => s.version.to_s }
  s.source_files = 'Sources'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
