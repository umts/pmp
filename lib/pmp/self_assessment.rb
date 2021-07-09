# frozen_string_literal: true

module PMP
  class SelfAssessment < Document
    def initialize(answers = [])
      super
      @answers = answers
    end

    def render_document
      font 'Times-Roman'
      bounding_box([0, cursor], width: bounds.right) do
        pad box_pad do
          bounding_box [box_pad, cursor], width: bounds.right - box_pad do
            text 'Section 3: EMPLOYEE ANNUAL SELF REVIEW', style: :bold, size: 14.pt
          end
        end
        transparent(0.1) { fill_rectangle(bounds.top_left, bounds.width, bounds.height) }
        stroke_bounds
      end
      move_down 6.pt
      text 'Please, type responses in the space below each question. ' \
           'Electronic users: the space will expand as needed.', align: :center, size: 10.pt
      move_down 6.pt

      indent 0.25.in, 0.25.in do
        question_text.zip(@answers).each.with_index(1) do |(question, answer), n|
          text_box "#{n}.", at: [bounds.left, cursor], width: 16.pt
          indent 16.pt do
            text question
            bounding_box [0, cursor], width: bounds.right do
              move_down box_pad
              indent(box_pad, box_pad) { text answer }
              stroke_color 'DDDDDD'
              stroke_bounds
            end
            move_down 12.pt
          end
        end
      end
      header_and_footer
    end

    def question_text
      [<<~Q1, <<~Q2, <<~Q3, <<~Q4, <<~Q5, <<~Q6].map{|q| q.gsub(/\n/, ' ') }
        Describe the ways your performance met your expectations this evaluation
        period.
      Q1
        Describe significant accomplishments that you would like to have
        considered for the current performance review.  Consider listing
        accomplishments not already covered in the work priorities or
        contributions you have made to the department and/or the University.
      Q2
        Describe areas of your job in which you have grown significantly, made
        progress on past challenges and/or have been able to use new learning’s
        for professional and/or programmatic growth.
      Q3
        Describe any notable obstacles you encountered in fulfilling the
        expectations of your position during the period under review.  Can you
        suggest ways to remove those obstacles?
      Q4
        What do you see as your major goals/work priorities for the coming year?
      Q5
        What are the areas in which you would like to grow professionally and
        what kind of support, training and/or resources would you need to do so?
      Q6
    end
  end
end
