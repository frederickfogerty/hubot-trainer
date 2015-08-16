# Description
#   A hubot script to train your team to do certain actions
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Frederick Fogerty <frederick.fogerty@gmail.com>
cron = require('cron').CronJob

startTrainer = (robot) ->
  usersPostedLightbulb = []
  checkIfUsersPostedCron = new cron
    cronTime: '00 00 11 * * 1-5'
    onTick: ->
      robot.send 'lightbulbs'
    start: true
    timeZone: 'Pacific/Auckland'

  deleteUsersPostsCron = new cron
    cronTime: '00 00 23 * * *'
    onTick: ->
      usersPostedLightbulb = [],
    start: true
    timeZone: 'Pacific/Auckland'
  robot.hear /:lightbulb:/, (res) ->
    usersPostedLightbulb.push(res.message.user.name)
    console.log res
  return {
    stop: ->
      checkIfUsersPostedCron.stop()
      deleteUsersPostsCron.stop()
      usersPostedLightbulb = null
      checkIfUsersPostedCron = null
      deleteUsersPostsCron = null
    start: ->
      checkIfUsersPostedCron.start()
      deleteUsersPostsCron.start()
  }


module.exports = (robot) ->

  currentTrainer = startTrainer(robot)
  currentTrainer.start()

  robot.respond /trainer stop/, (res) ->
    currentTrainer.stop()
    res.send 'Trainer Stopped'

  robot.respond /trainer start/, (res) ->
    currentTrainer = startTrainer(robot)
    currentTrainer.start()
    res.send 'Trainer Started'

  robot.hear /orly/, (res) ->
    res.send "yarly"
