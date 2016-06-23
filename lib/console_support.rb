def pw
  load 'planning_worksheet.rb'
  p=PlanningWorkSheet.new('John Doe', 'Example Position', Date.today..Date.today)
  p.render_document
  p.save_as('out/example_planning_worksheet.pdf')
end
