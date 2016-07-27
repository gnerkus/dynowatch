require 'dynowatch'
require 'spec_helper'

describe Dynowatch::Analyzer do

  let(:sample_array) { [1, 2, 3, 4, 5] }

  let(:mixed_array) { [1, 4, 5, 2, 3, 2, 3, 3, 3] }

  describe 'mean' do
    it 'should obtain the mean of an array of numbers' do
      expect(Dynowatch::Analyzer.mean(sample_array)).to eq(3)
    end
  end

  describe 'median' do
    it 'should obtain the median of an array of numbers' do
      expect(Dynowatch::Analyzer.median(sample_array)).to eq(3)
    end
  end

  describe 'mode' do
    it 'should return the most frequent element of an array' do
      expect(Dynowatch::Analyzer.mode(mixed_array)).to eq(3)
    end
  end
end
