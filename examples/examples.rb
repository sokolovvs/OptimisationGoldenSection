$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "golden_section"

gs = GoldenSection::GoldenSection.new 1, 10, 0.0001 ,"min",
                                      lambda { |argument| 16 * Math.log2(argument) -  1 / Math.sqrt(argument) ** 7 }
answer = gs.search true
puts answer
