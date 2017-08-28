# README

## What does this app do?

I worked on TwitterEngage initially as a response to a challenge
on DemandRush.com for a Twitter customer engagement web app.

Currently, a user of Twitter Engage can track a number of keywords
at once and receive a stream of the keywords delivered back to them.

A user can save or discard the tweet, and they can also interact
with the tweet. By saving a tweet, they can access the Tweet
data in a table view in the app.

## Running the app

* Versions + configuration settings
    - Ruby: 2.2.2 (developed)
    - Redis: >= 4 (developed)
    - Rails: 4.2.3 (developed)

* Running the app in dev
    - redis-server
    - rails s
    - ruby scripts/sidekiq.rb

* Running the app in prod
    - Procfile (for starting puma, sidekiq workers)

## TODOs

* Test code (Anyone who can give pointers on how to do that for
this kind of app, I'd appreciate it).

* Automatically adjusting the rate of Twitter queries.

* Automatically adjusting the number of results to yield to
the user

* Gaining greater control over the tweet keyword queues within the
application so that it is not necessary to cancel / kill
queues through the sidekiq interface.

* Implementing some form of fair scheduling for different
stream users, or else creating a separate queue for each
user

* Styling + UI. Always styling + UI.

## Resources

* Links to Twitter Brand

    - https://brand.twitter.com/fi.html

    - https://dev.twitter.com/streaming/overview/request-parameters#filter_level

    - https://dev.twitter.com/streaming/overview/connecting

    - https://dev.twitter.com/basics/image-resources