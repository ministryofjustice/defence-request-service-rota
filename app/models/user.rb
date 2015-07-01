class User < ActiveRecord::Base
  devise :database_authenticatable, :async, :recoverable, :rememberable, :trackable, :validatable, :timeoutable
end
