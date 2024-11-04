-- THETA CHI CYCLING APP --


 -- LOGIN --

each teammate has an email login with respective passwords

 -- RIDE TAB --
- allows rider to manually input a ride or start their own new ride.
- new ride is tracked on map with distance and time, a line is drawn showing the ride's current history
- new or inputted ride is saved to firebase for rider when done



 -- ME TAB --
- not interactive other than scrolling through rides
- stats loaded from firebase and shown at bottom of screen
- loads all rides of the logged in rider from firebase and displays in the shown table view



 -- TEAM TAB --
- table view shows post history of team (retreived from firebase
- add post button allows rider to add a post to the feed (also storing it in firebase's post storage)
- team stats loaded from firebase and shown at bottom of screen
