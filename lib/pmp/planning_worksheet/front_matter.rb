# frozen_string_literal: true

module PMP
  module PlanningWorksheet
    module FrontMatter
      private

      def front_matter
        %i[name_and_position guides review_dates ws_instructions
           goal_expectations other_instructions].each do |document_part|
          send document_part
          move_down 6.pt
        end
      end

      def goal_expectations
        bounding_box([0, cursor], width: bounds.right) do
          pad 4.pt do
            bounding_box([4.pt, cursor], width: bounds.right - 4.pt) do
              formatted_text [
                { text: 'Every employee is expected to work on a ' },
                { text: 'minimum of three goals and/or work priorities ', styles: [:bold] },
                { text: 'and a ' },
                { text: 'maximum of eight goals and or work priorities ', styles: [:bold] },
                { text: 'during the review period.' }
              ]
            end
          end
          stroke_bounds
        end
      end

      def guides
        links = { 'PMP Handbook' => 'PMPHand.pdf', 'PMP Guidelines' => 'PMPGuide.pdf' }
        links.each do |title, file|
          formatted_text [
            { text: "#{title} on Web  ", styles: [:italic] },
            { text: "http://www.umass.edu/humres/#{file}",
              color: '0000FF',
              link: "http://www.umass.edu/humres/#{file}" }
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
        text 'NOTE: Attach the Performance Planning Worksheet text to the annual review form.'
        formatted_text [
          { text: 'Make additional copies if needed. ', styles: %i[bold italic] },
          { text: 'For Electronic Users: Please adjust box sizes as data is entered.' }
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
