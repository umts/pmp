def pw
  load 'pmp/planning_worksheet.rb'
  p=PMP::PlanningWorkSheet.new('John Doe', 'Example Position', Date.today..Date.today)
  p.render_document
  p.save_as('out/example_planning_worksheet.pdf')
end
