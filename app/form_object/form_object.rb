module FormObject

  extend ActiveSupport::Concern
  include ActiveModel::Model

  included do

    validate :check_for_errors

    _model = self.to_s.gsub("Form","")

    # class_attribute :model_name
    # self.model_name = ActiveModel::Name.new(_model.constantize)
    
    

    define_singleton_method :model_name do
       ActiveModel::Name.new(_model.constantize)
    end

    attr_reader :model

    alias_attribute _model.underscore.to_sym, :model

    delegate :id, to: :model

  end

  module ClassMethods

    def set_attributes(*attributes)

      delegate *attributes, to: :model

      define_method :model_attributes do
        attributes
      end

    end
  end

  def initialize(object = self.model_name.klass.new)
    @model = object
  end

  def submit(params)
    model.attributes = params[self.model_name.i18n_key].slice(*model_attributes).permit!
    if valid?
      model.save
    else
      false
    end
  end

  def persisted?
    model.id?
  end

private

  def check_for_errors
    unless model.valid?
      model.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

end