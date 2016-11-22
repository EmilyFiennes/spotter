addresses = ["54 Rue des Petites Ecuries, Paris", "1 Place Dupleix, Paris", "19 Rue Lagrange, Bordeaux", "82 Rue du Palais Gallien, Bordeaux", "57 Boulevard de Sévigné, Rennes", "7 Boulevard Sébastopol, Rennes", "50 Rue Bechevelin, Lyon", "19 Rue Paul Massimi,Lyon", "85 Rue des Trente Six Ponts, Toulouse", "36 Rue Rapas, Toulouse"]


10.times do
  event = Event.new(
    start_at: Date.today + (0..5).to_a.sample,
    end_at: Date.today + (6..10).to_a.sample,
    address: addresses.sample
    user_id: (1..10).to_a.sample,
    description:
    cancelled_at:
    level: ["newbie","intermediate","champion"].sample,
    activity_id: (1..20).to_a.sample,
    max_participants: (1..6).to_a.sample
  )
  event.save
end
