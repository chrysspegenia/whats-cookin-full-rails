class RecipeService
    require 'nokogiri'
    require 'faraday'
  
    def self.fetch_recipe_instructions(recipe_url, recipe_name, ingredients)
        # Rails.logger.debug "Fetching instructions for #{recipe_name} from #{recipe_url}"
        recipe_data = fetch_recipe_data(recipe_url)
        instructions = recipe_data[:instructions]

        if instructions.empty?
            instructions = generate_instructions(recipe_name, ingredients)
        else
            # Initialize Gemini API client
            gemini_client = Gemini::V1::Client.new

            # Call Gemini API to organize existing instructions
            organized_instructions = gemini_client.organize_cooking_instructions(instructions)

            if organized_instructions.nil? || organized_instructions.empty?
            Rails.logger.debug "Failed to organize existing instructions. Returning original instructions."
            else
            instructions = organized_instructions
            end
        end

        instructions
    end

      
  
    private
  
    def self.generate_instructions(recipe_name, ingredients)
        gemini_client = Gemini::V1::Client.new
      
        # Call Gemini API to generate instructions
        generated_instructions = gemini_client.generate_cooking_instructions(recipe_name, ingredients)
      
        if generated_instructions.nil? || generated_instructions.empty?
          # If Gemini API fails to generate instructions, return an empty array
          []
        else
          # If Gemini API returns instructions, return them
          generated_instructions
        end
      end
      
    
    def self.fetch_recipe_data(recipe_url)
      conn = Faraday.new(url: recipe_url)
      response = conn.get
      html_content = response.body
  
      doc = Nokogiri::HTML(html_content)
  
      title_element = doc.at_css('title')
      title = title_element ? title_element.text : "No title found"
      
      instructions = extract_instructions(doc)
  
      {
        title: title,
        instructions: instructions
      }
    rescue => e
      Rails.logger.error "Error fetching recipe data: #{e.message}"
      { title: "Error", instructions: [], error: e.message }
    end
  
    def self.extract_instructions(doc)
      instruction_selectors = [
        '[id*="instructions"]', 
        '[class*="instructions"]', 
        'section[id*="instructions"]', 
        'div[class*="instructions"]', 
        'section[class*="instructions"]', 
        'div[id*="recipe-instructions"]', 
        'ol[class*="instruction-list"]', 
        'ul[class*="instruction-list"]',
        '[id*="steps"]', 
        '[class*="steps"]', 
        'section[id*="steps"]', 
        'div[class*="steps"]', 
        'section[class*="steps"]', 
        'div[id*="recipe-steps"]', 
        'ol[class*="recipe-steps-list"]', 
        'ul[class*="recipe-steps-list"]',
        '[id*="directions"]', 
        '[class*="directions"]', 
        'section[id*="directions"]', 
        'div[class*="directions"]', 
        'section[class*="directions"]', 
        'div[id*="recipe-directions"]', 
        'ol[class*="recipe-directions-list"]', 
        'ul[class*="recipe-directions-list"]',
        '[id*="method"]', 
        '[class*="method"]', 
        'section[id*="method"]', 
        'div[class*="method"]', 
        'section[class*="method"]', 
        'div[id*="recipe-method"]', 
        'ol[class*="recipe-method-list"]',
        'ul[class*="recipe-method-list"]'
      ]
  
      instructions = [] 
  
      instruction_selectors.each do |selector|
        elements = doc.css(selector)
        next if elements.empty?
  
        elements.each do |element|
          element.text.strip.split("\n").each do |line|
            cleaned_line = line.strip
            next if cleaned_line.empty?
            instructions << cleaned_line
          end
        end
        break unless instructions.empty?
      end
  
      # Fallback to XPath if no instructions found
      if instructions.empty?
        xpath_selectors = [
          '//*[contains(@id, "instructions") or contains(@class, "instructions")]',
          '//*[contains(@id, "steps") or contains(@class, "steps")]',
          '//*[contains(@id, "directions") or contains(@class, "directions")]',
          '//*[contains(@id, "method") or contains(@class, "method")]'
        ]
        
        xpath_selectors.each do |xpath|
          doc.xpath(xpath).each do |node|
            node.text.strip.split("\n").each do |line|
              cleaned_line = line.strip
              next if cleaned_line.empty?
              instructions << cleaned_line
            end
          end
          break unless instructions.empty?
        end
      end
  
      instructions
    end
  end
  