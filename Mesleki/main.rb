#!/usr/bin/env ruby

require 'json'

class Abbreviation
  attr_reader :size
  attr_accessor :list
  def initialize(hash)
    @list = hash
    @keys = @list.keys
    @values = @list.values
    @size = @list.size
  end
  
  def random
    n = rand(@size)
    {@keys[n] => @values[n]}
  end

  def update
    @size = @list.size
  end
end

def play(abbrs)
  loop do
    abbr = abbrs.random
    key = abbr.keys[0]
    print "#{key}: "
    answer = gets.chomp
    return if answer.empty?
    answer == abbr[key] ? (puts 'True') : (puts "False, Right: #{abbr[key]}")
  end
end
def add_mode(file, abbrs)
  loop do
    print 'Enter the abbreviation: '
    abbr = gets.chomp
    return if abbr.empty?
    print "Enter the expansion of #{abbr}: "
    expansion = gets.chomp
    abbrs.list[abbr] = expansion
  end
end
def user_interface(file, abbrs)
  loop do
    print "\nWelcome to Abbreviation Game!\n" +
         "What do you want to do?\n\n" +
         "1 - Play the Game!\n" + 
         "2 - Add new abbreviations\n" +
         "\nPlease enter number of your choose: "
    mode = gets.chomp.to_i
    abbrs.update
    case mode
    when 1
      play abbrs
    when 2
      add_mode file, abbrs
      file.puts JSON.pretty_generate abbrs.list
    else
      return
    end
  end
end

def main
  file = File.open('abbreviations.json', 'r+')
  abbrs = Abbreviation.new JSON.parse File.read(file)
  user_interface file, abbrs
  file.close
end

main if __FILE__ == $PROGRAM_NAME
