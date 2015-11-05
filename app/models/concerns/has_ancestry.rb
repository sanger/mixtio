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

  def delete_parents
    find_parents.delete_all
    self
  end

  def set_parents(parents)
    delete_parents
    add_parents(parents)
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
    ancestors = find_relations(relation_type)
    ancestors.empty? ? ancestors : self.class.find(ancestors.pluck(:relation_id))
  end

  def find_parents
    find_relations("Child")
  end

  def find_children
    find_relations("Parent")
  end

  def find_relations(relation_type)
    Ancestor.where(family_name: self.class.to_s, relation_type: relation_type, family_id: self.id)
  end

end