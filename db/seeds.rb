Shelter.destroy_all
Application.destroy_all

shelter = Shelter.create!(name: "Park Creek Animal Shelter", address: "412 Fay Ridge", city: "Helainechester", state: "NE", zip: "70635")
Pet.create!(image:"/images/11.jpeg", name:"Cody", approximate_age:12, sex:"male", description:"they're good dogs Brent", shelter: shelter)
Pet.create!(image:"/images/10.jpeg", name:"Cooper", approximate_age:8, sex:"male", description:"long boi", shelter: shelter)
Pet.create!(image:"/images/7.jpeg", name:"Coco", approximate_age:5, sex:"female", description:"mlem", shelter: shelter)
Pet.create!(image:"/images/5.jpeg", name:"Jack", approximate_age:9, sex:"male", description:"zoom", shelter: shelter)
Pet.create!(image:"/images/12.jpeg", name:"Angel", approximate_age:3, sex:"female", description:"11/10", shelter: shelter)

shelter = Shelter.create!(name: "Royal Square Animal Shelter", address: "88148 West Heights", city: "South Elmira", state: "NM", zip: "54809")
Pet.create!(image:"/images/8.jpeg", name:"Bailey", approximate_age:4, sex:"female", description:"smol pupperino", shelter: shelter)
Pet.create!(image:"/images/2.jpeg",name:"Snickers", approximate_age:11, sex:"male", description:"blep", shelter: shelter)
Pet.create!(image:"/images/1.jpeg", name:"Bella", approximate_age:1, sex:"female", description:"heck no pal", shelter: shelter)

shelter = Shelter.create!(name: "Royal Village Animal Shelter", address: "72410 Herman Vista", city: "East Williefort", state: "VA", zip: "32406")
Pet.create!(image:"/images/3.jpeg", name:"Rex", approximate_age:6, sex:"male", description:"thicc doggo", shelter: shelter)
Pet.create!(image:"/images/9.jpeg", name:"Harvey", approximate_age:2, sex:"male", description:"big ol' pupper", shelter: shelter)
Pet.create!(image:"/images/6.jpeg", name:"Scooter", approximate_age:7, sex:"male", description:"boop the snoot", shelter: shelter)
Pet.create!(image:"/images/4.jpeg", name:"Misty", approximate_age:10, sex:"female", description:"big ol' pupper", shelter: shelter)


application = Application.create!(applicant_name: "Lavonna Stroman",
                                  street_address: "28742 Sal Ramp",
                                  city: "Charmainehaven",
                                  state: "IN",
                                  zip: "09936",
                                  description: "Only the educated are free.",
                                  status: "Pending")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)


application = Application.create!(applicant_name: "Cora Nolan",
                                  street_address: "251 Dan Landing",
                                  city: "West Benedict",
                                  state: "MO",
                                  zip: "51713-7182",
                                  description: "The mind is not a vessel to be filled but a fire to be kindled.",
                                  status: "Pending")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

application = Application.create!(applicant_name: "Msgr. Kristofer Wyman",
                                  street_address: "3164 Nelson Unions",
                                  city: "North Miltonmouth",
                                  state: "NM",
                                  zip: "09112-3883")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

application = Application.create!(applicant_name: "Eli Morissette",
                                  street_address: "93401 Perry Lights",
                                  city: "Port Alton",
                                  state: "MS",
                                  zip: "08617",
                                  description: "Rhetoric is the art of ruling the minds of men.",
                                  status: "Pending")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

application = Application.create!(applicant_name: "Mr. Wilhelmina Tromp",
                                  street_address: "2902 Renea Burg",
                                  city: "New Astridmouth",
                                  state: "NE",
                                  zip: "82230-8899",
                                  description: "Beware the barrenness of a busy life.",
                                  status: "Pending")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

application = Application.create!(applicant_name: "Harvey Lynch",
                                  street_address: "46773 Rodriguez Ridge",
                                  city: "Mitchelltown",
                                  state: "NC",
                                  zip: "04576")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

application = Application.create!(applicant_name: "Kendrick Marquardt",
                                  street_address: "48965 Nader Branch",
                                  city: "D'Amorestad",
                                  state: "KS",
                                  zip: "93496",
                                  description: "The virtue of justice consists in moderation, as regulated by wisdom.",
                                  status: "Pending")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

application = Application.create!(applicant_name: "Kimberley Swaniawski",
                                  street_address: "622 Mayert Forest",
                                  city: "Doylefurt",
                                  state: "LA",
                                  zip: "98120",
                                  description: "Know how to listen, and you will profit even from those who talk badly.",
                                  status: "Pending")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

application = Application.create!(applicant_name: "Thaddeus Beatty", street_address: "6396 Hannah Dam", city: "East Vella", state: "MO", zip: "45706")
ApplicationPet.create!(pet: Pet.order('RANDOM()').first, application: application)

Application.create!(applicant_name: "Irvin Tromp", street_address: "70215 Stoltenberg Unions", city: "Kuphalton", state: "NE", zip: "07523")
Application.create!(applicant_name: "Keenan Beer", street_address: "5764 Hillary Trail", city: "East Kenneth", state: "MN", zip: "94423")
Application.create!(applicant_name: "Rosendo Ryan", street_address: "8815 McKenzie Summit", city: "Schummmouth", state: "IA", zip: "58490")
