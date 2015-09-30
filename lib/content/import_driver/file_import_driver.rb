module Content
  class ImportDriver
    class FileImportDriver < Content::ImportDriver
      def run
        load "#{Rails.root}/Rakefile"
        [Date.current.in_time_zone - 1.day, Date.current.in_time_zone].each do |date|
          ENV['DATE'] = date.to_s(:iso)
          Rake::Task["content:gpo_images:convert_eps"].invoke
        end
      end

      def lockfile_name
        "eps_file_import_driver.lock"
      end
    end
  end
end
