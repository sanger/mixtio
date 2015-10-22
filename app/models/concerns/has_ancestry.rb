module HasAncestry

  extend ActiveSupport::Concern

  def add_children(children)
    Array(children).each { |child| add_ancestor(child, self) }
    self
  end

  def add_parents(parents)
    Array(parents).each { |parent| add_ancestor(self, parent) }
    self
  end

  def add_ancestor(child, parent)
    Ancestor.create(family_name: self.class.to_s, family_id: child.id, relation_id: parent.id, relation_type: "Child")
    Ancestor.create(family_name: self.class.to_s, family_id: parent.id, relation_id: child.id, relation_type: "Parent")
  end

  def children
    ancestors("Parent")
  end

  def parents
    ancestors("Child")
  end

  def parent_ids
    @parent_ids ||= parents.select(&:id)
  end

  def parent_ids=(parent_ids)
    @parent_ids = parent_ids.instance_of?(String) ? parent_ids.split(',').collect(&:to_i) : parent_ids
  end

  private

  def ancestors(relation_type)
    ancestors = Ancestor.where(family_name: self.class.to_s, relation_type: relation_type, family_id: self.id)
    ancestors.empty? ? ancestors : self.class.find(ancestors.pluck(:relation_id))
  end

end