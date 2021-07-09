# frozen_string_literal: true

require 'pathname'
require 'prawn'
require 'prawn/measurement_extensions'
require 'kramdown'
require 'kramdown/converter/pdf_part'

module PMP
  class Document
    include Prawn::View

    attr_accessor :margins

    def initialize(*_args)
      @margins = Array.new(4, 1.in)
      @header = @footer = 0.5.in

      font_dir = Pathname(__dir__).join('../../fonts')
      font_families.update('LiberationSerif' => {
                             normal: font_dir.join('LiberationSerif-Regular.ttf'),
                             bold: font_dir.join('LiberationSerif-Bold.ttf'),
                             italic: font_dir.join('LiberationSerif-Italic.ttf'),
                             bold_italic: font_dir.join('LiberationSerif-BoldItalic.ttf')
                           })
      font 'LiberationSerif'
    end

    def document
      @document ||= Prawn::Document.new(margin: @margins, default_leading: 8.pt)
    end

    private

    def box_pad
      4.pt
    end

    def boxed_with_padding(&block)
      bounding_box([0, cursor], width: bounds.right) do
        pad box_pad do
          bounding_box [box_pad, cursor], width: bounds.right - box_pad, &block
        end
        stroke_bounds
      end
    end

    def footer
      text_box 'University of Massachusetts SEIU Performance Management Program',
               at: [0, @footer], align: :center
    end

    def format_markdown(markdown)
      document = Kramdown::Document.new(markdown, pdf: self)
      document.to_pdf_part
    end

    def header; end

    def header_and_footer
      repeat :all do
        canvas do
          header
          footer
        end
      end
    end
  end
end
