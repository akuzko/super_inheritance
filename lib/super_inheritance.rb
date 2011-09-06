require 'active_support'

module SuperInheritance
  extend ActiveSupport::Concern
  
  module ClassMethods
    def acts_as_super
      def self.inherited subclass
        inherited_with_inheritable_attributes subclass
        
        super_association_name = name.downcase.to_sym
        foreign_key = "super_#{name.downcase}_id"
        column_names_without_sti = connection.columns(undecorated_table_name(subclass.name), "#{subclass.name} Columns").map(&:name)
        
        if column_names_without_sti.include? foreign_key
          subclass.class_eval do
            include ::SuperInheritance::Subclass
            belongs_to super_association_name, :foreign_key => foreign_key, :autosave => true, :touch => true, :dependent => :destroy
            reflections[:super] = reflections[super_association_name]
            alias_method :super_association, super_association_name
            alias_method :build_super, :"build_#{super_association_name}"
          end
        end
      end
    end
  end
  
  module Subclass
    extend ActiveSupport::Concern
    
    included do
      reset_column_information
      set_table_name undecorated_table_name(name)
      default_scope select("#{superclass.table_name}.*, #{table_name}.*").joins(:super).includes(:super)
      
      before_validation :delegate_associations
    end
    
    module ClassMethods
      def base_class
        self
      end
      
      def columns
        super + superclass_columns
      end
      
      def unscoped
        default_scoping[0]
      end
      
      def superclass_columns
        superclass.columns.reject{ |c| c.name == superclass.primary_key }
      end
      private :superclass_columns
      
      def superclass_column_names
        superclass_columns.map(&:name)
      end
      private :superclass_column_names
    end
    
    def column_for_attribute name
      super unless self.super.column_for_attribute(name)
    end
    
    def write_attribute name, value
      build_super_with_attributes unless super_association
      self.super.send(:write_attribute, name, value) if self.class.superclass_column_names.include?(name)
      super
    end
    
    def super
      super_association || build_super_with_attributes
    end
    
    def build_super_with_attributes
      super_attributes = attributes.select{ |k, v| self.class.superclass_column_names.include? k }
      build_super super_attributes
    end
    private :build_super_with_attributes
    
    def delegate_associations
      build_super_with_attributes unless self.super_association
      self.class.superclass.reflect_on_all_associations.each do |assoc|
        if instance = association_instance_get(assoc.name)
          self.super.instance_variable_set "@#{assoc.name}", instance
        end
      end
    end
    private :delegate_associations
  end
end
