require 'rest-client'
require 'json'

def lookup(word)
  response = RestClient.get "https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{word}?key=<your_api_key_here>"
  result = JSON.parse(response.body)[0]
  definitions = result["shortdef"].join("\n")

  puts "English-English result:"
  puts "#{word}: #{definitions}"

  puts "\nChinese result:"
  puts "<insert Chinese translation here>"
end

lookup(ARGV[0])
