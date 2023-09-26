# frozen_string_literal: true

module PMP
  module PlanningWorksheet
    ##
    # Methods for the "front matter" of the planning worksheet -- everything
    # before the "goals" -- included in PMP::PlanningWorkSheet::Document
    module FrontMatter
      private

      ##
      # Main "front matter" method. Calls all of the other methods in this
      # module in turn.
      def front_matter
        %i[name_and_position review_dates ws_instructions
           goal_expectations other_instructions].each do |document_part|
          send document_part
          move_down 6.pt
        end
      end

      def goal_expectations
        boxed_with_padding do
          formatted_text [
            { text: 'Every employee is expected to work on a ' },
            { text: 'minimum of three goals and/or work priorities ', styles: [:bold] },
            { text: 'and a ' },
            { text: 'maximum of eight goals and or work priorities ', styles: [:bold] },
            { text: 'during the review period.' }
          ]
        end
      end

      def name_and_position
        formatted_text [
          { text: 'EMPLOYEE NAME:', styles: [:bold] },
          { text: @name.center(20), styles: [:underline] },
          { text: 'POSITION:', styles: [:bold] },
          { text: @position.center(30), styles: [:underline] },
          { text: Prawn::Text::NBSP }
        ]
      end

      def other_instructions
        formatted_text [
          { text: 'NOTE: Attach the Performance Planning Worksheet text to the annual review form. ', styles: [:bold] },
          { text: 'Make additional copies if needed. ', styles: %i[bold italic] }
        ]
      end

      def review_dates
        formatted_text [
          { text: 'REVIEW PERIOD: From: ' },
          { text: @start_date.to_s.center(15), styles: [:underline] },
          { text: 'To: ' },
          { text: @end_date.to_s.center(15), styles: [:underline] },
          { text: Prawn::Text::NBSP }
        ]
      end

      def ws_instructions
        formatted_text [{ text: <<~INST.gsub(/\n/, ''), styles: [:bold] }], align: :center
          Use this worksheet to record goals/work priorities, specify the
          success criteria and, when completed, to comment on the end
          results.
        INST
      end
    end
  end
end
