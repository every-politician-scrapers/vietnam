#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def zeropad
    rjust(2, '0')
  end
end

# Vietnamese dates
class Vietnamese < WikipediaDate
  def to_s
    date_str.to_s.gsub('đương nhiệm', '').gsub('tháng', '').gsub('năm', '').gsub(',', '').tidy.gsub(' ', '-').split('-').reverse.map(&:zeropad).join('-')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Nhiệm kỳ'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name start end].freeze
    end

    def date_class
      Vietnamese
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
