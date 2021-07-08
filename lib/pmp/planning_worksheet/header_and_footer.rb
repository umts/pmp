# frozen_string_literal: true

module PMP
  module PlanningWorksheet
    module HeaderAndFooter
      private

      def header_and_footer
        repeat(:all) do
          canvas do
            bounding_box([bounds.left + @margins[3], bounds.top - @header],
                         width: bounds.width - @margins[1] - @margins[3],
                         height: 20.pt) do
              text 'PERFORMANCE PLANNING WORKSHEET',
                   size: 14.pt, style: :bold, align: :center, valign: :center
              transparent(0.1) do
                fill_rectangle(bounds.top_left, bounds.width, bounds.height)
              end
              stroke_bounds
            end
            footer_text = 'University of Massachusetts' \
                          ' SEIU Performance Management Program'
            text_box footer_text, at: [0, @footer], align: :center
          end
        end
      end
    end
  end
end
