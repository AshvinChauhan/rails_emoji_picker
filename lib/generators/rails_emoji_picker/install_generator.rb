module RailsEmojiPicker
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.dirname(__FILE__)

      def append_to_js
        insert_into_file 'app/assets/javascripts/application.js', "//= require rails_emoji_picker\n", before: '//= require_tree .'
      end

      def insert_to_css
        application_css = css_type
        type = application_css.split('.')[1]

        case type
        when 'css'
          insert_into_file application_css, " *= require rails_emoji_picker\n", before: ' *= require_self'
        when 'scss'
          insert_into_file application_css, "\n@import 'rails_emoji_picker';", after: '*/'
        when 'sass'
          insert_into_file application_css, "\n@import 'rails_emoji_picker'", after: '*= require_self'
        end
      end

      def insert_to_assets
        regex = /# Add additional assets to the asset load path/
        insert_into_file 'config/initializers/assets.rb/', "\nRails.application.config.assets.paths << Emoji.images_path", after: regex
        insert_into_file 'config/initializers/assets.rb/', "\nRails.application.config.assets.precompile += %w(emoji/*.png)", after: regex
      end

      def copy_images
        directory 'emoji_img', 'public/emoji_img'
      end

      def info
        puts "    =====================================================
              #{yellow '😼  😼  😼  Rails Emoji Picker'} #{yellow RailsEmojiPicker::VERSION}  #{yellow '😼  😼  😼'}
              #{blue 'Repository'}: 'https://github.com/ID25/rails_emoji_picker'
              #{blue 'Author'}: Eugene Domosedov (ID25)

          1. Add this data-attribute to your input/text field

            #{green 'data: { emojiable: true }'}

          2. Wrap your input with #{yellow '.emoji-picker-container'} css-class

            #{green 'p.emoji-picker-container'}

          3. To show text with emoji, use helper content_with_emoji

        Exaple:
          #{green 'p.emoji-picker-container'}
            #{green '= f.text_field :title, class: "form-control", data: { emojiable: true }'}

          #{green '= content_with_emoji(@post.title)'}

    =====================================================
          "
      end

      private

      def css_type
        css_file = if File.file?(css_file('css'))
                     css_file('css')
                   elsif File.file?(css_file('scss'))
                     css_file('scss')
                   elsif File.file?(css_file('sass'))
                     css_file('sass')
                   end
        css_file
      end

      def css_file(type)
        "app/assets/stylesheets/application.#{type}"
      end

      def colorize(text, color_code)
        "\e[#{color_code}m#{text}\e[0m"
      end

      def green(text)
        colorize(text, 32)
      end

      def yellow(text)
        colorize(text, 33)
      end

      def blue(text)
        colorize(text, 36)
      end
    end
  end
end
