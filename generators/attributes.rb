# frozen_string_literal: true

require 'fileutils'

module Generators
  # generate all the HTML5 attribute methods
  # list created via Claude.ai - blame the AI if it is wrong
  module Attributes
    ATTRIBUTES = {
      'accept' => { desc: 'Specifies file types browser will accept', values: ['audio/*', 'video/*', 'image/*'],
                    type: :string },
      'accept-charset' => { desc: 'Character encodings used for form submission', values: nil, type: :string },
      'accesskey' => { desc: 'Keyboard shortcut to access element', values: nil, type: :string },
      'action' => { desc: 'URL where form data is submitted', values: nil, type: :url },
      'align' => { desc: 'Alignment of content', values: %w[left right center justify], type: :enum },
      'alt' => { desc: 'Alternative text for images', values: nil, type: :string },
      'async' => { desc: 'Script should execute asynchronously', values: nil, type: :boolean },
      'autocomplete' => { desc: 'Form/input autocompletion', values: %w[on off], type: :enum },
      'autofocus' => { desc: 'Element should be focused on page load', values: nil, type: :boolean },
      'autoplay' => { desc: 'Media will start playing automatically', values: nil, type: :boolean },
      'bgcolor' => { desc: 'Background color of element', values: nil, type: :color },
      'border' => { desc: 'Border width in pixels', values: nil, type: :number },
      'charset' => { desc: 'Character encoding of document', values: nil, type: :string },
      'checked' => { desc: 'Whether checkbox/radio button is selected', values: nil, type: :boolean },
      'class' => { desc: 'CSS class name(s) for styling', values: nil, type: :string },
      'cols' => { desc: 'Number of columns in textarea', values: nil, type: :number },
      'colspan' => { desc: 'Number of columns a cell spans', values: nil, type: :number },
      'content' => { desc: 'Content for meta tags', values: nil, type: :string },
      'contenteditable' => { desc: 'Whether content is editable', values: %w[true false], type: :enum },
      'controls' => { desc: 'Show media playback controls', values: nil, type: :boolean },
      'coords' => { desc: 'Coordinates for image maps', values: nil, type: :string },
      'data' => { desc: 'Custom data attributes', values: nil, type: :string },
      'datetime' => { desc: 'Date/time of element content', values: nil, type: :datetime },
      'default' => { desc: 'Default track for media', values: nil, type: :boolean },
      'defer' => { desc: 'Script should execute after parsing', values: nil, type: :boolean },
      'dir' => { desc: 'Text direction', values: %w[ltr rtl auto], type: :enum },
      'disabled' => { desc: 'Element is disabled', values: nil, type: :boolean },
      'download' => { desc: 'Resource should be downloaded', values: nil, type: :boolean_or_string },
      'draggable' => { desc: 'Element can be dragged', values: %w[true false auto], type: :enum },
      'enctype' => { desc: 'Form data encoding for submission',
                     values: ['application/x-www-form-urlencoded', 'multipart/form-data', 'text/plain'], type: :enum },
      'for' => { desc: 'Associates label with form control', values: nil, type: :string },
      'form' => { desc: 'Form the element belongs to', values: nil, type: :string },
      'formaction' => { desc: 'URL for form submission', values: nil, type: :url },
      'headers' => { desc: 'Related header cells for data cell', values: nil, type: :string },
      'height' => { desc: 'Height of element', values: nil, type: :number_or_string },
      'hidden' => { desc: 'Element is not displayed', values: nil, type: :boolean },
      'high' => { desc: 'Upper range of meter', values: nil, type: :number },
      'href' => { desc: 'URL of linked resource', values: nil, type: :url },
      'hreflang' => { desc: 'Language of linked resource', values: nil, type: :string },
      'id' => { desc: 'Unique identifier for element', values: nil, type: :string },
      'integrity' => { desc: 'Subresource integrity hash', values: nil, type: :string },
      'ismap' => { desc: 'Image is server-side image map', values: nil, type: :boolean },
      'kind' => { desc: 'Type of text track', values: %w[captions chapters descriptions metadata subtitles],
                  type: :enum },
      'label' => { desc: 'Label for form control/option', values: nil, type: :string },
      'lang' => { desc: 'Language of element content', values: nil, type: :string },
      'list' => { desc: 'Links input to datalist options', values: nil, type: :string },
      'loop' => { desc: 'Media will replay when finished', values: nil, type: :boolean },
      'low' => { desc: 'Lower range of meter', values: nil, type: :number },
      'max' => { desc: 'Maximum allowed value', values: nil, type: :number_or_datetime },
      'maxlength' => { desc: 'Maximum length of input', values: nil, type: :number },
      'media' => { desc: 'Media type for resource', values: nil, type: :string },
      'method' => { desc: 'HTTP method for form submission', values: %w[get post], type: :enum },
      'min' => { desc: 'Minimum allowed value', values: nil, type: :number_or_datetime },
      'multiple' => { desc: 'Multiple values can be selected', values: nil, type: :boolean },
      'muted' => { desc: 'Media is muted by default', values: nil, type: :boolean },
      'name' => { desc: 'Name of form control', values: nil, type: :string },
      'novalidate' => { desc: 'Form validation is skipped', values: nil, type: :boolean },
      'open' => { desc: 'Details element is expanded', values: nil, type: :boolean },
      'optimum' => { desc: 'Optimal value for meter', values: nil, type: :number },
      'pattern' => { desc: 'Regular expression pattern', values: nil, type: :string },
      'placeholder' => { desc: 'Hint text for input field', values: nil, type: :string },
      'poster' => { desc: 'Preview image for video', values: nil, type: :url },
      'preload' => { desc: 'How media should be loaded', values: %w[auto metadata none], type: :enum },
      'readonly' => { desc: 'Input field cannot be modified', values: nil, type: :boolean },
      'rel' => { desc: 'Relationship of linked resource',
                 values: %w[alternate author bookmark help license next nofollow noreferrer prefetch prev search tag], type: :enum },
      'required' => { desc: 'Input must be filled out', values: nil, type: :boolean },
      'reversed' => { desc: 'List is numbered in reverse', values: nil, type: :boolean },
      'rows' => { desc: 'Number of rows in textarea', values: nil, type: :number },
      'rowspan' => { desc: 'Number of rows a cell spans', values: nil, type: :number },
      'sandbox' => { desc: 'Security rules for iframe',
                     values: %w[allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-top-navigation], type: :enum },
      'scope' => { desc: 'Cells header element relates to', values: %w[col colgroup row rowgroup], type: :enum },
      'selected' => { desc: 'Option is pre-selected', values: nil, type: :boolean },
      'shape' => { desc: 'Shape of image map area', values: %w[default rect circle poly], type: :enum },
      'size' => { desc: 'Size of input/select control', values: nil, type: :number },
      'sizes' => { desc: 'Image sizes for different layouts', values: nil, type: :string },
      'spellcheck' => { desc: 'Element should be spellchecked', values: %w[true false], type: :enum },
      'src' => { desc: 'URL of resource', values: nil, type: :url },
      'srcdoc' => { desc: 'Content for inline frame', values: nil, type: :string },
      'srclang' => { desc: 'Language of text track', values: nil, type: :string },
      'srcset' => { desc: 'Images to use in different situations', values: nil, type: :string },
      'start' => { desc: 'Starting number for ordered list', values: nil, type: :number },
      'step' => { desc: 'Increment for numeric input', values: nil, type: :number_or_string },
      'style' => { desc: 'Inline CSS styles', values: nil, type: :string },
      'tabindex' => { desc: 'Position in tab order', values: nil, type: :number },
      'target' => { desc: 'Where to open linked document', values: %w[_blank _self _parent _top], type: :enum },
      'title' => { desc: 'Advisory information about element', values: nil, type: :string },
      'translate' => { desc: 'Whether to translate content', values: %w[yes no], type: :enum },
      'type' => { desc: 'Type of element or input', values: nil, type: :string },
      'usemap' => { desc: 'Image map to use', values: nil, type: :string },
      'value' => { desc: 'Value of form control', values: nil, type: :string },
      'width' => { desc: 'Width of element', values: nil, type: :number_or_string },
      'wrap' => { desc: 'How text wraps in textarea', values: %w[hard soft], type: :enum }
    }.freeze

    def self.call
      File.write 'lib/fun_html/attribute_definitions.rb', template(generate.join("\n"))
      File.write 'rbi/attributes.rbx', template(rbi_sigs.join("\n"))
    end

    def self.template(body)
      <<~SRC
        module FunHtml
          # HTML attributes autogenerated, do not edit
          module AttributeDefinitions
            #{body}
          end
        end
      SRC
    end

    def self.generate
      ATTRIBUTES.map do |attr_name, meta|
        name = clean_name(attr_name)
        doc = "# #{meta[:desc]}\n"

        # the madness of exceptions
        if attr_name == 'data'
          ["# #{meta[:desc]}",
           "def #{name}(suffix, value)",
           'raise ArgumentError, "suffix (#{suffix}) must be lowercase and only contain \'a\' to \'z\' or hyphens." unless suffix.match?(/\A[a-z-]+\z/) ',
           "write(' #{attr_name}-'+suffix+'=\"', value)",
           'end'].join("\n")
        else
          doc +
            case meta[:type]
            in :boolean
              "def #{name}(value) = write_empty(' #{attr_name}', value)"
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
    end

    def self.rbi_sigs
      ATTRIBUTES.map do |attr_name, meta|
        name = clean_name(attr_name)

        if name == 'data'
          ['sig { params(suffix: String, value: String).void }',
           "def #{name}(suffix, value);end"].join("\n")
        else
          method =
            case meta[:type]
            in :boolean
              ['sig { params(value: T::Boolean).void }',
               "def #{name}(value);end"]
            in :boolean_or_string
              ['sig { params(value: T.any(String, T::Boolean)).void }',
               "def #{name}(value);end"]
            in :number
              ['sig { params(value: Numeric).void }',
               "def #{name}(value);end"]
            in :number_or_datetime | :number_or_string
              ['sig { params(value: T.any(Numeric, String)).void }',
               "def #{name}(value);end"]
            in :color |
              :datetime |
              :enum |
              :string |
              :url
              ['sig { params(value: String).void }',
               "def #{name}(value);end"]
            else
              raise meta[:type].to_s
            end

          method.join("\n")
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
