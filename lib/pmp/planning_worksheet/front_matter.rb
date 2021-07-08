# frozen_string_literal: true

module PMP
  module PlanningWorksheet
    module FrontMatter
      private

      def front_matter
        formatted_text [
          { text: 'EMPLOYEE NAME:', styles: [:bold] },
          { text: @name.center(20), styles: [:underline] },
          { text: 'POSITION:', styles: [:bold] },
          { text: @position.center(30), styles: [:underline] },
          { text: Prawn::Text::NBSP }
        ]
        move_down 6.pt

        formatted_text [
          { text: 'PMP Handbook on Web  ', styles: [:italic] },
          { text: 'http://www.umass.edu/humres/PMPHand.pdf',
            color: '0000FF',
            link: 'http://www.umass.edu/humres/PMPGuide.pdf' }
        ]
        formatted_text [
          { text: 'PMP Guidelines on Web  ', styles: [:italic] },
          { text: 'http://www.umass.edu/humres/PMPGuide.pdf',
            color: '0000FF',
            link: 'http://www.umass.edu/humres/PMPGuide.pdf' }
        ]
        move_down 6.pt

        formatted_text [
          { text: 'REVIEW PERIOD: From: ' },
          { text: @start_date.to_s.center(15), styles: [:underline] },
          { text: 'To: ' },
          { text: @end_date.to_s.center(15), styles: [:underline] },
          { text: Prawn::Text::NBSP }
        ]
        move_down 6.pt

        formatted_text [{ text: <<~INST.gsub(/\n/, ''),
          Use this worksheet to record goals/work priorities, specify the
          success criteria and, when completed, to comment on the end
          results.
        INST
                          styles: [:bold] }],
                       align: :center
        move_down 6.pt

        bounding_box([0, cursor], width: bounds.right) do
          pad 4.pt do
            bounding_box([4.pt, cursor], width: bounds.right - 4.pt) do
              formatted_text [
                { text: 'Every employee is expected to work on a ' },
                { text: 'minimum of three goals and/or work priorities ',
                  styles: [:bold] },
                { text: 'and a ' },
                { text: 'maximum of eight goals and or work priorities ',
                  styles: [:bold] },
                { text: 'during the review period.' }
              ]
            end
          end
          stroke_bounds
        end
        move_down 6.pt

        note = 'NOTE: Attach the Performance Planning Worksheet' \
               ' text to the annual review form.'
        text note
        formatted_text [
          { text: 'Make additional copies if needed. ', styles: %i[bold italic] },
          { text: 'For Electronic Users:' \
                  ' Please adjust box sizes as data is entered.' }
        ]
      end
    end
  end
end
