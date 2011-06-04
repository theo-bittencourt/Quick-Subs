module ActiveRecord
  # = Active Record Has And Belongs To Many Association
  module Associations
    class HasAndBelongsToManyAssociation < CollectionAssociation #:nodoc:
      attr_reader :join_table

      def initialize(owner, reflection)
        @join_table = Arel::Table.new(reflection.options[:join_table])
        super
      end

      def insert_record(record, validate = true)
        return if record.new_record? && !record.save(:validate => validate)

        if options[:insert_sql]
          owner.connection.insert(interpolate(options[:insert_sql], record))
        else
          stmt = join_table.compile_insert(
            join_table[reflection.foreign_key]             => owner.id,
            join_table[reflection.association_foreign_key] => record.id
          )

          owner.connection.insert stmt.to_sql
        end

        record
      end

      private

        def count_records
          load_target.size
        end

        def delete_records(records, method)
          if sql = options[:delete_sql]
            records.each { |record| owner.connection.delete(interpolate(sql, record)) }
          else
            relation = join_table
            stmt = relation.where(relation[reflection.foreign_key].eq(owner.id).
              and(relation[reflection.association_foreign_key].in(records.map { |x| x.id }.compact))
            ).compile_delete
            owner.connection.delete stmt.to_sql
          end
        end

        def invertible_for?(record)
          false
        end
    end
  end
end