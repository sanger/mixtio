module FormObject
  class Naming
    include ActiveModel::Naming

    attr_accessor :attributes

    def initialize(klass, attributes = [])
      unless const_defined? klass, const_set
      @model_name = ActiveModel::Name.new(klass.to_s.gsub("Form","").constantize)
      @attributes = attributes
    end

    def name
      model_name.name
    end

    def model
      model_name.klass
    end

    def params_key
      model_name.i18n_key
    end

    def add_attributes(*attrs)
      @attributes.concat attrs
    end

  private

    attr_reader :model_name
  end
end