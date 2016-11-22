class ThreadsController
  def inititalize(sender_id, recipient_id, sent_at, payload)
    @sender_id = sender_id
    @recipient_id = recipient_id
    @sent_at = sent_at
    @payload = payload
    @threads_view = ThreadsView.new
  end


end


Received '#<Facebook::M@messaging={"sender"=>{"id"=>"1393875870646092"}, "recipient"=>{"id"=>"1222854861090730"}, "timestamp"=>1479836300199, "message"=>{"mid"=>"mid.1479836300199:aced051070", "seq"=>239, "text"=>"hhihihihi"}}>' from {"id"=>"1393875870646092"}
