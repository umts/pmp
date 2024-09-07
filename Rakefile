# frozen_string_literal: true

require 'pathname'
$LOAD_PATH.unshift Pathname(__dir__).join('lib').to_path

require 'pmp'

def output_planning_worksheet(start_year, filename)
  settings_file = Pathname(__dir__).join('config.yml').open
  settings = PMP::Settings.new(settings_file)
  goals_file = Pathname(__dir__).join('goals.yml').open
  goals = YAML.load_stream(goals_file).map { |doc| PMP::Goal.from_hash(doc) }
  pw = PMP::PlanningWorksheet.new(
    settings.name, settings.position, settings.period(start_year), goals
  )
  pw.render_document
  pw.save_as(filename)
end

desc 'Output the planning worksheet for the period that starts now'
task :begin_planning, :year do |_t, args|
  args.with_defaults(year: Date.today.year)
  year = args[:year].to_i
  output_planning_worksheet year, "out/planning-#{year}-#{year + 1}.pdf"
end

desc 'Output the planning worksheet for the perod that ends now'
task :evaluate_planning, :year do |_t, args|
  args.with_defaults(year: Date.today.year)
  year = args[:year].to_i - 1
  output_planning_worksheet year, "out/planning-#{year}-#{year + 1}-evaluation.pdf"
end

desc 'Output self-assessment page'
task :self_assessment, :year do |_t, args|
  args.with_defaults(year: Date.today.year)

  answer_file = Pathname(__dir__).join('self-assessment.yml')
  out_file = Pathname(__dir__).join("out/self-assessment-#{args[:year]}.pdf")
  answers = YAML.load_file answer_file
  sa = PMP::SelfAssessment.new(answers)
  sa.render_document
  sa.save_as out_file
end
