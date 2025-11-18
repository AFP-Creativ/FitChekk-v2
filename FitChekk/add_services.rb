require 'xcodeproj'

project_path = 'FitChekk.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target_name = 'FitChekk'
target = project.targets.find { |t| t.name == target_name }

if target.nil?
  puts "Error: Target #{target_name} not found"
  exit 1
end

# Define files to add and their group paths
files_to_add = {
  'FitChekk/Services/Weather/WeatherService.swift' => ['FitChekk', 'Services', 'Weather'],
  'FitChekk/Services/AI/OutfitService.swift' => ['FitChekk', 'Services', 'AI'],
  'FitChekk/Services/AI/CategorizationService.swift' => ['FitChekk', 'Services', 'AI'],
  'FitChekk/Services/AI/PortkeyService.swift' => ['FitChekk', 'Services', 'AI'],
  'FitChekk/Services/Data/DatabaseService.swift' => ['FitChekk', 'Services', 'Data'],
  'FitChekk/Services/Data/DatabaseServiceDTOs.swift' => ['FitChekk', 'Services', 'Data'],
  'FitChekk/Services/Data/StorageService.swift' => ['FitChekk', 'Services', 'Data'],
  'FitChekk/Services/Data/SyncService.swift' => ['FitChekk', 'Services', 'Data'],
  'FitChekk/Services/Image/BackgroundRemovalService.swift' => ['FitChekk', 'Services', 'Image'],
  'FitChekk/Services/Image/ImageService.swift' => ['FitChekk', 'Services', 'Image']
}

files_to_add.each do |file_path, group_path|
  # Navigate to the group
  current_group = project.main_group
  group_path.each do |group_name|
    current_group = current_group[group_name] || current_group.new_group(group_name)
  end

  file_name = File.basename(file_path)
  
  # Check if file is already in group
  existing_file = current_group.files.find { |f| f.path == file_name }
  
  if existing_file
    puts "File #{file_name} already exists in group"
    file_ref = existing_file
  else
    puts "Adding #{file_name} to group #{group_path.join('/')}"
    file_ref = current_group.new_file(file_name)
  end

  # Add to target
  unless target.source_build_phase.files_references.include?(file_ref)
    puts "Adding #{file_name} to target #{target_name}"
    target.add_file_references([file_ref])
  else
    puts "File #{file_name} already in target"
  end
end

project.save
puts "Project saved"
