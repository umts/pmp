# frozen_string_literal: true

module PMP
  class Goal
    TEXT_FIELDS = %i[description criteria employee_review supervisor_review].freeze
    DATE_FIELDS = %i[due_date employee_review_date supervisor_review_date].freeze
    FIELDS = TEXT_FIELDS + DATE_FIELDS

    attr_accessor(*TEXT_FIELDS)
    attr_reader(*DATE_FIELDS)

    def self.from_hash(document)
      new.from_hash(document)
    end

    # e.g.
    # def due_date=(value)
    #   @due_date = date_cast(value)
    # end
    DATE_FIELDS.each do |field|
      define_method :"#{field}=" do |value|
        instance_variable_set(:"@#{field}", date_cast(value))
      end
    end

    def from_hash(document)
      FIELDS.each do |field|
        send(:"#{field}=", document.fetch(field.to_s))
      end
      self
    end

    private

    def date_cast(value)
      case value
      when Date, nil then value
      when String then Date.parse(value)
      else raise ArgumentError, 'must be a Date, parsable String, or nil'
      end
    end
  end
end
