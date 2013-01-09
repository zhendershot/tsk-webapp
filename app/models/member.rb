class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name1, 
                  :name2, :name3, :extra_emails, :phone, :disabled, :disabled_reason, 
                  :admin, :joined_on, :service_group

  has_many :orders, :dependent => :destroy
  validates_presence_of :name1, :email
  validates_uniqueness_of :email

  ServiceStartDate = Time.local(2013,01,01)
  HoursPerMonth = 2.0
  
  def name
    [name1,name2,name3].collect{ |e| e.nil? or e.strip == "" ? nil : e }.compact.join(", ")
  end

  def service_total
    # would be more efficient to do this select in the db...
    Service.find_all_by_member_id(self.id).collect{ |e| e.created_at >= ServiceStartDate ? e.hours : nil }.compact.sum
  end

  def start_date
    self.joined_on.nil? ? self.created_at.to_date : self.joined_on
  end
 
  def service_per_week
    (self.service_total/(self.days_since_service_start/7.0))
  end

  def service_per_month
    self.months_since_service_start == 0 ? 0.0 : self.service_total/self.months_since_service_start
  end

  def days_as_member
    ((Time.now - self.start_date.to_time)/(2400*24)).ceil
  end

  class Month<Date
    def next
      self >> 1
    end
    def prior
      self << 1
    end
  end

  def consecutive_months_under_service
    cur = Month.new(Time.now.year,Time.now.month)
    #first = Month.new(self.start_date.year,self.start_date.month)
    first = Month.new(ServiceStartDate.year,ServiceStartDate.month)
    thresh = Setting.first.workshare_hours_per_month
    return 0 if thresh.nil?
    # start at -1 because we're considering the current month too
    n = -1 
    while cur >= first
      sum = 0
      Service.where("member_id=? AND extract(year from did_at)=? AND extract(month from did_at)=?",self.id,cur.year,cur.month).collect{ |s| 
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
