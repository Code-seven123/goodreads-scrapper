require "httparty"
require "oga"
require "uri"

class Quotes
  include HTTParty
  base_uri "www.goodreads.com"
  def search(tag)
    parse = self.class.get("/quotes/tag/#{tag}")
    document = Oga.parse_html(parse.body)
    selected_divs = document.xpath('//div[contains(@class, "quote") and contains(@class, "mediumText")]')

    data = []
    selected_divs.each do |div|
      text = div.xpath('//div[@class="quoteText"]')
      data.push(text.map(&:to_xml))
    end
    item = Oga.parse_html(data.join("\n"))
    quotes = item.css('.quoteText').map { |div| div.text.strip }

    authors_titles = item.css('span.authorOrTitle').map { |a| a.text.strip }

    result = []
    quotes.each_with_index do |quote, index|
      filter = quote.scan(/“(.*?)”/).flatten
      text = "\"#{filter[0]}\""
      author = authors_titles[index]
      result.push({ "quote" => text, "author" => author })
    end
    return result
  end
  def paginate(tag, length)
    data = self.search(tag)
    chunk = []
    data.each_slice(length) do |array|
      chunk.push(array)
    end
    return chunk
  end
  def limit(tag, length)
    data = self.search(tag)
    return data.take(length)
  end
end
