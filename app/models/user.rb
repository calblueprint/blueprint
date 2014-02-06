class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  before_validation :nullify_blanks

  validates :name, :presence => true

  validate :unique_email
  validate :position_exists

  accepts_nested_attributes_for :roles

  has_attached_file :image,
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/users/:style/:id/:filename",
    :styles => { :medium => "400px>" },
    :default_url => "member.png"

  def image_path
    file_name = self.name.downcase.split.join('_')
    return "/images/members/" + file_name + ".jpg"
  end

  def position_type
    User.positions_by_type.select {|k,v| v.include?(self.position)}.first.first
  end

  def self.positions
    User.positions_by_type.values.flatten
  end

  def set_roles(params)
    @user = User.find(params[:id])
    params[:user][:roles_attributes].each do |id, role|
      @user.add_role_for_semester(role["name"], Semester.find(role["resource_id"]))
    end
  end

  # Roles
  def add_role_for_semester(role, semester)
    if role_for_semester(semester).nil?
      self.add_role role, semester
    else
      user_role = self.roles.find_by_resource_id(semester.id)
      user_role.name = role
      user_role.save
    end
  end

  def role_for_semester(semester)
    self.roles.find_by_resource_id(semester.id)
  end

  def role_for_current_semester
    self.role_for_semester(Semester.current)
  end

  def is_admin
    unless role_for_current_semester.nil?
      (User.positions_by_type["exec"] + User.positions_by_type["pl"]).include? role_for_current_semester.name
    else
      false
    end
  end

  protected
  def nullify_blanks
    attributes.each do |col, val|
      # dont' use blank? because false is blank
      self[col] = nil if self[col].nil? or self[col] == ""
    end
  end

  def unique_email
    users_with_same_email = User.where("email = ? OR facebook_id = ?", self.email, self.email)
    users_with_same_email.each do |u|
      unless u == self
        errors.add(:email, "Someone is already using this e-mail!")
      end
    end
    unless facebook_id.nil?
      users_with_same_facebook_id = User.where("email = ? OR facebook_id = ?", self.facebook_id, self.facebook_id)
      users_with_same_facebook_id.each do |u|
        unless u == self
          errors.add(:email, "Someone is already using this Facebook ID!")
        end
      end
    end
  end

  def position_exists
    unless User.positions.include?(self.position)
      errors.add(:position, 'A valid position must be given!')
    end
  end

  def self.positions_by_type
    return {
      'exec' => ["President", "VP of Technology", "VP of Projects", "VP of Operations", "VP of Marketing & Finance", "Internal VP", "External VP"],
      'pl' => ["Project Leader"],
      'member' => ["Project Member"],
      'chair' => ["Technology Chair", "Marketing Chair", "External Relations & Events Chair"],
      'faculty' => ["Faculty Advisor"]
    }
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.info
    User.where("email = ? OR facebook_id = ?", data['email'], data['email']).first
  end
end
