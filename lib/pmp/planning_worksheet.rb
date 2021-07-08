# frozen_string_literal: true

require 'kramdown'
require 'pmp/planning_worksheet/front_matter'
require 'pmp/planning_worksheet/goal_block'
require 'pmp/planning_worksheet/header_and_footer'

module PMP
  module PlanningWorksheet
    def self.new(...)
      Document.new(...)
    end

    class Document
      include Prawn::View
      include FrontMatter
      include GoalBlock
      include HeaderAndFooter

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
        @document ||= Prawn::Document.new(margin: @margins, default_leading: 8.pt)
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

      def format_markdown(markdown)
        document = Kramdown::Document.new(markdown, pdf: self)
        document.to_pdf_part
      end
    end
  end
end
