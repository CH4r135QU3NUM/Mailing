require 'dotenv'
Dotenv.load
require 'gmail'
require "google_drive"

def send_email_to_line(i)
   Gmail.connect(ENV['IDENTIFIANT'], ENV['MOTDEPASSE']) do |gmail|

   session = GoogleDrive::Session.from_config("config.json")
   ws = session.spreadsheet_by_key("1u7GMgI4Md0u0CbVf3DDy5kIKtD5NvoqYaG5mcdhu1CA").worksheets[0]

   name = "Jean Michel"
   first_name = ws[i,1]
   dep = ws[i,3]
   
   gmail.deliver do
         to ws[i,2]
         subject "Créér votre MVP en 24h gratuitement !"
         
         html_part do
               content_type 'text/html; charset=UTF-8'
           body "<p>Bonjour,</p><br/> <p>Je m'appelle #{name}, je suis élève à <strong>The Hacking Project</strong>, une formation au code <strong>gratuite</strong>.<br/> <br/> <p>Votre entreprise :#{first_name}, comme beaucoup de sociétés, cherche à révolutionner un marché et être disruptive. Afin d’innover et d’améliorer vos fonctionnalités vous devez sans cesse lancer des projets web et mobile …
Des solutions existent permettant de réduire ses frais. C'est pour cette raison que nous vous donnons en exclusivité accès à un site qui vous permet si vous réservez le plus rapidement possible (dans les heures qui suivent la récéption de ce mail) un MVP GRATUIT et d'obtenir plus d'informations sur notre formation <a href='https://hidden-cliffs-20693.herokuapp.com'> en vous inscrivant ici! </a>
</p> <br> <p>Ps: Inscrivez vous dès maintenant, ça n’engage en rien et surtout ça vous permet de bénéficier comme énoncé d'un prototype et d’avoir des informations pour former vos collaborateurs au code. 
<a href='https://hidden-cliffs-20693.herokuapp.com'> Pour s'inscrire c'est ici! </a> <br> <br>À bientôt</p>" 
         end
   end

   end
end

def go_through_all_the_lines
   session = GoogleDrive::Session.from_config("config.json")
   ws = session.spreadsheet_by_key("1u7GMgI4Md0u0CbVf3DDy5kIKtD5NvoqYaG5mcdhu1CA").worksheets[0]
   i = 1
   until ws[i,1] == "" do
       send_email_to_line(i)
       i += 1


   end


end
go_through_all_the_lines