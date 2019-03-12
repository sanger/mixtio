# ViewModel for the batches/index page
module Batches
  class Index

    attr_reader :consumable_type_id, :created_after, :created_before

    def initialize(params)
      @params = params
      @consumable_type_id = params.fetch(:consumable_type_id, nil)
      @created_after      = to_date(params.fetch(:created_after, nil))
      @created_before     = to_date(params.fetch(:created_before, nil))
      @page               = params.fetch(:page, nil)
    end

    # Show the filter box only if any of the params are set
    def show_filters?
      !params.empty?
    end

    # Returns the batches based on parameters given
    def batches
      batches = Batch.includes(:consumable_type)
      batches = batches.where(consumable_type_id: consumable_type_id) unless consumable_type_id.blank?
      batches = batches.where("created_at > ?", created_after) unless created_after.blank?
      batches = batches.where("created_at < ?", created_before) unless created_before.blank?
      batches.order_by_created_at.page(page)
    end

    private

    attr_reader :params, :page

    # Tries to convert date_str to a Date. Returns nil if it can not be converted
    def to_date(date_str)
      date_str.to_date unless date_str.nil?
    rescue ArgumentError
      nil
    end

  end
end