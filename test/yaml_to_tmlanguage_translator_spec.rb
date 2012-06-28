require_relative 'spec_helper'
require 'yaml_to_tmlanguage_translator'

describe YamlToTmLanguageTranslator do
  
  it "must translate an empty file" do
    output = translate <<-EOF
             EOF
    xml    = prepare <<-EOF
              <?xml version="1.0" encoding="UTF-8"?>
              <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
              <plist version="1.0">
              </plist>
             EOF
    output.must_equal xml 
  end

  it "must translate a string value" do
    output = translate <<-EOF
               name: RSpeak
             EOF
    xml    = prepare <<-EOF
             <?xml version="1.0" encoding="UTF-8"?>
             <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
             <plist version="1.0">
               <dict>
                 <key>name</key>
                 <string>RSpeak</string>
               </dict>
             </plist>
             EOF
    output.must_equal xml 
  end

  it "must translate an array value" do
    output = translate <<-EOF
               patterns:
                         - name: whatever
                         - match: another
             EOF
    xml    = prepare <<-EOF
             <?xml version="1.0" encoding="UTF-8"?>
             <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
             <plist version="1.0">
               <dict>
                 <key>patterns</key>
                 <array>
                    <dict>
                      <key>name</key>
                      <string>whatever</string>
                    </dict>
                    <dict>
                      <key>match</key>
                      <string>another</string>
                    </dict>
                 </array>
               </dict>
             </plist>
             EOF
    output.must_equal xml 
  end

  it "must translate a whole file" do
    output  = translate <<-EOF
                name:       RSpeak
                uuid:       6e201089-c5b9-4ccd-9105-493e660ead50
                scopeName:  source.rspeak
                fileTypes: 
                            - requirements
                patterns:
                            - comment: Group name
                              name:    keyword.rspeak
                              match:   ===+

              EOF
    xml       = prepare <<-EOF
                 <?xml version="1.0" encoding="UTF-8"?>
                 <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                 <plist version="1.0">
                   <dict>
                     <key>name</key>
                     <string>RSpeak</string>
                     <key>uuid</key>
                     <string>6e201089-c5b9-4ccd-9105-493e660ead50</string>
                     <key>scopeName</key>
                     <string>source.rspeak</string>
                     <key>fileTypes</key>
                     <array>
                      <string>requirements</string>
                     </array>
                     <key>patterns</key>
                     <array>
                      <dict>
                        <key>comment</key>
                        <string>Group name</string>
                        <key>name</key>
                        <string>keyword.rspeak</string>
                        <key>match</key>
                        <string>===+</string>
                      </dict>
                     </array>
                   </dict>
                 </plist>
              EOF
    output.must_equal xml
  end

  private

  def translate(text)
    YamlToTmLanguageTranslator.new.translate(text, 2)
  end

  def prepare(xml)
    output = ''
    REXML::Document.new(xml).write output, 2
    output
  end

end