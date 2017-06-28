module PMP
  class Goal
    FORMATTED_FIELDS = %i(description
                          criteria
                          employee_review
                          supervisor_review).freeze

    attr_accessor :due_date, :employee_review_date, :supervisor_review_date
    attr_writer(*FORMATTED_FIELDS)

    FORMATTED_FIELDS.each do |field|
      define_method field do
        format_text(instance_variable_get("@#{field}"))
      end
    end

    private

    def format_text(text)
      text
    end
  end
end
