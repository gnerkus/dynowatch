module Dynowatch
  class Parser
    # A valid Heroku log has the form:
    # time hostname heroku[router]: <log-details>
    # Example:
    # 2014-01-09T06:16:53.742892+00:00 heroku[router]: at=info method=GET path=/api/users/100002266342173/count_pending_messages host=services.pocketplaylab.com fwd="94.66.255.106" dyno=web.8 connect=9ms service=9ms status=304 bytes=0
    # We're only concerned with the format at the beginning.
    def self.is_valid_log(log)
      line_regex = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}\+00:00\ heroku\[router\]\:/

      !!(log =~ line_regex)
    end
  end
end
