require 'rexml/document'
require 'yaml'

class YamlToTmLanguageTranslator
  def translate(yml)
    xml = <<-EOF
          <?xml version="1.0" encoding="UTF-8"?>
              <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
              <plist version="1.0">
                #{ load_and_dump(yml) }
              </plist>
          EOF
    output = ''
    REXML::Document.new(xml).write output
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
      output = "<dict>"
      obj.each do |key, value|
        output << "<key>#{ key }</key>"
        output << dump(value)
      end
      output << "</dict>"
    elsif obj.class == String
      output = "<string>#{ obj }</string>"
    elsif obj.class == Array
      output = "<array>"

      obj.each do |value|
        output << dump(value)
      end

      output << "</array>"
    end

    output || ''
  end

end