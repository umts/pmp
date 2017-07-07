# frozen_string_literal: true

module Kramdown
  module Converter
    class PdfPart < Pdf
      def initialize(root, options)
        super
        return if options.key? :pdf
        warn 'Options is missing a :pdf value. Rendering will fail.'
      end

      def convert(el, opts = {})
        send(DISPATCHER_RENDER[el.type], el, opts)
      end

      def render_root(root, opts)
        @pdf = setup_document(root)
        inner(root, root_options(root, opts))
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
