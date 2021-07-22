# frozen_string_literal: true

require 'pmp/planning_worksheet/front_matter'
require 'pmp/planning_worksheet/goal_block'
require 'pmp/planning_worksheet/header'

module PMP
  ##
  # PMP "planning worksheet" module used to namespace its component
  # modules, and the actual document.
  module PlanningWorksheet
    ##
    # For convenience: allows typing +PMP::PlanningWorksheet.new+
    def self.new(...)
      Document.new(...)
    end

    ##
    # The actual document class
    class Document < PMP::Document
      include FrontMatter
      include GoalBlock
      include Header

      def initialize(name, position, date_range, goals = [])
        super
        @name = name
        @position = position
        @start_date = date_range.first
        @end_date = date_range.last
        @goals = goals
      end

      def render_document
        front_matter
        @goals.each.with_index(1) do |goal, n|
          goal_block(n, goal)
          start_new_page unless n == @goals.count
        end
        header_and_footer
      end
    end
  end
end
