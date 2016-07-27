module Dynowatch
  class Parser
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

    def self.get_route_name(log)
      # Get the request method
      method = log.match(REQUEST_METHOD)[1]
      # Get API resource
      resource = log.match(API_RESOURCE)[1]
      # Get API endpoint
      endpoint = log.match(API_ENDPOINT)[1] || 'blank'

      ENDPOINTS[resource.to_sym][endpoint.to_sym][method.to_sym]
    end

    def self.get_time(log)
      connect_time = log.match(CONNECT_TIME)[1].to_i
      service_time = log.match(SERVICE_TIME)[1].to_i

      connect_time + service_time
    end

    def self.get_dyno(log)
      log.match(DYNO)[1]
    end
  end
end
