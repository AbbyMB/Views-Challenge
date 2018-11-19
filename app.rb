require "json"
require "pry"

data = File.read('./views.json')
json_data = JSON.parse(data)

puts "Enter View Information"
user_input = gets.chomp
input_type = ""

if user_input[0] == "."
  input_type = "classNames"
  user_input = user_input.tr('.','')
elsif user_input[0] == "#"
  input_type = "identifier"
  user_input = user_input.tr('#','')
else
  input_type = "class"
end


def check_subviews(data, input_type, user_input, views)
  if input_type == "classNames"
    if data[input_type]&.include?(user_input)
      views << data
    end
  elsif data[input_type] == user_input
    views << data
  end

  if data["contentView"]
    data["contentView"]["subviews"].each do |subview|
      views += check_subviews(subview, input_type, user_input, [] )
    end
  end

  if data["contentView"]
    data["contentView"]["subviews"].each do |subview|
      if subview["control"]
        views += check_subviews(subview["control"], input_type, user_input, [] )
      end
    end
  end

  if data["subviews"]
    data["subviews"].each do |subview|
      views += check_subviews(subview, input_type, user_input, [] )
    end
  end

  views
end

selected_views = check_subviews(json_data, input_type, user_input, [])
puts selected_views
puts selected_views.length
