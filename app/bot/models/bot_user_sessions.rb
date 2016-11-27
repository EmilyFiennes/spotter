class BotUserSession
  attr_accessor :find_event_data, :create_event_data, :find_address_required,
                :create_date_required, :create_start_time_required,
                :create_end_time_required, :create_address_required,
                :create_max_participants_required, :create_event_description_required

  def initialize
    @find_event_data = {}
    @create_event_data = {}

    # Find event variables
    @find_address_required = false

    # Create event variable
    @create_date_required = false
    @create_start_time_required = false
    @create_end_time_required = false
    @create_address_required = false
    @create_max_participants_required = false
    @create_event_description_required = false
  end
end
