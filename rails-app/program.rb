def modify_file(path)
  puts "Modifying file..."
  return unless File.exists? path

  old_content = File.read(path)
  File.open(path, 'w') { |file| file.write old_content }

  puts "File modified"
  sleep 3
end

$stdout.sync = true

modify_file('app/controllers/posts_controller.rb')
modify_file('app/controllers/posts_controller.rb')
sleep 8.5

puts File.read('output.log').gsub '[H[J', ''
File.delete('output.log')


