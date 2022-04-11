#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb | qsv select item,name,position > scraped.csv

cd ~-
