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

            next if ms <= 0.2

            next unless code = source_lines[line - 1]
            parsed << Sample.new(options[:ip], ms, line, code)
          end

          parsed
        end
      end

      def source_lines
        @source_lines ||= ::File.open(file_name, 'r').to_a
      end
    end
  end
end
