
require "google_drive"
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'csv'
require 'pry'

def open_link_townhalls (link)
  #first of all we are defining our array where all the informations about the townhalls will be stored in 

  listarray = []
 
 #then we open the page that we want to scrap
 
  page_origin = Nokogiri::HTML(open(link))

 #after that because this page has on it a bunch of towhalls links where all the informations that we want are we are selecting those links

  start_up_link = page_origin.css("a.sabai-entity-bundle-type-directory-listing")
 # then itering on each one

  start_up_link.each {|balise|

 #we are making the link of each pages by putting together the base of the link and the href id 
  lien_start_up = balise['href']
 # this puts is just there to know where your programm is 
  puts lien_start_up
 # we open each link 
  start_up_page = Nokogiri::HTML(open(lien_start_up))
 #we are selecting the name 
  start_up_name = start_up_page.xpath("/html/body/div[2]/div[4]/div/div/div/article/header/h1").text
 #we are selecting the email 
  
  start_up_email = start_up_page.css("div.sabai-directory-contact-email").text

 #we are selecting the adress
  start_up_code = start_up_page.xpath("/html/body/div[2]/div[4]/div/div/div/article/div/div/div[1]/div/div[1]/div/div[2]/div[1]/span").text
 # then we are creating a Hash 
  list = Hash[:name => start_up_name, :email => start_up_email, :postal => start_up_code]
 #But in order to iterate on the information that we did get on each townhalls we have to put each hash in an array so we push it into the array listarray
  listarray.push(list)


}
#This puts is also to keep an eye on where is your programm and if all the datas are well scrapped
puts listarray
# we connect ourselves to a google session with the config.json that u have to fill up with your API keys 
  session = GoogleDrive::Session.from_config("config.json")
# then we open the spreadsheet with it's key to get the first french department that we want to scrap here it's haute vienne
  start_ups = session.spreadsheet_by_key("15ttNey0-aqFOWty8XxzZeOQciTMJTjHUA3rcCe6ziKw").worksheets[0]
  # the key of loire atlantique "1GS7WWhw9J_kMoxoMQmsB-Bf71Gw9-_6-byFFFmuFwaQ" and of martinique "1hfQXd0-qhSl6vpRtGlcseHGnSKmwpJHr0bt8Vprybxk"
  #we define the first three columns with a name start_up, Email, Adresse
  
  start_ups[1, 1] = "start_up"
  start_ups[1, 2] = "Email"
  start_ups[1, 3] = "Adresse"
  #We are saving it in order to see the results on our spreadsheet when the programm is over

start_ups.save
#we define i to be equal to 2 because on line one there's the name of our three columns and we don't want them to be erased
i = 2
#but what we want is to store on a line the datas so i =2 for the first loop then 3 and so on so that no lines are erased 
 listarray.each{ |x|

  start_ups[i, 1] = x[:name]
  start_ups[i, 2] = x[:email]
  start_ups[i, 3] = x[:postal]
  start_ups.save
  i += 1
  }
end 


  #while changing the id of the spreadsheet you also have to change the url because this one is only for the Haute vienne department
  # thats the  loire atlantique one : "http://www.annuaire-des-start_ups.com/loire-atlantique.html" , for martinique: "http://www.annuaire-des-start_ups.com/martinique.html"
  url_origin = "https://www.presse-citron.net/startups-directory?p=5&category=0&zoom=15&is_mile=0&directory_radius=2&view=list"

  open_link_townhalls(url_origin)



#And finally we just run the programm ;) 



