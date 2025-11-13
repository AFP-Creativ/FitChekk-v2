#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'FitChekk.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main target
target = project.targets.first

# Get the Features/Outfits group
features_group = project.main_group.find_subpath('FitChekk/Features')
outfits_group = features_group.find_subpath('Outfits')

# Files to add
files_to_add = [
  'FitChekk/Features/Outfits/OutfitsFeature.swift',
  'FitChekk/Features/Outfits/OutfitsView.swift',
  'FitChekk/Features/Outfits/OutfitCreationFeature.swift',
  'FitChekk/Features/Outfits/OutfitCreationView.swift',
  'FitChekk/Features/Outfits/OutfitDetailFeature.swift',
  'FitChekk/Features/Outfits/OutfitDetailView.swift',
  'FitChekk/Features/Outfits/OutfitEditFeature.swift',
  'FitChekk/Features/Outfits/OutfitEditView.swift'
]

files_to_add.each do |file_path|
  # Check if file exists
  full_path = File.join(Dir.pwd, file_path)
  unless File.exist?(full_path)
    puts "⚠️  File not found: #{file_path}"
    next
  end

  # Check if already added to target
  file_ref = outfits_group.files.find { |f| f.path == File.basename(file_path) }
  
  if file_ref.nil?
    puts "❌ File reference not found in group: #{file_path}"
    next
  end

  # Check if already in build phase
  build_file = target.source_build_phase.files.find { |bf| bf.file_ref == file_ref }
  
  if build_file
    puts "✓ Already added: #{File.basename(file_path)}"
  else
    # Add to compile sources
    target.source_build_phase.add_file_reference(file_ref)
    puts "✅ Added to target: #{File.basename(file_path)}"
  end
end

# Save the project
project.save
puts "\n✨ Project saved successfully!"

