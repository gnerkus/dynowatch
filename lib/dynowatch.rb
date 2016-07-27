require "dynowatch/version"
require "dynowatch/parser"
require "dynowatch/analyzer"

module Dynowatch
  class CLI
    # Your code goes here...
    LOG_DATA = {
      users: {
        count_pending_messages: {
          count: 0, times: [], dynos: [],
          path: 'GET /api/users/{user_id}/count_pending_messages'
        },
        get_messages: {
          count: 0, times: [], dynos: [],
          path: 'GET /api/users/{user_id}/get_messages'
        },
        get_friends_progress: {
          count: 0, times: [], dynos: [],
          path: 'GET /api/users/{user_id}/get_friends_progress'
        },
        get_friends_score: {
          count: 0, times: [], dynos: [],
          path: 'GET /api/users/{user_id}/get_friends_score'
        },
        create_user: {
          count: 0, times: [], dynos: [],
          path: 'POST /api/users/{user_id}'
        },
        get_user: {
          count: 0, times: [], dynos: [],
          path: 'GET /api/users/{user_id}'
        }
      }
    }

    VALID_RESOURCE = 'users'

    def self.print_data
      parser = Dynowatch::Parser
      analyzer = Dynowatch::Analyzer

      file_path = ARGV[0]

      log_file_info = parser.parse_log_file(file_path, VALID_RESOURCE, LOG_DATA)

      results = log_file_info[VALID_RESOURCE.to_sym]

      results.each_pair do |url_name, url_info|
        puts "======================== #{url_info[:path]} ================================"
        puts "Number of calls: #{url_info[:count]}"
        puts "Mean response time: #{analyzer.mean(url_info[:times])}ms"
        puts "Median response time: #{analyzer.median(url_info[:times])}ms"
        puts "Mode response time: #{analyzer.mode(url_info[:times])}ms"
        puts "Dyno that responded the most: #{analyzer.mode(url_info[:dynos])}"
      end
    end
  end
end
