require "uri"

broken = []

Dir.glob("**/*.md").sort.each do |file|
  next if file.start_with?("my-work/")

  File.read(file).scan(/\[[^\]]*\]\(([^)]+)\)/).flatten.each do |link|
    next if link.match?(/\A(?:https?:|mailto:|#)/)

    raw_path = link.split("#", 2).first
    begin
      raw_path = URI.decode_www_form_component(raw_path)
    rescue ArgumentError
      # Оставляем исходный путь: ниже он будет отмечен как битая ссылка.
    end

    target = File.expand_path(raw_path, File.dirname(file))
    broken << "#{file} -> #{link}" unless File.exist?(target)
  end
end

if broken.empty?
  puts "Битых локальных Markdown-ссылок нет."
  exit 0
end

puts "Найдены битые локальные Markdown-ссылки:"
broken.each { |item| puts "- #{item}" }
exit 1
