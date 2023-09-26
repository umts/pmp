# frozen_string_literal: true

module Kramdown
  module Converter
    ##
    # This class is a Kramdown converter that inherits from the one in
    # "kramdown-converter-pdf". The primary difference is that, rather than
    # instantiating a new Prawn document, it can (must) take an existing one
    # as an option. The converter then calls Prawn methods on _that_ document
    # to render.
    #
    # Results may be mixed depending on the existing PDF, but it works well
    # for "a text box with some rendered markdown in it.
    class PdfPart < Pdf
      ##
      # Just a call to super plus a warning if the +:pdf+ option is missing.
      def initialize(root, options)
        super
        return if options.key? :pdf

        warn 'Options is missing a :pdf value. Rendering will fail.'
      end

      ##
      # Copy of the super method with the font changed to a TTF font
      def codeblock_options(_element, opts)
        { font: 'LiberationMono', color: '880000', bottom_padding: opts[:size] }
      end

      ##
      # Copy of the super method with the font changed to a TTF font
      def codespan_options(_element, _opts)
        { font: 'LiberationMono', color: '880000' }
      end

      ##
      # Essentially, the meat of the super method, but with all logic about
      # ids, auto-headers, and table-of-contents generation removed. All of
      # that stuff is inaccessible from inside a _part_ of the PDF.
      def convert(element, opts = {})
        send(DISPATCHER_RENDER[element.type], element, opts)
      end

      ##
      # Copy of the super method with the font changed to a TTF font
      def header_options(element, opts)
        size = opts[:size] * (1.15**(6 - element.options[:level]))
        {
          font: 'LiberationSans', styles: (opts[:styles] || []) + [:bold],
          size:, bottom_padding: opts[:size], top_padding: opts[:size]
        }
      end

      ##
      # Copy of the super method that does not cause the Prawn document to
      # render. Nor does it do anything about constructing a table-of-contents
      def render_root(root, opts)
        @pdf = setup_document(root)
        inner(root, root_options(root, opts))
      end

      ##
      # Copy of the super method with the default font removed
      def root_options(_root, _opts)
        { size: 12, leading: 2 }
      end

      ##
      # Copy of the super method that uses +@options.fetch(:pdf)+ as the
      # document object rather than a new Prawn::Document
      def setup_document(_root)
        doc = @options.fetch(:pdf)
        doc.extend(PrawnDocumentExtension)
        doc.converter = self
        doc
      end
    end
  end
end
