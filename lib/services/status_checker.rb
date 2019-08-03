module Services
  class StatusChecker
    def check(channel_id)
      begin
        p "Check #{channel_id}".colorize(color: :light_black, background: :light_yellow)
        ch = Channel.find(channel_id)
        conn = Faraday.new
        response = conn.head(ch.url) { |request| request.options.timeout = 5 }
        if response.success?
          p "#{channel_id} ok".colorize(:green)
          ch.update(status: 1)
          return
        else
          p "#{channel_id} red".colorize(:red)
          ch.update(status: ch.active? ? 2 : 3)
        end
      rescue Faraday::ConnectionFailed => _
        p "#{channel_id} red".colorize(:red)
        ch.update(status: ch.active? ? 2 : 3)
      end
    end
  end
end