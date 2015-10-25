module Rack
  class Lineprof
    class Source

      attr_reader :file_name, :raw_samples, :options

      def initialize file_name, raw_samples, options = {}
        @file_name, @raw_samples, @options = file_name, raw_samples, options
      end

      def format colorize = true
        return nil if samples.empty?

        formatted = ""

        samples.each do |sample|
          formatted << sample.format
        end

        formatted
      end

      def samples
        @samples ||= begin
          parsed = []

          raw_samples.each_with_index do |sample, line|
            next if line == 0 # drop file info

            ms = sample[0] / 1000.0
            calls = sample[2]

            abnormal = ms >= thresholds[NOMINAL]

            next unless abnormal

            threshold = thresholds.invert.detect { |th, _| ms > th }
            level = threshold ? threshold.last : CONTEXT

            next unless code = source_lines[line - 1]
            parsed << Sample.new(ms, calls, line, code, level)
          end

          parsed
        end
      end

      def source_lines
        @source_lines ||= ::File.open(file_name, 'r').to_a
      end

      private

      def color
        Term::ANSIColor
      end

      def context
        options.fetch :context, 2
      end

      def thresholds
        @thresholds ||= {
          CRITICAL => 50,
          WARNING  => 5,
          NOMINAL  => 0.2
        }.merge(options.fetch :thresholds, {})
      end

    end
  end
end
