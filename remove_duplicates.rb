# Recursively crawls through a directory and deletes singular mac-style duplicate files.
# Useful for when you accidentally hit "Consolidate files" on your entire iTunes library.
# THIS IS A POTENTIALLY DESTRUCTIVE SCRIPT -- keep $MAX_FILES_TO_DELETE low at first to 
# get a feel for the exact files it's deleting -- MAKE SURE THEY ARE THE RIGHT ONES.
$TARGET_DIR = "/Users/dennis/Dropbox/Music"
$MAX_FILES_TO_DELETE = 10
$dups = []

def process_dir(dir_raw)
    dir = dir_raw.to_a
    dir.each.with_index { |f, index|
        break if $dups.count > $MAX_FILES_TO_DELETE
        next if f == '.' || f == '..'

        cur_path = "#{dir_raw.path}/#{f}"
        if Dir.exists?(cur_path)
            process_dir(Dir.new(cur_path))
        else
            # process file. check for duplicate, etc
            dot_index = cur_path.rindex('.')

            unless dot_index.nil?
                dup_file_path = cur_path[0...dot_index] + ' 1' + cur_path[dot_index...cur_path.length]
                $dups << dup_file_path unless dir.find_index(File.basename(dup_file_path)).nil?
            end
        end
    }
end

target_dir = Dir.new($TARGET_DIR)

process_dir(target_dir)

p $dups
count = File.delete(*$dups)
p "Deleted #{count} files"