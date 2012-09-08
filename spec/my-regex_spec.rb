require 'spec_helper'

describe "regex matching" do
  subject { regex_engine }
  let(:regex_engine) { MyRegex.new(pattern) }
  let(:pattern){ example.example_group.description }

  def self.should_match(str)
    it "matches #{str.inspect}" do
      should have_match(str)
    end
  end

  def self.should_not_match(str)
    it "doesn't match #{str.inspect}" do
      should_not have_match(str)
    end
  end

  describe "/a/" do
    should_match "a"

    should_not_match ""    
    should_not_match "b"
  end

  describe "/abc/" do
    should_match "abc"
    should_match "zabc"

    should_not_match "bca"
    should_not_match "cba"
    should_not_match "ab."
  end

  describe "/a.c/" do
    should_match "abc"
    should_match "zabc"
    should_match "zadcasdf"

    should_not_match "cbc"
    should_not_match "zabd"
    should_not_match "zadbca"
  end

  describe "0 or more occurrences" do
    describe "/a.*c/" do
      should_match "ac"
      should_match "abc"
      should_match "abbc"
      should_match "zabdddddc"
      should_match "zadcasdf"
      should_match "zacasdfacg"

      should_not_match "abddddd"
    end

    describe "/ab*c/" do
      should_match "abc"
      should_match "abbbbbbbbbbbbc"
      should_match "zacasdfacg"

      should_match "abbc"
      should_not_match "zabdddddc"
      should_not_match "zadcasdf"
      should_not_match "abddddd"
    end
  end

  describe "1 or more occurrences" do
    describe "/a.+c/" do
      should_match "abc"
      should_match "abbc"
      should_match "zabdddddc"
      should_match "zadcasdf"
      should_match "zacasdfacg"

      should_not_match "ac"
      should_not_match "abddddd"
    end

    describe "/ab+c/" do
      should_match "abc"
      should_match "abbbbbbbbbbbbc"
      should_match "abbc"

      should_not_match "zacasdfacg"
      should_not_match "zabdddddc"
      should_not_match "zadcasdf"
      should_not_match "abddddd"
    end
  end

  describe "0 or 1 occurrence" do
    describe "/ab?c/" do
      should_match "abc"
      should_match "ac"

      should_not_match "abbc"
    end
  end

  describe "mixing modifiers" do
    describe "/a+bc*d/" do
      should_match "abcd"
      should_match "aaaabcd"
      should_match "aaaabccccccccd"
      should_match "aaaabd"

      should_not_match "bcd"
      should_not_match "aaabbbbbcd"
    end

    describe "/a*.c+d/" do
      should_match "abcd"
      should_match "aaaabcd"
      should_match "aaaabccccccccd"
      should_match "bcd"

      should_not_match "aaaabd"
      should_not_match "aaabbbbbcd"
    end
  end

end