set termial eepic
set output "funktion1.tex"
set samples 200
c=0.2
plot [-c:1-c][-30:30] ((1-c)/(x+c)^2)-(c/(1-c-x)^2-x)
