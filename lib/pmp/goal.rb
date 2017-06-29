module PMP
  class Goal
    TEXT_FIELDS = %i[description criteria employee_review supervisor_review]
    DATE_FIELDS = %i[due_date employee_review_date supervisor_review_date]
    FIELDS = TEXT_FIELDS + DATE_FIELDS
    attr_accessor(*TEXT_FIELDS)
    attr_reader(*DATE_FIELDS)

    def self.from_hash(document)
      new.from_hash(document)
    end

    DATE_FIELDS.each do |field|
      define_method :"#{field}=" do |value|
        case value
        when Date, nil
          instance_variable_set(:"@#{field}", value)
        when String
          instance_variable_set(:"@#{field}", Date.parse(value))
        else
          raise ArgumentError,
                "#{field} must be a Date, parsable String, or nil"
        end
      end
    end

    def from_hash(document)
      FIELDS.each do |field|
        send(:"#{field}=", document.fetch(field.to_s))
      end
      self
    end
  end
end
