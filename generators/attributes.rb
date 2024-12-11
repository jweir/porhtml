# frozen_string_literal: true

module Generators
  # generate all the HTML5 attribute methods
  # list created via Claude.ai - blame the AI if it is wrong
  module Attributes
    ATTRIBUTES = {
      'accept' => { values: ['audio/*', 'video/*', 'image/*'], type: :string },
      'accept-charset' => { values: nil, type: :string },
      'accesskey' => { values: nil, type: :string },
      'action' => { values: nil, type: :url },
      'align' => { values: %w[left right center justify], type: :enum },
      'alt' => { values: nil, type: :string },
      'async' => { values: nil, type: :boolean },
      'autocomplete' => { values: %w[on off], type: :enum },
      'autofocus' => { values: nil, type: :boolean },
      'autoplay' => { values: nil, type: :boolean },
      'bgcolor' => { values: nil, type: :color },
      'border' => { values: nil, type: :number },
      'charset' => { values: nil, type: :string },
      'checked' => { values: nil, type: :boolean },
      'class' => { values: nil, type: :string },
      'cols' => { values: nil, type: :number },
      'colspan' => { values: nil, type: :number },
      'content' => { values: nil, type: :string },
      'contenteditable' => { values: %w[true false], type: :enum },
      'controls' => { values: nil, type: :boolean },
      'coords' => { values: nil, type: :string },
      'data' => { values: nil, type: :string },
      'datetime' => { values: nil, type: :datetime },
      'default' => { values: nil, type: :boolean },
      'defer' => { values: nil, type: :boolean },
      'dir' => { values: %w[ltr rtl auto], type: :enum },
      'disabled' => { values: nil, type: :boolean },
      'download' => { values: nil, type: :boolean_or_string },
      'draggable' => { values: %w[true false auto], type: :enum },
      'enctype' => { values: ['application/x-www-form-urlencoded', 'multipart/form-data', 'text/plain'], type: :enum },
      'for' => { values: nil, type: :string },
      'form' => { values: nil, type: :string },
      'formaction' => { values: nil, type: :url },
      'headers' => { values: nil, type: :string },
      'height' => { values: nil, type: :number_or_string },
      'hidden' => { values: nil, type: :boolean },
      'high' => { values: nil, type: :number },
      'href' => { values: nil, type: :url },
      'hreflang' => { values: nil, type: :string },
      'id' => { values: nil, type: :string },
      'integrity' => { values: nil, type: :string },
      'ismap' => { values: nil, type: :boolean },
      'kind' => { values: %w[captions chapters descriptions metadata subtitles], type: :enum },
      'label' => { values: nil, type: :string },
      'lang' => { values: nil, type: :string },
      'list' => { values: nil, type: :string },
      'loop' => { values: nil, type: :boolean },
      'low' => { values: nil, type: :number },
      'max' => { values: nil, type: :number_or_datetime },
      'maxlength' => { values: nil, type: :number },
      'media' => { values: nil, type: :string },
      'method' => { values: %w[get post], type: :enum },
      'min' => { values: nil, type: :number_or_datetime },
      'multiple' => { values: nil, type: :boolean },
      'muted' => { values: nil, type: :boolean },
      'name' => { values: nil, type: :string },
      'novalidate' => { values: nil, type: :boolean },
      'open' => { values: nil, type: :boolean },
      'optimum' => { values: nil, type: :number },
      'pattern' => { values: nil, type: :string },
      'placeholder' => { values: nil, type: :string },
      'poster' => { values: nil, type: :url },
      'preload' => { values: %w[auto metadata none], type: :enum },
      'readonly' => { values: nil, type: :boolean },
      'rel' => {
        values: %w[alternate author bookmark help license next nofollow noreferrer prefetch prev search
                   tag], type: :enum
      },
      'required' => { values: nil, type: :boolean },
      'reversed' => { values: nil, type: :boolean },
      'rows' => { values: nil, type: :number },
      'rowspan' => { values: nil, type: :number },
      'sandbox' => {
        values: %w[allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts
                   allow-top-navigation], type: :enum
      },
      'scope' => { values: %w[col colgroup row rowgroup], type: :enum },
      'selected' => { values: nil, type: :boolean },
      'shape' => { values: %w[default rect circle poly], type: :enum },
      'size' => { values: nil, type: :number },
      'sizes' => { values: nil, type: :string },
      'spellcheck' => { values: %w[true false], type: :enum },
      'src' => { values: nil, type: :url },
      'srcdoc' => { values: nil, type: :string },
      'srclang' => { values: nil, type: :string },
      'srcset' => { values: nil, type: :string },
      'start' => { values: nil, type: :number },
      'step' => { values: nil, type: :number_or_string },
      'style' => { values: nil, type: :string },
      'tabindex' => { values: nil, type: :number },
      'target' => { values: %w[_blank _self _parent _top], type: :enum },
      'title' => { values: nil, type: :string },
      'translate' => { values: %w[yes no], type: :enum },
      'type' => { values: nil, type: :string },
      'usemap' => { values: nil, type: :string },
      'value' => { values: nil, type: :string },
      'width' => { values: nil, type: :number_or_string },
      'wrap' => { values: %w[hard soft], type: :enum }
    }.freeze

    def self.call
      source =
        <<~SRC
          # frozen_string_literal: true

          module FunHtml
            # HTML attributes autogenerated, do not edit
            module AttributeDefinitions
              #{generate.join("\n")}
            end
          end
        SRC

      File.write 'lib/fun_html/attribute_definitions.rb', source
    end

    def self.generate
      ATTRIBUTES.map do |attr_name, meta|
        name = clean_name(attr_name)

        case meta[:type]
        in :boolean
          "def #{name}(state = true) = write_empty(' #{attr_name}', state)"
        in
          :boolean_or_string |
          :color |
          :datetime |
          :enum |
          :number |
          :number_or_datetime |
          :number_or_string |
          :string |
          :url
          "def #{name}(value) = write(' #{attr_name}=\"', value)"
        else
          raise meta[:type].to_s
        end
      end
    end

    def self.clean_name(name)
      case name
      in 'class'
        'klass'
      else
        name.gsub('-', '_')
      end
    end
  end
end
