# frozen_string_literal: true

module Kramdown
  module Converter
    class PdfPart < Pdf
      def initialize(root, options)
        super
        return if options.key? :pdf

        warn 'Options is missing a :pdf value. Rendering will fail.'
      end

      def codeblock_options(_el, opts)
        { font: 'LiberationMono', color: '880000', bottom_padding: opts[:size] }
      end

      def codespan_options(_el, _opts)
        { font: 'LiberationMono', color: '880000' }
      end

      def convert(element, opts = {})
        send(DISPATCHER_RENDER[element.type], element, opts)
      end

      def header_options(el, opts)
        size = opts[:size] * 1.15**(6 - el.options[:level])
        {
          font: 'LiberationSans', styles: (opts[:styles] || []) + [:bold],
          size: size, bottom_padding: opts[:size], top_padding: opts[:size]
        }
      end

      def render_root(root, opts)
        @pdf = setup_document(root)
        inner(root, root_options(root, opts))
      end

      def root_options(_root, _opts)
        { size: 12, leading: 2 }
      end

      def setup_document(_root)
        doc = @options.fetch(:pdf)
        doc.extend(PrawnDocumentExtension)
        doc.converter = self
        doc
      end
    end
  end
end
