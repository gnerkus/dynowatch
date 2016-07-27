module Dynowatch
  class Parser
    # A list of endpoints to be analyzed as specified by the problem statement
    ENDPOINTS = {
      users: {
        count_pending_messages: { 'GET': 'count_pending_messages' },
        get_messages: { 'GET': 'get_messages' },
        get_friends_progress: { 'GET': 'get_friends_progress' },
        get_friends_score: { 'GET': 'get_friends_score' },
        blank: {
          'POST': 'create_user',
          'GET': 'get_user'
        }
      }
    }

    # Regular expressions for testing routes
    VALID_LOG_LINE = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}\+00:00\ heroku\[router\]\:/
    REQUEST_METHOD = /method\=([A-Z]+)/
    API_RESOURCE = /path\=\/api\/(\w+)\/.+/
    API_ENDPOINT = /path\=\/api\/\w+\/\d+\/(\w+)/

    # Regular expressions for obtaining request times
    CONNECT_TIME = /connect\=(\d+)\w+/
    SERVICE_TIME = /service\=(\d+)\w+/

    # Regular expression to fetch responding dyno
    DYNO = /dyno\=([a-z.0-9]+)/

    def initialize

    end

    # A valid Heroku log has the form:
    # time hostname heroku[router]: <log-details>
    # Example:
    # 2014-01-09T06:16:53.742892+00:00 heroku[router]: at=info method=GET path=/api/users/100002266342173/count_pending_messages host=services.pocketplaylab.com fwd="94.66.255.106" dyno=web.8 connect=9ms service=9ms status=304 bytes=0
    # We're only concerned with the format at the beginning.
    def self.is_valid_log(log)
      !!(log =~ VALID_LOG_LINE)
    end

    # Check if the log file contains a request to a route listed in ENDPOINTS
    def self.get_route_name(log, valid_resource)
      # Get the request method
      method = log.match(REQUEST_METHOD).to_a.dig(1)
      # Get API resource
      resource = log.match(API_RESOURCE).to_a.dig(1)
      # Get API endpoint
      endpoint = log.match(API_ENDPOINT).to_a.dig(1) || 'blank'

      if method && resource == valid_resource && endpoint
        ENDPOINTS[resource.to_sym][endpoint.to_sym][method.to_sym]
      else
        false
      end
    end

    # Obtain the response time for the request in the log
    def self.get_time(log)
      connect_time = log.match(CONNECT_TIME)[1].to_i
      service_time = log.match(SERVICE_TIME)[1].to_i

      connect_time + service_time
    end

    # Get the responding dyno for the request in the log
    def self.get_dyno(log)
      log.match(DYNO)[1]
    end

    # Get route, response time and dyno details from a log line
    def self.parse_log_line(log, valid_resource)
      if is_valid_log(log)
        route_name = get_route_name(log, valid_resource)
        if route_name
          {
            route: route_name,
            time: get_time(log),
            dyno: get_dyno(log)
          }
        end
      end
    end

    # Read information from a log file and update the log data
    def self.parse_log_file(log_file_path, valid_resource, log_file_info)
      # Resource path
      resc = valid_resource.to_sym

      # Read log file
      File.open(log_file_path, 'r') do |infile|
        while line = infile.gets
          log_info = parse_log_line(line, valid_resource)

          if log_info
            log_url = log_info[:route].to_sym

            # Increment count for the file
            log_file_info[resc][log_url][:count] += 1
            log_file_info[resc][log_url][:times] << log_info[:time]
            log_file_info[resc][log_url][:dynos] << log_info[:dyno]
          end
        end
      end

      log_file_info
    end
  end
end
