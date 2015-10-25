module Rack
  class Lineprof
    class Sample < Struct.new :ip, :ms, :line, :code

      def format
        sprintf "%s - - [%s] \"line %3i %s\" 200 0 \"-\" \"-\" %6.2f\n", ip, Time.now, line, code.strip.gsub("\"", ""), ms
      end
    end
  end
end
