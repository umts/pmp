# frozen_string_literal: true

module PMP
  module PlanningWorksheet
    module GoalBlock
      private

      def goal_block(number, goal)
        bounding_box([0, cursor], width: bounds.right) do
          goal_desc(number, goal)
          goal_criteria(goal)
          stroke_with_center_line
          goal_due(goal)
        end

        goal_employee_review(goal)
        goal_supervisor_review(goal)
      end

      def goal_criteria(goal)
        bounding_box([bounds.right / 2, bounds.top],
                     width: (bounds.right / 2) - box_pad) do
          move_down box_pad
          indent box_pad do
            text 'SUCCESS CRITERIA:', style: :bold
            move_down 12.pt
            format_markdown(goal.criteria)
          end
        end
      end

      def goal_desc(number, goal)
        bounding_box([0, bounds.top], width: bounds.right / 2) do
          bounding_box([box_pad, bounds.top - box_pad],
                       width: (bounds.right - box_pad)) do
            text "#{number}. GOAL/WORK PRIORITY", style: :bold
            format_markdown(goal.description)
          end
        end
      end

      def goal_due(goal)
        float do
          move_up 16.pt
          indent box_pad do
            due_date = goal.due_date&.strftime('%B %-d, %Y') || 'ongoing'
            text "DUE DATE: #{due_date}"
          end
        end
      end

      def goal_employee_review(goal)
        boxed_with_padding do
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

      def goal_supervisor_review(goal)
        boxed_with_padding do
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

      def stroke_with_center_line
        transparent(0.1) { fill_rectangle(bounds.top_left, bounds.width / 2, bounds.height) }
        line [bounds.right / 2, bounds.top], [bounds.right / 2, 0]
        stroke_bounds
      end
    end
  end
end
