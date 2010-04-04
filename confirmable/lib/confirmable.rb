module Confirmable

  class Confirmation
    def initialize; @confirmed = false end
    def confirm!;   @confirmed = true end
    def confirmed?; @confirmed end
  end

  def self.included(klass)
    klass.instance_eval do
      def confirm(*methods)
        imethods = instance_methods
        methods.each do |m|
          unless imethods.include?(m.to_sym)
            warn "Warning (Confirmable): ##{m} isn't defined for #{self}. Ignoring."
          else
            meth = instance_method(m.to_sym)
            define_method(m.to_s) do |*args, &b|
              raise(SecurityError, "need to confirm!") unless b
              b.call(c = Confirmation.new)
              raise(SecurityError, "need to confirm!") unless c.confirmed?
              meth.bind(self).call(*args)
            end
          end
        end
      end
    end
  end
end
