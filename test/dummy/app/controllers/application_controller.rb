class ApplicationController < ActionController::Base
  protect_from_forgery

  meta_tags_defaults(
    title: "Car Wash Pro",
    description: "Wash your car 356 days a year for 1$",
    image: "/assets/illustration.jpg"
  )
end
