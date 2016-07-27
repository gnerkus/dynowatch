require 'dynowatch'
require 'spec_helper'

describe Dynowatch::Parser do

  let(:valid_log) { '2014-01-09T06:16:53.742892+00:00 heroku[router]: at=info method=GET path=/api/users/100002266342173/count_pending_messages host=services.pocketplaylab.com fwd="94.66.255.106" dyno=web.8 connect=9ms service=9ms status=304 bytes=0' }

  let(:invalid_log) { 'x.x.x.90 - - [13/Sep/2006:07:01:51 -0700] "PROPFIND /svn/[xxxx]/[xxxx]/trunk HTTP/1.1" 401 587' }

  describe 'is_valid_log' do
    it 'should return true for valid log string' do
      expect(Dynowatch::Parser.is_valid_log(valid_log)).to be true
    end

    it 'should return false for invalid log string' do
      expect(Dynowatch::Parser.is_valid_log(invalid_log)).to be false
    end
  end

  describe 'get_route_name' do
    it 'should determine the matching route from a log line' do
      expect(Dynowatch::Parser.get_route_name(valid_log)).to eq('count_pending_messages')
    end
  end

  describe 'get_time' do
    it 'should fetch the response time' do
      expect(Dynowatch::Parser.get_time(valid_log)).to eq(18)
    end
  end

  describe 'get_dyno' do
    it 'should fetch the responding dyno' do
      expect(Dynowatch::Parser.get_dyno(valid_log)).to eq('web.8')
    end
  end

end
