#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def zeropad
    rjust(2, '0')
  end
end

class Slashed < WikipediaDate
  def to_s
    date_str.to_s.gsub('nay', '').tidy.split('/').reverse.map(&:zeropad).join('-')
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
      %w[no name dates].freeze
    end

    def date_class
      Slashed
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
