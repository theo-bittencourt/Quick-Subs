module ExecJS
  class RubyRhinoRuntime
    class Context
      def initialize(source = "")
        @rhino_context = ::Rhino::Context.new
        @rhino_context.eval(source)
      end

      def exec(source, options = {})
        souce = source.encode('UTF-8') if source.respond_to?(:encode)

        if /\S/ =~ source
          eval "(function(){#{source}})()", options
        end
      end

      def eval(source, options = {})
        souce = source.encode('UTF-8') if source.respond_to?(:encode)

        if /\S/ =~ source
          unbox @rhino_context.eval("(#{source})")
        end
      rescue ::Rhino::JavascriptError => e
        if e.message == "syntax error"
          raise RuntimeError, e.message
        else
          raise ProgramError, e.message
        end
      end

      def call(properties, *args)
        unbox @rhino_context.eval(properties).call(*args)
      rescue ::Rhino::JavascriptError => e
        if e.message == "syntax error"
          raise RuntimeError, e.message
        else
          raise ProgramError, e.message
        end
      end

      def unbox(value)
        case value
        when ::Rhino::NativeFunction
          nil
        when ::Rhino::NativeObject
          value.inject({}) do |vs, (k, v)|
            vs[k] = unbox(v) unless v.is_a?(::Rhino::NativeFunction)
            vs
          end
        else
          value
        end
      end
    end

    def name
      "therubyrhino (Rhino)"
    end

    def exec(source)
      context = Context.new
      context.exec(source)
    end

    def eval(source)
      context = Context.new
      context.eval(source)
    end

    def compile(source)
      Context.new(source)
    end

    def available?
      require "rhino"
      true
    rescue LoadError
      false
    end
  end
end
