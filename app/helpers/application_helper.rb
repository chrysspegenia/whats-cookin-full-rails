module ApplicationHelper
    
    def limit_decimal_places(number, decimal_places = 2)
        number = number.to_f
        format("%.#{decimal_places}f", number)
      end

      def split_string(str)
        str.chars
      end
      
      
end
