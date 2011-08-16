module Sunspot
  module Search
    class GroupSearch < StandardSearch
      def results
        @group_results ||= paginate_collection(
          verified_group_hits.inject({}) do |r, (group, hits)|
            r[group] = hits.map { |hit| hit.instance }
            r
          end
        )
      end

      def group_hits(options = {})
        if options[:verify]
          verified_group_hits
        else
          @group_hits ||=
            begin
              gh = {}
              grouped_value['groups'].each do |result|
                gh[result['groupValue']] = result['doclist']['docs'].map do |doc|
                h = Hit.new(doc, highlights_for(doc), self)
                end
              end
              paginate_collection(gh)
            end
        end
      end

      def verified_group_hits
        @verified_group_hits ||= paginate_collection(
          group_hits.inject({}) do |r, (group, hits)|
            r[group] = hits.select { |hit| hit.instance }
            r
          end
        )
      end

      def hits(options={})
        if options[:verify]
          @verified_hits ||= paginate_collection(group_hits(options).values.flatten(1))
        else
          @hits ||= paginate_collection(group_hits.values.flatten(1))
        end
      end

      def total
        @total ||= grouped_value['ngroups'] || 0
      end

      def grouped_value
        indexed_name = @query.group.field_indexed_name
        @solr_result['grouped'][indexed_name]
      end
    end
  end
end
