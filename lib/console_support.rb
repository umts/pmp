# frozen_string_literal: true

##
# Helper methods that are mixed into the IRB context invoked by
# +script/console+
module ConsoleSupport
  def pw
    load 'pmp/planning_worksheet.rb'
    p = PMP::PlanningWorksheet.new 'John Doe',
                                   'Example Position',
                                   Date.today..Date.today,
                                   goals
    p.render_document
    p.save_as 'out/example_planning_worksheet.pdf'
  end

  def goals
    File.open('goals.yml.example') do |f|
      YAML.load_stream(f).map { |doc| PMP::Goal.from_hash(doc) } * 5
    end
  end

  def sa
    load 'pmp/self_assessment.rb'
    s = PMP::SelfAssessment.new(Array.new(6, 'An Answer'))
    s.render_document
    s.save_as 'out/example_self_assessment.pdf'
  end
end
