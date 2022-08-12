# encoding: US-ASCII

require 'spec_helper'
require 'ronin/support/format/hex/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#hex_encode" do
    expect(subject).to respond_to(:hex_encode)
  end

  it "must provide String#hex_decode" do
    expect(subject).to respond_to(:hex_decode)
  end

  it "must provide String#hex_unescape" do
    expect(subject).to respond_to(:hex_unescape)
  end

  describe "#hex_encode" do
    subject { "hello\x4e" }

    it "must hex encode a String" do
      expect(subject.hex_encode).to eq("68656c6c6f4e")
    end
  end

  describe "#hex_decode" do
    subject { "68656c6c6f4e" }

    it "must hex decode a String" do
      expect(subject.hex_decode).to eq("hello\x4e")
    end
  end

  describe "#hex_escape" do
    subject { "hello\xff" }

    it "must hex escape a String" do
      expect(subject.hex_escape).to eq("hello\\xff")
    end
  end

  describe "#hex_string" do
    subject { "hello\nworld" }

    it "must return a double-quoted hex escaped String" do
      expect(subject.hex_string).to eq("\"hello\\x0aworld\"")
    end
  end

  describe "#hex_unquote" do
    context "when the String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the JavaScript string" do
        expect(subject.hex_unquote).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      subject { "'hello\\'world'" }

      let(:unescaped) { "hello'world" }

      it "must remove the single-quotes and unescape the JavaScript string" do
        expect(subject.hex_unquote).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.hex_unquote).to be(subject)
      end
    end
  end
end
