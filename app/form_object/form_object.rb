module FormObject

  extend ActiveSupport::Concern
  include ActiveModel::Model

  included do

    class_attribute :form_variables
    self.form_variables = []

    attr_reader :params, :controller, :action

    validate :check_for_errors

     _model = self.to_s.gsub("Form","")

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

    def set_form_variables(*variables)
      #self.class.form_variables = variables
      variables.each do |variable|
        attr_accessor variable
      end
    end
  end

  def initialize(object = self.model_name.klass.new)
    @model = object
  end

  def submit(params)
    assign_attributes(params: params, controller: params[:controller], action: params[:action])
    assign_form_variables
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

  def assign_attributes(attributes)
    attributes.each do |k,v|
      assign_attribute k, v
    end
  end

  def assign_attribute(attribute, value)
    instance_variable_set "@#{attribute}", value
  end

  def assign_form_variables
    p self.form_variables
    self.form_variables.each do |variable|
      instance_variable_set "@#{variable}", params[self.model_name.i18n_key][variable]
    end
  end

end