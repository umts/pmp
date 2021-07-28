# frozen_string_literal: true

require 'pathname'
require 'prawn'
require 'prawn/measurement_extensions'
require 'kramdown'
require 'kramdown/converter/pdf_part'

module PMP
  ##
  # Parent class for the documents produced by this repo. Normalizes shared
  # settings like:
  #
  # * Margins
  # * Fonts
  # * Headers and footers
  class Document
    include Prawn::View

    attr_accessor :margins

    def initialize(*_args)
      @margins = Array.new(4, 1.in)
      @header = @footer = 0.5.in

      font_families.update(liberation_fonts)
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
      document = Kramdown::Document.new(markdown.to_s, pdf: self)
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

    def liberation_fonts
      font_dir = Pathname(__dir__).join('../../fonts')

      %w[Mono Sans Serif].map do |family|
        ["Liberation#{family}", {
          normal: font_dir.join("Liberation#{family}-Regular.ttf"),
          bold: font_dir.join("Liberation#{family}-Bold.ttf"),
          italic: font_dir.join("Liberation#{family}-Italic.ttf"),
          bold_italic: font_dir.join("Liberation#{family}-BoldItalic.ttf")
        }]
      end.to_h
    end
  end
end
