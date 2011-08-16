module Sunspot
  module DSL #:nodoc
    module Groupable
      def group(&block)
        group = Sunspot::Query::Group.new(@setup)
        Sunspot::Util.instance_eval_or_call(group, &block)
        @query.add_group(group)
      end
    end
  end
end
