# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  due_date    :date
#  category_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#  code        :string
#
class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :name, type: String
  field :description, type: String
  field :due_date, type: Date
  field :code, type: String
  field :status, type: String
  field :transitions, type: Array, default: []

  belongs_to :category
  belongs_to :owner, class_name: 'User'

  has_many :participating_users, class_name: 'Participant'
  # has_many :participants, through: :participating_users, source: :user 
  has_many :notes

  validates :participating_users, presence: true
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_insensitive: false }
  validate :due_date_validity

  before_create :create_code

  after_create :send_email

  # Aceptar atributos anidados
  # Permite anidar informacion de nuestros participantes y tambien destruir
  accepts_nested_attributes_for :participating_users, allow_destroy: true

  #AASM Maquina de estado
  aasm column: :status do # se le establece la variable declarada previamente
    state :pending, initial: true
    state :in_process, :finished

    #callback
    after_all_transitions :audit_status_change

    event :start do
      transitions from: :pending, to: :in_process
    end

    event :finish do
      transitions from: :in_process, to: :finished
    end

  end

  #callback
  def audit_status_change
    # puts "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
    set transitions: transitions.push(
      {
        from_state: aasm.from_state,
        to_state: aasm.to_state,
        current_event: aasm.current_event,
        timestamps: Time.zone.now
      }
    )
  end

  # Equivalencia
  def participants
    participating_users.includes(:user).map(&:user)
  end

  def due_date_validity
    return if due_date.blank? # Si es due_date esta en blanco 'true'
    return if due_date > Date.today # Si el due-date es mayoral dia de hoy 'true'

    errors.add :due_date, I18n.t('task.errors.invalid_due_date')
    # Si las condiciones no se cumplen es :due_date es la que tiene el error
  end

  def create_code
    self.code = "#{owner_id}#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"
  end

  def send_email
    return unless Rails.env.development?
    # Tasks::SendEmailJob.perform_async self.id.to_s # id.to_s
    Tasks::SendEmailJob.perform_in 5, self.id.to_s # perform_in 5 -> Espera 5 segundos para enviar el correo 
  end

end
