#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'
require 'wikidata_ids_decorator'

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath('//table[.//th[contains(.,"Portrait")]][1]//tr[td[a]]')
    end
  end

  class Member
    field :item do
      tds[2].css('a/@wikidata').map(&:text).first
    end

    field :name do
      tds[2].css('a').map(&:text).map(&:tidy).first
    end

    field :position do
      tds[0].css('a').map(&:text).last
    end

    private

    def tds
      noko.css('td,th')
    end
  end
end

url = 'https://en.wikipedia.org/wiki/Government_of_Vietnam'
puts EveryPoliticianScraper::ScraperData.new(url).csv
