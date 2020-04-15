class Person < ActiveRecord::Base
  belongs_to :location
  belongs_to :role
  belongs_to :manager, class_name: "Person", foreign_key: :manager_id
  has_many :employees, class_name: "Person", foreign_key: :manager_id

  def self.without_remote_manager
    joins("LEFT JOIN people managers ON managers.id = people.manager_id").
    where('people.location_id = managers.location_id OR people.manager_id IS NULL')
  end

  def self.order_by_location_name
    joins(:location).order("locations.name")
  end

  def self.with_employees
    #joins(:employees).distinct
    from(
        joins(:employees).distinct,
        :people
    )
  end

  def self.with_local_coworkers
    #joins(location: :people).where("people_locations.id <> people.id").distinct
    from(joins(location: :people).where("people_locations.id <> people.id").distinct, :people)
  end
end
