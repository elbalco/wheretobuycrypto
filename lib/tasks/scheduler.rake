namespace :scheduler do
  desc "Create all new coins"
  task :create_all_coins => :environment do
    puts "Creating all coins..."
    CreateAllCoinsWorker.perform_async
    puts "done."
  end

  desc "Update data for all existing coins in db"
  task :update_all_coins => :environment do
    puts "Updating all coins..."
    UpdateAllCoinsWorker.perform_async
    puts "done."
  end

  desc "Update data for all exchanges"
  task :update_all_exchanges => :environment do
    puts "Updating all exchanges..."
    UpdateAllExchangesWorker.perform_async
    puts "done."
  end

  desc "Tweet top gainers"
  task :tweet_gainers => :environment do
    puts "Tweeting top gainers..."
    TweetGainersWorker.perform_async
    puts "done."
  end
end
