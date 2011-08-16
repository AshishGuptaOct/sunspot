module Sunspot
  module Query
    class Group

      def initialize(setup)
        @setup = setup
        @sorts = []
      end

      def field(field_name)
        @field = @setup.field(field_name)
      end

      def field_indexed_name
        @field.indexed_name
      end

      def limit(limit)
        @limit = limit
      end

      def order_by(field_name, direction = nil)
        sort =
          if special = Sunspot::Query::Sort.special(field_name)
            special.new(direction)
          else
            Sunspot::Query::Sort::FieldSort.new(
              @setup.field(field_name), direction
            )
          end
        @sorts << sort
      end

      def to_params
        p = { :group => 'true', :'group.ngroups' => 'true' }
        p[:'group.field'] = @field.indexed_name
        p[:'group.limit'] = "#{@limit}" if @limit
        unless @sorts.empty?
          p[:'group.sort'] = @sorts.map { |sort| sort.to_param }.join(', ')
        end
        p
      end
    end
  end
end
