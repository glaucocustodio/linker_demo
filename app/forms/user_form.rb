class UserForm
  include Linker
 
  main_model User

  validates  :name, presence: true
  #validate   :check_tasks
  
  private 
    def check_tasks
      self.user.tasks.each do |c|
        if c.name.blank?
          # workaround to display error messages in bootstrap style
          c.error_message = "can't be blank"
          errors.add(:base, "Task name can't be blank")
        end
      end
    end
end