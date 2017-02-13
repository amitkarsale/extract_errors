# extract_errors

Initial Description: Its a lightweight Sinatra app to parse the task export logs and find all the errors occured at various stage while performing any activity in the Satellite. The logs are parsed on case number basis. The purpose of this library is to play with the analysis of the occurance of errors, their occurances(overall or case basis), filter date wise, etc. 

# App Structure

'/' => root location of the app displays all the errors occured along with their occurance date and case number.(unpolished UI)
'/feed_data' => is to parse and feed the data into the db.