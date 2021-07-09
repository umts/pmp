# frozen_string_literal: true

module PMP
  module PlanningWorksheet
    module HeaderAndFooter
      private

      def footer
        footer_text = 'University of Massachusetts SEIU Performance Management Program'
        text_box footer_text, at: [0, @footer], align: :center
      end

      def header
        bounding_box header_bounds, header_size do
          text 'PERFORMANCE PLANNING WORKSHEET',
               size: 14.pt, style: :bold, align: :center, valign: :center
          transparent(0.1) { fill_rectangle(bounds.top_left, bounds.width, bounds.height) }
          stroke_bounds
        end
      end

      def header_and_footer
        repeat(:all) do
          canvas do
            header
            footer
          end
        end
      end

      def header_bounds
        [bounds.left + @margins[3], bounds.top - @header]
      end

      def header_size
        { width: bounds.width - @margins[1] - @margins[3], height: 20.pt }
      end
    end
  end
end
