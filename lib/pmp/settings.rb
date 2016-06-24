module PMP
  class Settings

    ATTRS = %i(name department position supervisor reviewer reviewer_title).freeze
    attr_accessor(*ATTRS)

    def init(settings_file)
      settings_file.rewind
      data = YAML.load(settings.read)
      ATTRS.each do |attr|
        instance_variable_set(attr, data[attr.to_s])
      end
      @period_start = data['period_start']
    end

    def start_date(year)
      month = @period_start[0,2]
      day = @period_start[2,2]
      Date.new(year.to_i, month, day)
    end

    def end_date(year)
      start_date(year).next_year - 1
    end

    def period(year)
      (start_date..end_date)
    end
  end
end
