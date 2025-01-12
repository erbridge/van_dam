class LibraryScanJob < ApplicationJob
  queue_as :default

  def perform(library)
    # For each directory in the library, create a model
    all_3d_files = Dir.glob([
      File.join(library.path, "**", "*.stl"),
      File.join(library.path, "**", "*.obj")
    ])
    model_folders = all_3d_files.map { |f| File.dirname(f) }.uniq
    model_folders = model_folders.map { |f| f.gsub(/\/files$/, "").gsub(/\/images$/, "") }.uniq # Ignore thingiverse subfolders
    model_folders.each do |path|
      relative_path = path.gsub(library.path, "")
      next if relative_path.blank? # For now, ignore files in the root
      model = library.models.find_or_create_by(name: File.basename(relative_path).humanize.tr("+", " ").titleize, path: relative_path)
      ModelScanJob.perform_later(model)
    end
  end
end
