# This class show us what Linker gem is going to do 
# under the hood via metaprogramming
class UserUnderHoodForm
  include ActiveModel::Model

  attr_reader :user

  delegate :name, :name=, :avatar, :avatar=, to: :user

  validates :name, presence: true

  PROFILES = Profile.all.map{|c| [c.profile_type, c.id]}

  #validate :check_tasks

  def initialize user
    @user = user
  end

  def profile_list
    (@user.profile.present? && @user.profile.id) || nil
  end

  def dependent_users
    if @user.dependent_users.map{|c| c}.present?
      @user.dependent_users.map{|c| c}
    else
      [DependentUser.new] * 2
    end
  end

  def dependent_users_attributes=(attributes)
  end

  def tasks
    if @user.tasks.map{|c| c}.present?
      @user.tasks.map{|c| c}
    else
      [Task.new] * 2
    end
  end

  def tasks_attributes=(attributes)
  end

  def address
    (@user.address.present? && @user.address) || Address.new
  end

  def address_attributes=(attributes)
  end

  def company
    (@user.company.present? && @user.company) || Company.new
  end

  def company_attributes=(attributes)
  end

  def my_family
    (@user.my_family.present? && @user.my_family) || Family.new
  end

  def my_family_attributes=(attributes)
  end

  def to_model
    @user
  end

  def params= params
    params.each do |param, value|
      if value.is_a?(Hash)
        table = param.gsub(%r{_attributes$}, '')
        # belongs_to attrs
        if User.reflect_on_all_associations(:belongs_to).map{|c| c.name.to_s}.select{|c| c == table}.present?
          if value['id'].present?
            @user.send(table).update_attributes(value)
          else
            @user.send("build_#{table}", value)
          end

        # has_one
        elsif search_has_one(table)
          if value['id'].present?
            @user.send(table).update_attributes(value)
          else
            @user.send("build_#{table}", value)
          end

        # has_many attrs
        else
          ids_to_remove = value.map{|c| c.last['id'] if c.last['id'].present? && c.last.key?('_remove') && c.last['_remove'] == '1' }.compact

          if ids_to_remove.present?
            r = search_has_many(table)
            r[:klass].constantize.send(:where, ["#{r[:klass].constantize.table_name}.id IN (?)", ids_to_remove]).destroy_all
            value.delete_if{|i, c| ids_to_remove.include?(c['id']) }
          end

          value.each do |c|
            if c.last['id'].present?
              @user.send(table).find(c.last['id']).update_attributes(c.last.except('_remove'))
            else
              @user.send(table).send(:build, c.last.except('_remove'))
            end
          end
        end
      elsif param.match(/_list$/)
        assoc = param.gsub(/_list$/, '')
        if r = search_has_one(assoc)
          final = value.present? ? r[:klass].constantize.send(:find, value) : nil
          @user.send("#{assoc}=", final)
        end
      else
        self.send("#{param}=", value)
      end
    end
    
  end

  def save validate: true
    if validate     
      self.valid? && @user.save
    else
      @user.save
    end
  end

  private 
    def check_tasks
      self.user.tasks.each do |c|
        if c.name.blank?
          c.error_message = "can't be blank"
          errors.add(:base, "Task name can't be blank")
        end
      end
    end

    def search_has_many name
      s = User.reflect_on_all_associations(:has_many).inject([]) do |t, c| 
        t << {
          name: c.name.to_s, 
          klass: c.klass.name,
        }
      end
      .detect{|c| c[:name] == name}
      s.present? && s
    end

    def search_has_one name
      s = User.reflect_on_all_associations(:has_one).inject([]) do |t, c| 
        t << {
          name: c.name.to_s, 
          klass: c.klass.name,
        }
      end
      .detect{|c| c[:name] == name}
      s.present? && s
    end
  
end