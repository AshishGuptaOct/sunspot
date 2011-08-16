module Sunspot
  module Query
    class GroupQuery < StandardQuery
      attr_accessor :group

      def intialize(types)
        super(types)
      end

      def add_group(group)
        @components << @group = group
        @group
      end
    end
  end
end
