#!/usr/bin/env ruby
require 'pry'
@nodes = {}
@matches = []
@points = {
  'a' => 1,
  'b' => 3,
  'c' => 3,
  'd' => 2,
  'e' => 1,
  'f' => 4,
  'g' => 2,
  'h' => 4,
  'i' => 1,
  'j' => 8,
  'k' => 5,
  'l' => 1,
  'm' => 3,
  'n' => 1,
  'o' => 1,
  'p' => 3,
  'q' => 10,
  'r' => 1,
  's' => 1,
  't' => 1,
  'u' => 1,
  'v' => 4,
  'w' => 4,
  'x' => 8,
  'y' => 4,
  'z' => 10,
}
class Node
  attr_accessor :data, :next
  def initialize(data)   
    @data   = data  #The word, if this is a possible final letter
    @next = {} #hash of possible next letters
  end

  def add (data, word)
    sym = data.to_sym
    if @next[sym].nil?
      nxt = Node.new(word)
      @next[sym] = nxt
      return nxt
    end
    @next[sym]
  end
end

def add_word (word)
  wordarr = word.split('')
  add_recur(@nodes[wordarr.shift.to_sym], wordarr, word)
end

def add_recur(starting_node, datas, word)
  nxt = starting_node.add(datas.shift, (datas.length == 0 ? word : ''))
  add_recur(nxt, datas, word) if datas.length > 0
end

def search(letters)
  @matches = []
  letters = letters.split('');
  letters.each_with_index do |letter, i|
    tmp = letters.dup;
    tmp.delete_at(i);
    if letter == "*"
      ('a'..'z').each{|node| walk_recur(@nodes[node.to_sym], tmp)}
    else
      walk_recur(@nodes[letter.to_sym], tmp)
    end
  end
  @matches.uniq
  out = {}
  @matches.each do |match|
    out[match] = score(match)
  end
  out.sort_by{|_, score| -score}
end

def score(word) 
  word = word.split('')
  score = 0
  word.each do |letter|
    score += @points[letter]
  end
  score
end

def walk_recur(node, rest)
  @matches.push(node.data) if node.data.length > 0
  rest.each_with_index do |letter, i|
    tmp = rest.dup;
    tmp.delete_at(i);
    if letter == '*'
      node.next.each{|_, nxt| walk_recur(nxt, tmp)}
    elsif !node.next[letter.to_sym].nil?
      walk_recur(node.next[letter.to_sym], tmp)
    end
  end
end

#Load the word trie, or create a new one and cache to file
if File.exists?('scrabble_data')
  @nodes = Marshal.load(File.read('scrabble_data'))
else
  ('a'..'z').each{|letter| @nodes[letter.to_sym] = Node.new('')} 

  words = File.open('words').read

  words.split("\n").each do |line|
    add_word(line.downcase)
  end

  File.open('scrabble_data', 'w') {|f| f.write(Marshal.dump(@nodes)) }  
end

#Display Matches
result = search(ARGV[0].downcase)
print result.length.to_s+" legal words: \n-------------------------------\n"
result.each do |match|
  print match[0] + "\t" + match[1].to_s + "pts\n"
end