# frozen_string_literal: true

module PMP
  class Settings
    ATTRS = %i[name department position supervisor reviewer reviewer_title period_start].freeze
    attr_accessor(*ATTRS - [:period_start])

    def initialize(settings_file)
      settings_file.rewind
      data = YAML.safe_load(settings_file.read)
      ATTRS.each do |attr|
        instance_variable_set("@#{attr}", data[attr.to_s])
      end
    end

    def start_date(year)
      month = @period_start[0, 2].to_i
      day = @period_start[2, 2].to_i
      Date.new(year.to_i, month, day)
    end

    def end_date(year)
      start_date(year).next_year - 1
    end

    def period(year)
      (start_date(year)..end_date(year))
    end
  end
end
