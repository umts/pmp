def pw
  load 'pmp/planning_worksheet.rb'
  p=PMP::PlanningWorksheet.new('John Doe', 'Example Position', Date.today..Date.today, goals)
  p.render_document
  p.save_as('out/example_planning_worksheet.pdf')
end

def goals
  File.open('goals.yml.example') do |f|
    YAML.load_stream(f).map{|doc| PMP::Goal.from_hash(doc)} * 5
  end
end
