# Recursively crawls through a directory and deletes singular duplicate files.
# Useful for when you accidentally hit "Consolidate files" on your entire iTunes library.
# THIS IS A POTENTIALLY DESTRUCTIVE SCRIPT -- keep $MAX_FILES_TO_DELETE low (10) at first
# to get a feel for the exact files it's deleting -- MAKE SURE THEY ARE THE RIGHT ONES.


                    ####################################
                    # NO WARRANTY - EXPRESS OR IMPLIED #
                    #       RUN AT YOUR OWN RISK!      #
                    ####################################


# Configuration
$TARGET_DIR = '/Users/dennis/Dropbox/Music' # the directory to process
$MAX_FILES_TO_DELETE = 10                   # the maximum amount of files it will delete (best to cap at 10 initially, then 1000)
$DUPLICATE_INDICATOR = ' 1'                 # the suffix indicating a duplicate (if it finds "Ahiga.mp3", it will try to delete "Ahiga$DUPLICATE_INDICATOR.mp3")


# End configuration
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
                dup_file_path = cur_path[0...dot_index] + $DUPLICATE_INDICATOR + cur_path[dot_index...cur_path.length]
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