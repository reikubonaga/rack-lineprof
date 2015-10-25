module Rack
  class Lineprof
    class Sample < Struct.new :ms, :calls, :line, :code, :level

      def format colorize = true
        formatted = if level == CONTEXT
          sprintf "               | % 3i  %s", line, code
        else
          sprintf "0.0.0.0 - - [%s] \"line %i %s\" 200 0 \"-\" \"-\" %f\n", Time.now, line, code.chomp.gsub("\"", ""), ms
        end

        return formatted unless colorize

        case level
        when CRITICAL
          color.red formatted
        when WARNING
          color.yellow formatted
        when NOMINAL
          color.white formatted
        else # CONTEXT
          color.intense_black formatted
        end
      end

      private

      def color
        Term::ANSIColor
      end

    end
  end
end
