require 'dynowatch'
require 'spec_helper'

describe Dynowatch::Parser do

  describe 'is_valid_log' do
    let(:valid_log_file) { 'valid.log' }
    let(:invalid_log_file) { 'invalid.log' }

    it 'should return true for valid log file' do
      expect(Dynowatch::Parser.is_valid_log(valid_log_file)).to be true
    end

    it 'should return false for invalid log file' do
      expect(Dynowatch::Parser.is_valid_log(invalid_log_file)).to be false
    end
  end

end
