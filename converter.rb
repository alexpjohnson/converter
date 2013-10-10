require 'json'
require 'csv'


class Converter
	# This can be modified to add different models.
	def run(file, model, end_type)
		puts "Starting parsing on file: #{file} to type #{end_type}"
		case model
		when 'stock_item'
			parse_stock_item(file)
		else
		end
	end

	def parse_stock_item(file)
		# This is a pretty basic CSV parser that makes the assumption that the data isn't malformed. Handling those exceptions would be tough since I'm not sure
		# what a valid stock item looks like or what is or is not a valid modifier.
		IO.readlines(file).each do |row|
			arr = row.split(',')
			s = StockItem.new(arr[0], arr[1], arr[2], arr[3], arr[4].strip)
			s.modify_quantity(arr[5].strip) if arr[5]
			if arr.length > 6
				for i in (6..arr.length-1).step(2)
					s.add_modifier arr[i],arr[i+1].strip
				end
			end
			puts s.to_json
		end
	end

	private :parse_stock_item
end

#The stock item has basic getters/setters and a to_json method
class StockItem
	def initialize(item_id, description, price, cost, price_type)
		@item_id = item_id
		@description = description
		@price = price
		@cost = cost
		@price_type = price_type
		@quantity_on_hand = nil
		@modifiers = []
	end

	def modify_quantity(quantity)
		@quantity_on_hand = quantity
	end

	def add_modifier(name, price)
		@modifiers << {'name' => name, 'price' => price}
	end

	def to_json
		{'item_id' => @item_id, 'description' => @description, 'price' => @price, 'cost' => @cost, 'price_type' => @price_type, 'quantity_on_hand' => @quantity_on_hand, 'modifiers' => @modifiers}
	end
end

Converter.new.run('test.txt', 'stock_item', 'json')