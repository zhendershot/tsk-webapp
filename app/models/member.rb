class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name1, :name2, :name3, :extra_emails, :phone, :disabled, :disabled_reason, :admin

  has_many :orders, :dependent => :destroy
  validates_presence_of :name1, :email
  validates_uniqueness_of :email

  ServiceStartDate = Time.local(2011,11,01)
  HoursPerMonth = 2.0
  
  def name
    [name1,name2,name3].collect{ |e| e.nil? or e.strip == "" ? nil : e }.compact.join(", ")
  end

  def service_total
    # would be more efficient to do this select in the db...
    Service.find_all_by_member_id(self.id).collect{ |e| e.created_at >= ServiceStartDate ? e.hours : nil }.compact.sum
  end
 
  def service_per_week
    (self.service_total/(self.days_since_service_start/7.0))
  end

  def service_per_month
    self.service_total/self.months_since_service_start
  end

  def days_as_member
    ((Time.now - self.created_at)/(2400*24)).ceil
  end

  class Month<Date
    def next
      self >> 1
    end
    def prior
      self << 1
    end
  end

  def consective_months_under_service
    cur = Month.new(Time.now.year,Time.now.month)
    cur = cur.prior
    first = Month.new(self.created_at.year,self.created_at.month)
    thresh = Setting.first.workshare_hours_per_month
    return 0 if thresh.nil?
    n = 0
    while cur >= first
      sum = 0
      Service.where("extract(year from did_at)=? AND extract(month from did_at)=?",cur.year,cur.month).collect{ |s| 
        sum += s.hours unless s.hours.nil? 
      }
      if sum < thresh
        n += 1
      else
        break
      end
      cur = cur.prior
    end
    return n
  end

  # hack!
  def days_since_service_start
    ((Time.now - ServiceStartDate)/(2400*24)).round
  end

  def months_since_service_start
    y1 = ServiceStartDate.year
    m1 = ServiceStartDate.month
    y2 = Time.now.year
    m2 = Time.now.month
    (y2*12+m2)-(y1*12+m1)
  end

  def service_balance
    self.months_since_service_start*HoursPerMonth - self.service_total
  end


end
