# This class show us what Linker gem is going to do 
# under the hood via metaprogramming
# class UserForm
  
#   include ActiveModel::Model
  
#   attr_reader :user

#   delegate :name, :name=, :avatar, :avatar=, to: :user

#   validates :name, presence: true

#   validate :check_tasks

#   def initialize user
#     @user = user
#   end

#   def dependent_users
#     if @user.dependent_users.map{|c| c}.present?
#       @user.dependent_users.map{|c| c}
#     else
#       [DependentUser.new] * 2
#     end
#   end

#   def dependent_users_attributes=(attributes)
#   end

#   def tasks
#     if @user.tasks.map{|c| c}.present?
#       @user.tasks.map{|c| c}
#     else
#       [Task.new] * 2
#     end
#   end

#   def tasks_attributes=(attributes)
#   end

#   def address
#     (@user.address.present? && @user.address) || Address.new
#   end

#   def address_attributes=(attributes)
#   end

#   def company
#     (@user.company.present? && @user.company) || Company.new
#   end

#   def company_attributes=(attributes)
#   end

#   def family
#     (@user.family.present? && @user.family) || Family.new
#   end

#   def family_attributes=(attributes)
#   end

#   def to_model
#     @user
#   end

#   def params= params
#     @user.dependent_users.destroy_all if !params.key?('dependent_users_attributes')
#     @user.tasks.destroy_all           if !params.key?('tasks_attributes')

#     params.each do |param, value|
#       table = param.gsub(%r{_attributes$}, '')
#       if value.is_a?(Hash)
#         # belongs_to attrs
#         if User.reflect_on_all_associations(:belongs_to).map{|c| c.klass.name}.select{|c| c == table.singularize.camelize}.present?
#           if value['id'].present?
#             @user.send(table).update(value)
#           else
#             @user.send("build_#{table}", value)
#           end

#         # has_one
#         elsif User.reflect_on_all_associations(:has_one).map{|c| c.klass.name}.select{|c| c == table.singularize.camelize}.present?
#           if value['id'].present?
#             @user.send(table).update(value)
#           else
#             @user.send("#{table}=", table.singularize.camelize.constantize.new(value))
#           end

#         # has_many attrs
#         else
#           ids = value.map.with_index{|c,i| c.last['id'].present? ? c.last['id'] : nil }.compact
#           @user.send(table).where(["#{table}.id NOT IN (?)", ids]).destroy_all if ids.present?

#           value.each do |c|
#             if c.last['id'].present?
#               @user.send(table).find(c.last['id']).update(c.last)
#             else
#               @user.send(table) << table.singularize.camelize.constantize.new(c.last)
#             end
#           end
#         end
#       else
#         self.send("#{param}=", value)
#       end
#     end
    
#   end

#   def save validate: true
#     if validate     
#       self.valid? && @user.save
#     else
#       @user.save
#     end
#   end

#   private 
#     def check_tasks
#       self.user.tasks.each do |c|
#         if c.name.blank?
#           c.error_message = "can't be blank"
#           errors.add(:base, "Task name can't be blank")
#         end
#       end
#     end
  
# end