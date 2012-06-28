#!/usr/bin/env ruby
$:.unshift File.expand_path("..", __FILE__)
require 'yaml_to_tmlanguage_translator'

source_path = ARGV[0]
target_path = File.join(File.dirname(ARGV[0]), File.basename(ARGV[0]).gsub(/\.yml$/, ''))

source_file = File.open(source_path, "rb")
xml_string = YamlToTmLanguageTranslator.new.translate(source_file.read)

target_file = File.new(target_path, "w")
target_file.write(xml_string)
target_file.close