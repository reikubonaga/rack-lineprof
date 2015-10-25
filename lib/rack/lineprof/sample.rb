module Rack
  class Lineprof
    class Sample < Struct.new :ms, :line, :code

      def format
        sprintf "0.0.0.0 - - [%s] \"line %i %s\" 200 0 \"-\" \"-\" %f\n", Time.now, line, code.chomp.gsub("\"", ""), ms
      end
    end
  end
end
