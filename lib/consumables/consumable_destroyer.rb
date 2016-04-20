class ConsumableDestroyer

  def run!
    ConsumableType.destroy_all
    Supplier.destroy_all
    Lot.destroy_all
    Consumable.destroy_all
    Batch.destroy_all
    Audit.destroy_all
    Favourite.destroy_all
    Mixture.destroy_all
  end

  private

end