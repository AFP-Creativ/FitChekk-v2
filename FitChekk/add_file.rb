require 'xcodeproj'

project_path = 'FitChekk.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target_name = 'FitChekk'
target = project.targets.find { |t| t.name == target_name }

if target.nil?
  puts "Error: Target #{target_name} not found"
  exit 1
end

# Find the group
# FitChekk -> Features -> Home
fitchekk_group = project.main_group['FitChekk']
features_group = fitchekk_group['Features']
home_group = features_group['Home']

if home_group.nil?
  puts "Error: Home group not found"
  # Try to find it recursively or create it?
  # Based on pbxproj, it exists.
  exit 1
end

file_name = 'HomeView.swift'
file_path = 'HomeView.swift' # Relative to the group's path which is 'Home'

# Check if file is already in group
existing_file = home_group.files.find { |f| f.path == file_name }

if existing_file
  puts "File #{file_name} already exists in group"
  file_ref = existing_file
else
  puts "Adding #{file_name} to group"
  # The file is physically at FitChekk/Features/Home/HomeView.swift
  # The group 'Home' has path 'Home' relative to 'Features'
  # 'Features' has path 'Features' relative to 'FitChekk'
  # 'FitChekk' has path 'FitChekk' relative to project root.
  # So 'Home' group path is effectively FitChekk/Features/Home
  
  # We can just add the file to the group.
  file_ref = home_group.new_file(file_name)
end

# Add to target
unless target.source_build_phase.files_references.include?(file_ref)
  puts "Adding #{file_name} to target #{target_name}"
  target.add_file_references([file_ref])
else
  puts "File #{file_name} already in target"
end

project.save
puts "Project saved"
