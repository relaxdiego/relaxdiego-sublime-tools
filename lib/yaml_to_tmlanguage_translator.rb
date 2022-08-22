require 'rexml/document'
require 'yaml'

class YamlToTmLanguageTranslator
  def translate(yml, indent = -1)
    xml = REXML::Document.new(
        <<-EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        </plist>
        EOF
    )
    xml.root << load_and_dump(yml)
    output = ''
    xml.write output, indent
    output
  end

  private

  def load_and_dump(yml)
    return '' if yml.strip.empty?
    obj = YAML::load(yml)
    dump obj
  end

  def dump(obj)
    if obj.class == Hash
      output = REXML::Element.new "dict"
      obj.each do |key, value|
        key_el = REXML::Element.new "key"
        key_el.text = key
        output << key_el
        output << dump(value)
      end
    elsif obj.class == String
      output = REXML::Element.new "string"
      output.add_text obj
    elsif obj.class == Array
      output = REXML::Element.new "array"

      obj.each do |value|
        output << dump(value)
      end
    end

    output || REXML::Text.new("")
  end

end
