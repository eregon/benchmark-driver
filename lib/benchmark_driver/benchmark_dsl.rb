module BenchmarkDriver
  class BenchmarkDSL
    BENCHMARK_BLOCK_START = /^([ \t]*)benchmark\b\s*(?:[(]?\s*['"](.+)['"]\s*[)]?)?\s*({|do)(\s*$)?/

    def self.load(path, script)
      # require 'ripper'
      # pp Ripper.lex(script)

      # pp RubyVM::AbstractSyntaxTree.parse(script)

      pp new.parse(path, script).build_config
    end

    def initialize
      @prelude = ''
      @jobs = {}
    end

    def parse(path, script)
      from = 0
      start = script.match(BENCHMARK_BLOCK_START, from)
      raise script unless start

      while start
        spacing = start[1]
        name = start[2]
        opening = start[3]
        multiline = start[4]
        closing = { '{' => '}', 'do' => 'end' }.fetch(opening)

        @prelude << script[from...start.begin(0)]

        if multiline
          block_end_regexp = /^()#{spacing}#{closing}\s*$/
        else
          block_end_regexp = /\G(.+)#{closing}\s*$/
        end
        block_end = script.match(block_end_regexp, start.end(0))
        raise "Could not find #{block_end_regexp} in #{start.post_match}" unless block_end

        benchmark = script[start.end(0)...block_end.end(1)]
        name ||= benchmark.strip
        @jobs[name] = benchmark

        from = block_end.end(0)
        start = script.match(BENCHMARK_BLOCK_START, from)
      end

      self
    end

    def build_config
      {
        prelude: @prelude,
        benchmark: @jobs
      }
    end
  end
end
