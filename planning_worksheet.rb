require 'prawn'
require 'prawn/measurement_extensions'
require 'pry'

class PlanningWorkSheet
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
    @goals.each_with_index do |goal, n|
      goal_block(n, goal)
    end
    header_and_footer
  end

  def header_and_footer
    repeat(:all) do
      canvas do
        bounding_box([bounds.left + @margins[3], bounds.top - @header],
                     width: bounds.width - @margins[1] - @margins[3], height: 20.pt) do
          text "PERFORMANCE PLANNING WORKSHEET",
            size: 14.pt, style: :bold, align: :center, valign: :center
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
    p1 = 'Use this worksheet to record goals/work priorities, specify the
          success criteria and, when completed, to comment on the end
          results.'.gsub(/\n +/, ' ')
    formatted_text [
      {text: p1, styles: [:bold]}
    ], {align: :center}
    move_down 6.pt
    bounding_box([0, cursor], width: bounds.right) do
      move_down 4.pt
      formatted_text [
        {text: 'Every employee is expected to work on a '},
        {text: 'minimum of three goals and/or work priorities ', styles: [:bold]},
        {text: 'and a '},
        {text: 'maximum of eight goals and or work priorities ', styles: [:bold]},
        {text: 'during the review period.'}
      ]
      move_down 4.pt
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

  end
end
