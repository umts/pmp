# frozen_string_literal: true

module PMP
  module PlanningWorksheet
    module GoalBlock
      private

      def goal_block(n, goal)
        box_pad = 4.pt

        bounding_box([0, cursor], width: bounds.right) do
          bounding_box([0, bounds.top], width: bounds.right / 2) do
            bounding_box([box_pad, bounds.top - box_pad],
                         width: (bounds.right - box_pad)) do
              text "#{n}. GOAL/WORK PRIORITY", style: :bold
              format_markdown(goal.description)
            end
          end

          bounding_box([bounds.right / 2, bounds.top],
                       width: (bounds.right / 2) - box_pad) do
            move_down box_pad
            indent box_pad do
              text 'SUCCESS CRITERIA:', style: :bold
              move_down 12.pt
              format_markdown(goal.criteria)
            end
          end

          transparent(0.1) do
            fill_rectangle(bounds.top_left, bounds.width / 2, bounds.height)
          end
          line [bounds.right / 2, bounds.top], [bounds.right / 2, 0]
          stroke_bounds

          float do
            move_up 16.pt
            indent box_pad do
              due_date = if goal.due_date.nil?
                           'ongoing'
                         else
                           goal.due_date.strftime('%B %-d, %Y')
                         end
              text "DUE DATE: #{due_date}"
            end
          end
        end

        bounding_box([0, cursor], width: bounds.right) do
          move_down box_pad
          indent box_pad do
            bounding_box([0, cursor], width: bounds.right - box_pad) do
              formatted_text [
                { text: 'Employee Review Comments', styles: [:bold] },
                { text: Prawn::Text::NBSP * 28 },
                { text: 'Date: ', styles: [:bold] },
                { text: goal.employee_review_date.to_s }
              ]
              move_down 6.pt
              format_markdown(goal.employee_review)
            end
          end
          stroke_bounds
        end

        bounding_box([0, cursor], width: bounds.right) do
          move_down box_pad
          indent box_pad do
            bounding_box([0, cursor], width: bounds.right - box_pad) do
              formatted_text [
                { text: 'Supervisor Review Comments', styles: [:bold] },
                { text: Prawn::Text::NBSP * 26 },
                { text: 'Date: ', styles: [:bold] },
                { text: goal.supervisor_review_date.to_s }
              ]
              move_down 6.pt
              format_markdown(goal.supervisor_review)
            end
          end
          stroke_bounds
        end
      end
    end
  end
end
