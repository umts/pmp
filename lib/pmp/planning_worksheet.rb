require 'kramdown'

module PMP
  class PlanningWorksheet
    include Prawn::View

    attr_accessor :margins

    def initialize(name, position, date_range, goals = [])
      @name = name
      @position = position
      @start_date = date_range.first
      @end_date = date_range.last
      @goals = goals
      @margins = [1.in, 1.in, 1.in, 1.in]
      @header = 0.5.in
      @footer = 0.5.in
    end

    def document
      @document ||= Prawn::Document.new({
        margin: @margins,
        default_leading: 8.pt
      })
    end

    def render_document
      font 'Times-Roman'
      front_matter
      @goals.each.with_index(1) do |goal, n|
        goal_block(n, goal)
        start_new_page unless n == @goals.count
      end
      header_and_footer
    end

    private

    def header_and_footer
      repeat(:all) do
        canvas do
          bounding_box([bounds.left + @margins[3], bounds.top - @header],
                       width: bounds.width - @margins[1] - @margins[3], height: 20.pt) do
            text "PERFORMANCE PLANNING WORKSHEET",
              size: 14.pt, style: :bold, align: :center, valign: :center
            transparent(0.1) do
              fill_rectangle(bounds.top_left, bounds.width, bounds.height)
            end
            stroke_bounds
          end
          text_box "University of Massachusetts SEIU Performance Management Program",
            at: [0, @footer], align: :center
        end
      end
    end

    def front_matter
      formatted_text [
        {text: 'EMPLOYEE NAME:', styles: [:bold]},
        {text: @name.center(20), styles: [:underline]},
        {text: 'POSITION:', styles: [:bold]},
        {text: @position.center(30), styles: [:underline]},
        {text: Prawn::Text::NBSP}
      ]
      move_down 6.pt

      formatted_text [
        {text: 'PMP Handbook on Web  ', styles: [:italic]},
        {text: 'http://www.umass.edu/humres/PMPHand.pdf',
         color: '0000FF',
         link: 'http://www.umass.edu/humres/PMPGuide.pdf'}
      ]
      formatted_text [
        {text: 'PMP Guidelines on Web  ', styles: [:italic]},
        {text: 'http://www.umass.edu/humres/PMPGuide.pdf',
         color: '0000FF',
         link: 'http://www.umass.edu/humres/PMPGuide.pdf'}
      ]
      move_down 6.pt

      formatted_text [
        {text: 'REVIEW PERIOD: From: '},
        {text: @start_date.to_s.center(15), styles: [:underline]},
        {text: 'To: '},
        {text: @end_date.to_s.center(15), styles: [:underline]},
        {text: Prawn::Text::NBSP}
      ]
      move_down 6.pt

      formatted_text [{ text: <<-INST.gsub(/\n?  +/, ' '),
        Use this worksheet to record goals/work priorities, specify the
        success criteria and, when completed, to comment on the end
        results.
        INST
        styles: [:bold] }], align: :center
      move_down 6.pt

      bounding_box([0, cursor], width: bounds.right) do
        pad 4.pt do
          bounding_box([4.pt, cursor], width: bounds.right - 4.pt) do
            formatted_text [
              {text: 'Every employee is expected to work on a '},
              {text: 'minimum of three goals and/or work priorities ', styles: [:bold]},
              {text: 'and a '},
              {text: 'maximum of eight goals and or work priorities ', styles: [:bold]},
              {text: 'during the review period.'}
            ]
          end
        end
        stroke_bounds
      end
      move_down 6.pt

      text "NOTE: Attach the Performance Planning Worksheet to the annual review form."
      formatted_text [
        {text: 'Make additional copies if needed. ', styles: [:bold, :italic]},
        {text: 'For Electronic Users: Please adjust box sizes as data is entered.'}
      ]
    end

    def goal_block(n, goal)
      box_pad = 4.pt

      bounding_box([0, cursor], width: bounds.right) do
        bounding_box([0, bounds.top], width: bounds.right / 2) do
          bounding_box([box_pad, bounds.top - box_pad], width: (bounds.right - box_pad)) do
            text "#{n}. GOAL/WORK PRIORITY", style: :bold
            format_markdown(goal.description)
          end
        end

        bounding_box([bounds.right / 2, bounds.top], width: (bounds.right / 2) - box_pad) do
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
            text "DUE DATE: #{goal.due_date.nil? ? 'ongoing' : goal.due_date.strftime('%B %-d, %Y')}"
          end
        end
      end

      bounding_box([0, cursor], width: bounds.right) do
        move_down box_pad
        indent box_pad do
          bounding_box([0, cursor], width: bounds.right - box_pad) do
            formatted_text [
              {text: 'Employee Review Comments', styles: [:bold]},
              {text: Prawn::Text::NBSP * 28},
              {text: 'Date: ', styles: [:bold]},
              {text: goal.employee_review_date.to_s}
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
              {text: 'Supervisor Review Comments', styles: [:bold]},
              {text: Prawn::Text::NBSP * 26},
              {text: 'Date: ', styles: [:bold]},
              {text: goal.supervisor_review_date.to_s}
            ]
            move_down 6.pt
            format_markdown(goal.supervisor_review)
          end
        end
        stroke_bounds
      end
    end

    def format_markdown(markdown)
      document = Kramdown::Document.new(markdown, pdf: self)
      document.to_pdf_part
    end
  end
end
