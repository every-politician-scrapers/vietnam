#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class Slashed < WikipediaDate
  def to_s
    date_str.to_s.gsub('nay', '').tidy.split('/').reverse.map(&:zeropad2).join('-')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Hình'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name dates].freeze
    end

    def date_class
      Slashed
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
