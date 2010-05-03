class I18N
  I18N_YAML_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'i18n'))

  LANGUAGES = {} 

  attr_accessor :language

  def initialize(language)
    @language = language
  end

  def translate!(attributes)
    if i18n?
      translate_text! attributes
      translate_days! attributes
      translate_locations! attributes
    end
    attributes
  end

  private
    def translate_text!(attributes)
      translate_attribute('text', attributes, language_translations, 'code')
    end

    def translate_days!(attributes)
      translate_attribute('day', attributes, language_translations['forecasts']['days'])
    end

    def translate_locations!(attributes)
      (%w[city country region] & attributes.keys).each do |key|
        translate_attribute(key, attributes, language_translations['locations'])
      end
    end

    def translate_attribute(name, attributes, translations, change_by = nil)
      translation_key = attributes[(change_by || name)]

      if attributes[name] and translations[translation_key]
        attributes[name] = translations[translation_key]
      end
    end

    def language_translations
      LANGUAGES[language] ||= load_language_yaml!
    end

    def load_language_yaml!
      stream = File.read(File.join(I18N_YAML_DIR, language + '.yml'))
      YAML::load(stream) 
    end

    def i18n?
      !!@language
    end
end
